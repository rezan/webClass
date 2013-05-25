#!/bin/bash

URL="http://en.wikipedia.org/wiki/List_of_American_film_actresses"
OUT="actresses.dtree"

echo "# en wikipedia american film actresses `date +"%Y%m%d"`" > $OUT
echo "#\$regex" >> $OUT
echo "#\$dups" >> $OUT
echo "#!unknown,exact,medium" >> $OUT

curl "$URL" 2> /dev/null | grep "^<li>" | grep "/wiki/" | grep -v "Lists" | sed "s/^.*\">//" | sed "s/<.*$//" | tr "\"" "'" | tr ";" "," | gawk '
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
  full=$0
  pattern=normpattern(full,".","?")
  id=normpattern(full,"x","")
  gsub(" ","_",id)
  printf("\"%s\";%s;S;;name=\"%s\",age=unknown,match=exact\n",pattern,id,full)
  for(i=1;i<=NF;i++) {
    pat=tolower($i)
    if(length(pat)>=2) {
      part[pat]=part[pat] "; " full
    }
  }
}
END{
  for(x in part) {
    pattern=normpattern(x,".")
    id=normpattern(x,"x")
    gsub(" ","_",id)
    type="likely"
    val=substr(part[x],3);
    if(index(val,";")>0) {
      type="possible"
    }
    printf("\"%s\";%s;W;;%s=\"%s\",match=medium\n",pattern,id,type,val);
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
}' >> $OUT
