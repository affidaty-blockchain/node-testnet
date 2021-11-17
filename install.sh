#!/bin/bash
git checkout *
git pull origin main
chmod a+x $HOME/*.sh $HOME/bin/*.sh

./$HOME/bin/install.sh
