Robot   = require('hubot').Robot
Adapter = require('hubot').Adapter
TextMessage = require('hubot').TextMessage

LCB_PROTOCOL = process.env.HUBOT_LCB_PROTOCOL || 'http'
LCB_HOSTNAME = process.env.HUBOT_LCB_HOSTNAME || 'localhost'
LCB_PORT = process.env.HUBOT_LCB_PORT || 5000
LCB_USER = process.env.HUBOT_LCB_USER
LCB_PASSWORD = process.env.HUBOT_LCB_PASSWORD
LCB_ROOM = process.env.HUBOT_LCB_ROOM

io = require('socket.io-client')
url = require('url')

chatURL = url.format(
  protocol: LCB_PROTOCOL
  hostname: LCB_HOSTNAME
  port: LCB_PORT
  query:
    username: LCB_USER
    password: LCB_PASSWORD
)

class LCB extends Adapter

  constructor: (@robot) ->
    super @robot

  send: (user, strings...) ->
    for str in strings
      @socket.emit 'room:messages:new',
        'room': user.room,
        'text': "#{str}"

  reply: (user, strings...) ->
    for str in strings
      @socket.emit 'room:messages:new',
        'room': user.room,
        'text': "@#{user.name}: #{str}"

  run: ->
    @socket = io.connect chatURL
    @socket.on 'connect', =>
      # TODO: Fix this shitty server shit bro
      @socket.emit 'user:whoami'
      @socket.on 'user:whoami', (profile) =>
        @robot.name = profile.safeName
        if !@connected
          @emit 'connected'
          @connected = true
      @socket.emit 'room:join', LCB_ROOM, (room) =>
        console.log 'Joined ' + room.name
    @socket.on 'room:messages:new', (message) =>
      user = @robot.brain.userForId message.owner,
        room: message.room,
        name: message.name
      @receive new TextMessage user, message.text
    @socket.on 'error', (err) =>
      console.log err
    @socket.on 'disconnect', =>
      console.log 'Disconnected!'

exports.use = (robot) ->
  new LCB robot
