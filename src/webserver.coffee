common = require './common'
restify = require 'restify'
app = restify.createServer()

module.exports =
  start_server: (info) ->
    this.setup_routes(info)
    app.listen('3000')
    console.log "Webserver is up at: http://0.0.0.0:%s", 3000

  setup_routes: (info) ->
    app.get '/', (req, res) ->
      res.json(200, 
        name: info.name,
        identity: info.identity,
        version: info.version)
