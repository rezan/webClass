package org.rezsoft.webclass.data;

import org.rezsoft.webclass.Util;
import dclass.dClass;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import org.springframework.core.io.Resource;

public class DClassProcessor {
    
    private static final Logger log = Logger.getLogger(DClassProcessor.class);
    
    private List<DClassObject> dclasses;
    
    public DClassProcessor() {
    }

    public void setData(List<Resource> paths) {
        long start=System.nanoTime();

        for(Resource path:paths) {
            try {
                loadDataResource(path);
            } catch(Exception ex) {
                log.error("ERROR: "+ex.toString(),ex);
            }
        }

        long diff=System.nanoTime()-start;
        String sdiff=Util.getTime(diff);

        log.info("dtrees loaded: "+sdiff);
    }

    
    public void setDtree(List<Resource> paths) {
        long start=System.nanoTime();

        List<DClassObject> dcs=new ArrayList<DClassObject>();
        
        for(Resource path:paths) {
            try {
                loadDtreeResource(path,dcs);
            } catch(Exception ex) {
                log.error("ERROR: "+ex.toString(),ex);
            }
        }
        
        long diff=System.nanoTime()-start;
        String sdiff=Util.getTime(diff);
        
        log.info("dtrees loaded: "+sdiff);
        
        dclasses=dcs;
    }
    
    private void loadDataResource(Resource resource) throws Exception
    {
        String name=resource.getFile().getName();

        if(name.indexOf(".")>0) {
            name=name.substring(0,name.indexOf("."));
        }

        String group="default";

        if(resource.getFile().getParentFile()!=null) {
            group=resource.getFile().getParentFile().getName();
        }

        log.info("loadDataResource() "+group+" "+name+": "+resource);

        throw new Exception("Loading raw data unsupported at this time");
    }

    private void loadDtreeResource(Resource resource,List<DClassObject> dcs) throws Exception
    {
        String name=resource.getFile().getName();
        
        if(name.indexOf(".")>0) {
            name=name.substring(0,name.indexOf("."));
        }
        
        String group="default";
        
        if(resource.getFile().getParentFile()!=null) {
            group=resource.getFile().getParentFile().getName();
        }
        
        log.info("loadDtreeResource() "+group+" "+name+": "+resource);

        DClassObject dco=loadDClass(resource.getFile().getAbsolutePath(),group,name);

        dcs.add(dco);
    }
    
    private DClassObject loadDClass(String path,String group,String name) {
        log.info("loadDClass: "+path);
        
        dClass dclass = new dClass(path);
        
        dclass.init();
        
        log.info("loadDClass init: "+dclass.getComment()+", patterns: "+dclass.getPatterns()+", nodes: "+dclass.getNodes()+", memory: "+dclass.getMemory());
        
        DClassObject dco=new DClassObject(group,name,dclass);
        
        return dco;
    }
    
    public List<DClassResult> process(String text,String group) {
        List<DClassResult> results=new ArrayList<DClassResult>();
        
        log.info("process: '"+text+"' group: "+group);
        
        for(DClassObject dclass:dclasses) {
            if(!group.equals("all") && !group.equals(dclass.getGroup())) {
                continue;
            }
            
            Map<String,String> rmap=dclass.getDclass().classify(text);
            
            String id=rmap.get("id");
            
            log.info("dclass "+dclass.getName()+" result: "+id);
            
            if(id!=null && !id.equals("unknown")) {
                results.add(new DClassResult(dclass.getGroup(), dclass.getName(), rmap));
            }
        }
        
        return results;
    }

    public List<DClassObject> getDClasses(String group) {
        List<DClassObject> results=new ArrayList<DClassObject>();
        
        for(DClassObject dclass:dclasses) {
            if(group.equals("all") || group.equals(dclass.getGroup())) {
                results.add(dclass);
            }
        }
        
        return results;
    }
    
    public List<String> getGroups() {
        List<String> groups=new ArrayList<String>();
        
        for(DClassObject dclass:dclasses) {
            if(!groups.contains(dclass.getGroup())) {
                groups.add(dclass.getGroup());
            }
        }
        
        return groups;
    }
}
