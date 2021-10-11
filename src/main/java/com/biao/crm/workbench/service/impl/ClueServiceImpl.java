package com.biao.crm.workbench.service.impl;

import com.biao.crm.dao.UserMapper;
import com.biao.crm.pojo.User;
import com.biao.crm.utils.DateTimeUtil;
import com.biao.crm.utils.UUIDUtil;
import com.biao.crm.vo.PaginationVO;
import com.biao.crm.workbench.dao.*;
import com.biao.crm.workbench.pojo.*;
import com.biao.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {
    private UserMapper userMapper;
    //线索相关表
    private ClueMapper clueMapper;
    private ClueActivityRelationMapper clueActivityRelationMapper;
    private ClueRemarkMapper clueRemarkMapper;
    //客户相关表
    private CustomerMapper customerMapper;
    private CustomerRemarkMapper customerRemarkMapper;
    //联系人相关表
    private ContactsMapper contactsMapper;
    private ContactsRemarkMapper contactsRemarkMapper;
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    //交易相关表
    private TranMapper tranMapper;
    private TranHistoryMapper tranHistoryMapper;

    @Autowired
    public void setUserMapper(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    @Autowired
    public void setContactsActivityRelationMapper(ContactsActivityRelationMapper contactsActivityRelationMapper) {
        this.contactsActivityRelationMapper = contactsActivityRelationMapper;
    }

    @Autowired
    public void setClueRemarkMapper(ClueRemarkMapper clueRemarkMapper) {
        this.clueRemarkMapper = clueRemarkMapper;
    }

    @Autowired
    public void setCustomerMapper(CustomerMapper customerMapper) {
        this.customerMapper = customerMapper;
    }

    @Autowired
    public void setCustomerRemarkMapper(CustomerRemarkMapper customerRemarkMapper) {
        this.customerRemarkMapper = customerRemarkMapper;
    }

    @Autowired
    public void setContactsMapper(ContactsMapper contactsMapper) {
        this.contactsMapper = contactsMapper;
    }

    @Autowired
    public void setContactsRemarkMapper(ContactsRemarkMapper contactsRemarkMapper) {
        this.contactsRemarkMapper = contactsRemarkMapper;
    }

    @Autowired
    public void setTranMapper(TranMapper tranMapper) {
        this.tranMapper = tranMapper;
    }

    @Autowired
    public void setTranHistoryMapper(TranHistoryMapper tranHistoryMapper) {
        this.tranHistoryMapper = tranHistoryMapper;
    }

    @Autowired
    public void setClueMapper(ClueMapper clueMapper) {
        this.clueMapper = clueMapper;
    }

    @Autowired
    public void setClueActivityRelationMapper(ClueActivityRelationMapper clueActivityRelationMapper) {
        this.clueActivityRelationMapper = clueActivityRelationMapper;
    }

    public boolean save(Clue clue) {
        Integer i = clueMapper.save(clue);
        return i == 1;
    }

    public PaginationVO<Clue> pageList(Map<String, Object> map) {
        //取得总条数
        Integer total = clueMapper.getTotalByCondition(map);
        //取得数据
        List<Clue> dataList = clueMapper.getClueListByCondition(map);
        //返回VO
        PaginationVO<Clue> VO = new PaginationVO<Clue>();
        VO.setTotal(total);
        VO.setDatalist(dataList);
        return VO;

    }

    public Clue detail(String id) {

        return clueMapper.detail(id);
    }

    public boolean unbund(String id) {
        Integer i = clueActivityRelationMapper.unbund(id);
        return i == 1;
    }

    public boolean bund(String cid, String[] aids) {
        boolean flag = true;
        for (String aid : aids
        ) {
            ClueActivityRelation clueActivityRelation = new ClueActivityRelation();
            clueActivityRelation.setId(UUIDUtil.getUUID());
            clueActivityRelation.setActivityId(aid);
            clueActivityRelation.setClueId(cid);
            //添加
            Integer i = clueActivityRelationMapper.bund(clueActivityRelation);
            if (i != 1) {
                flag = false;
            }
            System.out.println("1234456789");
        }
        return flag;
    }

    public void convert(String clueId, Tran t, String createBy) {
        String sysTime = DateTimeUtil.getSysTime();
        //通过线索id获取线索对象
        Clue clue = clueMapper.getById(clueId);
        //通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司的名称精确匹配，判断该客户是否存在！）
        String company = clue.getCompany();
        Customer customer = customerMapper.getCustomerByName(company);
        if (customer == null) {//为空表示没有这个客户，新建
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setAddress(clue.getAddress());
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setOwner(clue.getOwner());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setName(company);
            customer.setDescription(clue.getDescription());
            customer.setCreateTime(sysTime);
            customer.setCreateBy(createBy);
            customer.setContactSummary(clue.getContactSummary());
            Integer i = customerMapper.save(customer);
            if (i != 1) {
                System.out.println("添加失败");
            }
        }
        //通过线索对象提取联系人信息，保存联系人
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setSource(clue.getSource());
        contacts.setOwner(clue.getOwner());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setFullname(clue.getFullname());
        contacts.setEmail(clue.getEmail());
        contacts.setDescription(clue.getDescription());
        contacts.setCustomerId(customer.getId());
        contacts.setCreateTime(sysTime);
        contacts.setCreateBy(createBy);
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setAppellation(clue.getAppellation());
        contacts.setAddress(clue.getAddress());
        //添加联系人
        Integer i1 = contactsMapper.save(contacts);
        if (i1 != 1) {
            System.out.println("添加联系人失败");
        }
        //线索备注转换到客户备注以及联系人备注
        //1,查询出与线索相关联的线索备注列表
        List<ClueRemark> clueRemarkLists = clueRemarkMapper.getListByClueId(clueId);
        for (ClueRemark clueRemark : clueRemarkLists
        ) {
            //取出备注信息主要转换到客户备注和联系人备注上
            String noteContent = clueRemark.getNoteContent();
            //创建客户对象和联系人备注
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setCreateBy(createBy);
            customerRemark.setCreateTime(sysTime);
            customerRemark.setCustomerId(customer.getId());
            customerRemark.setEditFlag("0");
            customerRemark.setNoteContent(noteContent);
            Integer i2 = customerRemarkMapper.save(customerRemark);
            if (i2 != 1) {
                System.out.println("添加客户备注失败");
            }
            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setCreateTime(sysTime);
            contactsRemark.setContactsId(contacts.getId());
            contactsRemark.setEditFlag("0");
            contactsRemark.setNoteContent(noteContent);
            Integer i3 = contactsRemarkMapper.save(contactsRemark);
            if (i3 != 1) {
                System.out.println("添加联系人备注失败");
            }
        }
        //线索和市场活动”的关系转换到“联系人和市场活动”的关系
        //查询与该条线索关联的市场活动
        List<ClueActivityRelation> clueActivityRelations = clueActivityRelationMapper.getListByClueId(clueId);
        for (ClueActivityRelation c : clueActivityRelations
        ) {
            String activityId = c.getActivityId();
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(activityId);
            contactsActivityRelation.setContactsId(contacts.getId());
            Integer i4 = contactsActivityRelationMapper.save(contactsActivityRelation);
            if (i4 != 1) {
                System.out.println("添加联系人与市场活动关系失败");
            }

        }
//(6) 如果有创建交易需求，创建一条交易
        if (t != null) {
            t.setSource(clue.getSource());
            t.setOwner(clue.getOwner());
            t.setNextContactTime(clue.getNextContactTime());
            t.setDescription(clue.getDescription());
            t.setCustomerId(customer.getId());
            t.setContactSummary(clue.getContactSummary());
            t.setContactsId(contacts.getId());
            //添加交易
            Integer i5 = tranMapper.save(t);
            if (i5 != 1) {
                System.out.println("添加交易失败");
            }
            //(7) 如果创建了交易，则创建一条该交易下的交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setCreateBy(createBy);
            tranHistory.setCreateTime(sysTime);
            tranHistory.setExpectedDate(t.getExpectedDate());
            tranHistory.setMoney(t.getMoney());
            tranHistory.setStage(t.getStage());
            tranHistory.setTranId(t.getId());
            Integer i6 = tranHistoryMapper.save(tranHistory);
            if (i6 != 1) {
                System.out.println("添加交易历史失败");
            }
        }
//	           (8) 删除线索备注
        for (ClueRemark clueRemark : clueRemarkLists
        ) {
            Integer i7 = clueRemarkMapper.delete(clueRemark);
            if (i7 != 1) {
                System.out.println("删除线索备注失败");
            }
        }
//			(9) 删除线索和市场活动的关系
        for (ClueActivityRelation clueActivityRelation : clueActivityRelations
        ) {
            Integer i8 = clueActivityRelationMapper.delete(clueActivityRelation);
            if (i8 != 1) {
                System.out.println("删除线索和市场活动的关系失败");
            }
        }
//			(10) 删除线索
        Integer i9 = clueMapper.delete(clueId);
        if (i9 != 1) {
            System.out.println(" 删除线索失败");
        }
    }

    public Map<String, Object> getUserListAndClue(String id) {
        boolean flag = true;
        Map<String, Object> map = new HashMap<String, Object>();
        List<User> uList = userMapper.getUserList();
        Clue c = clueMapper.getById(id);
        if (uList.size() == 0 && c == null) {
            flag = false;
        }
        map.put("success", flag);
        map.put("uList", uList);
        map.put("c", c);
        return map;
    }

    public boolean update(Clue clue) {
        Integer i = clueMapper.update(clue);
        return i == 1;
    }

    public boolean delete(String[] ids) {
        boolean flag=true;
        //删除线索备注的条数
        Integer count1 = clueRemarkMapper.getCountByIds(ids);
        //删除线索与市场的关联的条数
        Integer count2 = clueActivityRelationMapper.getCountByIds(ids);
        //删除线索本身的条数
        Integer count3 = ids.length;
        //删除线索备注
        Integer count11 = clueRemarkMapper.deleteByIds(ids);
        //删除线索与市场的关联
        Integer count22 = clueActivityRelationMapper.deleteByIds(ids);
        //删除线索
       Integer count33= clueMapper.deletes(ids);
        System.out.println("count1"+count1);
        System.out.println("count2"+count2);
        System.out.println("count3"+count3);
        if(count1!=count11){
            flag=false;
        }
        if(count2!=count22){
            flag=false;
        }
        if(count3!=count33){
            flag=false;
        }

        return flag;
    }
}
