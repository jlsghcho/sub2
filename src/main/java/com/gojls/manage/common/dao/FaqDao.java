package com.gojls.manage.common.dao;

import java.util.List;
import java.util.Map;


public interface FaqDao {
	public List<Map<String, String>> selectTypeList(Map<String, String> param);

	public List<Map<String, String>> selectFaqList(Map<String, Object> param);

	public Map<String, Object> selectFaqDetail(Map<String, Object> param);

	public void update_faq(Map<String, Object> param);

	public void insert_faq(Map<String, Object> param);

	public void delete_faq(Map<String, Object> param);

	public void insert_type(Map<String, Object> param);

	public void update_type(Map<String, Object> param);

	public String select_type_max_cate();

	public void delete_type(Map<String, Object> param);
	
	
	
}
