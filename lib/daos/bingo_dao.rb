require_relative "sqlite_connection"
require_relative "../models/term_set"

##
# Sqlite Dao for our Bingo models
class BingoDao < SqliteConnection

  def initialize(database = self.get_database_connection)
    @database = database
  end


  def save_term_set(term_set)
    if term_set.get_terms().size < 24
      raise DatabaseError.new("Cannot save a term set with less than 24 terms")
    end

    name = term_set.get_name
    terms_string = flatten_term_string(term_set.get_terms)
    free_space = term_set.get_free_space

    ins = @database.prepare(INSERT_INTO_TERMS_SQL)
    result = ins.execute(name, terms_string, free_space)

    return result
  end


  private

  def flatten_term_string(terms)
    return terms.join(",")
  end


  INSERT_INTO_TERMS_SQL = "
    INSERT INTO terms (name, terms_string, free_space)
    VALUES (?, ?, ?);"
  private_constant :INSERT_INTO_TERMS_SQL

end