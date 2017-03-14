require 'rspotify'


class Album

  QUESTIONS = ["What is this album's release date?", "What is the popularity rate of the album", "Is this track on the album"]

  attr_reader :release_year, :popularity_rate, :track, :id


  def initialize(args)

    # @release_year = {release_year: "play"}
    # @popularity_rate = args.popularity
    # @one_track = args.tracks.sample.name
    # binding.pry
    year = args.release_date.to_i
    # year = Date.parse(release_date).year
    @release_year = {answer: year, question: "When was the album #{args.name} released?"}
    @popularity_rate = {answer: args.popularity, question: "Guess #{args.name}'s popularity rate on Spotify?"}
    track = args.tracks.sample.name
    @track = {answer: track, question: "Is the song '#{track}' on the #{args.name} album?"}

    @id = args.id


  end


  def release_year_option
    self.release_year[:answer].to_i + (-5..5).to_a.sample
  end

  def popularity_option
    before_100 = 99 - self.popularity_rate[:answer]

    self.popularity_rate[:answer] + [-15, before_100].to_a.sample
    # binding.pry
  end


end
