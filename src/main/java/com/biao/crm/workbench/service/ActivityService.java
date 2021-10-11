package com.biao.crm.workbench.service;

import com.biao.crm.vo.PaginationVO;
import com.biao.crm.workbench.pojo.Activity;
import com.biao.crm.workbench.pojo.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    boolean save(Activity activity);

    PaginationVO<Activity> pageList( Map map);

    boolean delete(String[] param);

    Map<String, Object> getUserListAndActivity(String id);

    boolean update(Activity activity);

    Activity detail(String id);

    List<ActivityRemark> getRemarkListByActivityId(String id);

    boolean deleteRemark(String id);

    boolean saveRemark(ActivityRemark activityRemark);

    boolean updateRemark(ActivityRemark activityRemark);

    List<Activity> getActivityListByClueId(String clueId);

    List<Activity> getActivityListByNameAndNotByClueId(Map<String, Object> map);

    List<Activity> getActivityListByName(String aname);

    Map<String, Object> getCharts();
}
