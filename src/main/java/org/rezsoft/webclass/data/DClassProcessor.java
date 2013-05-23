package org.rezsoft.webclass.data;

import org.rezsoft.webclass.Util;
import dclass.dClass;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import org.springframework.core.io.Resource;

public class DClassProcessor {
    
    private static final Logger log = Logger.getLogger(DClassProcessor.class);
    
    private List<DClassObject> dclasses;
    
    public DClassProcessor() {
        dclasses=new ArrayList<DClassObject>();
    }
    
    public void setDtree(List<Resource> paths) {
        long start=System.nanoTime();
        
        for(Resource path:paths) {
            try {
                loadDtreeResource(path);
            } catch(Exception ex) {
                log.error("ERROR: "+ex.toString(),ex);
            }
        }
        
        long diff=System.nanoTime()-start;
        String sdiff=Util.getTime(diff);
        
        log.info("dtrees loaded: "+sdiff);
    }
    
    private void loadDtreeResource(Resource resource) throws Exception
    {
        InputStream is=resource.getInputStream();
        
        String name=resource.getFile().getName();
        
        if(name.indexOf(".")>0) {
            name=name.substring(0,name.indexOf("."));
        }
        
        String group="default";
        
        if(resource.getFile().getParentFile()!=null) {
            group=resource.getFile().getParentFile().getName();
        }
        
        log.info("loadDtreeResource() "+group+" "+name+": "+resource);

        if(is==null)
            throw new RuntimeException("Resource not found: "+resource);

        File f=File.createTempFile(name,null);
        f.deleteOnExit();

        if(!f.exists())
            throw new RuntimeException("Could not make temp file for "+name);

        OutputStream fos=new FileOutputStream(f);

        byte[] buffer=new byte[10000];
        int read;

        while((read=is.read(buffer))!=-1)
        {
            fos.write(buffer,0,read);
        }

        is.close();
        fos.close();

        DClassObject dco=loadDClass(f.getAbsolutePath(),group,name);
        dclasses.add(dco);
    }
    
    private DClassObject loadDClass(String path,String group,String name) {
        log.info("loadDClass: "+path);
        
        dClass dclass = new dClass(path);
        
        dclass.init();
        
        log.info("loadDClass init: "+dclass.getComment()+", patterns: "+dclass.getPatterns()+", nodes: "+dclass.getNodes()+", memory: "+dclass.getMemory());
        
        DClassObject dco=new DClassObject(group,name,dclass);
        
        return dco;
    }
    
    public List<DClassResult> process(String text) {
        List<DClassResult> results=new ArrayList<DClassResult>();
        
        log.info("process: '"+text+"'");
        
        for(DClassObject dclass:dclasses) {
            Map<String,String> rmap=dclass.getDclass().classify(text);
            String id=rmap.get("id");
            log.info("dclass "+dclass.getName()+" result: "+id);
            if(id!=null && !id.equals("unknown")) {
                results.add(new DClassResult(dclass.getGroup(), dclass.getName(), rmap));
            }
        }
        
        return results;
    }
}
