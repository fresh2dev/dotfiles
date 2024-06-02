#!/usr/bin/env bash

# Run playbook.
ANSIBLE_LOCALHOST_WARNING="False" \
  ANSIBLE_INVENTORY_UNPARSED_WARNING="False" \
  LC_ALL="C.UTF-8" \
  ansible-playbook apply.yml "$@" --extra-vars "ansible_user=$(whoami)"
