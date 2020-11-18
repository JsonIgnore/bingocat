require 'sinatra'
require 'haml'

# Setup for
set :haml, :format => :html5

# We'll make a CLI log entry real quick so we can see the app running in Docker
puts 'Running Hello Carrot Cat!'

get '/' do
  haml :index
end
