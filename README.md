# buggy

A Slackbot that makes it easy to organize bug bashes. This is my Artsy 2018 Hackathon project.

## Setup

Do the clone and `bundle install`, then make sure the follow env vars are set:

```sh
export SLACK_API_TOKEN='Token you got from the Engineering 1Password'
export GITHUB_ACCESS_TOKEN='GitHub personal access token with repo scope'
export DATABASE_URL='my something like postgres://localhost/buggy'
```

Then run the server with `bundle exec puma`. It'll run a Sinatra server, but that's only to play nicely with Heroku. In reality, a thread has been spawned to connect to your Slack instance.

Look for TODOs to see what's left to do.

## Resources

Here are some things that've helped me:

- [slack-ruby-bot](https://github.com/slack-ruby/slack-ruby-bot)
- [sequel cheat sheet](https://github.com/jeremyevans/sequel/blob/master/doc/cheat_sheet.rdoc)
