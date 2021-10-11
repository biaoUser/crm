package com.biao.crm.workbench.service.impl;

import com.biao.crm.workbench.dao.CustomerMapper;
import com.biao.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class CustomerServiceImpl implements CustomerService {
    private CustomerMapper customerMapper;
    @Autowired
    public void setCustomerMapper(CustomerMapper customerMapper) {
        this.customerMapper = customerMapper;
    }

    public List<String> getCustomerName(String name) {
        return customerMapper.getCustomerName(name);
    }
}
