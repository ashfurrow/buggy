require 'slack-buggybot/database'

SlackBuggybot::Database.database

module SlackBuggybot
  class Bug < Sequel::Model
    def self.ready
      self.where(state: 'ready')
    end

    def self.wip
      self.where(state: 'wip')
    end
    
    def self.in_event(event_id)
      self.where(event_id: event_id)
    end

    def self.user_existing_bug(user_id:, event_id:)
      Bug.in_event(event_id).where(state: 'wip').where(assignee: user_id).first
    end

    def self.user_finished_bugs(user_id:, event_id:)
      Bug.in_event(event_id).where(assignee: user_id).where(Sequel.~(completed: nil))
    end

    # Instance methods
    def assign(user_id:)
      self.update(assignee: user_id, state: 'wip')
      self.save
    end
  end
end
