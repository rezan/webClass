#!/bin/bash

URL="http://en.wikipedia.org/wiki/%YEAR%_in_film"
OUT="movies1991_2014.dtree"

echo "# en wikipedia USA movies 1991_2014 `date +"%Y%m%d"`" > $OUT
echo "#\$regex" >> $OUT
echo "#\$dups" >> $OUT
echo "#!unknown" >> $OUT

> movies

echo "Notable"
for YEAR in {1991..2001};
do
    echo "$YEAR"
	YURL=`echo $URL | sed "s/%YEAR%/$YEAR/"`
	curl "$YURL" 2> /dev/null | gawk '
BEGIN {
  on=0
}
/="Notable.films/ {
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
' | sed "s/<\/i>/\n/g" | grep "^<li>" | grep "<i>" | sed "s/<[^>]*>//g" | sed "s/amp;//g" | tr "\"" "'" | tr ";" "," | sed "s/\.\.\.//" | sed "s/$/ $YEAR/" >> movies
done

echo "Special"
for YEAR in {1997,2000};
do
    echo "$YEAR"
	YURL=`echo $URL | sed "s/%YEAR%/$YEAR/"`
	curl "$YURL" 2> /dev/null | gawk '
BEGIN {
  on=0
}
/="Films_released_in_/ {
  on=1
  next
}
/h3/ {
  on=0
}
{
  if(on)
    print $0
}
' | sed "s/<\/i>/\n/g" | grep "^<li>" | grep "<i>" | sed "s/<[^>]*>//g" | sed "s/amp;//g" | tr "\"" "'" | tr ";" "," | sed "s/$/ $YEAR/" >> movies
done

echo "Wide release"
for YEAR in {2000..2014};
do
    echo "$YEAR"
	YURL=`echo $URL | sed "s/%YEAR%/$YEAR/"`
	curl "$YURL" 2> /dev/null | gawk '
BEGIN {
  on=0
}
/="Wide-release|Wide release|="201._films/ {
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
' | sed "s/<\/i>/\n/g" | grep "^<td>" | grep "<i>" | sed "s/<[^>]*>//g" | sed "s/amp;//g" | tr "\"" "'" | tr ";" "," | sed "s/$/ $YEAR/" >> movies
done

cat movies | sort -u | gawk '
BEGIN{
  for(n=0;n<256;n++)ord[sprintf("%c",n)]=n
  vals=ord[" "]
  val0=ord["0"]
  val9=ord["9"]
  vala=ord["A"]
  valz=ord["Z"]
  valla=ord["a"]
  vallz=ord["z"]
}
{
  title=$1
  for(i=2;i<NF;i++) {
    title=title " " $i
  }
  year=$NF
  NNF=NF-1
  full=title
  pattern=normpattern(full,".","?")
  id=normpattern(full,"x","")
  gsub(" ","_",id)
  printf("\"%s\";%s;W80;;name=\"%s\",year=%s,match=exact\n",pattern,id,full,year)
  for(i=1;i<=NNF;i++) {
    pat=tolower($i)
    if(length(pat)>=2) {
      part[pat]=part[pat] "; " full
    }
  }
  if(NNF>2) {
    for(i=1;i<NNF;i++) {
      if(length($i)<2 || length($(i+1))<2) {
        continue
      }
      bipat=tolower($i) " " tolower($(i+1))
      bipart[bipat]=bipart[bipat] "; " full
    }
  }
  if(NNF>3) {
    for(i=1;i<NNF-1;i++) {
      tripat=tolower($i) " " tolower($(i+1)) " " tolower($(i+2))
      tripart[tripat]=tripart[tripat] "; " full
    }
  }
}
END{
  for(x in part) {
    pattern=normpattern(x,".","?");
    id=normpattern(x,"x","");
    gsub(" ","_",id)
    type="likely"
    val=substr(part[x],3);
    if(index(val,";")>0) {
      type="possible"
    }
    printf("\"%s\";%s;W10;;%s=\"%s\",match=low\n",pattern,id,type,val);
  }
  for(x in bipart) {
    pattern=normpattern(x,".","?");
    id=normpattern(x,"x","");
    gsub(" ","_",id)
    type="likely"
    val=substr(bipart[x],3);
    if(index(val,",")>0) {
      type="possible"
    }
    printf("\"%s\";%s;W40;;%s=\"%s\",match=medium\n",pattern,id,type,val);
  }
  for(x in tripart) {
    pattern=normpattern(x,".","?")
    id=normpattern(x,"x","")
    gsub(" ","_",id)
    type="likely"
    val=substr(tripart[x],3);
    if(index(val,",")>0) {
      type="possible"
    }
    printf("\"%s\";%s;W60;;%s=\"%s\",match=high\n",pattern,id,type,val);
  }
}
function normpattern(s,r,o) {
  ret=""
  for(i=1;i<=length(s);i++) {
    val=ord[substr(s,i,1)]
    if(val>126) {
      ret=ret r o
    }else if(val!=vals && (val<val0 || (val>val9 && val<vala) || (val>valz && val<valla) || val>vallz)) {
      ret=ret r o
    }else{
      ret=ret substr(s,i,1)
    }
  }
  return ret
}' | sed "s/ \./\( .\)/g" >> $OUT

rm movies

