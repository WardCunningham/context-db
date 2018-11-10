#!/bin/bash
echo "Usage load_json.sh 'http://json.api.com?params=values' import_json.cypher"
echo "Use {data} as parameter in your query for the JSON data"

echo 'args' $1 $2
JSON_API="$1"
QUERY=`cat "$2"` # cypher file

echo curl -s -H accept:application/json -s "$JSON_API"
JSON_DATA=`curl -s http://context.asia.wiki.org/plugin/json/organization-chart`

JSON_DATA='[true]'
POST_DATA="{\"statements\":[{\"statement\": \"$QUERY\", \"parameters\": {\"data\":\"$JSON_DATA\"}}]}"

echo "$POST_DATA"
DB_URL=http://0.0.0.0:7474
curl -i -H accept:application/json -H content-type:application/json -d "$POST_DATA" -X POST "$DB_URL/db/data/transaction/commit"
