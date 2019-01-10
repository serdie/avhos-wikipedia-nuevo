#!/bin/bash
# Here you can create functions which will be available from the commands file
# You can also use here user variables defined in your config file




jv_pg_wk_search ()
{

#get language
jv_pg_wk_lang="$(tr '[:lower:]' '[:upper:]' <<< ${language:0:2})" # en_GB => en => EN

#remove space in first argument
local WIKI_SEARCH=$(echo $1 | tr -d ' ')

#remove accent etc..
#local WIKI_SEARCH=$(jv_sanitize $1)

#wikipedia search api
local LIMITED_WIKI_QUERY="https://$jv_pg_wk_lang.wikipedia.org/w/api.php?action=opensearch&search="$WIKI_SEARCH"&prop=revisions&rvprop=content&format=json"


#the request's result 
local jv_pg_wk_result=$(curl -s "$LIMITED_WIKI_QUERY" | jq -r '.')

#name's request
#jv_pg_wk_name=$(echo "$jc_pg_wk_result" | jq -r '.[0]')

#definition 
local jv_pg_wk_definition=$(echo "$jv_pg_wk_result" | jq -r '.[2][0]')

#search if w list is used
if [[ "$jv_pg_wk_definition" =~ "may refer to:" ]]
then
jv_pg_wk_definition=$(echo "$jv_pg_wk_result" | jq -r '.[2][1]')
else
jv_pg_wk_definition=$(echo "$jv_pg_wk_result" | jq -r '.[2][0]')
fi

#search if the result is null or empty
if [ "$jv_pg_wk_definition" = "null" ] | [ -z "$jv_pg_wk_definition" ]
then
echo "I found nothing"
else
echo "$jv_pg_wk_definition"
fi

}

