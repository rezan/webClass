package org.rezsoft.webclass.data;

import java.util.Map;

public class DClassResult {

    private String group;
    private String name;
    private Map<String,String> result;
    
    private DClassResult() {}
    
    public DClassResult(String group,String name,Map<String,String> result) {
        this.group=group;
        this.name=name;
        this.result=result;
    }
    
    public String getGroup() {
        return group;
    }

    public String getName() {
        return name;
    }

    public Map<String,String> getResult() {
        return result;
    }
}
