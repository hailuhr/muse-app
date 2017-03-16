module AlbumsHelper


  def full_message(params)
    array_of_messages = []
    if params[:track]
      array_of_messages << track_answer(params[:track])
    end

    if params[:release_year_id]
      array_of_messages << year_album_answer(params[:release_year_id])
    end

    if params[:popularity_rate_id]
      array_of_messages << popularity_album_answer(params[:popularity_rate_id])
    end

    if params[:sec_release_year_id]
      array_of_messages << year_album_answer(params[:sec_release_year_id])
    end

    if params[:sec_popularity_rate_id]
      array_of_messages << popularity_album_answer(params[:sec_popularity_rate_id])
    end


    if params[:first_track_popularity_id]
      array_of_messages << track_popularity_answer(params[:first_track_popularity_id])
    end
    # binding.pry
    array_of_messages
  end



  def congratulations
    # "Job Well Done! Here are the answers:"
    ["Job Well Done!","Here are the answers:"]
  end

  def track_answer(track)
    # binding.pry
    ["", "#{params[:track]} is on Spotify's #{RSpotify::Track.search(params[:track]).first.album.name} album!"]
  end

  def year_album_answer(release_year_id)
    year_album = RSpotify::Album.find(release_year_id)
    name = year_album.name

    user_response_and_answer = ["You guessed #{name} was released in #{params[:release_year]}.", "#{year_album.name} was released in #{year_album.release_date.to_i}."]
  end

  def popularity_album_answer(popularity_rate_id)
    popularity_album = RSpotify::Album.find(popularity_rate_id)
    user_response_and_answer = ["You guessed #{params[:popularity_rate]} for #{popularity_album.name}'s popularity rating on Spotify.", "#{popularity_album.name}'s rating on Spotify is #{popularity_album.popularity}."]
    user_response_and_answer
  end

  def track_popularity_answer(track_id)
    track_popularity = RSpotify::Track.find(track_id)
    track_popularity_name = track_popularity.name
    track_popularity_rate = track_popularity.popularity
    user_response_and_answer = ["You guessed #{params[:first_track_popularity_rate]} for the song #{track_popularity_name}'s popularity rating on Spotify.", "#{track_popularity_name}'s rating on Spotify is #{track_popularity_rate}."]
    user_response_and_answer
  end


end
