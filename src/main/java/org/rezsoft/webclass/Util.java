package org.rezsoft.webclass;

public class Util {
    public static String getTime(long diffn) {
        return diffn/(1000*1000*1000)+"s "+diffn/(1000*1000)%(1000*1000)+"ms "+diffn/1000%1000+"us "+diffn%1000+"ns";
    }
    
    public static String normAscii(String s) {
        if(s==null) {
          return s;
        }
        StringBuilder ret=new StringBuilder();
        for(int i=0;i<s.length();i++) {
            if(((int)s.charAt(i))>126) {
                ret.append('.');
            } else {
                ret.append(s.charAt(i));
            }
        }
        return ret.toString();
    }
}
