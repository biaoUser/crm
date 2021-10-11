package com.biao.crm.service;

import com.biao.crm.pojo.DicValue;

import java.util.List;
import java.util.Map;

public interface DicService {
    Map<String, List<DicValue>> getAll();
}
