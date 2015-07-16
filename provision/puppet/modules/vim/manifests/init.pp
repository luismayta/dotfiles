class vim {
    package { 'vim':
        ensure => installed,
        require => Exec["manager update"],
    }
}
