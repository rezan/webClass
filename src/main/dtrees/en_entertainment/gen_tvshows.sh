#!/bin/bash

URL="http://en.wikipedia.org/wiki/List_of_television_programs_by_name"
OUT="tvshows.dtree"

echo "# en wikipedia television tv programs `date +"%Y%m%d"`" > $OUT
echo "#\$regex" >> $OUT
echo "#\$dups" >> $OUT
echo "#!unknown,low,medium,high,exact" >> $OUT


curl "$URL" 2> /dev/null | grep "^<li>" | grep "/wiki/" | sed "s/^.*\">//" | sed "s/<.*$//" | sed "s/amp;//g" | tr "\"" "'" | tr ";" "," | gawk '
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
  printf("\"%s\";%s;W80;;name=\"%s\",year=unknown,match=exact\n",pattern,id,full)
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
  if(NF>3) {
    for(i=1;i<NF-1;i++) {
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
