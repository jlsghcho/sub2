package com.gojls.manage.common.service;

import java.util.List;
import java.util.Map;

import org.springframework.transaction.annotation.Transactional;

@Transactional(readOnly=true, rollbackFor={Exception.class})
public interface FaqService {
	public Object selectTypeList(Map<String, String> param);

	public Object selectFaqList(Map<String, Object> param);

	public Object selectFaqDetail(Map<String, Object> param);
	
	public int faq_save(Map<String, Object> param);

	public int faq_delete(Map<String, Object> param);

	public int type_save(Map<String, Object> param);

	public int type_delete(Map<String, Object> param);
	
}
