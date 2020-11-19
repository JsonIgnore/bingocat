require_relative "sqlite_connection"

##
# Sqlite database creator to create a new, empty database
class DatabaseCreator < SqliteConnection

  def initialize(database = self.get_database_connection)
    @database = database
  end

  ##
  # Create the database
  def create_database
    create_terms_table
    create_cards_table
  end

  private

  def create_terms_table
    results = @database.execute TERMS_TABLE_DEFINITION
  end

  def create_cards_table
    results = @database.execute CARDS_TABLE_DEFINITION
  end


  ##  Table Definitions  ##
  TERMS_TABLE_DEFINITION = "
    CREATE TABLE terms (
      id            INTEGER         PRIMARY KEY,
      name          VARCHAR(255),
      terms_string  TEXT            NOT NULL,
      free_space    VARCHAR(255)    NOT NULL
    );"
  private_constant :TERMS_TABLE_DEFINITION

  CARDS_TABLE_DEFINITION = "
    CREATE TABLE cards (
      id              INTEGER PRIMARY KEY,
      spaces_string   TEXT    NOT NULL,
      made_from       INT,

      FOREIGN KEY (made_from) REFERENCES terms (id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
  );"
  private_constant :CARDS_TABLE_DEFINITION

end