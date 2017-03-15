require 'rspotify'

class AlbumsController < ActionController::Base


  def home
    render :home
  end

  def search
    if !(@artists = RSpotify::Artist.search(params[:search]))
      message = "nah"
    else
      @artist = RSpotify::Artist.search(params[:search]).first
      # @albums = @artist.albums.fetch_random_five
      # binding.pry
      # @albums = fetch_random_five(@artist.albums(limit: 0, offset: 0, **filters))
      @albums = fetch_random_five(@artist.top_tracks(:US).map{|track| track.album })
      @album_questions = @albums.map{|album| Album.new(album)}
    end

    render :questions
  end



  def index
  end

  def answers

      @message1 = "Job Well Done!"
      @message2 =  "Here are the answers:"

      @message3 = "#{params[:track]} is on Spotify's #{RSpotify::Track.search(params[:track]).first.album.name} album.\n"
      # binding.pry

      # @message += "You guessed #{params[:track]}"

      year_album = RSpotify::Album.find(params[:release_year_id])
      @message4 = "You guessed " + year_album.name + " was released in " + params[:release_year] + ".\n"
      @message5 = "#{year_album.name} was released in #{year_album.release_date.to_i}.\n"
      popularity_album = RSpotify::Album.find(params[:popularity_rate_id])
      @message6 = "You guessed #{params[:popularity_rate]} for #{popularity_album.name}'s popularity on Spotify\n"
      @message7 = "The answer was: #{popularity_album.popularity}\n"
      # "Bravo!" + params[:track].values[0] + "is on the "
      # if params[:track] && (params[:track] == "True" || params[:track] == "true")
        # ""
      # render :home
    end



  private

    def fetch_random_five(array)
      array.sample(5)
    end

    def answer_params

      params.permit(:release_year, :popularity_rate, :track, :release_year_id, :popularity_rate_id)
      # binding.pry
    end



end
