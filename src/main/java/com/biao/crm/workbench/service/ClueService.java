package com.biao.crm.workbench.service;

import com.biao.crm.vo.PaginationVO;
import com.biao.crm.workbench.pojo.Clue;
import com.biao.crm.workbench.pojo.Tran;

import java.util.Map;

public interface ClueService {
    boolean save(Clue clue);

    PaginationVO<Clue> pageList(Map<String, Object> map);

    Clue detail(String id);

    boolean unbund(String id);

    boolean bund(String cid, String[] aids);

    void convert(String clueId, Tran tran, String createBy);

    Map<String, Object> getUserListAndClue(String id);

    boolean update(Clue clue);

    boolean delete(String[] ids);
}
