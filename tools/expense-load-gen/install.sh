read -p 'Enter Url: ' url

while true ; do
  requests=$(echo $RANDOM | cut -c 1-3)
  curl -s "https://random-word-api.herokuapp.com/word?number=$requests" | sed -e "s/\[//" -e 's/\]//' | sed -e 's/,/ /g' -e 's/"//g' >/tmp/words
  for word in `cat /tmp/words`; do
    curl -X POST $url/api/transaction --header "Content-Type: application/json" -d "{\"amount\":\"$RANDOM\",\"desc\":\"$word\"}" &>/tmp/out
  done
  curl -X DELETE $url/api/transaction &>>/tmp/out
  sleep $(echo $RANDOM | cut -c3)
done
