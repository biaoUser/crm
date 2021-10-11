package com.biao.crm.workbench.controller;

import com.biao.crm.pojo.User;
import com.biao.crm.service.UserService;
import com.biao.crm.utils.DateTimeUtil;
import com.biao.crm.utils.PrintJson;
import com.biao.crm.utils.UUIDUtil;
import com.biao.crm.vo.PaginationVO;
import com.biao.crm.workbench.pojo.Activity;
import com.biao.crm.workbench.pojo.ActivityRemark;
import com.biao.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ActivityController {
    private ActivityService activityService;
    private UserService userService;

    @Autowired
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    @Autowired
    public void setActivityService(ActivityService activityService) {
        this.activityService = activityService;
    }

    //填充打开模态框所属者内容填充
    @RequestMapping("workbench/activity/getUserList.do")
    @ResponseBody
    public String getUserList() {
        List<User> userList = userService.getUserList();
        String json = PrintJson.getJson(userList);
        return json;
    }

    //保存一条activity数据
    @RequestMapping("workbench/activity/save.do")
    @ResponseBody
    public String save(Activity activity, HttpSession session) {
        String id = UUIDUtil.getUUID();
        String startDate = activity.getStartDate();
        String endDate = activity.getEndDate();
        if (startDate.compareTo(endDate) > 0) {

            String msg = "您输入的时间不合法，添加失败请重新添加";
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("msg", msg);
            map.put("success", false);
            String json = PrintJson.getJson(map);
            return json;

        } else {


            activity.setId(id);
            //创建当前时间
            String sysTime = DateTimeUtil.getSysTime();
            activity.setCreateTime(sysTime);
            //session获取当前创建人
            String name = ((User) session.getAttribute("user")).getName();
            activity.setCreateBy(name);
            boolean flag = activityService.save(activity);
            String json = PrintJson.getJson(flag);
            return json;
        }
    }

    //关于分页+条件和打开市场查询初次数据填充
    @RequestMapping("workbench/activity/pageList.do")
    @ResponseBody
    public String pageList(Activity activity,
                           @RequestParam("pageNo") String pageNo,
                           @RequestParam("pageSize") String pageSize) {
        System.out.println("进入市场查询（分页查询+条件查询）");
        Integer PageNo = Integer.valueOf(pageNo);
        Integer PageSize = Integer.valueOf(pageSize);
        //limit公式
        Integer skipCount = (PageNo - 1) * PageSize;

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("skipCount", skipCount);
        map.put("PageSize", PageSize);
        map.put("name", activity.getName());
        map.put("owner", activity.getOwner());
        map.put("startDate", activity.getStartDate());
        map.put("endStart", activity.getEndDate());
        PaginationVO<Activity> vo = activityService.pageList(map);
        String json = PrintJson.getJson(vo);
        return json;
    }


    //删除activity操作
    @RequestMapping(value = "workbench/activity/delete.do", method = RequestMethod.POST)
    @ResponseBody
    public String delete(HttpServletRequest request, @RequestParam("id") String id) {
        boolean flag = false;
        if (id != "" && id.length() != 0) {
            String[] idOne = {id};
            flag = activityService.delete(idOne);
        } else {
            String[] ids = request.getParameterValues("id");
            flag = activityService.delete(ids);

        }
        String json = PrintJson.getJson(flag);

        return json;
    }

    //打开修改模态框需要的数据拿取
    @RequestMapping(value = "workbench/activity/getUserListAndActivity.do")
    @ResponseBody
    public String getUserListAndActivity(@RequestParam("id") String id) {
//        List<User> userList = userService.getUserList();  放在service中处理
        Map<String, Object> map = activityService.getUserListAndActivity(id);
        String json = PrintJson.getJson(map);
        return json;
    }

    //打开修改模态框点击更新提交
    @RequestMapping(value = "workbench/activity/update.do", method = RequestMethod.POST)
    @ResponseBody
    public String update(Activity activity, HttpSession session) {
        //修改人
        String name = ((User) session.getAttribute("user")).getName();
        activity.setEditBy(name);
        //修改时间
        activity.setEditTime(DateTimeUtil.getSysTime());

        boolean flag = activityService.update(activity);
        String json = PrintJson.getJson(flag);
        return json;
    }

    //跳转到详细信息页
    @RequestMapping("workbench/activity/detail.do")
    public String detail(@RequestParam("id") String id, Model model) {
        Activity activity = activityService.detail(id);
        model.addAttribute("a", activity);
        return "activity/detail";
    }

    //在市场活动详情页准备备注信息
    @RequestMapping("workbench/activity/getRemarkListByActivityId.do")
    @ResponseBody
    public String getRemarkListByActivityId(@RequestParam("activityId") String activityId) {
        List<ActivityRemark> activityRemarkList = activityService.getRemarkListByActivityId(activityId);
        String json = PrintJson.getJson(activityRemarkList);

        return json;
    }

    //在市场活动详情页删除备注一条
    @RequestMapping("workbench/activity/deleteRemark.do")
    @ResponseBody
    public String deleteRemark(@RequestParam("id") String id) {
        boolean flag = activityService.deleteRemark(id);
        String json = PrintJson.getJson(flag);
        return json;
    }


    @RequestMapping("workbench/activity/saveRemark.do")
    @ResponseBody
    public String saveRemark(@RequestParam("noteContent") String noteContent
            , @RequestParam("activityId") String activityId
            , HttpSession session) {
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setId(UUIDUtil.getUUID());
        activityRemark.setNoteContent(noteContent);
        activityRemark.setCreateTime(DateTimeUtil.getSysTime());
        activityRemark.setCreateBy(((User) session.getAttribute("user")).getName());
        activityRemark.setActivityId(activityId);
        activityRemark.setEditFlag("0");
        boolean flag = activityService.saveRemark(activityRemark);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("ar", activityRemark);
        map.put("success", flag);
        String json = PrintJson.getJson(map);
        return json;
    }

    @RequestMapping("workbench/activity/updateRemark.do")
    @ResponseBody
    public String updateRemark(
            @RequestParam("noteContent") String noteContent
            , @RequestParam("id") String id
            , HttpSession session) {
        System.out.println("?????????????????????????????");
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setNoteContent(noteContent);
        activityRemark.setId(id);
        activityRemark.setEditTime(DateTimeUtil.getSysTime());
        activityRemark.setEditBy(((User) session.getAttribute("user")).getName());
        activityRemark.setEditFlag("1");
        boolean flag = activityService.updateRemark(activityRemark);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("ar", activityRemark);
        map.put("success", flag);
        String json = PrintJson.getJson(map);
        return json;

    }

    @RequestMapping("workbench/activity/getCharts.do")
    @ResponseBody
    public String getCharts() {
        Map<String, Object> map = activityService.getCharts();
        String json = PrintJson.getJson(map);


        return json;
    }
}
