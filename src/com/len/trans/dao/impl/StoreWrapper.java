package com.len.trans.dao.impl;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.len.trans.pojo.Store;

public class StoreWrapper implements RowMapper<Store> {
	
	@Override
	public Store mapRow(ResultSet rs, int rowNum) throws SQLException {
		Store res = new Store();
		
		res.setRestaurantId(rs.getString("RId"));
		res.setRestaurantName(rs.getString("RName"));
		res.setRestaurantIntro(rs.getString("RIntro"));
		res.setRestaurantImg(rs.getString("RImg"));
		res.setRestaurantLocation(rs.getString("Location"));

		return res;
	}
}
