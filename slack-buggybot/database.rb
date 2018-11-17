require 'sequel'

# Taken originally from https://github.com/KrauseFx/mood/blob/master/database.rb

module SlackBuggybot
  class Database
    class << self
      # Not great to expose the internal singleton instance, but it makes testing easier.
      # Don't access this in actual code.
      attr_accessor :_db
      
      def database
        db.transaction do
          unless db.table_exists?("events")
            db.create_table :events do
              primary_key :id
              DateTime :start, null: false
              DateTime :end
              String :owner, null: false
              String :channel_id, null: false
              column 'users', 'text[]', null: false, default: []
            end
          end

          unless db.table_exists?("bugs")
            # Enum options (ready, then wip, then one of these)
            # > 1. I fixed it
            # > 2. I added steps to reproduce or documentation
            # > 3. I verified the bug still exists
            # > 4. I found the bug in another place and added links
            # > 5. I didn't do anything, I just want a new bug.
            db.create_enum(:event_state, %w(ready wip fixed added_docs verified interlinked))
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
      def db
        if @_db.nil?
          @_db = Sequel.connect(ENV["DATABASE_URL"])
          @_db.extension :pg_enum
          @_db.extension :pg_array
        end
        @_db
      end
    end
  end
end
