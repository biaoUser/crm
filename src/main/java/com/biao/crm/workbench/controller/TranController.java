package com.biao.crm.workbench.controller;

import com.biao.crm.pojo.User;
import com.biao.crm.service.UserService;
import com.biao.crm.utils.DateTimeUtil;
import com.biao.crm.utils.PrintJson;
import com.biao.crm.utils.UUIDUtil;
import com.biao.crm.vo.PaginationVO;
import com.biao.crm.workbench.pojo.Activity;
import com.biao.crm.workbench.pojo.Contacts;
import com.biao.crm.workbench.pojo.Tran;
import com.biao.crm.workbench.pojo.TranHistory;
import com.biao.crm.workbench.service.ActivityService;
import com.biao.crm.workbench.service.ContactsService;
import com.biao.crm.workbench.service.CustomerService;
import com.biao.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class TranController {

    private TranService tranService;
    private UserService userService;
    private ActivityService activityService;
    private CustomerService customerService;//客户
    private ContactsService contactsService;//联系人

    @Autowired
    public void setContactsService(ContactsService contactsService) {
        this.contactsService = contactsService;
    }

    @Autowired
    public void setCustomerService(CustomerService customerService) {
        this.customerService = customerService;
    }

    @Autowired
    public void setActivityService(ActivityService activityService) {
        this.activityService = activityService;
    }

    @Autowired
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    @Autowired
    public void setTranService(TranService tranService) {

        this.tranService = tranService;
    }

    //跳转到添加也
    @RequestMapping("workbench/transaction/add.do")
    public String add(Model model) {
        List<User> uList = userService.getUserList();
        model.addAttribute("uList", uList);
        return "transaction/save";
    }

    @RequestMapping("workbench/transaction/getActivityListByName.do")
    @ResponseBody
    public String getActivityListByName(@RequestParam("aname") String aname) {
        List<Activity> aList = activityService.getActivityListByName(aname);
        String json = PrintJson.getJson(aList);

        return json;
    }

    //
    @RequestMapping("workbench/transaction/getContactsListByName.do")
    @ResponseBody
    public String getContactsListByName(@RequestParam("aContactsName") String aContactsName) {
        List<Contacts> aList = contactsService.getContactsListByName(aContactsName);
        String json = PrintJson.getJson(aList);
        return json;
    }

    @RequestMapping("workbench/transaction/getCustomerName.do")
    @ResponseBody
    public String getCustomerName(@RequestParam("name") String name) {
        List<String> sList = customerService.getCustomerName(name);
        String json = PrintJson.getJson(sList);
        return json;
    }

    @RequestMapping("workbench/transaction/save.do")
    public String save(Tran tran, @RequestParam("customerName") String customerName, HttpSession session) {
        tran.setId(UUIDUtil.getUUID());
        //创建当前时间
        String sysTime = DateTimeUtil.getSysTime();
        //session获取当前创建人
        String createBy = ((User) session.getAttribute("user")).getName();
        tran.setCreateBy(createBy);
        tran.setCreateTime(sysTime);
        boolean flag = tranService.save(tran, customerName);
        System.out.println(flag + "....>>>> ");
        return "redirect:/workbench/transaction/index.jsp";

//        return "transaction/index";

    }

    @RequestMapping("workbench/transaction/pageList.do")
    @ResponseBody
    public String pageList(@RequestParam("pageNo") String pageNo,
                           @RequestParam("pageSize") String pageSize,
                           @RequestParam("owner") String owner,
                           @RequestParam("customer") String customer,
                           @RequestParam("contacts") String contacts,
                           Tran tran) {

        Integer PageNo = Integer.valueOf(pageNo);
        Integer PageSize = Integer.valueOf(pageSize);
        //limit公式
        Integer skipCount = (PageNo - 1) * PageSize;
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("skipCount", skipCount);
        map.put("PageSize", PageSize);
        map.put("name", tran.getName());
        map.put("type", tran.getType());
        map.put("source", tran.getSource());
        map.put("owner", owner);
        map.put("stage", tran.getStage());
        map.put("customer", customer);
        map.put("contacts", contacts);
        PaginationVO<Tran> vo = tranService.pageList(map);
        String json = PrintJson.getJson(vo);
        return json;

    }

    @RequestMapping("workbench/transaction/detail.do")
    //servletContext在参数中会报错：原因未知
    public String detail(@RequestParam("id") String id, Model model, HttpServletRequest request) {
        Tran tran = tranService.detail(id);
        ServletContext servletContext1 = request.getServletContext();
        String stage = tran.getStage();
        Map<String, String> map = (Map) servletContext1.getAttribute("pMap");
        String possibility = map.get(stage);
        tran.setPossibility(possibility);
        model.addAttribute("t", tran);
        return "transaction/detail";
    }

    @RequestMapping("workbench/transaction/getHistoryListByTranId.do")
    @ResponseBody
    public String getHistoryListByTranId(@RequestParam("id") String id, HttpServletRequest request) {
        ServletContext servletContext = request.getServletContext();
        Map<String, String> map = (Map) servletContext.getAttribute("pMap");


        List<TranHistory> tranHistories = tranService.getHistoryListByTranId(id);

        for (TranHistory th : tranHistories
        ) {
            String stage = th.getStage();
            String possibility = map.get(stage);
            th.setPossibility(possibility);
        }
        String json = PrintJson.getJson(tranHistories);
        return json;
    }

    @RequestMapping("workbench/transaction/changStage.do")
    @ResponseBody
    public String changStage(
            @RequestParam("id") String id, @RequestParam("stage") String stage,
            @RequestParam("money") String money, @RequestParam("expectedDate") String expectedDate,
            HttpSession session, HttpServletRequest request) {
        //创建当前时间
        String sysTime = DateTimeUtil.getSysTime();
        //session获取当前创建人
        String name = ((User) session.getAttribute("user")).getName();
        ServletContext servletContext = request.getServletContext();
        Map<String, String> pMap = (Map<String, String>) servletContext.getAttribute("pMap");
        String possibility = pMap.get(stage);
        Tran t = new Tran();
        t.setId(id);
        t.setMoney(money);
        t.setEditBy(name);
        t.setEditTime(sysTime);
        t.setStage(stage);
        t.setExpectedDate(expectedDate);
        t.setPossibility(possibility);
        boolean flag = tranService.changStage(t);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("success", flag);
        map.put("t", t);
        String json = PrintJson.getJson(map);
        return json;

    }

    @RequestMapping("workbench/transaction/getCharts.do")
    @ResponseBody
    public String getCharts() {
        Map<String, Object> map = tranService.getCharts();
        String json = PrintJson.getJson(map);
        return json;
    }
}
