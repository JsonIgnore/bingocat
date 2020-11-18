# Hello Dolly - A "Hello" Sinatra Project Via Bundler and Docker

require 'sinatra'

# We'll make a CLI log entry real quick so we can see the app running in Docker
puts 'Running Hello Carrot Cat!'

get '/' do
  'Hello Carrot Cat!'
end
