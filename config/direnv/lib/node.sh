#!/bin/bash

use_nvm() {
  watch_file .nvmrc
  NVM=/usr/share/nvm/init-nvm.sh
  if [ -f "$NVM" ]; then
    source "$NVM"
    nvm install
    layout node
  fi
}
