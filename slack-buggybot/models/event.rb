require 'slack-buggybot/database'

SlackBuggybot::Database.database

module SlackBuggybot
  class Event < Sequel::Model
    def self.open
      self.where(end: nil)
    end

    def self.user_current_event(user_id:)
      Event.open.all.find { |e| e.users.include? user_id }
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

    # Instance methods
    def name_from_client(client)
      owner_user = client.users[self.owner]
      "#{owner_user.real_name}'s bug bash"
    end

    def sorted_user_names_and_points_from_client(client)
      users
        .map { |u| client.users[u] }
        .map { |u| [u, Bug.user_finished_bugs(user_id: u.id, event_id: self.id).count]}
        .sort { |l, r| l[1] <=> r[1] }
        .reverse
        .map { |a| [a[0].real_name, a[1]]}
    end
  end
end
