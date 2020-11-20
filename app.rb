require 'sinatra'
require 'haml'
require 'sqlite3'
require 'pry'

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
  dao.save_term_set(TermSet.make_numeric_terms)
  print " Done!\n"
end

default_terms = dao.get_term_set(1)

# Setup haml templates to use html5 by default
set :haml, :format => :html5
set :public_folder, 'public'

# We'll make a CLI log entry real quick so we can see the app running in Docker
puts 'Running Carrot Cat!'

# Landing
# Show a randomly generated number card
get '/' do
  redirect "/generate/#{default_terms.get_id}"
end

# Show an existing Card
get '/card/:card_id' do
  @card = dao.get_card(params[:card_id])
  haml :view_card
end

# Generate a card from the terms id
# Should generate/save a card and then redirect to /card/:card_id
get '/generate/:terms_id' do
  term_set = dao.get_term_set(params[:terms_id])
  card = dao.save_card(term_set.generate_random_card)
  redirect "/card/#{card.get_id}"
end

# Page to define terms to use for cards
# form posts to /terms
get '/create' do
  @terms = TermSet.new([])
  haml :create_terms
end

# Load the /create view with an existing set of terms for viewing or submitting changes for
# currently this will generate a new terms entry, as we're not supporting edits
get '/terms/:terms_id' do
  @terms = nil
  begin
    @terms = dao.get_term_set(params[:terms_id])
  rescue DatabaseError
    redirect '/create'
  end

  haml :create_terms
end

# Submit terms to be verified/saved
post '/terms' do
  valid_terms = nil
  begin
    valid_terms = TermSet.validate_terms_string(params['terms'])
  rescue TermSetValidationError => @validation_error
    @terms = TermSet.new(
        params['terms'].split(","),
        params['free-space'],
        params['name'])
    # Escape!
    return haml :create_terms
  end

  @terms = dao.save_term_set(TermSet.new(valid_terms, params['free-space'], params['name']))

  haml :share_play
end

