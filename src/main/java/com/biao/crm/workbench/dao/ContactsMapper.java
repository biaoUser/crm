package com.biao.crm.workbench.dao;

import com.biao.crm.workbench.pojo.Contacts;

import java.util.List;

public interface ContactsMapper {

    Integer save(Contacts contacts);

    List<Contacts> getContactsListByName(String aContactsName);
}
