require 'rspotify'


class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    # @artists = RSpotify::Artist.search('Arctic Monkeys')
    # binding.pry
  end






end
