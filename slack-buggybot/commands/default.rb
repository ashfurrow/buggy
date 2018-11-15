module SlackBuggybot
  module Commands
    class Default < SlackRubyBot::Commands::Base
      # TODO: SlackRubyBot has built-in support for help menus, implement it.
      match(/^(?<buggy>\w*)$/) do |client, data, _match|
        help_message = <<~EOS
        Buggy usage:

        `buggy start` #channel-name URL # starts a bug bash.
        `buggy end` # ends your bug bash.
        `buggy events` # lists all current bug bashes.
        `buggy join [ID]` # joins a bug bash with that ID (ID is optional unless there are multiple concurrent bashes).
        `buggy done [fixed, docs, verified, interlinked, none]` # Gets your next bug
        `buggy leave` # leaves your current bug bash.
          - `fixed`: you fixed the bug.
          - `docs`: you added some docs or resources to help someone else fix it.
          - `verified`: you verified the bug still exists (or was fixed already).
          - `interlinked`: you added a link to a related Sentry, GitHub, or Jira entity.
          - `none`: you didn't do anything and just want a different bug.
        EOS
        client.say(channel: data.channel, text: help_message)
      end
    end
  end
end