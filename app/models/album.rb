require 'rspotify'


class Album

  QUESTIONS = ["What is this album's release date?", "What is the popularity rate of the album", "Is this track on the album"]

  attr_reader :release_year, :popularity_rate, :track, :id


  def initialize(args)

    year = args.release_date.to_i
    @release_year = {answer: year, question: "When was the track #{args.name} released?"}
    @popularity_rate = {answer: args.popularity, question: "Guess #{args.name}'s popularity rate on Spotify?"}
    track = args.tracks.sample.name
    @track = {answer: track, question: "Is the song '#{track}' on the #{args.name} album?"}

    @id = args.id


  end


  def release_year_option
    self.release_year[:answer].to_i + (-5..5).to_a.sample
  end

  def release_year_min_option
    self.release_year[:answer].to_i + (-4...0).to_a.sample
  end

  def release_year_max_option
    before_this_year = DateTime.now.year - self.release_year[:answer].to_i
    self.release_year[:answer].to_i + (0..before_this_year).to_a.sample
  end



  def popularity_option
    before_100 = 99 - self.popularity_rate[:answer]
    self.popularity_rate[:answer] + [-10, before_100].to_a.sample
  end

  def popularity_min_option
    self.popularity_rate[:answer] + [-5, -1].to_a.sample
  end

  def popularity_max_option
    before_max_100 = 99 - self.popularity_rate[:answer]
    self.popularity_rate[:answer] + [0, before_max_100].to_a.sample
  end



end
