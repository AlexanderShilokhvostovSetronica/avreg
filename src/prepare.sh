#!/bin/bash
set -e
source /tmp/buildconfig
set -x

## Temporarily disable dpkg fsync to make building faster.
if [[ ! -e /etc/dpkg/dpkg.cfg.d/docker-apt-speedup ]]; then
	echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup
fi

## Prevent initramfs updates from trying to run grub and lilo.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189
export INITRD=no
mkdir -p /etc/container_environment
echo -n no > /etc/container_environment/INITRD

## Enable Ubuntu Universe and Multiverse.
sed -i 's/^#\s*\(deb.*universe\)$/\1/g;/multiverse/d' /etc/apt/sources.list
echo "deb http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list
echo "deb http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list
echo "deb http://archive.canonical.com/ubuntu trusty partner" > /etc/apt/sources.list.d/partner.list
echo "deb http://avreg.net/repos/6.1/ubuntu/ trusty main contrib non-free" > /etc/apt/sources.list.d/avreg.list
apt-get update
$minimal_apt_get_install ubuntu-extras-keyring
echo "deb http://extras.ubuntu.com/ubuntu trusty main" > /etc/apt/sources.list.d/extras.list
apt-get update
## Fix some issues with APT packages.
## See https://github.com/dotcloud/docker/issues/1024
dpkg-divert --local --rename --add /sbin/initctl
ln -sf /bin/true /sbin/initctl

## Replace the 'ischroot' tool to make it always return true.
## Prevent initscripts updates from breaking /dev/shm.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## https://bugs.launchpad.net/launchpad/+bug/974584
dpkg-divert --local --rename --add /usr/bin/ischroot
ln -sf /bin/true /usr/bin/ischroot

## Install HTTPS support for APT.
$minimal_apt_get_install apt-transport-https ca-certificates

## Install add-apt-repository
$minimal_apt_get_install software-properties-common

## Upgrade all packages.

apt-get dist-upgrade -y --no-install-recommends

## Fix locale.
$minimal_apt_get_install language-pack-en
locale-gen en_US
locale-gen ru_RU.UTF-8
locale-gen fr_FR.UTF-8
update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8
echo -n en_US.UTF-8 > /etc/container_environment/LANG
echo -n en_US.UTF-8 > /etc/container_environment/LC_CTYPE
