package com.biao.crm.workbench.dao;

import com.biao.crm.workbench.pojo.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {

    List<ClueRemark> getListByClueId(String clueId);

    Integer delete(ClueRemark clueRemark);

    Integer getCountByIds(String[] ids);

    Integer deleteByIds(String[] ids);
}
