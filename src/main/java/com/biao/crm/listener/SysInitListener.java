package com.biao.crm.listener;

import com.biao.crm.pojo.DicValue;
import com.biao.crm.service.DicService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

public class SysInitListener implements ServletContextListener {
    private DicService dicService = null;


    /**
     * event：该参数能够取得监听的对象
     * 监听的application就可以获得application
     */
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        System.out.println("上下文域对象创建");
        ServletContext application = servletContextEvent.getServletContext();
//         ApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(application);
        ApplicationContext applicationContext = new ClassPathXmlApplicationContext("applicationContext.xml");
        dicService = (DicService) applicationContext.getBean("dicServiceImpl");

        Map<String, List<DicValue>> map = dicService.getAll();
        Set<String> strings = map.keySet();
        for (String key : strings
        ) {
            application.setAttribute(key, map.get(key));
        }

        //
        ResourceBundle rb= ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> keys = rb.getKeys();
        Map<String,String> pMap=new HashMap<String, String>();
        while (keys.hasMoreElements()){
            String key=keys.nextElement();//阶段
            String value = rb.getString(key);//可能性
            pMap.put(key,value);
        }

        application.setAttribute("pMap",pMap);


    }

    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }
}
