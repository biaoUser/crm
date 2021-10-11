package com.biao.crm.workbench.dao;

import com.biao.crm.workbench.pojo.Activity;
import com.biao.crm.workbench.pojo.ActivityRemark;

import java.util.List;

public interface ActivityRemarkMapper {
    int getCountByIds(String[] ids);

    int deleteByIds(String[] ids);

    List<ActivityRemark> getRemarkListByActivityId(String id);

    Integer deleteById(String id);

    Integer saveRemark(ActivityRemark activityRemark);

    Integer updateRemark(ActivityRemark activityRemark);

}
