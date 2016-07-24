package com.len.trans.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.len.trans.dao.CommodityDao;
import com.len.trans.pojo.Commodity;
import com.len.trans.service.impl.DDBSDaoUtil;

@Repository("foodDao")
public class CommodityDaoImpl implements CommodityDao {
	@Autowired
	@Qualifier("ddbsDaoUtil")
	private DDBSDaoUtil ddbsDaoUtil;
	
	public List<Commodity> getFoodList(String restaurantId, String location) {
		List<Commodity> foodList = new ArrayList<Commodity>();
		
		String tableName = "commodity";
		String[] fields = {"Location"};
		Object[] params = {location};
		
		List<JdbcTemplate> jdbcTemplateList = ddbsDaoUtil.getQueryJdbcTemplateList(tableName, fields, params);
		String sql = "select * from " + tableName + " where RId = '" + restaurantId + "'";
		for(JdbcTemplate j : jdbcTemplateList){
			foodList.addAll(j.query(sql, new CommodityWrapper()));
			if(!foodList.isEmpty()) {
				break;
			}
		}
		
		return foodList;
	}
}
