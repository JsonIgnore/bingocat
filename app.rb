require 'sinatra'
require 'haml'
require 'sqlite3'

require_relative "lib/daos/database_creator"
require_relative "lib/daos/bingo_dao"
require_relative "lib/models/term_set"

# Create our Dao and create the DB if we need to
dao = BingoDao.new
unless dao.database_exists
  print "Carrot Cat DB not found - Creating now..."
  db_creator = DatabaseCreator.new
  db_creator.create_database
  print " Done!\n"

  print "Creating a sample terms and card for testing..."
  terms = TermSet.make_numeric_terms
  dao.save_term_set(terms)
  card = terms.generate_random_card
  dao.save_card(card)
  print " Done!\n"
end

# Setup haml templates to use html5 by default
set :haml, :format => :html5
set :public_folder, 'public'

# We'll make a CLI log entry real quick so we can see the app running in Docker
puts 'Running Hello Carrot Cat!'

# Landing
# Show a randomly generated number card
get '/' do
  @card = TermSet.make_numeric_terms.generate_random_card
  haml :index
end

# Show an existing Card
get '/card/:card_id' do
  "WIP"
end

# Generate a card from the terms id
# Should generate/save a card and then redirect to /card/:card_id
get '/generate/:terms_id' do
  "WIP"
end

# Page to define terms to use for cards
# form posts to /terms
get '/create' do
  "WIP"
end

# Load the /create view with an existing set of terms for viewing or submitting changes for
# currently this will generate a new terms entry, as we're not supporting edits
get '/terms/:terms_id' do
  "WIP"
end

# Submit terms to be verified/saved
post '/terms' do
  "WIP"
end