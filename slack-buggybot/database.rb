require 'sequel'

# Taken originally from https://github.com/KrauseFx/mood/blob/master/database.rb

module SlackBuggybot
  class Database
    def self.database
      db.transaction do
        unless db.table_exists?("events")
          db.create_table :events do
            primary_key :id
            DateTime :start, null: false
            DateTime :end
            String :owner, null: false
            column 'users', 'text[]', null: false, default: []
          end
        end

        unless db.table_exists?("bugs")
          db.create_enum(:event_state, %w(ready wip done))
          db.create_table :bugs do
            primary_key :id
            foreign_key :event_id, :events
            String :url, null: false
            String :assignee
            DateTime :completed
            event_state :state, default: 'ready'
          end
        end

        return db
      end
    end

    private
    def self.db
      if @_db.nil?
        @_db = Sequel.connect(ENV["DATABASE_URL"])
        @_db.extension :pg_enum
        @_db.extension :pg_array
      end
      @_db
    end
  end
end
