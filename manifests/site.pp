# Ensure that apt-get update is called
# automatically when a package is about to be installed
exec { 'apt-update':
  command => '/usr/bin/apt-get update'
}

Exec['apt-update'] -> Package <| |>

# Postgresql server
# see https://forge.puppetlabs.com/puppetlabs/postgresql
class { 'postgresql::server':
  listen_addresses  => '*',
  # This obviously still needs tweaking
  postgres_password => 'postgres!'
}

postgresql::server::db { 'talk':
  user     => 'talk',
  password => postgresql_password('talk', 'talk'),
}

# setup required users
class users {
    user { 'deployment':
        ensure     => present,
        groups     => ['adm','admin', 'sudo'],
        managehome => true,
        shell => "/bin/bash",
    }
    user { 'talk':
        ensure     => present,
        groups     => [],
        managehome => true,
        shell => "/bin/bash",
    }
}

# setup the node...
node default {
  include users
  include postgresql::server
  include mongodb
}
