#!/bin/bash


if ! OUTPUT=$(systemctl status home-assistant@homeassistant.service 2>&1); then
    echo "$OUTPUT"
    exit 1
fi