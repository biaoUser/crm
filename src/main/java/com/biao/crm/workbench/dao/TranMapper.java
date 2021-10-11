package com.biao.crm.workbench.dao;

import com.biao.crm.workbench.pojo.Tran;

import java.util.List;
import java.util.Map;

public interface TranMapper {

    Integer save(Tran t);

    Integer getTotalByCondition(Map<String, Object> map);

    List<Tran> getTranListByCondition(Map<String, Object> map);

    Tran detail(String id);

    Integer changStage(Tran t);

    int getTotal();

    List<Map<String, Object>> getCharts();
}
