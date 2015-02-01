BASIC_EXCLUDES="
    lost+found
    run/acpid.socket
    run/dbus/system_bus_socket
    tmp
    var/cache/apt/*.bin
    var/cache/apt/archives/*.deb
    var/cache/debconf/*-old
    var/lib/apt/lists/*
    var/lib/dpkg/*-old
    etc/udev/rules.d/*-persistent-net.rules
"

PERSIST_EXCLUDES="
    etc/live/protect/remaster
"

REMASTER_EXCLUDES="
    dev
    etc/live/protect/persist
    proc
    root/.bash_history
    sys
    var/log/*.log
    var/log/apt/*.log
    var/tmp
"


