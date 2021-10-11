package com.biao.crm.workbench.controller;

import com.biao.crm.pojo.User;
import com.biao.crm.service.UserService;
import com.biao.crm.utils.DateTimeUtil;
import com.biao.crm.utils.PrintJson;
import com.biao.crm.utils.UUIDUtil;
import com.biao.crm.vo.PaginationVO;
import com.biao.crm.workbench.pojo.Activity;
import com.biao.crm.workbench.pojo.Clue;
import com.biao.crm.workbench.pojo.Tran;
import com.biao.crm.workbench.service.ActivityService;
import com.biao.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ClueController {
    private ClueService clueService;
    private UserService userService;
    private ActivityService activityService;

    @Autowired
    public void setActivityService(ActivityService activityService) {
        this.activityService = activityService;
    }

    @Autowired
    public void setClueService(ClueService clueService) {
        this.clueService = clueService;
    }

    @Autowired
    public void setUserService(UserService userService) {
        this.userService = userService;
    }


    @RequestMapping("workbench/clue/getUserList.do")
    @ResponseBody
    public String getUserList() {
        List<User> uList = userService.getUserList();
        String json = PrintJson.getJson(uList);
        return json;
    }

    @RequestMapping("workbench/clue/save.do")
    @ResponseBody
    public String save(Clue clue, HttpSession session) {
        //自动生成id
        String uuid = UUIDUtil.getUUID();
        clue.setId(uuid);
        //创建当前时间
        String sysTime = DateTimeUtil.getSysTime();
        clue.setCreateTime(sysTime);
        //session获取当前创建人
        String name = ((User) session.getAttribute("user")).getName();
        clue.setCreateBy(name);
        boolean flag = clueService.save(clue);
        String json = PrintJson.getJson(flag);
        return json;
    }

    //分页
    @RequestMapping("workbench/clue/pageList.do")
    @ResponseBody
    public String pageList(@RequestParam("pageNo") String pageNo,
                           @RequestParam("pageSize") String pageSize,
                           Clue clue) {
        Integer PageNo = Integer.valueOf(pageNo);
        Integer PageSize = Integer.valueOf(pageSize);
        //limit公式
        Integer skipCount = (PageNo - 1) * PageSize;
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("skipCount", skipCount);
        map.put("PageSize", PageSize);
        map.put("fullname", clue.getFullname());
        map.put("company", clue.getCompany());
        map.put("phone", clue.getPhone());
        map.put("source", clue.getSource());
        map.put("owner", clue.getOwner());
        map.put("mphone", clue.getMphone());
        map.put("State", clue.getState());
        PaginationVO<Clue> vo = clueService.pageList(map);
        String json = PrintJson.getJson(vo);
        System.out.println(json);
        return json;
    }


    @RequestMapping("workbench/clue/detail.do")
    public String detail(@RequestParam("id") String id, Model model) {
        Clue clue = clueService.detail(id);
        model.addAttribute("c", clue);

        return "clue/detail";
    }

    @RequestMapping("workbench/clue/getActivityListByClueId.do")
    @ResponseBody
    public String getActivityListByClueId(@RequestParam("clueId") String clueId) {
        System.out.println("根据clueID查询关联市场活动列表");
        List<Activity> activities = activityService.getActivityListByClueId(clueId);
        String json = PrintJson.getJson(activities);
        return json;
    }

    @RequestMapping("workbench/clue/unbund.do")
    @ResponseBody
    public String unbund(@RequestParam("id") String id) {
        boolean flag = clueService.unbund(id);
        String json = PrintJson.getJson(flag);
        return json;
    }

    @RequestMapping("workbench/clue/getActivityListByNameAndNotByClueId.do")
    @ResponseBody
    public String getActivityListByNameAndNotByClueId(
            @RequestParam("aname") String aname,
            @RequestParam("clueId") String clueId) {
        System.out.println("查询市场活动（排除已经关联过的市场活动和进行模糊查询）");
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("aname", aname);
        map.put("clueId", clueId);
        List<Activity> aList = activityService.getActivityListByNameAndNotByClueId(map);
        String json = PrintJson.getJson(aList);
        return json;
    }


    @RequestMapping(value = "workbench/clue/bund.do", method = RequestMethod.POST)
    @ResponseBody
    public String bund(HttpServletRequest request) {
        System.out.println("执行关联市场活动");
        String cid = request.getParameter("cid");
        String[] aids = request.getParameterValues("aid");
        System.out.println("aids"+aids.length);
        boolean flag = clueService.bund(cid, aids);
        String json = PrintJson.getJson(flag);
        return json;
    }

    @RequestMapping("workbench/clue/getActivityListByName.do")
    @ResponseBody
    public String getActivityListByName(@RequestParam("aname") String aname) {
        List<Activity> aList = activityService.getActivityListByName(aname);
        String json = PrintJson.getJson(aList);

        return json;
    }

    @RequestMapping("workbench/clue/concert.do")
    public String concert(@RequestParam("clueId") String clueId,
                          HttpServletRequest request,
                          HttpSession session) {
        String flag = request.getParameter("flag");
        //session获取当前创建人
        String createBy = ((User) session.getAttribute("user")).getName();
        Tran tran = null;
        if ("true".equals(flag)) {
            tran = new Tran();
            String money = request.getParameter("money");
            String name = request.getParameter("name");
            String expectedDate = request.getParameter("expectedDate");
            String stage = request.getParameter("stage");
            String activityId = request.getParameter("activityId");
            String id = UUIDUtil.getUUID();
            //创建当前时间
            String sysTime = DateTimeUtil.getSysTime();

            tran.setId(id);
            tran.setActivityId(activityId);
            tran.setMoney(money);
            tran.setName(name);
            tran.setExpectedDate(expectedDate);
            tran.setStage(stage);
            tran.setCreateBy(createBy);
            tran.setCreateTime(sysTime);
        }

        clueService.convert(clueId, tran, createBy);

        return "redirect:/workbench/clue/index.jsp";
    }

    @RequestMapping("workbench/clue/getUserListAndClue.do")
    @ResponseBody
    public String getUserListAndClue(@RequestParam("id") String id) {
        Map<String, Object> map = clueService.getUserListAndClue(id);
        String json = PrintJson.getJson(map);
        System.out.println(json);
        return json;

    }

    @RequestMapping("workbench/clue/update.do")
    @ResponseBody
    public String update(Clue clue, HttpSession session) {
        System.out.println(clue);
        //创建当前时间
        String sysTime = DateTimeUtil.getSysTime();
        //session获取当前创建人
        String name = ((User) session.getAttribute("user")).getName();
        clue.setEditTime(sysTime);
        clue.setEditBy(name);
        boolean flag = clueService.update(clue);
        String json = PrintJson.getJson(flag);
        return json;
    }
    @RequestMapping("workbench/clue/delete.do")
    @ResponseBody
    public String delete(HttpServletRequest request){
        boolean flag = false;
        String[] ids = request.getParameterValues("id");
        System.out.println(Arrays.asList(ids));
        flag = clueService.delete(ids);
        String json = PrintJson.getJson(flag);
        return json;
    }

}
