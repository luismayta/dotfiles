class git {
    package { 'git':
        ensure => installed,
        require => Exec["manager update"],
    }
}
