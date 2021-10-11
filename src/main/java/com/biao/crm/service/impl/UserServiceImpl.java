package com.biao.crm.service.impl;

import com.biao.crm.dao.UserMapper;
import com.biao.crm.exception.LoginException;
import com.biao.crm.pojo.User;
import com.biao.crm.service.UserService;
import com.biao.crm.utils.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {
    private UserMapper userMapper;
    @Autowired
    public void setUserMapper(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        Map<String,String> map = new HashMap<String,String>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);
        User user = userMapper.login(map);
        if(user==null){
            throw new LoginException("账号密码错误");
        }
        //验证失效时间
        String expireTime = user.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        if(expireTime.compareTo(currentTime)<0){
            throw new LoginException("账号已失效");
        }

        //判断锁定状态
        String lockState = user.getLockState();
        if("0".equals(lockState)){
            throw new LoginException("账号已锁定");
        }
        //判断ip地址
//        String allowIps = user.getAllowIps();
//
//        if(!allowIps.contains(ip)){
//
//            throw new LoginException("ip地址受限");
//
//        }
        return user;
    }

    public List<User> getUserList() {
        return userMapper.getUserList();
    }
}
