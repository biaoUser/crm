package com.biao.crm.workbench.service.impl;

import com.biao.crm.dao.UserMapper;
import com.biao.crm.pojo.User;
import com.biao.crm.vo.PaginationVO;
import com.biao.crm.workbench.dao.ActivityMapper;
import com.biao.crm.workbench.dao.ActivityRemarkMapper;
import com.biao.crm.workbench.pojo.Activity;
import com.biao.crm.workbench.pojo.ActivityRemark;
import com.biao.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {
    private UserMapper userMapper;

    @Autowired
    public void setUserMapper(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    private ActivityMapper activityMapper;

    @Autowired
    public void setActivityRemarkMapper(ActivityRemarkMapper activityRemarkMapper) {
        this.activityRemarkMapper = activityRemarkMapper;
    }

    private ActivityRemarkMapper activityRemarkMapper;

    @Autowired
    public void setActivityMapper(ActivityMapper activityMapper) {
        this.activityMapper = activityMapper;
    }

    public boolean save(Activity activity) {
        Integer count = activityMapper.save(activity);
        if (count != 1) {
            return false;
        }
        return true;
    }


    public PaginationVO<Activity> pageList(Map map) {
        //取得总条数
        Integer total = activityMapper.getTotalByCondition(map);
        //取得数据
        List<Activity> dataList = activityMapper.getActivityListByCondition(map);
        //返回VO
        PaginationVO<Activity> VO = new PaginationVO<Activity>();
        VO.setTotal(total);
        VO.setDatalist(dataList);
        return VO;
    }


    public Map<String, Object> getUserListAndActivity(String id) {
        List<User> uList = userMapper.getUserList();
        Activity a = activityMapper.getById(id);
        Map<String, Object> map = new HashMap<String, Object>();
        if (a != null && uList.size() > 0) {

            map.put("uList", uList);
            map.put("a", a);
            map.put("success", true);
            return map;
        }
        map.put("success", false);
        return map;
    }

    public boolean delete(String[] ids) {
        boolean flag = true;
        //查询需要删除备注的数量
        int count = activityRemarkMapper.getCountByIds(ids);
        //删除备注受到影响的条数
        int count3 = activityMapper.delete(ids);

        int count2 = activityRemarkMapper.deleteByIds(ids);//是根据市场键删除
        if (count2 != count) {
            flag = false;
        }
        if (count3 != ids.length) {
            flag = false;
        }
        return flag;
    }

    public boolean update(Activity activity) {
        Integer integer = activityMapper.update(activity);

        return integer == 1;
    }

    public Activity detail(String id) {
        Activity activity = activityMapper.detail(id);
        return activity;
    }

    public List<ActivityRemark> getRemarkListByActivityId(String id) {
        List<ActivityRemark> activityRemarkList = activityRemarkMapper.getRemarkListByActivityId(id);
        return activityRemarkList;
    }

    public boolean deleteRemark(String id) {
        Integer i = activityRemarkMapper.deleteById(id);//根据自己表的主键删除
        return i > 0;
    }

    public boolean saveRemark(ActivityRemark activityRemark) {
        Integer i = activityRemarkMapper.saveRemark(activityRemark);
        return i == 1;
    }

    public boolean updateRemark(ActivityRemark activityRemark) {
        Integer i = activityRemarkMapper.updateRemark(activityRemark);
        return i == 1;
    }

    public List<Activity> getActivityListByClueId(String clueId) {
        List<Activity> activities = activityMapper.getActivityListByClueId(clueId);
        return activities;
    }

    public List<Activity> getActivityListByNameAndNotByClueId(Map<String, Object> map) {

        return activityMapper.getActivityListByNameAndNotByClueId(map);
    }

    public List<Activity> getActivityListByName(String aname) {
        return activityMapper.getActivityListByName(aname);
    }

    public Map<String, Object> getCharts() {

        List<Map<String, Object>> dataList = activityMapper.getCharts();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("dataList", dataList);
        return map;
    }
}
