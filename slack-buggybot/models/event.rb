require 'slack-buggybot/database'

SlackBuggybot::Database.database

class Event < Sequel::Model
  def self.open
    return self.where(end: nil)
  end
end
