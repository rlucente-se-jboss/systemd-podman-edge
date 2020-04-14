#!/usr/bin/env bash

#
# replace with your credentials for RHSM
#
USERNAME=
PASSWORD=

podman login --username=$USERNAME --password=$PASSWORD registry.redhat.io

podman pull registry.redhat.io/rhscl/mariadb-102-rhel7:latest
podman pull quay.io/rlucente-se-jboss/myphp:latest

sudo firewall-cmd --add-port 8080/tcp --permanent
sudo firewall-cmd --reload

sudo mkdir -p /var/lib/mysql/data
sudo chmod a+rwx /var/lib/mysql/data

#
# modify SELinux policy to allow access to /var/lib/mysql/data
#
sudo ausearch -c mysqld | audit2allow -M local
checkmodule -M -m -o local.mod local.te
semodule_package -o local.pp -m local.mod
sudo semodule -i local.pp

#
# enable services and start as local user
#
mkdir -p $HOME/.config/systemd/user
cp *.service $HOME/.config/systemd/user

systemctl --user enable container-mariadb.service
systemctl --user enable container-myphp.service

systemctl --user start container-mariadb.service
systemctl --user start container-myphp.service

