#!/usr/bin/env bash

if [ -f $SERVER_JS ]; then
  echo "Found server.js, ignoring other files"
  args="$@"
  exec node $SERVER_JS $args
fi

if [ -z "$HOST" ]; then
  HOST="0.0.0.0"
fi

if [ -z "$PORT" ]; then
  PORT="80"
fi

if [ -f $ROUTES_JSON ]; then
  echo "Found routes.json file, trying to open"
  args="$args -r $ROUTES_JSON"
fi

skip_args=y
# prefer files over db.json
if [ -f $SEED_JS ]; then
  echo "Found seed.js file, trying to open"
  args="$args $SEED_JS"
	skip_args=n
elif [ -f $DB_JSON ]; then
  echo "Found db.json, trying to open"
  args="$args -w $DB_JSON"
	skip_args=n
fi

if [ "$skip_args" == "n" ]; then
	args="$@ $args -H '$HOST' -p '$PORT'"
else
	args="$@ $args"
fi

exec json-server $args

