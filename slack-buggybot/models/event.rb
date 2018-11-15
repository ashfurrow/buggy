require 'slack-buggybot/database'

SlackBuggybot::Database.database

module SlackBuggybot
  class Event < Sequel::Model
    def self.open
      return self.where(end: nil)
    end

    def name_from_client(client)
      owner_user = client.users[self.owner]
      "#{owner_user.real_name}'s bug bash"
    end

    def self.find_from_match(match)
      case Event.open.count
      when 0
        return nil
      when 1
        return Event.open.all.first
      else
        if match[:expression].nil?
          return nil
        else
          pk = match[:expression].to_i
          return Event.open[pk]
        end
      end
    end
  end
end
