# == Class: rsyslog
#
# rsyslogd is a full-featured kernel logging daemon. It is the default
# syslogd implementation on Debian systems.
#
class rsyslog {

    if (! defined(Package['apt-transport-https'])) {
        package { 'apt-transport-https':
          ensure => 'present'
        }
    }

    apt::source { 'wikimedia':
      location => 'https://apt.wikimedia.org/wikimedia',
      repos    => 'main',
      release  => 'stretch-wikimedia',
      key      => {
          'id'     => 'B8A2DF05748F9D524A3A2ADE9D392D3FFADF18FB',
          'server' => 'https://apt.wikimedia.org',
          'source' => 'https://wikitech.wikimedia.org/w/index.php?title=APT_repository/Stretch-Key&action=raw',
      },
    }
    package { 'rsyslog':
        ensure => present,
        require => Apt::Source['wikimedia']
    }

    file { '/etc/rsyslog.d':
        ensure  => directory,
        source  => 'puppet:///modules/rsyslog/rsyslog.d-empty',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        recurse => true,
        purge   => true,
        force   => true,
        ignore  => '50-default.conf',
        require => Package['rsyslog'],
        notify  => Service['rsyslog'],
    }

    service { 'rsyslog':
        ensure  => running,
        require => Package['rsyslog'],
    }
}
