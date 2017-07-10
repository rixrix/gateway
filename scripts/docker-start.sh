#!/bin/bash

# For Docker purposes

source ~/.nvm/nvm.sh
nvm use --delete-prefix v7.7.2
pm2 start npm --name gateway --no-daemon -- start
