package com.biao.crm.workbench.dao;

import com.biao.crm.workbench.pojo.Customer;

import java.util.List;

public interface CustomerMapper {

    Customer getCustomerByName(String company);

    Integer save(Customer customer);

    List<String> getCustomerName(String name);
}
