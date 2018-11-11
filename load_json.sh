# load page from json data and cypher code found from site and slug
# usage: sh load_json.sh organization-chart

SITE=http://context.asia.wiki.org
SLUG=$1
echo $SLUG

JSON=`curl -s $SITE/plugin/json/$SLUG`
CYPHER=`curl -s $SITE/$SLUG.json | jq '.story[]|select(.type=="code").text'`
POST="{\"statements\":[{\"statement\":$CYPHER, \"parameters\": {\"json\":$JSON}}]}"

DB=http://0.0.0.0:7474
curl -s -H accept:application/json -H content-type:application/json -d "$POST" -X POST "$DB/db/data/transaction/commit" | jq .

