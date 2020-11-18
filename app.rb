require 'sinatra'
require 'haml'

require_relative "lib/card.rb"

# Setup for
set :haml, :format => :html5

# We'll make a CLI log entry real quick so we can see the app running in Docker
puts 'Running Hello Carrot Cat!'


get '/' do
  @card = Card.new()
  haml :index
end
