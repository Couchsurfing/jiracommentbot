# README

Hi. This repo contains code used for Slack bots.

## Server Reserver<br>
Server Reserver is a Slack app that connects to API endpoints created in this repo. Together, though the use of Slack slash commands, they can handle testing server reservations in case the folks who work at your company have to fight over them. 

The initial server setup is handled by whoever sets the Slack and API apps up, but then anyone can view the list of current reservations, reserve a free server, or unreserve a taken server through the use of slash commands in Slack.

**Available commands:**<br>
/reservations<br>
/reserve [server] [purpose]<br>
/unreserve [server]

## Jira comment bot<br>
Jira comment bot is a Slack app that connects to API endpoints created in this repo. They combine with some Jira webhooks (right now set up through the use of the Automation Lite add-on within Jira) to allow users to receive Jira comments as Slack DMs from the Jira comment bot.

v2 for this app will be transitioning the portion handled by Automation Lite into this app so it's all self-contained.
