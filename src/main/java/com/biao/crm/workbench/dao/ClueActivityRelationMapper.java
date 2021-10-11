package com.biao.crm.workbench.dao;


import com.biao.crm.workbench.pojo.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationMapper {


    Integer unbund(String id);

    Integer bund(ClueActivityRelation clueActivityRelation);

    List<ClueActivityRelation> getListByClueId(String clueId);

    Integer delete(ClueActivityRelation clueActivityRelation);

    Integer getCountByIds(String[] ids);

    Integer deleteByIds(String[] ids);
}
