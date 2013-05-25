#!/bin/bash

URL="http://en.wikipedia.org/wiki/List_of_professional_sports_teams_in_the_United_States_and_Canada"
OUT="sports.dtree"

echo "# en wikipedia professional sports teams USA Canada `date +"%Y%m%d"`" > $OUT
echo "#\$regex" >> $OUT
echo "#\$dups" >> $OUT
echo "#!unknown,exact,low,high" >> $OUT


curl "$URL" 2> /dev/null | grep -E "<h3>|<b>" | grep "/wiki/" | sed "s/<h3>/H3:/" | sed "s/<[^>]*>//g" | sed "s/ \[edit\]//" | tr "\"" "'" | tr ";" "," | gawk '
BEGIN{
  for(n=0;n<256;n++)ord[sprintf("%c",n)]=n
  vals=ord[" "]
  val0=ord["0"]
  val9=ord["9"]
  vala=ord["A"]
  valz=ord["Z"]
  valla=ord["a"]
  vallz=ord["z"]
  league="unknown"
}
{
  if(substr($0,1,3)=="H3:") {
    league=substr($0,4)
    next;
  }
  full=$0
  pattern=normpattern(full,".","?")
  id=normpattern(full,"x","")
  gsub(" ","_",id)
  printf("\"%s\";%s;S;;name=\"%s\",league=\"%s\",match=exact\n",pattern,id,full,league)
  for(i=1;i<=NF;i++) {
    pat=tolower($i)
    if(length(pat)>=2) {
      part[pat]=part[pat] "; " full
    }
  }
  if(NF>2) {
    for(i=1;i<NF;i++) {
      if(length($i)<2 || length($(i+1))<2) {
        continue
      }
      bipat=tolower($i) " " tolower($(i+1))
      bipart[bipat]=bipart[bipat] "; " full
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
    printf("\"%s\";%s;W40;;%s=\"%s\",match=high\n",pattern,id,type,val);
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
