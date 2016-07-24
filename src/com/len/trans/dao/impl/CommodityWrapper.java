package com.len.trans.dao.impl;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.len.trans.pojo.Commodity;

public class CommodityWrapper implements RowMapper<Commodity> {

	@Override
	public Commodity mapRow(ResultSet rs, int rowNum) throws SQLException {
		Commodity food = new Commodity();
		
		food.setFoodId(rs.getString("FId"));
		food.setRestaurantId(rs.getString("RId"));
		food.setFoodName(rs.getString("FName"));
		food.setPrice(rs.getString("price"));
		food.setFoodIntro(rs.getString("FIntro"));
		food.setFoodImg(rs.getString("FImg"));

		return food;
	}

}
