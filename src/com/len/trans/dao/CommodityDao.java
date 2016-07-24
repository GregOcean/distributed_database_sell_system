package com.len.trans.dao;

import java.util.List;

import com.len.trans.pojo.Commodity;

public interface CommodityDao {
	public List<Commodity> getFoodList(String RId, String location);
}
