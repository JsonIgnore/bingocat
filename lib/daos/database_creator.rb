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

  end

  private def create_terms_table
    results = @database.execute TERMS_TABLE_DEFINITION
  end


  ##  Table Definitions  ##
  TERMS_TABLE_DEFINITION = "
    CREATE TABLE terms (
      id            INT             SERIAL,
      name          VARCHAR(255),
      terms_string  TEXT            NOT NULL,
      free_space    VARCHAR(255)    NOT NULL,

      PRIMARY KEY (id)
    );"
  private_constant :TERMS_TABLE_DEFINITION

end