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
    return (result.size != 0)
  end


  def save_term_set(term_set)
    if term_set.get_terms.size < 24
      raise DatabaseError.new("Cannot save a term set with less than 24 terms")
    end

    name = term_set.get_name
    terms_string = flatten_string_array(term_set.get_terms)
    free_space = term_set.get_free_space

    ins = @database.prepare(INSERT_INTO_TERMS_SQL)
    result = ins.execute(name, terms_string, free_space)

    return result
  end

  def save_card(card)
    if card.get_spaces.size != 25
      raise DatabaseError.new("Cannot save a card without 25 spaces")
    end

    spaces_string = flatten_string_array(card.get_spaces)
    unless card.get_defining_terms.nil?
      made_from_id = card.get_defining_terms.get_id
    else
      made_from_id = nil
    end

    ins = @database.prepare(INSERT_INTO_CARDS_SQL)
    result = ins.execute(spaces_string, made_from_id)

    return result
  end


  private

  def flatten_string_array(string_array)
    return string_array.join(",")
  end

  DATABASE_TABLES_EXIST_CHECK = "
    SELECT COUNT(name) FROM sqlite_master WHERE type='table'
    ;"
  private_constant :DATABASE_TABLES_EXIST_CHECK

  INSERT_INTO_TERMS_SQL = "
    INSERT INTO terms (name, terms_string, free_space)
    VALUES (?, ?, ?);"
  private_constant :INSERT_INTO_TERMS_SQL

  INSERT_INTO_CARDS_SQL = "
    INSERT INTO cards (spaces_string, made_from)
    VALUES (?, ?);"
  private_constant :INSERT_INTO_TERMS_SQL

end