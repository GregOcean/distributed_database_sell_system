package com.len.trans.dao;

import java.util.List;

import com.len.trans.pojo.Store;

public interface StoreDao {
	public List<Store> getRestaurantList(String location);
}
