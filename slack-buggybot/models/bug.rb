require 'slack-buggybot/database'

SlackBuggybot::Database.database

module SlackBuggybot
  class Bug < Sequel::Model
    def self.ready
      return self.where(state: 'ready')
    end
  end
end
