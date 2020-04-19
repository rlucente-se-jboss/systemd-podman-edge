#!/usr/bin/env bash

#
# Add your Red Hat Customer Portal credentials
#
USERNAME=
PASSWORD=

TYPE="Virtual"
POOL=

if [[ "$(whoami)" != "root" ]]
then
    echo
    echo "*** MUST RUN AS root ***"
    echo
    exit 1
fi

subscription-manager register --username $USERNAME --password $PASSWORD || exit 1

if [[ "$POOL" = "" ]]
then
    POOL=$(subscription-manager list --all --available | \
        grep 'Pool ID\|Entitlement Type\|Subscription Name\|Available' | \
        grep -A3 'Employee SKU' | grep -B3 $TYPE | grep 'Pool ID' | \
        awk '{print $NF; exit}')

    if [[ "$POOL" = "" ]]
    then
        echo "No matching pools found"
        exit 1
    fi
fi

subscription-manager attach --pool="$POOL" || exit 1

subscription-manager repos --disable='*'
subscription-manager repos \
    --enable=rhel-8-for-x86_64-baseos-rpms \
    --enable=rhel-8-for-x86_64-appstream-rpms

dnf -y update

dnf -y groupinstall 'Development Tools' 'Container Management'
dnf -y install cmake lsof man-pages man-pages-overrides systemd-devel udica

dnf -y clean all

#
# open firewall ports
#
firewall-cmd --add-port 8080/tcp --permanent
firewall-cmd --reload

#
# create persistent data directory for mariadb
#
mkdir -p /var/lib/mysql/data
chmod a+rwx /var/lib/mysql/data

#
# modify SELinux policy to allow container access to /var/lib/mysql/data
#
restorecon -vFr /var/lib/mysql
semodule -v -i mariadb_container.cil /usr/share/udica/templates/{base_container.cil,net_container.cil}
