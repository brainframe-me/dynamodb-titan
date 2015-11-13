#!/bin/bash

BIN=./bin
SLEEP_INTERVAL_S=2

IN=rexster-dynamodb.xml.template
OUT=rexster-dynamodb.xml

cp $IN $OUT

# Use hash instead of slash because the hostport has a slash
sed -i "s#_DYNAMODB_HOSTPORT_#${DYNAMODB_HOSTPORT}#g" $OUT
sed -i "s#_GRAPH_NAME_#${GRAPH_NAME}#g" $OUT
sed -i "s#_BASE_URI_#${BASE_URI}#g" $OUT

$BIN/rexster.sh -s -c ../$OUT
