#!/usr/bin/env bash

args="$@ -p 80"

file=/data/db.json
if [ -f $file ]; then
    echo "Found db.json, trying to open"
    args="$args -w db.json"
fi

file=/data/routes.json
if [ -f $file ]; then
    echo "Found routes.js file, trying to open"
    args="$args -r routes.json"
fi

file=/data/file.js
if [ -f $file ]; then
    echo "Found file.js seed file, trying to open"
    args="$args file.js"
fi

json-server $args
