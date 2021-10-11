package com.biao.crm.workbench.service;

import com.biao.crm.vo.PaginationVO;
import com.biao.crm.workbench.pojo.Contacts;
import com.biao.crm.workbench.pojo.Tran;
import com.biao.crm.workbench.pojo.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranService {
    boolean save(Tran tran, String customerName);

    PaginationVO<Tran> pageList(Map<String, Object> map);

    Tran detail(String id);

    List<TranHistory> getHistoryListByTranId(String id);

    boolean changStage(Tran t);

    Map<String, Object> getCharts();
}
