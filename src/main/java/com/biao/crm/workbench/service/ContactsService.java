package com.biao.crm.workbench.service;

import com.biao.crm.workbench.pojo.Contacts;

import java.util.List;

public interface ContactsService {
    List<Contacts> getContactsListByName(String aContactsName);
}
