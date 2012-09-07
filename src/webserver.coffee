express = require 'express'
app = express()

module.exports =
  start_server: () ->
    this.setup_routes()
    app.listen('3000')
    console.log "Webserver is up at: http://0.0.0.0:%s", 3000

  setup_routes: () ->
    app.get '/', (req, res) ->
      res.send('Hello world')
