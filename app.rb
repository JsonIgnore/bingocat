require 'sinatra'
require 'haml'
require 'sqlite3'

require_relative "lib/daos/database_creator"
require_relative "lib/daos/bingo_dao"
require_relative "lib/models/term_set"


# Setup haml templates to use html5 by default
set :haml, :format => :html5
set :public_folder, 'public'

# We'll make a CLI log entry real quick so we can see the app running in Docker
puts 'Running Hello Carrot Cat!'


get '/' do
  @card = TermSet.make_numeric_terms.generate_random_card
  haml :index
end
