SUFFIX = 'o=example'

ldap = require 'ldapjs'
ldapRiak = require 'ldapjs-riak'
require('pkginfo')(module, 'name', 'version')

Config = require './config'
Logger = require './logger'
{Identity, generate_identity} = require './identity'

class LdapServer
  constructor: ->
    @config = Config.get()
    @logger = Logger.get()
    @logger.getLogger = () -> return @logger
    @identity = Identity.get()
    @app = ldap.createServer()
    backend = ldapRiak.createBackend
      bucket:
        name: "ldapjs_riak"

      uniqueIndexBucket:
        name: "ldapjs_ldapjs_riak"

      indexes:
        email: true
        uuid: true
        cn: false
        sn: false

      client:
        url: "http://localhost:8098"
        clientId: "ldapjs_riak_1"
        retry:
          retries: 3
          factor: 2
          minTimeout: 1000
          maxTimeout: 10000

      log4js: @logger

    @app.bind 'cn=root', (req, res, next) ->
      if req.version != 3
        return next(new ldap.ProtocolError(req.version + ' is not v3'))

      if req.credentials != 'secret'
        return next(new ldap.InvalidCredentialsError(req.dn.toString()))

    authorize = (req, res, next) =>
      bindDN = req.connection.ldap.bindDN
      return next()

      if req.type == 'BindRequest' or
          bindDN.parentOf(req.dn) or
          bindDN.equals(req.dn)
        return next()

      return next(new ldap.InsufficientAccessRightsError())

    @app.add(SUFFIX, backend, authorize, backend.add())
    @app.modify(SUFFIX, backend, authorize, backend.modify())
    @app.bind(SUFFIX, backend, authorize, backend.bind())
    @app.compare(SUFFIX, backend, authorize, backend.compare())
    @app.del(SUFFIX, backend, authorize, backend.del())
    @app.search(SUFFIX, backend, authorize, backend.search())

    @app.listen 1389, =>
      @logger.info "Ldap server is up at: #{@app.url}"

module.exports = LdapServer
