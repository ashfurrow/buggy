# frozen_string_literal: true

require 'slack-buggybot/database'

SlackBuggybot::Database.database

module SlackBuggybot
  class Bug < Sequel::Model
    def self.ready
      self.where(state: 'ready')
    end

    def self.ready_in_event(event_id)
      return self.ready.where(event_id: event_id)
    end

    def self.remaining_in_event(event_id)
      return self.where(event_id: event_id).where(state: %w(ready wip))
    end

    def self.done_in_event(event_id)
      self.where(event_id: event_id).where(state: %w(fixed added_docs verified interlinked))
    end
    
    def self.in_event(event_id)
      self.where(event_id: event_id)
    end

    def self.user_existing_bug(user_id:, event_id:)
      Bug.in_event(event_id).where(completed: nil).where(assignee: user_id).first
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
