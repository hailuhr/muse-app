require 'rspotify'

class AlbumsController < ActionController::Base


  def home
    render :home
  end

  def search
    if !(params[:search].empty?)
      @artists = RSpotify::Artist.search(params[:search])
    end

    if @artists.nil? || @artists.empty?
      @artist_message = "Try Another Name"
    else
      @artist = RSpotify::Artist.search(params[:search]).first
      # @albums = fetch_random_five(@artist.top_tracks(:US).map{|track| track.album })


      @spotify_albums = unique_albums(@artist.albums).sample(5)

      # @albums_unique = @albums.uniq
      # hash.map { |k,v| v }.uniq


      if @spotify_albums.nil?
        @artist_message = "Try Another Name"
      end
      @albums = @spotify_albums.map{|album| Album.new(album)}


      render :questions and return
    end

    render "/application/index" and return
  end



  def index
  end

  def answers

      @message1 = "Job Well Done!"
      @message2 =  "Here are the answers:"

      @message3 = "#{params[:track]} is on Spotify's #{RSpotify::Track.search(params[:track]).first.album.name} album!"

      year_album = RSpotify::Album.find(params[:release_year_id])
      @message4 = "You guessed " + year_album.name + " was released in " + params[:release_year]
      @message5 = "#{year_album.name} was released in #{year_album.release_date.to_i}.\n"

      popularity_album = RSpotify::Album.find(params[:popularity_rate_id])
      @message6 = "You guessed #{params[:popularity_rate]} for #{popularity_album.name}'s popularity rating on Spotify\n"
      @message7 = "#{popularity_album.name}'s rating on Spotify is #{popularity_album.popularity}\n"

      sec_year_album = RSpotify::Album.find(params[:sec_release_year_id])
      sec_year_album_name = sec_year_album.name
      @message8 = "You guessed " + sec_year_album_name + " was released in " + params[:sec_release_year] + ""
      @message9 = "#{sec_year_album_name} was released in #{sec_year_album.release_date.to_i}.\n"

      sec_popularity_album = RSpotify::Album.find(params[:sec_popularity_rate_id])
      sec_popularity_album_name = sec_popularity_album.name
      @message10 = "You guessed #{params[:sec_popularity_rate]} for #{sec_popularity_album_name}'s popularity rating on Spotify\n"
      @message11 = "#{sec_popularity_album_name}'s rating on Spotify is #{sec_popularity_album.popularity}\n"


      # binding.pry

      first_track_popularity = RSpotify::Track.find(params[:first_track_popularity_id])
      first_track_popularity_name = first_track_popularity.name
      first_track_popularity_rate = first_track_popularity.popularity
      @message12 = "You guessed #{params[:first_track_popularity_rate]} for the song #{first_track_popularity_name}'s popularity rating on Spotify\n"
      @message13 = "#{first_track_popularity_name}'s rating on Spotify is #{first_track_popularity_rate}\n"
    end



  private

    def unique_albums(array)
      # array.sample(5)
      unique_albums = []
      i = 0
      until unique_albums.length == 20 || i == 20 || array[i].nil?
        if unique_albums.empty?
          unique_albums << array[i]
        else
          if !(unique_albums.any? {|e| e.name == array[i].name })
            unique_albums << array[i]
          end
        end
        # binding.pry

        i += 1
      end
      unique_albums

    end




    def answer_params

      params.permit(:release_year, :popularity_rate, :track, :release_year_id, :popularity_rate_id, :sec_release_year_id, :sec_popularity_rate_id, :first_track_popularity_rate, :first_track_popularity_id)
    end



end
