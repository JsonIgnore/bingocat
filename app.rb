require 'sinatra'
require 'haml'
require 'sqlite3'

require_relative "lib/term_set"

# SQLite3::Database.open('test.db')

# Setup haml templates to use html5 by default
set :haml, :format => :html5

# We'll make a CLI log entry real quick so we can see the app running in Docker
puts 'Running Hello Carrot Cat!'


get '/' do
  @card = TermSet.make_numeric_terms.generate_random_card
  haml :index
end
