require './app'
set :port, 7654
set :bind, '0.0.0.0'
run Sinatra::Application
