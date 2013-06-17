#!/bin/bash

URL="http://en.wikipedia.org/wiki/List_of_professional_sports_teams_in_the_United_States_and_Canada"
OUT="sports.data"
UA="curl reza.naghibi@yahoo.com webclass"

curl -A "$UA" "$URL" 2> /dev/null | grep -E "<h3>|<b>" | grep "/wiki/" | sed "s/<h3>/H3:/" | sed "s/<[^>]*>//g" | sed "s/\[edit\]//" | tr "\"" "'" | tr ";" "," | gawk '
BEGIN{
  league="unknown"
}
{
  if(substr($0,1,3)=="H3:") {
    league=substr($0,4)
    next;
  }
  print $0 "|league=" league
}' > $OUT
