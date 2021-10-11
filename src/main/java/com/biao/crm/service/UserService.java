package com.biao.crm.service;

import com.biao.crm.exception.LoginException;
import com.biao.crm.pojo.User;

import java.util.List;

public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();
}
