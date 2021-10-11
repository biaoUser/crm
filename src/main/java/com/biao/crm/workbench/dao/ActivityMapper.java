package com.biao.crm.workbench.dao;

import com.biao.crm.workbench.pojo.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    Integer save(Activity activity);

    Integer getTotalByCondition(Map map);

    List<Activity> getActivityListByCondition(Map map);

    int delete(String[] ids);

    Activity getById(String id);

    Integer update(Activity activity);

    Activity detail(String id);

    List<Activity> getActivityListByClueId(String clueId);

    List<Activity> getActivityListByNameAndNotByClueId(Map<String, Object> map);

    List<Activity> getActivityListByName(String aname);

    List<Map<String, Object>> getCharts();
}
