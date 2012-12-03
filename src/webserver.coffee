express = require 'express'
http = require 'http'
require('pkginfo')(module, 'name', 'version')

Config = require './config'
Logger = require './logger'
{Identity, generate_identity} = require './identity'

class WebServer
  constructor: ->
    @config = Config.get()
    @logger = Logger.get()
    @identity = Identity.get()
    @app = express()
    @app.configure
    @app.use express.bodyParser()

    @setup_routing()
    @srv = http.createServer(@app)
    @srv.listen(@config.get('port'))
    @logger.info "Webserver is up at: http://0.0.0.0:#{@config.get('port')}"

  setup_routing: =>
    # Returns the base name and version of the app.
    @app.get '/', (req, res, next) =>
      res.json 200, 
        name: exports.name,
        version: exports.version

module.exports = WebServer
