## Setup
Install a base image for RHEL 8. Make sure that the hostname is
configured. Post installation you can simply use the command:

    sudo hostnamectl set-hostname NAME

where NAME is your hostname.

Install the needed packages using the command:

    sudo ./setup.sh

Be sure that the Red Hat customer portal credentials are correct
at the top of `setup.sh` file.

## Images to use
Use the following images for this:
* quay.io/rlucente-se-jboss/myphp:latest
* registry.redhat.io/rhscl/mariadb-102-rhel7:10.2

## Run the containers
Run the command:

    ./start-app.sh

## Stop the containers
Run the command:

    ./stop-app.sh

