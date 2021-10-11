package com.biao.crm.workbench.dao;

import com.biao.crm.workbench.pojo.TranHistory;

import java.util.List;

public interface TranHistoryMapper {

    Integer save(TranHistory tranHistory);

    List<TranHistory> getHistoryListByTranId(String id);
}
