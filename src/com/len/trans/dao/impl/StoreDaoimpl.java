package com.len.trans.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.len.trans.dao.StoreDao;
import com.len.trans.pojo.Store;
import com.len.trans.service.impl.DDBSDaoUtil;

@Repository("restaurantDao")
public class StoreDaoimpl implements StoreDao {
	@Autowired
	@Qualifier("ddbsDaoUtil")
	private DDBSDaoUtil ddbsDaoUtil;
	
	@Override
	public List<Store> getRestaurantList(String location) {
		List<Store> resList = new ArrayList<Store>();
		
		String tableName = "store";
		String[] fields = {"Location"};
		Object[] params = {location};
		List<JdbcTemplate> jdbcTemplateList = ddbsDaoUtil.getQueryJdbcTemplateList(tableName, fields, params);

		String sql = "select * from " + tableName + " where Location = ?";
		for(JdbcTemplate j : jdbcTemplateList){
			resList.addAll(j.query(sql, params, new StoreWrapper()));
			if(!resList.isEmpty()) {
				break;
			}
		}
		
		return resList;
	}

}
