package com.len.trans.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.len.trans.dao.StoreDao;
import com.len.trans.pojo.Store;
import com.len.trans.service.StoreService;

@Service("restaurantService")
public class StoreServiceImpl implements StoreService {
	@Autowired
	@Qualifier("restaurantDao")
	private StoreDao restaurantDao;
	
	@Override
	public List<Store> getRestaurantList(String location) {
		List<Store> restList = restaurantDao.getRestaurantList(location);
		return restList;
	}

}
