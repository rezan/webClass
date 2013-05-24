package org.rezsoft.webclass.controller;
 
import org.rezsoft.webclass.Util;
import org.rezsoft.webclass.data.DClassProcessor;
import org.rezsoft.webclass.data.DClassResult;
import java.util.List;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class WebClass
{
    private static final Logger log = Logger.getLogger(WebClass.class);
    
    @Autowired
    private DClassProcessor dclassProcessor;

    @RequestMapping(value="/class",method=RequestMethod.GET)
    public String webClass(ModelMap model, @RequestParam(value="text",required=false) String text)
    {
        processWebClass(model,text);
        
        return "classHTML";
    }
    
    @RequestMapping(value="/class.js",method=RequestMethod.GET)
    public String webClassJS(ModelMap model, @RequestParam(value="text",required=false) String text,
        @RequestParam(value="callback",required=false) String callback)
    {
        processWebClass(model,text);

        if(callback!=null && !callback.isEmpty()) {
            model.addAttribute("callback",callback);
            return "classJSONP";
        }
        
        return "classJSON";
    }
    
    private void processWebClass(ModelMap model, String text) {
        log.info("processWebClass() called, text: '"+text+"'");
        
        model.addAttribute("text",text);

        text=Util.normAscii(text);
        
        if(text==null || text.isEmpty()) {
            return;
        }
        
        long start=System.nanoTime();
        
        List<DClassResult> results=dclassProcessor.process(text);
        
        long diff=System.nanoTime()-start;
        String sdiff=Util.getTime(diff);
        
        log.info("processWebClass() results: "+results.size()+" time: "+sdiff);

        model.addAttribute("time",sdiff);
        model.addAttribute("results",results);
    }

    @RequestMapping(value="/index",method=RequestMethod.GET)
    public String webClass(ModelMap model)
    {
        model.addAttribute("indexes",dclassProcessor.getDClasses());

        return "indexHTML";
    }
    
    @RequestMapping(value="/index.js",method=RequestMethod.GET)
    public String webClassJS(ModelMap model, @RequestParam(value="callback",required=false) String callback)
    {
        model.addAttribute("indexes",dclassProcessor.getDClasses());

        if(callback!=null && !callback.isEmpty()) {
            model.addAttribute("callback",callback);
            return "indexJSONP";
        }
        
        return "indexJSON";
    }
}
