#!/bin/bash
set -e
source /tmp/buildconfig
set -x

## Often used tools.
$minimal_apt_get_install curl wget nano vim psmisc mc iptraf bash-completion tcpdump mtr-tiny screen tmux tar rar unrar zip unzip lsof git mercurial \
                         strace ntp telnet nmap bind9-host dnsutils jq rsync ssh rlwrap elfutils libaio1 libaio-dev libstdc++6-4.4-dev libtool  \
                         numactl pdksh openssh-server openssh-client gawk patch gcc ksh make sysstat tcsh unixODBC unixODBC-dev \
                         bc xauth g++ rpm2cpio awscli tree avreg-server-mysql
## This tool runs a command as another user and sets $HOME.
cp /tmp/bin/setuser /sbin/setuser
