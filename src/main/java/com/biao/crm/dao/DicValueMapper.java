package com.biao.crm.dao;

import com.biao.crm.pojo.DicValue;

import java.util.List;

public interface DicValueMapper {
    List<DicValue> getListByCode(String code);
}
