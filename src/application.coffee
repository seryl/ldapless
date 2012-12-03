Logger = require './logger'
CLI = require './cli'
Config = require './config'
{Identity, generate_identity} = require './identity'
WebServer = require './webserver'
LdapServer = require './ldapserver'

###*
 * The base application class.
###
class Application
  constructor: ->
    @config = Config.get()
    @logger = Logger.get()
    @cli = new CLI()
    @identity = Identity.get()
    @ws = new WebServer()
    @ls = new LdapServer()

  ###*
   * Aborts the application with a message.
   * @param {String} (msg) The message to abort the application with
  ###
  abort: (msg) =>
    @logger.info(''.concat('Aborting Application: ', str, '...'))
    process.exit(1)

module.exports = Application
