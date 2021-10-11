package com.biao.crm.workbench.service.impl;

import com.biao.crm.utils.DateTimeUtil;
import com.biao.crm.utils.UUIDUtil;
import com.biao.crm.vo.PaginationVO;
import com.biao.crm.workbench.dao.CustomerMapper;
import com.biao.crm.workbench.dao.TranHistoryMapper;
import com.biao.crm.workbench.dao.TranMapper;
import com.biao.crm.workbench.pojo.Customer;
import com.biao.crm.workbench.pojo.Tran;
import com.biao.crm.workbench.pojo.TranHistory;
import com.biao.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class TranServiceImpl implements TranService {

    private TranMapper tranMapper;
    private CustomerMapper customerMapper;
    private TranHistoryMapper tranHistoryMapper;

    @Autowired
    public void setCustomerMapper(CustomerMapper customerMapper) {
        this.customerMapper = customerMapper;
    }

    @Autowired
    public void setTranHistoryMapper(TranHistoryMapper tranHistoryMapper) {
        this.tranHistoryMapper = tranHistoryMapper;
    }

    @Autowired
    public void setTranMapper(TranMapper tranMapper) {
        this.tranMapper = tranMapper;
    }

    public boolean save(Tran tran, String customerName) {
        boolean flag = true;
        //根据名字查，有就取id，没有就创建一个客户
        Customer customer = customerMapper.getCustomerByName(customerName);
        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setCreateBy(tran.getCreateBy());
            customer.setName(customerName);
            customer.setContactSummary(tran.getContactSummary());
            customer.setOwner(tran.getOwner());
            customer.setNextContactTime(tran.getNextContactTime());
            Integer count = customerMapper.save(customer);
            if (count != 1) {
                flag = false;
            }
        }

        tran.setCustomerId(customer.getId());

        //添加交易
        Integer count2 = tranMapper.save(tran);
        if (count2 != 1) {
            flag = false;
        }
        //添加交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setCreateTime(tran.getCreateTime());
        tranHistory.setCreateBy(tran.getCreateBy());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setStage(tran.getStage());

        Integer count3 = tranHistoryMapper.save(tranHistory);
        if (count3 != 1) {
            flag = false;
        }
        return flag;
    }

    public PaginationVO<Tran> pageList(Map<String, Object> map) {
        //取得总条数
        Integer total = tranMapper.getTotalByCondition(map);
        //取得数据
        List<Tran> dataList = tranMapper.getTranListByCondition(map);
        //返回VO
        PaginationVO<Tran> VO = new PaginationVO<Tran>();
        VO.setTotal(total);
        VO.setDatalist(dataList);
        return VO;
    }

    public Tran detail(String id) {
        return tranMapper.detail(id);
    }

    public List<TranHistory> getHistoryListByTranId(String id) {

        return tranHistoryMapper.getHistoryListByTranId(id);
    }

    public boolean changStage(Tran t) {
        Integer i = tranMapper.changStage(t);

        //交易阶段改变后，生成一条交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setStage(t.getStage());
        th.setPossibility(th.getStage());
        th.setCreateBy(t.getEditBy());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setExpectedDate(t.getExpectedDate());
        th.setMoney(t.getMoney());
        th.setTranId(t.getId());
        Integer ii = tranHistoryMapper.save(th);
        return i == 1 && ii == 1;
    }

    public Map<String, Object> getCharts() {
        //取得total
        int total = tranMapper.getTotal();
        //取得dataList
        List<Map<String, Object>> dataList = tranMapper.getCharts();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("total", total);
        map.put("dataList", dataList);
        return map;
    }
}
