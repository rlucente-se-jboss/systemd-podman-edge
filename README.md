# Run Podman containers with Systemd
This is a simple example of running two containers via systemd and
podman. The web server is exposed via port 8080 on the host and it
communicates with a database.

This example uses the following images:
* quay.io/rlucente-se-jboss/myphp:latest
* registry.redhat.io/rhscl/mariadb-102-rhel7:10.2

## Setup
Install a base image for RHEL 8 and make sure that the hostname is
configured. To set the hostname post installation you can simply
use the command:

    sudo hostnamectl set-hostname NAME

where `NAME` is your hostname.

Install the needed packages using the command:

    sudo ./setup.sh

Be sure that the Red Hat customer portal credentials are correct
at the top of `setup.sh` file.  Free developer accounts can be
created on the [Red Hat Developer](https://developers.redhat.com/)
site.

## Run the containers
Start the PHP and MariaDB containers using the command:

    ./start-app.sh

## Stop the containers
Stop the containers using:

    ./stop-app.sh

