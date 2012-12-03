optimist = require 'optimist'
require('pkginfo')(module, 'name')

Config = require './config'
Logger = require './logger'

###*
 * The command line interface class.
###
class CLI
  constructor: ->
    @config = Config.get()
    @logger = Logger.get()
    @argv = optimist
      .usage("Usage: " + exports.name)

      # configuration
      .alias('c', 'config')
      .describe('c', 'The configuration file to use')
      .default('c', "/etc/ldapless.json")

      # admin secret
      .alias('a', 'admin_secret')
      .describe('a', 'The secret for the admin user')
      .default('a', "admin")

      # logging
      .alias('l', 'loglevel')
      .describe('l', 'Set the log level (debug, info, warn, error, fatal)')
      .default('l', 'warn')

      # port
      .alias('p', 'port')
      .describe('p', 'Run the api server on the given port')
      .default('p', 3000)

      # help
      .alias('h', 'help')
      .describe('h', 'Shows this message')
      .default('h', false)

      # append the argv from the cli
      .argv

    @configure()

    if @config.get('help') and @config.get('help').toString() is "true"
      optimist.showHelp()
      process.exit(0)

  # Configures the nconf mapping where the priority matches the order
  configure: =>
    @set_overrides()
    @set_argv()
    @set_env()
    @set_file()
    @set_defaults()

  # Sets up forceful override values
  set_overrides: =>
    @config.overrides({
      })

  # Sets up the configuration for cli arguments
  set_argv: =>
    @config.add('optimist_args', {type: 'literal', store: @argv})

  # Sets up the environment configuration
  set_env: =>
    @config.env({
      whitelist: []
      })

  # Sets up the file configuration
  set_file: =>
    @config.file({ file: @config.get('c') })

  # Sets up the default configuration
  set_defaults: =>
    @config.defaults({
      })

module.exports = CLI
