ldap = require 'ldapjs'

module.exports =
  start_server: () ->
    server = ldap.createServer()
    server.listen 1389, () ->
      console.log '/etc/passwd LDAP server up at: %s', server.url
