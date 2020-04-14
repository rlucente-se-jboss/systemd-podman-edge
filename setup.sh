#!/usr/bin/env bash

dnf -y update

dnf -y groupinstall 'Development Tools' 'Container Management'
dnf -y install cmake lsof man-pages man-pages-overrides systemd-devel

dnf -y clean all

