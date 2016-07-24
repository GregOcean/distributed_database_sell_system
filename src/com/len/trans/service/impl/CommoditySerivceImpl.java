package com.len.trans.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.len.trans.dao.CommodityDao;
import com.len.trans.pojo.Commodity;
import com.len.trans.service.CommodityService;

@Service("foodService")
public class CommoditySerivceImpl implements CommodityService {
	@Autowired
	@Qualifier("foodDao")
	private CommodityDao foodDao;
	
	@Override
	public List<Commodity> getFoodList(String restaurantId, String location) {
		List<Commodity> foodList = foodDao.getFoodList(restaurantId, location);
		return foodList;
	}

}
