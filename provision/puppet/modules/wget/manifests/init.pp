class wget {
    package { 'wget':
        ensure => installed,
        require => Exec["manager update"],
    }
}
