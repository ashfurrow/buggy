require 'slack-buggybot/database'

SlackBuggybot::Database.database

class Bug < Sequel::Model
  def self.ready
    return self.where(state: 'ready')
  end
end
