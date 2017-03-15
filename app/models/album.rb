require 'rspotify'


class Album


  attr_reader :release_year, :popularity_rate, :track, :id, :track_popularity_rate


  def initialize(args)

    year = args.release_date.to_i
    @release_year = {answer: year, question: "When was #{args.name} released?"}
    @popularity_rate = {answer: args.popularity, question: "Guess #{args.name}'s popularity rate on Spotify?"}
    track = args.tracks.sample
    track_name = args.tracks.sample.name
    track_popularity_rate = track.popularity

    @track = {answer: track_name, question: "Is the song '#{track_name}' on the #{args.name} album?"}

    @track_popularity_rate = {answer: track_popularity_rate, question: "Guess the song '#{track_name}'s popularity rate on Spotify?"}

    # binding.pry


    @id = args.id


  end


  # def release_year_option
  #   self.release_year[:answer].to_i + (-5..5).to_a.sample
  # end

  def release_year_min_option
    self.release_year[:answer].to_i + (-4...-2).to_a.sample
  end

  def release_year_max_option
    before_this_year = DateTime.now.year - self.release_year[:answer].to_i

    self.release_year[:answer].to_i + (0..before_this_year).to_a.sample
  end

  #
  # def popularity_option
  #   before_100 = 99 - self.popularity_rate[:answer]
  #   self.popularity_rate[:answer] + [-10, before_100].to_a.sample
  # end

  def popularity_min_option
    min = self.popularity_rate[:answer] + [-7, -2].to_a.sample
    if min.negative?
      return 0
    else
      return min
    end
  end

  def popularity_max_option
    before_max_100 = 97 - self.popularity_rate[:answer]
    self.popularity_rate[:answer] + [2, before_max_100].to_a.sample
  end

  def track_popularity_min_option
    self.track_popularity_rate[:answer] + [-7, -2].to_a.sample
  end

  def track_popularity_max_option
    before_max_100 = 97 - self.track_popularity_rate[:answer]
    self.track_popularity_rate[:answer] + [2, before_max_100].to_a.sample
  end


end
