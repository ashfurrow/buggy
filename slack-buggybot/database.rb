require "sequel"

# Taken from https://github.com/KrauseFx/mood/blob/master/database.rb

module SlackBuggybot
  class Database
    def self.database
      @_db ||= Sequel.connect(ENV["DATABASE_URL"])

      unless @_db.table_exists?("events")
        @_db.create_table :events do
          primary_key :id
          DateTime :start
          String :owner
        end
      end

      unless @_db.table_exists?("bugs")
        @_db.create_table :bugs do
          primary_key :id
          foreign_key :event_id, :events
          String :url, null: false
          String :assignee
          DateTime :completed
        end
      end

      return @_db
    end
  end
end
