package org.rezsoft.webclass.data;

import dclass.dClass;

public class DClassObject {
    
    private String group;
    private String name;
    private dClass dclass;
    
    private DClassObject() {}
    
    public DClassObject(String group,String name,dClass dclass) {
        this.group=group;
        this.name=name;
        this.dclass=dclass;
    }
    
    public String getGroup() {
        return group;
    }

    public String getName() {
        return name;
    }

    public dClass getDclass() {
        return dclass;
    }    
}
