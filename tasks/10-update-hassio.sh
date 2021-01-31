#!/bin/bash

cd /srv/homeassistant/
echo "Activating python venv"
python3.8 -m venv .
source bin/activate
echo "Upgrading homeassistant"
pip3 install --upgrade homeassistant
echo "Home assistant upgrade complete!"
echo "Restarting homeassistant ..."
systemctl restart home-assistant@homeassistant.service
echo "Restarting homeassistant complete!"
