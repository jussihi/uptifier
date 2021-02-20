#!/bin/bash


if ! OUTPUT=$(ping 8.8.8.8 2>&1); then
    echo "$OUTPUT"
    exit 1
fi