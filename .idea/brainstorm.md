# Bugbash-maker

- [ ] Come up with a better name.

## Example Script (Starting a bash)

```
/bugbash
> What's your bugbash name?
Ash's Bugbash
> Where are the bugs?
[...]
> What channel to announce in?
#dev
> Okay, announced in #dev: [link]
```

## Bug Sources

- Epic links: https://artsyproduct.atlassian.net/browse/PURCHASE-344
- Jira searches:
	- Single label: https://artsyproduct.atlassian.net/browse/SELL-1133?jql=labels%20%3D%20good-first-issue
		- `labels = good-first-issue`
	- Multiple labels: https://artsyproduct.atlassian.net/browse/SELL-1133?jql=labels%20in%20(good-first-issue%2C%20infrastructure)
		- `labels in (good-first-issue, infrastructure)`
- GitHub repos
- GitHub searches
- Sentry projects
- Sentry searches

(Parsing out complete search URLs for all these searches might get tedious, just do a reasonable job and confirm with the user what the source is.)

## Example Script (Joining a bash)

```
/joinbash
> Which bash do you want to join?
> 1. Ash's Bugbash
(This should just auto-join if there's only one current bash.)
> Okay, here's your first issue: [...]
> Good luck. If you fix it, great! But there are lots of ways to contribute: 
> - Add steps to reproduce
> - Verify the bug still exists
> - Find out when the bug was introduced
> - Link the bug to other context (Sentry reports, GitHub issues, Jira tickets)
> - Investigate and add docs to the bug that might be helpful next time
> When you're done with this bug, type `/donebug` to get another one!
```

```
/donebug
> Great! What did you end up doing?
> 1. I fixed it
> 2. I added steps to reproduce or documentation
> 3. I verified the bug still exists
> 4. I found the bug in another place and added links
> 5. I didn't do anything, I just want a new bug.
```

Additional commands for `/stats` or whatever.

## Example Script (ending a bash)

```
/endbash # Ends your bug bash. Restrict users to only having one at a time so this is easy.
```

## Resources

dB recommends: https://github.com/slack-ruby/slack-ruby-bot#slack-ruby-bot (not this, which would be installable for anyone: https://github.com/slack-ruby/slack-ruby-bot-server). He's got a video on this topic, too: https://code.dblock.org/2016/03/11/your-first-slack-bot-service-video.html

## Feedback from Eloy

- limit data sources?
- chats directly with the bot won't be public, but getting people excited is an important part of a bug bash, so always have the bot send a message to the channel
- reduce the number of commands as follows:

Not joined an active bash yet:

```
/bot [join]
Hey there, do you want to join:
1. Ash's Bugbash
Okay, here's your first issue: [...]
```

In an active bash, but not assigned a ticket:

```
/bot [gimme]
Okay, here's your artisinally selected issue: [...]
```

With an assigned ticket:

```
/bot [done]
Great, are you done with "[…]"? If so, what did you do?
1. Nope, cancel
2. I fixed it
3. …
```