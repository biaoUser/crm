package com.biao.crm.dao;

import com.biao.crm.pojo.User;

import java.util.List;
import java.util.Map;

public interface UserMapper {
    User login(Map<String, String> map);

    List<User> getUserList();
}
