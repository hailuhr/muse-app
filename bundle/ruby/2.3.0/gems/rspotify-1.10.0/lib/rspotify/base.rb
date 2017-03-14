module RSpotify

  # @attr [Hash]   external_urls Known external URLs for object
  # @attr [String] href          A link to the Web API endpoint
  # @attr [String] id            The {https://developer.spotify.com/web-api/user-guide/#spotify-uris-and-ids Spotify ID} for the object
  # @attr [String] type          The object type (artist, album, etc.)
  # @attr [String] uri           The {https://developer.spotify.com/web-api/user-guide/#spotify-uris-and-ids Spotify URI} for the object
  class Base

    # Returns RSpotify object(s) with id(s) and type provided
    #
    # @param ids [String, Array]
    # @param type [String]
    # @return [Album, Artist, Track, User, Array<Album>, Array<Artist>, Array<Track>]
    #
    # @example
    #           user = RSpotify::Base.find('wizzler', 'user')
    #           user.class #=> RSpotify::User
    #           user.id    #=> "wizzler"
    #           
    #           ids = %w(2UzMpPKPhbcC8RbsmuURAZ 7Jzsc04YpkRwB1zeyM39wE)
    #           tracks = RSpotify::Base.find(ids, 'track')
    #           tracks.class       #=> Array
    #           tracks.first.class #=> RSpotify::Track
    def self.find(ids, type)
      case ids
      when Array
        if type == 'user'
          warn 'Spotify API does not support finding several users simultaneously'
          return false
        end
        limit = (type == 'album' ? 20 : 50)
        find_many(ids, type)
      when String
        id = ids
        find_one(id, type)
      end
    end

    def self.find_many(ids, type)
      type_class = RSpotify.const_get(type.capitalize)
      path = "#{type}s?ids=#{ids.join ','}"
      json = RSpotify.get path
      json["#{type}s"].map { |t| type_class.new t }
    end
    private_class_method :find_many

    def self.find_one(id, type)
      type_class = RSpotify.const_get(type.capitalize)
      path = "#{type}s/#{id}"
      json = RSpotify.get path
      type_class.new json
    end
    private_class_method :find_one

    def self.insert_total(result, types, json)
      result.instance_eval do
        @total = types.map do |type|
          json["#{type}s"]['total']
        end.reduce(:+)

        define_singleton_method :total do
          @total
        end
      end
    end
    private_class_method :insert_total

    # Returns array of RSpotify objects matching the query, ordered by popularity. It's also possible to find the total number of search results for the query
    #
    # @param query  [String]       The search query's keywords. For details access {https://developer.spotify.com/web-api/search-item here} and look for the q parameter description.
    # @param types  [String]       Valid types are: album, artist, track and playlist. Separate multiple types with commas.
    # @param limit  [Integer]      Maximum number of objects to return. Maximum: 50. Default: 20.
    # @param offset [Integer]      The index of the first object to return. Use with limit to get the next set of objects. Default: 0.
    # @param market [String, Hash] Optional. An {http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2 ISO 3166-1 alpha-2 country code} or the hash { from: user }, where user is a RSpotify user authenticated using OAuth with scope *user-read-private*. This will take the user's country as the market value. (Playlist results are not affected by the market parameter.) For details access {https://developer.spotify.com/web-api/search-item here} and look for the market parameter description.
    # @return [Array<Album>, Array<Artist>, Array<Track>, Array<Playlist>, Array<Base>]
    #
    # @example
    #           artists = RSpotify::Base.search('Arctic', 'artist')
    #           albums  = RSpotify::Base.search('AM', 'album', limit: 10, market: 'US')
    #           mixed   = RSpotify::Base.search('Arctic', 'artist, album, track')
    #           albums  = RSpotify::Base.search('AM', 'album', market: { from: user })
    #
    #           RSpotify::Base.search('Arctic', 'album,artist,playlist').total #=> 2142
    def self.search(query, types, limit: 20, offset: 0, market: nil)
      query = URI::encode query
      types.gsub!(/\s+/, '')

      url = "search?q=#{query}&type=#{types}"\
            "&limit=#{limit}&offset=#{offset}"

      json = if market.is_a? Hash
        url << '&market=from_token'
        User.oauth_get(market[:from].id, url)
      else
        url << "&market=#{market}" if market
        RSpotify.get(url)
      end

      types = types.split(',')
      result = types.flat_map do |type|
        type_class = RSpotify.const_get(type.capitalize)
        json["#{type}s"]['items'].map { |i| type_class.new i }
      end

      insert_total(result, types, json)
      result
    end

    def initialize(options = {})
      @external_urls = options['external_urls']
      @href          = options['href']
      @id            = options['id']
      @type          = options['type']
      @uri           = options['uri']
    end

    # When an object is obtained undirectly, Spotify usually returns a simplified version of it.
    # This method updates it into a full object, with all attributes filled.
    # 
    # @note It is seldom necessary to use this method explicitly, since RSpotify takes care of it automatically when needed (see {#method_missing})
    #
    # @example
    #           track = artist.tracks.first
    #           track.instance_variable_get("@popularity") #=> nil
    #           track.complete!
    #           track.instance_variable_get("@popularity") #=> 62
    def complete!
      initialize RSpotify.get("#{type}s/#{@id}")
    end

    # Used internally to retrieve an object's instance variable. If instance
    # variable equals nil, calls {#complete!} on object and retrieve it again.
    #
    # @example
    #           user.id #=> "wizzler"
    #
    #           track = artist.tracks.first
    #           track.instance_variable_get("@popularity") #=> nil
    #           track.popularity #=> 62
    #           track.instance_variable_get("@popularity") #=> 62
    def method_missing(method_name, *args)
      attr = "@#{method_name}"
      super unless instance_variable_defined? attr

      attr_value = instance_variable_get attr
      return attr_value if !attr_value.nil? || @id.nil?

      complete!
      instance_variable_get attr
    end

    # Overrides Object#respond_to? to also consider methods dynamically generated by {#method_missing}
    def respond_to?(method_name, include_private_methods = false)
      attr = "@#{method_name}"
      return true if instance_variable_defined? attr
      super
    end
    
    protected
    
    def hash_for(tracks, field)
      return nil unless tracks
      pairs = tracks.map do |track|
        key = track['track']['id']
        value = yield track[field] if track[field]
        [key, value]
      end
      Hash[pairs]
    end
  end
end
