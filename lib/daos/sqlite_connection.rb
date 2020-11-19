require "sqlite3"

##
# Sqlite database connection base class
#
# Intended to be used as a base class for Sqlite specific DAOs and utilities to extend and reuse connection details.
class SqliteConnection

  @@database_file = 'carrot-cat.db'.freeze

  protected def get_database_connection
    return SQLite3::Database.new @@database_file
  end

end

class DatabaseError < StandardError
end
