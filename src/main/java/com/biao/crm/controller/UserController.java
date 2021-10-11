package com.biao.crm.controller;

import com.biao.crm.pojo.User;
import com.biao.crm.service.UserService;
import com.biao.crm.utils.MD5Util;
import com.biao.crm.utils.PrintJson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {
    private UserService userService;

    @Autowired
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    @RequestMapping("/settings/user/login.do")
    @ResponseBody
    public String login(String loginAct, String loginPwd, HttpServletRequest request) {
        System.out.println("进入登录验证");
        //将密码的明文形式转换为MD5的密文形式
        loginPwd = MD5Util.getMD5(loginPwd);
        //接收浏览器端的ip地址
        String ip = request.getRemoteAddr();
        try {
            User user = userService.login(loginAct, loginPwd, ip);
            request.getSession().setAttribute("user", user);

            return PrintJson.getJson(true);
        } catch (Exception e) {
            e.printStackTrace();
            //一旦程序执行了catch块的信息，说明业务层为我们验证登录失败，为controller抛出了异常
            //表示登录失败
            /*
                {"success":true,"msg":?}
             */
            String msg = e.getMessage();
            /*
                我们现在作为contoller，需要为ajax请求提供多项信息

                可以有两种手段来处理：
                    （1）将多项信息打包成为map，将map解析为json串
                    （2）创建一个Vo
                            private boolean success;
                            private String msg;

                    如果对于展现的信息将来还会大量的使用，我们创建一个vo类，使用方便
                    如果对于展现的信息只有在这个需求中能够使用，我们使用map就可以了

             */
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("success", false);
            map.put("msg", msg);
            return PrintJson.getJson(map);


        }

    }
}
