package com.biao.crm.utils;


import com.biao.crm.vo.PaginationVO;
import com.biao.crm.workbench.pojo.Activity;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PrintJson {
	
	public static String getJson(Object o) {
		Gson gson = new Gson();
		if (o.equals(true) || o.equals(false)) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("success", o);
			String json = gson.toJson(map);
			return json;
		} else {
			String json = gson.toJson(o);
			return json;
		}
	}
	public static void main(String[] args) {
//		String json = getJson(true);
//		System.out.println(json);
	}

	}
	
























