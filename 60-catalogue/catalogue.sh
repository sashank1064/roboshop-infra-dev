#!/bin/bash

dnf install ansible -y
ansible-pull -U https://github.com/sashank1064/ansible-roboshop-roles.git -e component=$1 main.yaml