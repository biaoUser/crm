package com.biao.crm.vo;

import java.util.List;

public class PaginationVO<T> {
    private List<T> dataList;
    private Integer total;

    public List<T> getDatalist() {
        return dataList;
    }

    public void setDatalist(List<T> datalist) {
        this.dataList = datalist;
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }
}
