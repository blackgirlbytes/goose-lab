#!/bin/bash

# Watch Downloads folder for new current_session.json files and move them to the right place
while true; do
    if [ -f ~/Downloads/challenges_current_session.json ]; then
        mv ~/Downloads/challenges_current_session.json ./challenges/current_session.json
        echo "Moved session file to challenges directory"
    fi
    sleep 1
done