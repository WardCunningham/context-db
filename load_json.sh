# load page from json data and cypher code found from site and slug
# usage: sh load_json.sh organization-chart

SITE=http://context.asia.wiki.org
SLUG=$1
echo $SLUG

LINK="$SITE/$SLUG.html"
CYPHER=`curl -s $SITE/$SLUG.json | jq '.story[]|select(.type=="code").text'`
DESC=`curl -s $SITE/$SLUG.json | jq '.story[]|select(.type=="json").text'`
DATE=`curl -s $SITE/$SLUG.json | jq '.story[]|select(.type=="json").written/1000|strftime("%Y-%m-%d")'`
SOURCE=`echo null | jq -c "{name:\"$SLUG\",run:$DATE,description:$DESC,links:\"$LINK\"}"`
echo "$SOURCE"

JSON=`curl -s $SITE/plugin/json/$SLUG`
POST="{\"statements\":[{\"statement\":$CYPHER, \"parameters\": {\"json\":$JSON,\"props\":$SOURCE}}]}"
DB=http://0.0.0.0:7474
HEAD="-H accept:application/json -H content-type:application/json"
time curl -s $HEAD -d "$POST" -X POST "$DB/db/data/transaction/commit" | \
  jq -r '.errors[].message'

