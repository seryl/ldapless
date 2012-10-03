common = require './common'
ldap = require 'ldapjs'
ldapRiak = require 'ldapjs-riak'

module.exports =
  start_server: (info) ->
    server = ldap.createServer()
    backend = ldapRiak.createBackend
      bucket:
        name: "ldapless_riak"

      log4js: common.logger
      
      uniqueIndexBucket
        name: "ldapless_riak_indexes"

      indexes:
        email: true
        cn: false
        sn: false

      client:
        url: "http://localhost:8098"
        retry:
          retries: 3
          factor: 2
          minTimeout: 1000,
          maxTimeout: 10000

    server.add(SUFFIX)

    server.listen 1389, () ->
      console.log 'LDAP server is up at: %s', server.url
