Exec { path => "/usr/bin:/usr/sbin/:/bin:/sbin" }

exec { "manager update":
    command => "apt-get update",
}

include mysql
include git
include wget
include php
include apache
include vim
include firefox
include xvfb
include dev
include pip
include phantomjs
include casperjs