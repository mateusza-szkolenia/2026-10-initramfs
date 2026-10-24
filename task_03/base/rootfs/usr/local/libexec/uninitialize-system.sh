#!/bin/bash

set -e -x

echo "Removing SSH Host keys"
rm -rf /etc/ssh/ssh_host_*_key*

echo "Removing machine-id"
echo uninitialized > /etc/machine-id

echo "Removing etckeeper repo"
rm -rf /etc/.git
