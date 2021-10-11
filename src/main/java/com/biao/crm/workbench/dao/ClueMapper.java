package com.biao.crm.workbench.dao;


import com.biao.crm.workbench.pojo.Clue;

import java.util.List;
import java.util.Map;

public interface ClueMapper {


    Integer save(Clue clue);

    Integer getTotalByCondition(Map<String, Object> map);

    List<Clue> getClueListByCondition(Map<String, Object> map);

    Clue detail(String id);

    Clue getById(String clueId);

    Integer delete(String clueId);

    Integer update(Clue clue);

    Integer deletes(String[] ids);
}
