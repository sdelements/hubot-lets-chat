Robot   = require('hubot').Robot
Adapter = require('hubot').Adapter
TextMessage = require('hubot').TextMessage
EnterMessage = require('hubot').EnterMessage

LCB_PROTOCOL = process.env.HUBOT_LCB_PROTOCOL || 'http'
LCB_HOSTNAME = process.env.HUBOT_LCB_HOSTNAME || 'localhost'
LCB_PORT = process.env.HUBOT_LCB_PORT || 5000
LCB_TOKEN = process.env.HUBOT_LCB_TOKEN
LCB_ROOMS = process.env.HUBOT_LCB_ROOMS.split(',')

io = require('socket.io-client')
url = require('url')
tunnelAgent = require('tunnel-agent')

chatURL = url.format(
  protocol: LCB_PROTOCOL
  hostname: LCB_HOSTNAME
  port: LCB_PORT
  query:
    token: LCB_TOKEN
)

class LCB extends Adapter

  constructor: (@robot) ->
    super @robot

  send: (user, strings...) ->
    for str in strings
      @socket.emit 'messages:create',
        'room': user.room,
        'text': "#{str}"

  reply: (user, strings...) ->
    for str in strings
      @socket.emit 'messages:create',
        'room': user.room,
        'text': "@#{user.user.name} #{str}"

  run: ->
    opts = {}
    if process.env.http_proxy
      proxyURL = url.parse(process.env.http_proxy)
      opts.agent = tunnelAgent.httpOverHttp
        proxy:
          host: proxyURL.hostname
          port: proxyURL.port
    @socket = io.connect chatURL, opts

    @socket.on 'connect', =>
      console.log 'connected'

      @socket.emit 'account:whoami', (profile) =>
        @robot.name = profile.username

        if !@connected
          @emit 'connected'
          @connected = true

        for id in LCB_ROOMS
          @socket.emit 'rooms:join', id, (room) =>
            console.log 'Joined ' + room.name

      @socket.on 'users:join', (user) =>
        if user.room not in LCB_ROOMS or user.username is @robot.name
          return

        user = @robot.brain.userForId user.id,
          room: user.room,
          name: user.username

        @receive new EnterMessage user, null, user.id

      @socket.on 'messages:new', (message) =>
        user = @robot.brain.userForId message.owner.id,
          room: message.room.id,
          name: message.owner.username
        # Messages coming from Hubot itself must be filtered by the adapter
        unless message.owner.username is @robot.name
          @receive new TextMessage user, message.text

    @socket.on 'error', (err) =>
      console.log err

    @socket.on 'disconnect', =>
      console.log 'Disconnected!'

module.exports = (robot) ->
  new LCB robot
