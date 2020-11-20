require_relative "sqlite_connection"
require_relative "../models/card"
require_relative "../models/term_set"

##
# Sqlite Dao for our Bingo models
class BingoDao < SqliteConnection

  def initialize(database = self.get_database_connection)
    @database = database
  end


  def database_exists()
    # Cheeky, but we'll look and see if the terms table has been created yet as our metric for "does it exist"
    result = @database.table_info("terms")
    (result.size != 0)
  end


  def save_term_set(term_set)
    if term_set.get_terms.size < 24
      raise DatabaseError.new("Cannot save a term set with less than 24 terms")
    end

    name = term_set.get_name
    terms_string = flatten_string_array(term_set.get_terms)
    free_space = term_set.get_free_space

    @database.prepare(INSERT_INTO_TERMS_SQL).execute(name, terms_string, free_space)

    TermSet.new(
        term_set.get_terms,
        term_set.get_free_space,
        term_set.get_name,
        @database.last_insert_row_id)
  end

  def get_term_set(terms_id)
    results = @database.prepare(SELECT_FROM_TERM_ID).execute(terms_id)

    term_set = nil
    results.each do |row|
      term_set = convert_result_to_term_set(row)
      break
    end

    if term_set.nil?
      raise DatabaseError.new("Could not find terms for id '#{terms_id}'")
    end

    term_set
  end

  def save_card(card)
    if card.get_spaces.size != 25
      raise DatabaseError.new("Cannot save a card without 25 spaces")
    end

    spaces_string = flatten_string_array(card.get_spaces)
    made_from_id = nil
    unless card.get_defining_terms.nil?
      made_from_id = card.get_defining_terms.get_id
    end

    @database.prepare(INSERT_INTO_CARDS_SQL).execute(spaces_string, made_from_id)
    Card.new(
        card.get_spaces,
        card.get_defining_terms,
        @database.last_insert_row_id)
  end

  def get_card(card_id)
    results = @database.prepare(SELECT_FROM_CARD_ID).execute(card_id)

    card = nil
    results.each do |row|
      card = convert_result_to_card(row)
      break
    end

    if card.nil?
      raise DatabaseError.new("Could not find card for id '#{card_id}'")
    end

    card
  end


  private

  def convert_result_to_term_set(result)
    TermSet.new(
        extract_array_from_string(result[0]),
        result[1],
        result[2],
        result[3])
  end

  def convert_result_to_card(result)
    spaces = extract_array_from_string(result[0])
    made_from = nil
    unless result[1].nil?
      made_from = get_term_set(result[1])
    end
    Card.new(spaces, made_from, result[2])
  end

  def flatten_string_array(string_array)
    string_array.join(",")
  end

  def extract_array_from_string(flat_array)
    flat_array.split(",")
  end

  DATABASE_TABLES_EXIST_CHECK = "
    SELECT COUNT(name) FROM sqlite_master WHERE type='table'
    ;"
  private_constant :DATABASE_TABLES_EXIST_CHECK

  INSERT_INTO_TERMS_SQL = "
    INSERT INTO terms (name, terms_string, free_space)
    VALUES (?, ?, ?);"
  private_constant :INSERT_INTO_TERMS_SQL

  SELECT_FROM_TERM_ID = "
    SELECT
      terms_string, free_space, name, id
    FROM terms WHERE id = ?
  ;"
  private_constant :SELECT_FROM_TERM_ID

  INSERT_INTO_CARDS_SQL = "
    INSERT INTO cards (spaces_string, made_from)
    VALUES (?, ?);"
  private_constant :INSERT_INTO_TERMS_SQL

  SELECT_FROM_CARD_ID = "
    SELECT
      spaces_string,
      made_from,
      id
    FROM cards WHERE id = ?;"
  private_constant :SELECT_FROM_CARD_ID

end