#!/bin/bash

set -e -x

[[ -d /etc/.git ]] && exit 0

etckeeper init
etckeeper commit -m 'Init'
