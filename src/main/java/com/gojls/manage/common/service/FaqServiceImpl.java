package com.gojls.manage.common.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.gojls.manage.common.controller._HttpComponent;
import com.gojls.manage.common.dao.FaqDao;
import com.gojls.manage.common.dao.v2_NewsDao;
import com.gojls.manage.common.model.v2_NewsModel;
import com.gojls.manage.common.model.v2_TagModel;


@Service
public class FaqServiceImpl implements FaqService{
	protected Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired 
	@Qualifier("oracle")
	private SqlSession sqlSessionOracle;

	public List<Map<String, String>> selectTypeList(Map<String, String> param) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/FaqServiceImpl] selectTypeList(param)");}
		FaqDao faqDao = sqlSessionOracle.getMapper(FaqDao.class); 
		List<Map<String, String>> result = faqDao.selectTypeList(param);
		return result;
	}
	
	public List<Map<String, String>> selectFaqList(Map<String, Object> param) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/FaqServiceImpl] selectFaqList(param)");}
		FaqDao faqDao = sqlSessionOracle.getMapper(FaqDao.class); 
		List<Map<String, String>> result = faqDao.selectFaqList(param);
		return result;
	}
	
	public Map<String, Object> selectFaqDetail(Map<String, Object> param) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/FaqServiceImpl] selectFaqDetail(param)");}
		FaqDao faqDao = sqlSessionOracle.getMapper(FaqDao.class); 
		Map<String, Object> result = faqDao.selectFaqDetail(param);
		return result;
	}
	
	public int faq_save(Map<String, Object> param) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/FaqServiceImpl] faq_save(param)");}
		FaqDao faqDao = sqlSessionOracle.getMapper(FaqDao.class); 
		int param_rtn_val = 0;
		try {
			if(param.get("inup_type").equals("update")) {
				faqDao.update_faq(param); 
			}else {
				faqDao.insert_faq(param);
			}
			
			param_rtn_val = 1; 
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;
	}
	
	public int faq_delete(Map<String, Object> param) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/FaqServiceImpl] delete_faq(param)");}
		FaqDao faqDao = sqlSessionOracle.getMapper(FaqDao.class); 
		int param_rtn_val = 0;
		try {
			faqDao.delete_faq(param); 
			param_rtn_val = 1; 
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;
	}
	
	public int type_save(Map<String, Object> param) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/FaqServiceImpl] type_save(param)");}
		int param_rtn_val = 0; 
		try {
			FaqDao faqDao = sqlSessionOracle.getMapper(FaqDao.class); 
			List<String> site_id_list = new ArrayList<String>();
			site_id_list.add("9");
			site_id_list.add("10");
			if(param.get("cate_id").equals("")) {
				try {
					String cate_id = faqDao.select_type_max_cate();
					param.put("cate_id", cate_id);
//					param.put("site_id", "9");
//					faqDao.insert_type(param);
//					param.put("site_id", "10");
//					faqDao.insert_type(param);
					for(String site_id : site_id_list ) {
						param.put("site_id", site_id);
						faqDao.insert_type(param);
					}
					param_rtn_val = 1;
				}catch(Exception ex) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
					ex.printStackTrace();
				}
				
			}else {
				param_rtn_val = 1;
				for(String site_id : site_id_list ) {
					param.put("site_id", site_id);
					faqDao.update_type(param);
				}
			}
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;
	}
	
	
	public int type_delete(Map<String, Object> param) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/FaqServiceImpl] type_delete(param)");}
		FaqDao faqDao = sqlSessionOracle.getMapper(FaqDao.class); 
		int param_rtn_val = 0;
		try {
//			param.put("site_id", "9");
//			faqDao.delete_type(param);
//			param.put("site_id", "10");
//			faqDao.delete_type(param);
			
			List<String> site_id_list = new ArrayList<String>();
			site_id_list.add("9");
			site_id_list.add("10");
			for(String site_id : site_id_list ) {
				param.put("site_id", site_id);
				faqDao.delete_type(param);
			}
			param_rtn_val = 1; 
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;
	}

}
