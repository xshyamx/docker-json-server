#!/usr/bin/env bash

file=/data/server.js
if [ -f $file ]; then
    echo "Found server.js, ignoring other files"
    args="$@"
    node $file $args
else
    if [ -z "$HOST" ]; then
        HOST="0.0.0.0"
    fi

    if [ -z "$PORT" ]; then
        PORT="80"
    fi

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
    args="$@ $args -H '$HOST' -p '$PORT'"
    json-server $args
fi
