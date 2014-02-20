# Ensure that apt-get update is called
# automatically when a package is about to be installed
exec { 'apt-update':
  command => '/usr/bin/apt-get update'
}

Exec['apt-update'] -> Package <| |>

class { 'locales':
  locales         => ['en_US.UTF-8 UTF-8']
}

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

# Postgresql
# see https://forge.puppetlabs.com/puppetlabs/postgresql
class { 'postgresql::server':
  # This obviously still needs tweaking
  locale                  => 'en_US.UTF-8',
  encoding                => 'UTF8',
  ip_mask_allow_all_users => '0.0.0.0/0',
  listen_addresses        => '*',
  postgres_password       => 'postgres!',
  # see http://www.postgresql.org/docs/8.2/static/auth-pg-hba-conf.html
  ipv4acls                => ['host all talk 192.168.60.1/32 md5'],
  # manage_firewall         => true
}

postgresql::server::db { 'talk':
  user     => 'talk',
  password => postgresql_password('talk', 'talk'),
  locale   => 'en_US.UTF-8',
  encoding => 'UTF8',
}

# MongoDB
# see https://forge.puppetlabs.com/puppetlabs/mongodb
class { 'mongodb' :
    init => 'upstart',
}

# Nginx
# see https://forge.puppetlabs.com/puppetlabs/nginx
# class { 'nginx': }

# setup the node...
node default {
  include locales
  include users
  include postgresql::server
  include mongodb
  include java7
}
