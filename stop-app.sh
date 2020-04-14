#!/usr/bin/env bash

systemctl --user stop container-mariadb.service
systemctl --user stop container-myphp.service
systemctl --user disable container-mariadb.service
systemctl --user disable container-myphp.service

