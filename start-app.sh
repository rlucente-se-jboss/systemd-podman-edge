#!/usr/bin/env bash

#
# replace with your credentials for the Red Hat customer portal
#
USERNAME=
PASSWORD=

podman login --username=$USERNAME --password=$PASSWORD registry.redhat.io

podman pull registry.redhat.io/rhscl/mariadb-102-rhel7:latest
podman pull quay.io/rlucente-se-jboss/myphp:latest

#
# enable services and start as local user
#
mkdir -p $HOME/.config/systemd/user
cp *.service $HOME/.config/systemd/user

systemctl --user enable container-mariadb.service
systemctl --user enable container-myphp.service

systemctl --user start container-mariadb.service
systemctl --user start container-myphp.service

