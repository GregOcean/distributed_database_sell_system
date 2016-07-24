package com.len.trans.service;

import java.util.List;

import com.len.trans.pojo.Commodity;

public interface CommodityService {
	public List<Commodity> getFoodList(String restaurantId, String location);
}
