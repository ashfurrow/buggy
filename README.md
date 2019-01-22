# buggy [![Build Status](https://travis-ci.org/ashfurrow/buggy.svg?branch=master)](https://travis-ci.org/ashfurrow/buggy)

A Slackbot that makes it easy to organize bug bashes. This is my Artsy 2018 Hackathon project. It's still a work-in-progress.

## Usage

In Artsy's Slack, buggy is already set up. Open a new DM with the bot and type `buggy`:

```
buggy
> `buggy start` #channel-name URL # starts a bug bash.
> `buggy end` # ends your bug bash.
> `buggy events` # lists all current bug bashes.
> `buggy leaderboard [ID]` # Prints the leaderboard with that ID (ID is optional if you are in the event or started it).
> `buggy next [fixed, skip, docs, verified, interlinked]` # Gets your next bug
> - `fixed`: you fixed the bug.
> - `skip`: you didn't do anything and just want a different bug.
> - `docs`: you added some docs or resources to help someone else fix it.
> - `verified`: you verified the bug still exists (or was fixed already).
> - `interlinked`: you added a link to a related Sentry, GitHub, or Jira entity.
> `buggy join [ID]` # joins a bug bash with that ID (ID is optional unless there are multiple concurrent bashes).
> `buggy points` # Gets your number of points
> `buggy leave` # leaves your current bug bash.
```

When starting an even, you need to give it two things: a Slack channel to make announcements in, and a source of bugs to fix. Either Jira or GitHub works. There are some limitations, check out the [open issues](https://github.com/ashfurrow/buggy/issues) if you run into trouble, or DM Ash.

## Contributing

Do the clone and `bundle install`, then make sure the follow env vars are set:

```sh
export SLACK_API_TOKEN='Token you got from the Engineering 1Password'
export GITHUB_ACCESS_TOKEN='GitHub personal access token with repo scope'
export DATABASE_URL='my something like postgres://localhost/buggy'
export JIRA_EMAIL='Email in 1Password'
export JIRA_TOKEN='Token in 1Password' # See docs for token creation: https://confluence.atlassian.com/cloud/api-tokens-938839638.html
```

Then run the server with `bundle exec puma`. It'll run a Sinatra server, but that's only to play nicely with Heroku. In reality, a thread has been spawned to connect to your Slack instance.

## Resources

Here are some things that've helped me:

- [slack-ruby-bot](https://github.com/slack-ruby/slack-ruby-bot)
- [sequel cheat sheet](https://github.com/jeremyevans/sequel/blob/master/doc/cheat_sheet.rdoc)
- [Slack message formatting docs](https://api.slack.com/docs/message-formatting)
- [Jira API docs](https://docs.atlassian.com/software/jira/docs/api/REST/7.12.3/#api/2/search-search)
