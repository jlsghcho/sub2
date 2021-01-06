package com.gojls.manage.common.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;
import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.gojls.manage.common.controller._HttpComponent;
import com.gojls.manage.common.dao.v2_BannerDao;
import com.gojls.manage.common.dao.v2_CommonDao;
import com.gojls.manage.common.dao.v2_IRDao;
import com.gojls.manage.common.dao.v2_IR_OLD_Dao;
import com.gojls.manage.common.dao.v2_NewsDao;
import com.gojls.manage.common.dao.v2_SyncDao;
import com.gojls.manage.common.model.v2_BannerModel;
import com.gojls.manage.common.model.v2_DeptModel;
import com.gojls.manage.common.model.v2_IRFileModel;
import com.gojls.manage.common.model.v2_IRModel;
import com.gojls.manage.common.model.v2_NewsModel;
import com.gojls.manage.common.model.v2_ScheduleLogModel;
import com.gojls.manage.common.model.v2_SearchModel;
import com.gojls.manage.common.model.v2_SyncModel;
import com.gojls.manage.common.model.v2_SyncUnioneModel;
import com.gojls.manage.common.model.v2_TagModel;
import com.gojls.manage.member.model.EmpModel;
import com.gojls.util._Cookie;
import com.gojls.util._Response;

import net.minidev.json.parser.JSONParser;
import net.minidev.json.parser.ParseException;
import net.sf.json.JSONObject;

@Service
public class v2_CommonServiceImpl implements v2_CommonService{
	protected Logger logger = LoggerFactory.getLogger(getClass());

	@Value("#{globalContext['ENCACHE_NEWS_DEL1']?:''}") private String ENCACHE_NEWS_DEL1;
	@Value("#{globalContext['ENCACHE_NEWS_DEL2']?:''}") private String ENCACHE_NEWS_DEL2;
	@Value("#{globalContext['ENCACHE_NEWS_DEL3']?:''}") private String ENCACHE_NEWS_DEL3;
	
	@Value("#{globalContext['ENCACHE_AD_DEL1']?:''}") private String ENCACHE_AD_DEL1;
	@Value("#{globalContext['ENCACHE_AD_DEL2']?:''}") private String ENCACHE_AD_DEL2;
	@Value("#{globalContext['ENCACHE_AD_DEL3']?:''}") private String ENCACHE_AD_DEL3;

	@Value("#{globalContext['QUEUE_GOJLS_URL']?:'http://www.gojls.com/branch'}") private String QUEUE_GOJLS_URL;
	@Value("#{globalContext['QUEUE_UNIONE_SYNC']?:''}") private String QUEUE_UNIONE_SYNC;
	@Value("#{globalContext['QUEUE_AUTH_KEY']?:''}") private String QUEUE_AUTH_KEY;
	
	@Value("#{globalContext['ENCACHE_ABROAD_DEL1']?:''}") private String ENCACHE_ABROAD_DEL1;
	@Value("#{globalContext['ENCACHE_ABROAD_DEL2']?:''}") private String ENCACHE_ABROAD_DEL2;
	@Value("#{globalContext['ENCACHE_ABROAD_DEL3']?:''}") private String ENCACHE_ABROAD_DEL3;
	@Value("#{globalContext['ABROAD_CODE']?:''}") private String ABROAD_CODE;
	
	@Autowired 
	@Qualifier("oracle")
	private SqlSession sqlSessionOracle;

	/* 공통 부분 */
	public List<v2_DeptModel> sv_select_dept_top_list(v2_DeptModel deptVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_dept_top_list(v2_DeptModel)");}
		v2_CommonDao commonDao = sqlSessionOracle.getMapper(v2_CommonDao.class); 
		return commonDao.select_dept_top_list(deptVo);
	}

	public List<v2_DeptModel> sv_select_dept_course_list() {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_dept_course_list()");}
		v2_CommonDao commonDao = sqlSessionOracle.getMapper(v2_CommonDao.class); 
		return commonDao.select_dept_course_list();
	}
	
	public List<v2_DeptModel> sv_select_dept_sub_list(int parent_dept_seq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_dept_sub_list(dept_seq)");}
		v2_CommonDao commonDao = sqlSessionOracle.getMapper(v2_CommonDao.class); 
		v2_DeptModel deptVo = new v2_DeptModel();
		deptVo.setParent_dept_seq(parent_dept_seq);
		
		return commonDao.select_dept_sub_list(deptVo);
	}
	
	public List<v2_TagModel> sv_select_tag_view_list() {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_tag_view_list()");}
		v2_CommonDao commonDao = sqlSessionOracle.getMapper(v2_CommonDao.class); 
		return commonDao.select_tag_view_list();
	}

	public List<v2_TagModel> sv_select_tag_box_list() {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_tag_box_list()");}
		v2_CommonDao commonDao = sqlSessionOracle.getMapper(v2_CommonDao.class); 
		return commonDao.select_tag_box_list();
	}
	
	public List<v2_DeptModel> sv_select_dept_abroad_list(v2_SearchModel searchVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_dept_abroad_list(searchVo)");}
		v2_CommonDao commonDao = sqlSessionOracle.getMapper(v2_CommonDao.class); 
		return commonDao.select_abroad_dept_list(searchVo);
	}

	public List<v2_DeptModel> sv_select_dept_abroad_user(v2_SearchModel searchVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_dept_abroad_user(searchVo)");}
		v2_CommonDao commonDao = sqlSessionOracle.getMapper(v2_CommonDao.class); 
		return commonDao.select_abroad_dept_user(searchVo);
	}
	
	public List<v2_DeptModel> sv_select_dept_list(){
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_dept_list()");}
		v2_CommonDao commonDao = sqlSessionOracle.getMapper(v2_CommonDao.class); 
		return commonDao.select_dept_list();		
	}	

	/* 배너 부분 */
	public List<v2_BannerModel> sv_select_banner_list(v2_SearchModel schVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_banner_list(v2_SearchModel)");}
		v2_BannerDao bannerDao = sqlSessionOracle.getMapper(v2_BannerDao.class); 
		return bannerDao.select_banner_list(schVo);
	}

	/* 배너 저장 */ 
	public int sv_banner_save(v2_BannerModel bannerVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_banner_save(v2_BannerModel)");}
		v2_BannerDao bannerDao = sqlSessionOracle.getMapper(v2_BannerDao.class); 
		int param_rtn_val = 0;
		try {
			if(bannerDao.select_banner_overlap_check(bannerVo) == 0) {
				if(bannerVo.getInup_type().equals("update")) {
					bannerDao.update_banner_save(bannerVo); 
				}else {
					bannerDao.insert_banner_save(bannerVo); 
				}
				
				HttpHeaders headers = new HttpHeaders();
				headers.set("x-event-url", "manage");
				_HttpComponent http = new _HttpComponent();
				
				String param_type = "banner";
				if(ENCACHE_ABROAD_DEL1 != null && !ENCACHE_ABROAD_DEL1.equals("")){ http.sendGet(ENCACHE_ABROAD_DEL1 +"/"+ param_type, "", headers); }
				if(ENCACHE_ABROAD_DEL2 != null && !ENCACHE_ABROAD_DEL2.equals("")){ http.sendGet(ENCACHE_ABROAD_DEL2 +"/"+ param_type, "", headers); }
				if(ENCACHE_ABROAD_DEL3 != null && !ENCACHE_ABROAD_DEL3.equals("")){ http.sendGet(ENCACHE_ABROAD_DEL3 +"/"+ param_type, "", headers); }

				if(ENCACHE_AD_DEL1 != null && !ENCACHE_AD_DEL1.equals("")){ http.sendGet(ENCACHE_AD_DEL1, "", headers); }
				if(ENCACHE_AD_DEL2 != null && !ENCACHE_AD_DEL2.equals("")){ http.sendGet(ENCACHE_AD_DEL2, "", headers); }
				if(ENCACHE_AD_DEL3 != null && !ENCACHE_AD_DEL3.equals("")){ http.sendGet(ENCACHE_AD_DEL3, "", headers); }
				
				param_rtn_val = 1; 
			} else { param_rtn_val = 99; }
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;
	}
	
	/* 배너 삭제 */ 
	public int sv_banner_delete(v2_BannerModel bannerVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_banner_delete(v2_BannerModel)");}
		v2_BannerDao bannerDao = sqlSessionOracle.getMapper(v2_BannerDao.class); 
		int param_rtn_val = 0;
		try {
			bannerDao.delete_banner_save(bannerVo); 
			
			HttpHeaders headers = new HttpHeaders();
			headers.set("x-event-url", "manage");
			_HttpComponent http = new _HttpComponent();
			
			String param_type = "banner";
			if(ENCACHE_ABROAD_DEL1 != null && !ENCACHE_ABROAD_DEL1.equals("")){ http.sendGet(ENCACHE_ABROAD_DEL1 +"/"+ param_type, "", headers); }
			if(ENCACHE_ABROAD_DEL2 != null && !ENCACHE_ABROAD_DEL2.equals("")){ http.sendGet(ENCACHE_ABROAD_DEL2 +"/"+ param_type, "", headers); }
			if(ENCACHE_ABROAD_DEL3 != null && !ENCACHE_ABROAD_DEL3.equals("")){ http.sendGet(ENCACHE_ABROAD_DEL3 +"/"+ param_type, "", headers); }
			
			if(ENCACHE_AD_DEL1 != null && !ENCACHE_AD_DEL1.equals("")){ http.sendGet(ENCACHE_AD_DEL1, "", headers); }
			if(ENCACHE_AD_DEL2 != null && !ENCACHE_AD_DEL2.equals("")){ http.sendGet(ENCACHE_AD_DEL2, "", headers); }
			if(ENCACHE_AD_DEL3 != null && !ENCACHE_AD_DEL3.equals("")){ http.sendGet(ENCACHE_AD_DEL3, "", headers); }
			
			param_rtn_val = 1; 
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;
	}
	
	/* Sync 부분 */
	public List<v2_SyncModel> sv_select_sync_list(v2_SearchModel schVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_sync_list(v2_SearchModel)");}
		v2_SyncDao syncDao = sqlSessionOracle.getMapper(v2_SyncDao.class); 
		return syncDao.select_sync_list(schVo);
	}

	/* Sync 실행 */
	public int sv_exec_sync(v2_SyncModel sync_vo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_sync_list(String)");}
		v2_SyncDao syncDao = sqlSessionOracle.getMapper(v2_SyncDao.class);
		int rtn_val = 0;
		try {
			sync_vo.setParam_link_url(QUEUE_GOJLS_URL.toString());
			List<v2_SyncUnioneModel> param_sync_dept_arr = syncDao.select_sync_dept_list(sync_vo);

			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("deptList", param_sync_dept_arr);
			JSONObject jsonObj = new JSONObject();
			jsonObj.putAll(dataMap);

			// API 전달 QUEUE_UNIONE_SYNC , QUEUE_AUTH_KEY
			byte[] bytesEncoded = Base64.encodeBase64(QUEUE_AUTH_KEY.getBytes());
			StringBuffer sb = new StringBuffer();
			String authKey = sb.append(new String(bytesEncoded)).toString();
			
			HttpHeaders headers = new HttpHeaders();
			headers.set("X-JLS-Event", sync_vo.getParam_sync_type().toString());
			headers.set("Authorization", "Basic ".concat(authKey));
			headers.set("Accept-Charset", "UTF-8");
			headers.set("Content-Type", "application/json");
			_HttpComponent http = new _HttpComponent();
			String[] rtnData = http.sendPut(QUEUE_UNIONE_SYNC, jsonObj.get("deptList").toString(), headers);
			
			System.out.println(">> sv_select_sync_list : "+ rtnData[0] +","+ rtnData[1]);

			/* History Data Save */
			v2_ScheduleLogModel schlogVo = new v2_ScheduleLogModel();
			schlogVo.setPartner_nm("Unione");
			schlogVo.setEvent_code(sync_vo.getParam_sync_type().toString());
			schlogVo.setEvent_sub_code("");
			schlogVo.setTran_type("O");
			if(rtnData[0].equals("200")) {
				schlogVo.setTran_result("Y");
				schlogVo.setTran_msg("Success");

				v2_SyncUnioneModel unione_vo = new v2_SyncUnioneModel();
				unione_vo.setCorp_nm("Unione");
				if(sync_vo.getParam_sync_type().toString().equals("API-DEPT_MOD")) { unione_vo.setStatus("2"); }else { unione_vo.setStatus("0"); }
				unione_vo.setReg_user_seq("");
				unione_vo.setReg_user_id("");
				unione_vo.setReg_user_nm("");
				for(int i=0; i < sync_vo.getParam_dept_arr().size(); i++){
					unione_vo.setDept_seq(Integer.parseInt(sync_vo.getParam_dept_arr().get(i).toString()));
					syncDao.marge_dept_api(unione_vo);
					
					schlogVo.setTran_seq(sync_vo.getParam_dept_arr().get(i).toString());
					syncDao.insert_schedule_log(schlogVo);
				}
				rtn_val = 1;
			}else {
				schlogVo.setTran_result("N");
				schlogVo.setTran_msg("Http Connection fail Code : " + rtnData[1]);
				for(int i=0; i < sync_vo.getParam_dept_arr().size(); i++){
					schlogVo.setTran_seq(sync_vo.getParam_dept_arr().get(i).toString());
					syncDao.insert_schedule_log(schlogVo);
				}
				rtn_val = 0;
			}
		}catch(Exception ex) {
			logger.error(ex.getMessage());
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return rtn_val;
	}

	/* 공지사항 목록 */
	public List<v2_NewsModel> sv_select_news_list(v2_SearchModel schVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_news_list(v2_SearchModel)");}
		v2_NewsDao newsDao = sqlSessionOracle.getMapper(v2_NewsDao.class); 
		return newsDao.select_news_list(schVo);
	}
	
	/* 공지사항 상세보기 */
	public v2_NewsModel sv_select_news_view(v2_NewsModel newsVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_news_view(v2_NewsModel)");}
		v2_NewsDao newsDao = sqlSessionOracle.getMapper(v2_NewsDao.class); 
		return newsDao.select_new_view(newsVo);
	}
	
	
	/* 공지사항 상세보기(학교) */
	public v2_NewsModel sv_select_news_chessplus_view(Map<String, Object> param) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_news_chessplus_view(Map<String, Object> param)");}
		v2_NewsDao newsDao = sqlSessionOracle.getMapper(v2_NewsDao.class); 
		return newsDao.select_news_chessplus_view(param);
	}
	
	
	/* 공지사항 저장 */ 
	public int sv_news_save(v2_NewsModel newsVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_news_list(v2_SearchModel)");}
		v2_NewsDao newsDao = sqlSessionOracle.getMapper(v2_NewsDao.class); 
		int param_rtn_val = 0;
		try {
			if(newsVo.getInup_type().equals("update")) {
				newsDao.update_news_save(newsVo); 
				newsDao.update_news_content_save(newsVo); 
			}else {
				newsDao.insert_news_content_save(newsVo);
				newsDao.insert_news_save(newsVo); 
			}
			
			/* Tag Save */
			newsDao.delete_tag_content(newsVo.getNotice_content_seq());
			System.out.println(newsVo.getTag_select_type());
			if(newsVo.getTag_select_type().size() > 0 && newsVo.getTag_select_type() != null) {
				Map<String, Object> tag_map = new HashMap<String, Object>();
				List<v2_TagModel> tag_type_list = new ArrayList<v2_TagModel>();
				for(int i = 0; i < newsVo.getTag_select_type().size(); i++) {
					v2_TagModel tagVo = new v2_TagModel();
					tagVo.setNotice_content_seq(newsVo.getNotice_content_seq());
					tagVo.setTag_code(newsVo.getTag_select_type().get(i).replaceAll("\\\"", ""));
					tag_type_list.add(tagVo);
				}
				tag_map.put("data", tag_type_list);
				newsDao.insert_tag_content(tag_map);
			}
			
			HttpHeaders headers = new HttpHeaders();
			headers.set("x-event-url", "manage");
			_HttpComponent http = new _HttpComponent();
			
			String param_type = "notice";
			if(ENCACHE_ABROAD_DEL1 != null && !ENCACHE_ABROAD_DEL1.equals("")){ http.sendGet(ENCACHE_ABROAD_DEL1 +"/"+ param_type, "", headers); }
			if(ENCACHE_ABROAD_DEL2 != null && !ENCACHE_ABROAD_DEL2.equals("")){ http.sendGet(ENCACHE_ABROAD_DEL2 +"/"+ param_type, "", headers); }
			if(ENCACHE_ABROAD_DEL3 != null && !ENCACHE_ABROAD_DEL3.equals("")){ http.sendGet(ENCACHE_ABROAD_DEL3 +"/"+ param_type, "", headers); }
			
			if(ENCACHE_NEWS_DEL1 != null && !ENCACHE_NEWS_DEL1.equals("")){ http.sendGet(ENCACHE_NEWS_DEL1, "", headers); }
			if(ENCACHE_NEWS_DEL2 != null && !ENCACHE_NEWS_DEL2.equals("")){ http.sendGet(ENCACHE_NEWS_DEL2, "", headers); }
			if(ENCACHE_NEWS_DEL3 != null && !ENCACHE_NEWS_DEL3.equals("")){ http.sendGet(ENCACHE_NEWS_DEL3, "", headers); }
			
			param_rtn_val = 1; 
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;
	}
	
	/* 공지사항 저장(학교) */ 
	public int sv_news_chessplus_save(v2_NewsModel newsVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_news_chessplus_save(v2_SearchModel)");}
		v2_NewsDao newsDao = sqlSessionOracle.getMapper(v2_NewsDao.class); 
		int param_rtn_val = 0;
		try {
			if(newsVo.getInup_type().equals("update")) {
				newsDao.update_news_chessplus_save(newsVo); 
			}else {
				newsDao.insert_news_chessplus_save(newsVo);
			}
			
			/* Tag Save */
			System.out.println(newsVo.getTag_select_type());
			newsDao.delete_chessplus_tag_content(newsVo.getNotice_seq());
			if( null != newsVo.getTag_select_type() && newsVo.getTag_select_type().size() > 0 ) {
				Map<String, Object> tag_map = new HashMap<String, Object>();
				List<v2_TagModel> tag_type_list = new ArrayList<v2_TagModel>();
				for(int i = 0; i < newsVo.getTag_select_type().size(); i++) { 
					v2_TagModel tagVo = new v2_TagModel();
					tagVo.setNotice_content_seq(newsVo.getNotice_seq());
					tagVo.setTag_code(newsVo.getTag_select_type().get(i).replaceAll("\\\"", ""));
					tag_type_list.add(tagVo);
				}
				tag_map.put("data", tag_type_list);
				newsDao.insert_chessplus_tag_content(tag_map);
			}
			
			param_rtn_val = 1; 
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;
	}
	
	
	/* 공지사항 삭제 */ 
	public int sv_news_delete(int notice_content_seq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_news_delete(notice_content_seq)");}
		v2_NewsDao newsDao = sqlSessionOracle.getMapper(v2_NewsDao.class); 
		int param_rtn_val = 0;
		try {
			param_rtn_val = newsDao.delete_news(notice_content_seq);
			param_rtn_val = newsDao.delete_news_content(notice_content_seq);
			param_rtn_val = newsDao.delete_tag_content(notice_content_seq);
			
			HttpHeaders headers = new HttpHeaders();
			headers.set("x-event-url", "manage");
			_HttpComponent http = new _HttpComponent();
			String param_type = "notice";
			if(ENCACHE_ABROAD_DEL1 != null && !ENCACHE_ABROAD_DEL1.equals("")){ http.sendGet(ENCACHE_ABROAD_DEL1 +"/"+ param_type, "", headers); }
			if(ENCACHE_ABROAD_DEL2 != null && !ENCACHE_ABROAD_DEL2.equals("")){ http.sendGet(ENCACHE_ABROAD_DEL2 +"/"+ param_type, "", headers); }
			if(ENCACHE_ABROAD_DEL3 != null && !ENCACHE_ABROAD_DEL3.equals("")){ http.sendGet(ENCACHE_ABROAD_DEL3 +"/"+ param_type, "", headers); }

			if(ENCACHE_NEWS_DEL1 != null && !ENCACHE_NEWS_DEL1.equals("")){ http.sendGet(ENCACHE_NEWS_DEL1, "", headers); }
			if(ENCACHE_NEWS_DEL2 != null && !ENCACHE_NEWS_DEL2.equals("")){ http.sendGet(ENCACHE_NEWS_DEL2, "", headers); }
			if(ENCACHE_NEWS_DEL3 != null && !ENCACHE_NEWS_DEL3.equals("")){ http.sendGet(ENCACHE_NEWS_DEL3, "", headers); }
			
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;
	}
	
	/* 공지사항 삭제(학교) */ 
	public int sv_news_chessplus_delete(int notice_content_seq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_news_delete(notice_content_seq)");}
		v2_NewsDao newsDao = sqlSessionOracle.getMapper(v2_NewsDao.class); 
		int param_rtn_val = 0;
		try {
			param_rtn_val = newsDao.delete_news_chessplus(notice_content_seq);
			
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;
	}
	
	/* 태그 목록 전체 불러오기  */
	public List<v2_TagModel> sv_select_tag_list(v2_SearchModel schVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_tag_list(v2_SearchModel)");}
		v2_NewsDao newsDao = sqlSessionOracle.getMapper(v2_NewsDao.class); 
		return newsDao.select_tag_list(schVo);
	}

	/* 태그 목록 - 해당값 선택   */
	public List<String> sv_select_tag_view(int notice_content_seq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_tag_list(v2_SearchModel)");}
		v2_NewsDao newsDao = sqlSessionOracle.getMapper(v2_NewsDao.class); 
		return newsDao.select_tag_view(notice_content_seq);
	}
	
	/* 태그 목록(학교) - 해당값 선택   */
	public List<String> sv_select_chessplus_tag_view(int notice_content_seq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_tag_list(v2_SearchModel)");}
		v2_NewsDao newsDao = sqlSessionOracle.getMapper(v2_NewsDao.class); 
		return newsDao.select_chessplus_tag_view(notice_content_seq);
	}
	
	/* 태그 수정 및 추가입력 */
	public int sv_select_tag_save(v2_TagModel tagVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_tag_save(v2_TagModel)");}
		v2_NewsDao newsDao = sqlSessionOracle.getMapper(v2_NewsDao.class);
		newsDao.update_tag_mainview_change(tagVo);
		if(tagVo.getTag_code().equals("")) {
			return newsDao.insert_tag_save(tagVo);
		}else {
			return newsDao.update_tag_save(tagVo);
		}
	}

	public int sv_select_tag_remove(v2_TagModel tagVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_tag_remove(v2_TagModel)");}
		v2_NewsDao newsDao = sqlSessionOracle.getMapper(v2_NewsDao.class);
		return newsDao.delete_tag_save(tagVo);
	}

	/* IR 게시판 목록 */
	public List<v2_IRModel> sv_select_ir_list(v2_SearchModel schVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_ir_list(v2_SearchModel)");}
		v2_IR_OLD_Dao irDao = sqlSessionOracle.getMapper(v2_IR_OLD_Dao.class); 
		return irDao.select_ir_list(schVo);
	}

	/* IR file 목록 */

	public List<v2_IRFileModel> sv_select_ir_file_list(int ir_board_seq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_ir_file_list(int ir_board_seq)");}
		v2_IR_OLD_Dao irDao = sqlSessionOracle.getMapper(v2_IR_OLD_Dao.class); 
		return irDao.select_ir_file_list(ir_board_seq);		
	}
	
	/* IR 게시판 상세보기 */
	public v2_IRModel sv_select_ir_view(v2_IRModel irVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_ir_view(v2_IRModel)");}
		v2_IR_OLD_Dao irDao = sqlSessionOracle.getMapper(v2_IR_OLD_Dao.class); 
		return irDao.select_ir_view(irVo);
	}
	
	/* IR 게시판 저장 */ 
	public int sv_ir_save(v2_IRModel irVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_ir_save(v2_IRModel)");}
		v2_IR_OLD_Dao irDao = sqlSessionOracle.getMapper(v2_IR_OLD_Dao.class); 
		int param_rtn_val = 0;
		int sel_ir_board_seq = 0;
		v2_IRFileModel fileObj = null;
		try {
			//상태체크
			System.out.println("ir_board_seq ::"+irVo.getIr_board_seq());
			if(irVo.getIr_board_seq() > 0){
				param_rtn_val = irDao.update_ir_board(irVo);				
			}else{
				param_rtn_val = irDao.insert_ir_board(irVo);			
			}
			sel_ir_board_seq = irVo.getIr_board_seq();	
			System.out.println("ir_board_seq::"+irVo.getIr_board_seq());
				
			List<v2_IRFileModel> list = irVo.getFile_list();
			if(list != null && list.size() > 0){
				for (int i = 0; i < list.size(); i++) {
					fileObj = list.get(i);
					if(fileObj.getIr_board_file_seq() > 0){
						irDao.update_ir_board_file(fileObj);
					}else{
						fileObj.setIr_board_seq(sel_ir_board_seq);
						irDao.insert_ir_board_file(fileObj);
					}					
				}
			} 
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;
	}
	
	/* IR 게시판 삭제 */ 
	public int sv_ir_delete(v2_IRFileModel irFielModel) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_ir_delete(irFielModel)");}
		v2_IR_OLD_Dao irDao = sqlSessionOracle.getMapper(v2_IR_OLD_Dao.class); 
		int param_rtn_val = 0;
		try {
			if(irFielModel.getIr_board_seq() > 0){
				param_rtn_val = irDao.delete_ir_board(irFielModel.getIr_board_seq());
				irDao.delete_ir_board_file(irFielModel);
			}else if(irFielModel.getIr_board_seq() == 0 && irFielModel.getIr_board_file_seq() > 0){
				param_rtn_val = irDao.delete_ir_board_file(irFielModel);
			}					
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;
	}
	
	
	public List<v2_DeptModel> select_dept_news_top_list() {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_dept_top_list(v2_DeptModel)");}
		v2_CommonDao commonDao = sqlSessionOracle.getMapper(v2_CommonDao.class); 
		return commonDao.select_dept_news_top_list();
	}
	
	public List<Map<String, Object>> select_dept_combobox_list(Map<String, Object> cookieMap, String menuType) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceImpl] sv_select_dept_top_list(v2_DeptModel)");}
		v2_CommonDao commonDao = sqlSessionOracle.getMapper(v2_CommonDao.class); 
//		return commonDao.select_dept_news_top_list();
		
//		List<v2_DeptModel> reultData = new ArrayList<v2_DeptModel>();
		
		List<Map<String, Object>> result = commonDao.select_dept_combobox_list();
		List<Map<String, Object>> reultData = new ArrayList<Map<String, Object>>();
		
		
		String subMemuData = ((String) cookieMap.get("SUB_MENU")).split(menuType+"=")[1];
		subMemuData = subMemuData.split(" ")[0];	 
		subMemuData = subMemuData.split("}")[0];
		if (result.size() > 0) {
//			for(int i = 0; i < result.size(); i++) {
//				String subMenuSeq = Integer.toString(result.get(i).getDlt_dept_seq());
//				System.out.println(result.get(i));
//				System.out.println(result.get(i).getClass());
//				int dlt_dept_seq = dept.getDlt_dept_seq();
//				String subMenuSeq = Integer.toString(dlt_dept_seq);
//				String SUB_MENU = (String) cookieMap.get("SUB_MENU");
//				if (SUB_MENU.indexOf(subMenuSeq) >= 0) {
//					reultData.add(result.get(i));
//				}
//			}
			for(Map<String, Object> dept : result) {
				String subMenuSeq = dept.get("DLT_DEPT_SEQ").toString();
				System.out.println(subMenuSeq);
				if (subMemuData.indexOf(subMenuSeq) >= 0) {
					reultData.add(dept);
				}
			}
		}
		return reultData;
	}
	
}
