require 'slack-buggybot/database'

SlackBuggybot::Database.database

module SlackBuggybot
  class Bug < Sequel::Model
    def self.ready
      return self.where(state: 'ready')
    end

    def self.user_existing_bug(user_id:)
      event = Event.user_current_event(user_id: user_id)
      raise "User isn't in event." if event.nil?
      Bug.where(assignee: user_id).first
    end

    def assign(assignee_id:)
    end
  end
end
