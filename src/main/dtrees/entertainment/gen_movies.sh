#!/bin/bash

URL="http://en.wikipedia.org/wiki/%YEAR%_in_film"
OUT="movies.dtree"

echo "# wikipedia movies year_in_film" > $OUT
echo "#\$regex" >> $OUT
echo "#\$dups" >> $OUT
echo "#!unknown" >> $OUT

#for YEAR in {1998..2010};
for YEAR in {2012};
do
	YURL=`echo $URL | sed "s/%YEAR%/$YEAR/"`
	curl "$YURL" | gawk '
BEGIN {
  on=0
}
/="Notable.films|id="Wide.release|="Top.grossing_films/ {
  on=1
  next
}
/h2/ {
  on=0
}
{
  if(on)
    print $0
}
'
done
