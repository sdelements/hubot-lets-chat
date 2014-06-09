# Let's Chat Hubot Adapter

This is a WIP and will probably be unreliable for a while, so use at your own risk!

Important Note: LCB 0.3.0 will ship with an API_TOKEN. This adapter will probably break.

## Setup

Create a new brobot
```
hubot --create myhubot
```

Go into your new bot's directory
```
cd myhubot
```

Install this adapter via npm
```
npm install hubot-lets-chat --save
```

Set the following environment variables
```
export HUBOT_LCB_USER=user@example.com
export HUBOT_LCB_PASSWORD=ohmygodthisisbadpractice
export HUBOT_LCB_ROOM=5279facb1015642226000011
```

These environment variables are *optional* and have default values
```
export HUBOT_LCB_PROTOCOL=http
export HUBOT_LCB_HOSTNAME=localhost
export HUBOT_LCB_PORT=5000
```

Enjoy skynet, I hope you're happy with yourself
```
bin/hubot -a lets-chat
```
