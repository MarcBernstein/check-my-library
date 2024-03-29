$as_vagrant   = 'sudo -u vagrant -H bash -l -c'
$home         = '/home/vagrant'

# $ar_databases = ['activerecord_unittest', 'activerecord_unittest2']

$ruby_version = '2.1.2'

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# --- Preinstall Stage ---------------------------------------------------------

stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { 'apt-get -y update':
    unless => "test -e ${home}/.rvm"
  }
}
class { 'apt_get_update':
  stage => preinstall
}

file {'gemrc':
  path    => '/home/vagrant/.gemrc',
  ensure  => present,
  mode    => 0644,
  content => 'gem: --no-rdoc --no-ri'
}

# --- SQLite -------------------------------------------------------------------

package { ['sqlite3', 'libsqlite3-dev']:
  ensure => installed;
}

# --- MySQL --------------------------------------------------------------------

# class install_mysql {
#   class { 'mysql': }

#   class { 'mysql::server':
#     config_hash => { 'root_password' => '' }
#   }

#   database { $ar_databases:
#     ensure  => present,
#     charset => 'utf8',
#     require => Class['mysql::server']
#   }

#   database_user { 'rails@localhost':
#     ensure  => present,
#     require => Class['mysql::server']
#   }

#   database_grant { ['rails@localhost/activerecord_unittest', 'rails@localhost/activerecord_unittest2', 'rails@localhost/inexistent_activerecord_unittest']:
#     privileges => ['all'],
#     require    => Database_user['rails@localhost']
#   }

#   package { 'libmysqlclient15-dev':
#     ensure => installed
#   }
# }
# class { 'install_mysql': }

# --- PostgreSQL ---------------------------------------------------------------

# class install_postgres {
#   class { 'postgresql': }

#   class { 'postgresql::server': }

#   pg_database { $ar_databases:
#     ensure   => present,
#     encoding => 'UTF8',
#     require  => Class['postgresql::server']
#   }

#   pg_user { 'rails':
#     ensure  => present,
#     require => Class['postgresql::server']
#   }

#   pg_user { 'vagrant':
#     ensure    => present,
#     superuser => true,
#     require   => Class['postgresql::server']
#   }

#   package { 'libpq-dev':
#     ensure => installed
#   }

#   package { 'postgresql-contrib':
#     ensure  => installed,
#     require => Class['postgresql::server'],
#   }
# }
# class { 'install_postgres': }

# --- Memcached ----------------------------------------------------------------

# class { 'memcached': }

# --- Packages -----------------------------------------------------------------

package { 'curl':
  ensure => installed
}

package { 'build-essential':
  ensure => installed
}

package { 'git-core':
  ensure => installed
}

# Nokogiri dependencies.
package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed
}

# ExecJS runtime.
package { 'nodejs':
  ensure => installed
}

# --- Ruby ---------------------------------------------------------------------

exec { 'install_rvm':
  command => "${as_vagrant} 'curl -L https://get.rvm.io | bash -s stable'",
  creates => "${home}/.rvm/bin/rvm",
  require => Package['curl']
}

exec { 'rvm_requirements':
  command => "${as_vagrant} '${home}/.rvm/bin/rvm requirements'",
  require => Exec['install_rvm']
}

exec { 'install_ruby':
  # We run the rvm executable directly because the shell function assumes an
  # interactive environment, in particular to display messages or ask questions.
  # The rvm executable is more suitable for automated installs.
  command => "${as_vagrant} '${home}/.rvm/bin/rvm install ruby-${ruby_version} --autolibs=enabled && rvm alias create default ${ruby_version}'",
  creates => "${home}/.rvm/bin/ruby",
  require => Exec['rvm_requirements']
}

# RVM installs a version of bundler, but for edge Rails we want the most recent one.
exec { "${as_vagrant} 'gem install bundler --no-rdoc --no-ri'":
  creates => "${home}/.rvm/bin/bundle",
  require => Exec['install_ruby']
}

# --- Locale -------------------------------------------------------------------

# Needed for docs generation.
exec { 'update-locale':
  command => 'update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8'
}
