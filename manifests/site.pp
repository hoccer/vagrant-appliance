# Ensure that apt-get update is called
# automatically when a package is about to be installed
exec { 'apt-update':
  command => '/usr/bin/apt-get update'
}

Exec['apt-update'] -> Package <| |>

# Postgresql
# see https://forge.puppetlabs.com/puppetlabs/postgresql
class { 'postgresql::server':
  # This obviously still needs tweaking
  ip_mask_allow_all_users => '0.0.0.0/0',
  listen_addresses        => '*',
  postgres_password       => 'postgres!'
}

postgresql::server::db { 'talk':
  user     => 'talk',
  password => postgresql_password('talk', 'talk'),
}

# MongoDB
# see https://forge.puppetlabs.com/puppetlabs/mongodb
class { 'mongodb' :
    init => 'upstart',
}

# Nginx
# see https://forge.puppetlabs.com/puppetlabs/nginx
class { 'nginx': }

# setup required users
class users {
    user { 'deployment':
        ensure     => present,
        groups     => ['adm','admin', 'sudo'],
        managehome => true,
        shell      => '/bin/bash',
    }
    user { 'talk':
        ensure     => present,
        groups     => [],
        managehome => true,
        shell      => '/bin/bash',
    }
}

# setup the node...
node default {
  include users
  include postgresql::server
  include mongodb
}
