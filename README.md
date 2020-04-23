# Run Podman containers with Systemd
This is a simple example of running two containers via systemd and
podman. The web server is exposed via port 8080 on the host and it
communicates with a database. The database bind mounts the
`/var/lib/mysql/data` directory on the host to persist data.

This example uses the following images:
* quay.io/rlucente-se-jboss/myphp:latest
* registry.redhat.io/rhscl/mariadb-102-rhel7:10.2

## Setup
Install a minimal instance of RHEL 8 and make sure that the hostname
is configured. To set the hostname post installation you can simply
use the command:

    sudo hostnamectl set-hostname NAME

where `NAME` is your desired hostname.

Install the needed packages using the command:

    sudo ./setup.sh

Be sure that the Red Hat customer portal credentials are correct
at the top of the `setup.sh` file.  Free developer accounts can be
created on the [Red Hat Developer](https://developers.redhat.com/)
site.

## Using Udica to create policy
The custom SELinux policy included in this git repository was
generated via [Udica](https://github.com/containers/udica).  Udica
provides a way to generate custom SELinux policy for a targeted
class of containers rather than say permitting all containers with
label container_t to access a specific host resource. In this
example, I have a MariaDB database that will bind mount and persist
data to `/var/lib/mysql/data` on the host. I only want the specific
class of MariaDB containers to have access to that host directory.

The commands listed in this section are illustrative of what needs
to be done to generate the custom SELinux policy, but the setup.sh
script above already uses the existing policy file to enable the
mariadb container to persist data. If you want to create the SELinux
policy again, please do the following.

First, login to the desired container registry:

    podman login registry.redhat.io

You'll need your [Red Hat customer support portal](https://access.redhat.com)
credentials to login to the registry. Next, run the mariadb container
interactively with the `bash` command so that it doesn't error out:

    podman run -v /var/lib/mysql/data:/var/lib/mysql/data -p 3306:3306 -it registry.redhat.io/rhscl/mariadb-102-rhel7:latest bash

In a separate terminal window, inspect the running container image
and then generate policy for it:

    podman inspect $(podman ps | awk 'END{print $1}') | sudo udica mariadb_container

The above command works as long as there's only one container
running. The result is the `mariadb_container.cil` file that's
already included in this repository.

*NB: The mariadb_container.cil file needed to be tweaked to add
permissions for this example to work. If you generate the file
yourself, please compare to what is in this repository.*

## Run the containers
Start the PHP and MariaDB containers using the command:

    ./start-app.sh

## Stop the containers
Stop the containers using:

    ./stop-app.sh

