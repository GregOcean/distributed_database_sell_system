package com.len.trans.service;

import java.util.List;

import com.len.trans.pojo.Store;

public interface StoreService {
	public List<Store> getRestaurantList(String location);
}
