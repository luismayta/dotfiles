Exec { path => "/usr/bin:/usr/sbin/:/bin:/sbin" }

exec { "manager update":
    command => "apt-get update",
}

include git
include wget
include vim
