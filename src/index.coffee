if process.env.HUBOT_LCB_API_KEY?
  exports.use = require './0_3'
else
  exports.use = require './0_2'
