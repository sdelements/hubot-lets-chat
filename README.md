# Let's Chat Hubot Adapter

This is a WIP and will probably be unreliable for a while, so use at your own risk!

## Setup

Create a new brobot
```
hubot --create myhubot
```

Go into your new bot's directory
```
cd myhubot
```

### Let's Chat 0.3+

Install this adapter via npm
```
npm install hubot-lets-chat --save
```

Set the following environment variables for Let's Chat 0.3
```
export HUBOT_LCB_TOKEN=NTRiNjg5NmYyMDZiMzEwMDAwYTAxNmZiOjE0ZTg2ODMwYz...
export HUBOT_LCB_ROOMS=5279facb1015642226000011,5394ffbabdea44e815000003
```

### Let's Chat 0.2

Install this adapter via npm
```
npm install hubot-lets-chat@0.0.4 --save
```

Set the following environment variables for Let's Chat 0.2
```
export HUBOT_LCB_USER=user@example.com
export HUBOT_LCB_PASSWORD=ohmygodthisisbadpractice
export HUBOT_LCB_ROOMS=5279facb1015642226000011,5394ffbabdea44e815000003
```

### Let's Chat 0.3+ and 0.2

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
