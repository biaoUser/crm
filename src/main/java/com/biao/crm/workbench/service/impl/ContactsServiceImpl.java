package com.biao.crm.workbench.service.impl;

import com.biao.crm.workbench.dao.ContactsMapper;
import com.biao.crm.workbench.pojo.Contacts;
import com.biao.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ContactsServiceImpl implements ContactsService {

    private ContactsMapper contactsMapper;

    @Autowired
    public void setContactsMapper(ContactsMapper contactsMapper) {
        this.contactsMapper = contactsMapper;
    }

    public List<Contacts> getContactsListByName(String aContactsName) {
        return contactsMapper.getContactsListByName(aContactsName);
    }
}
