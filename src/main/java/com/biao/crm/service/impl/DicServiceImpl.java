package com.biao.crm.service.impl;

import com.biao.crm.dao.DicTypeMapper;
import com.biao.crm.dao.DicValueMapper;
import com.biao.crm.pojo.DicType;
import com.biao.crm.pojo.DicValue;
import com.biao.crm.service.DicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DicServiceImpl implements DicService {
    private DicValueMapper dicValueMapper;
    private DicTypeMapper dicTypeMapper;

    @Autowired
    public void setDicValueMapper(DicValueMapper dicValueMapper) {
        this.dicValueMapper = dicValueMapper;
    }

    @Autowired
    public void setDicTypeMapper(DicTypeMapper dicTypeMapper) {
        this.dicTypeMapper = dicTypeMapper;
    }


    public Map<String, List<DicValue>> getAll() {
        Map<String, List<DicValue>> map = new HashMap<String, List<DicValue>>();
        List<DicType> dicTypes = dicTypeMapper.getTypeList();
        for (DicType dicType : dicTypes
        ) {
            String code = dicType.getCode();
            List<DicValue> dicValues = dicValueMapper.getListByCode(code);
            map.put(code + "List", dicValues);
        }
        return map;
    }
}
