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
import com.gojls.manage.common.dao.AdDao;
import com.gojls.manage.common.dao.DeptDao;
import com.gojls.manage.common.dao.NewsDao;
import com.gojls.manage.common.dao.TagDao;
import com.gojls.manage.common.dao.UnioneDao;
import com.gojls.manage.common.model.AdModel;
import com.gojls.manage.common.model.DeptModel;
import com.gojls.manage.common.model.NewsModel;
import com.gojls.manage.common.model.ScheduleLogModel;
import com.gojls.manage.common.model.SearchModel;
import com.gojls.manage.common.model.TagModel;
import com.gojls.manage.common.model.UnioneDeptModel;
import com.gojls.util._Request;

import net.sf.json.JSONObject;

@Service
public class CommonServiceImpl implements CommonService {
	
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
	
	@Autowired 
	@Qualifier("oracle")
	private SqlSession sqlSessionOracle;

	public Map<String, Object> selectNewsList(SearchModel searchVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] selectNewsList(newsVo)");}
		NewsDao newsDao = sqlSessionOracle.getMapper(NewsDao.class); 
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<NewsModel> newsList = newsDao.selectNewsList(searchVo);
			System.out.println(">>"+ newsList.size());
			if(newsList != null) {
				resultMap.put("Result", "OK");
				resultMap.put("TotalRecordCount", newsDao.selectNewsListCnt(searchVo));
				resultMap.put("Records", newsList);
			}else {
				resultMap.put("Result", "ERROR");
				resultMap.put("Message", "조건에 맞는 데이터가 없습니다.");
			}
		}catch(Exception ex) {
			System.out.println(ex);
			resultMap.put("Result", "ERROR");
			resultMap.put("Message", "데이터를 불러오는데 오류가 발생했습니다.");
		}
		return resultMap;
	}

	public List<TagModel> selectGetCodeTag() {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] selectGetCodeTag()");}
		NewsDao newsDao = sqlSessionOracle.getMapper(NewsDao.class); 
		return newsDao.selectNewsTag();
	}

	public List<DeptModel> selectGetCodeDept() {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] selectGetCodeDept()");}
		DeptDao deptDao = sqlSessionOracle.getMapper(DeptDao.class); 
		return deptDao.selectDeptList();
	}
	
	public List<AdModel> selectGetCodeAd(String ad_code) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] selectGetCodeAd(ad_code)");}
		AdDao adDao = sqlSessionOracle.getMapper(AdDao.class); 
		return adDao.selectAdCode(ad_code);
	}

	public List<AdModel> selectGetCodeAdSub(String ad_code) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] selectGetCodeAdSub(ad_code)");}
		AdDao adDao = sqlSessionOracle.getMapper(AdDao.class); 
		return adDao.selectAdSubCode(ad_code);
	}
	
	public List<DeptModel> selectGetCodeCourse() {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] selectGetCodeCourse()");}
		UnioneDao unioneDao = sqlSessionOracle.getMapper(UnioneDao.class); 
		return unioneDao.selectCourseCode();
	}

	public List<DeptModel> selectGetCodeCourseDept(String courseSeq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] selectGetCodeCourseDept()");}
		UnioneDao unioneDao = sqlSessionOracle.getMapper(UnioneDao.class); 
		return unioneDao.selectDeptCode(courseSeq);
	}
	
	public NewsModel selectNewsView(int param_seq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] selectNewsView("+ param_seq +")");}
		NewsDao newsDao = sqlSessionOracle.getMapper(NewsDao.class); 
		return newsDao.selectNewsView(param_seq);
	}

	public List<TagModel> selectTagView(int param_contnt_seq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] selectTagView("+ param_contnt_seq +")");}
		NewsDao newsDao = sqlSessionOracle.getMapper(NewsDao.class); 
		return newsDao.selectNewsTagView(param_contnt_seq);
	}

	public Map<String, Object> setNewsSave(NewsModel newsVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] setNewsSave(newsVo)");}
		NewsDao newsDao = sqlSessionOracle.getMapper(NewsDao.class); 
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			System.out.println(JSONObject.fromObject(newsVo).toString());
			if(newsVo.getNoticeSeq() > 0) { // 수정작업 
				newsDao.upNewsContnt(newsVo);
				newsDao.upNews(newsVo);
			}else { //신규생성 
				newsDao.insNewsContnt(newsVo);
				newsDao.insNews(newsVo);
			}
			
			if(!newsVo.getTaglist().equals("")) {
				Map<String, Object> tagMap = new HashMap<String, Object>();
				List<TagModel> tagVoList = new ArrayList<TagModel>();
				String[] frm_tag_list_sp = newsVo.getTaglist().split(",");
				for(int i = 0; i < frm_tag_list_sp.length; i++) {
					TagModel tagVo = new TagModel();
					tagVo.setBranchContentSeq(newsVo.getNoticeContntSeq());
					tagVo.setTagCode(frm_tag_list_sp[i].split(":")[0]);
					tagVoList.add(tagVo);
				}
				tagMap.put("data", tagVoList);
				newsDao.delTagContnt(newsVo.getNoticeContntSeq());
				newsDao.insTagContnt(tagMap);
			}
			
			//대표홈 소식지 캐쉬 삭제
			HttpHeaders headers = new HttpHeaders();
			headers.set("x-event-url", "manage");
			_HttpComponent http = new _HttpComponent();
			if(ENCACHE_NEWS_DEL1 != null && !ENCACHE_NEWS_DEL1.equals("")){ http.sendGet(ENCACHE_NEWS_DEL1, "", headers); }
			if(ENCACHE_NEWS_DEL2 != null && !ENCACHE_NEWS_DEL2.equals("")){ http.sendGet(ENCACHE_NEWS_DEL2, "", headers); }
			if(ENCACHE_NEWS_DEL3 != null && !ENCACHE_NEWS_DEL3.equals("")){ http.sendGet(ENCACHE_NEWS_DEL3, "", headers); }
			
			resultMap = _Request.setResult("success", "", null);
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly(); 
			resultMap = _Request.setResult("error", ex.getMessage(), null);
		}
		return resultMap;
	}

	public Map<String, Object> selectTagList(SearchModel searchVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] selectTagList(searchVo)");}
		TagDao tagDao = sqlSessionOracle.getMapper(TagDao.class); 
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<TagModel> tagList = tagDao.selectTagList(searchVo);
			if(tagList != null) {
				resultMap.put("Result", "OK");
				resultMap.put("TotalRecordCount", tagDao.selectTagListCnt(searchVo));
				resultMap.put("Records", tagList);
			}else {
				resultMap.put("Result", "ERROR");
				resultMap.put("Message", "데이터를 불러오는데 오류가 발생했습니다.");
			}
		}catch(Exception ex) {
			resultMap.put("Result", "ERROR");
			resultMap.put("Message", "데이터를 불러오는데 오류가 발생했습니다.");
		}
		return resultMap;
	}

	public Map<String, Object> setTagSave(TagModel tagVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] setTagSave(tagVo)");}
		TagDao tagDao = sqlSessionOracle.getMapper(TagDao.class); 
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			System.out.println(JSONObject.fromObject(tagVo).toString());
			
			// 검수후 저장 동일태그명
			int checkInt = tagDao.selectTagCheck(tagVo);
			if(checkInt == 0) {
				if(tagVo.getBranchTagSeq() > 0) { // 수정작업시 
					tagDao.upTag(tagVo);
				}else { //신규생성
					tagDao.insTag(tagVo);
				}
				resultMap = _Request.setResult("success", "", null);
			} else {
				resultMap = _Request.setResult("error", "기존에 태그가 있습니다.", null);
			}
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly(); 
			resultMap = _Request.setResult("error", ex.getMessage(), null);
		}
		return resultMap;
	}

	public List<TagModel> getTagMainView() {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] getTagMainView()");}
		TagDao tagDao = sqlSessionOracle.getMapper(TagDao.class); 
		return tagDao.selectTagMainView();
	}

	public Map<String, Object> selectAdList(SearchModel searchVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] selectAdList(searchVo)");}
		AdDao adDao = sqlSessionOracle.getMapper(AdDao.class); 
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<AdModel> adList = adDao.selectAdList(searchVo);
			if(adList != null) {
				resultMap.put("Result", "OK");
				resultMap.put("TotalRecordCount", adDao.selectAdListCnt(searchVo));
				resultMap.put("Records", adList);
			}else {
				resultMap.put("Result", "ERROR");
				resultMap.put("Message", "데이터를 불러오는데 오류가 발생했습니다.");
			}
		}catch(Exception ex) {
			resultMap.put("Result", "ERROR");
			resultMap.put("Message", "데이터를 불러오는데 오류가 발생했습니다.");
		}
		return resultMap;
	}
	
	public Map<String, Object> selectDirectList(SearchModel searchVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] selectDirectList(searchVo)");}
		AdDao adDao = sqlSessionOracle.getMapper(AdDao.class); 
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<AdModel> directList = adDao.selectDirectList(searchVo);
			if(directList != null) {
				resultMap.put("Result", "OK");
				resultMap.put("TotalRecordCount", adDao.selectDirectListCnt(searchVo));
				resultMap.put("Records", directList);
			}else {
				resultMap.put("Result", "ERROR");
				resultMap.put("Message", "데이터를 불러오는데 오류가 발생했습니다.");
			}
		}catch(Exception ex) {
			resultMap.put("Result", "ERROR");
			resultMap.put("Message", "데이터를 불러오는데 오류가 발생했습니다.");
		}
		return resultMap;
	}
	

	public Map<String, Object> setAdSave(AdModel adVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] setAdSave(newsVo)");}
		AdDao adDao = sqlSessionOracle.getMapper(AdDao.class); 
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			System.out.println(JSONObject.fromObject(adVo).toString());
			Boolean param_save_fl = false;
			if(adVo.getBannerSeq() > 0) { // 수정작업 
				adDao.upAd(adVo);
				param_save_fl = true;
			}else { //신규생성 
				if(adDao.checkAd(adVo) == 0) {
					adDao.inAd(adVo);
					param_save_fl = true;
				}
			}
			
			if(param_save_fl) {
				/* 대표홈 배너 캐쉬 삭제 */
				HttpHeaders headers = new HttpHeaders();
				headers.set("x-event-url", "manage");
				_HttpComponent http = new _HttpComponent();
				if(ENCACHE_AD_DEL1 != null && !ENCACHE_AD_DEL1.equals("")){ http.sendGet(ENCACHE_AD_DEL1, "", headers); }
				if(ENCACHE_AD_DEL2 != null && !ENCACHE_AD_DEL2.equals("")){ http.sendGet(ENCACHE_AD_DEL2, "", headers); }
				if(ENCACHE_AD_DEL3 != null && !ENCACHE_AD_DEL3.equals("")){ http.sendGet(ENCACHE_AD_DEL3, "", headers); }
				resultMap = _Request.setResult("success", "", null);
			}else {
				resultMap = _Request.setResult("error", "이미 등록된 데이터가 있습니다.(게시기간 체크) ", null);
			}
			
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly(); 
			resultMap = _Request.setResult("error", ex.getMessage(), null);
		}
		return resultMap;
	}

	public AdModel selectAdView(int param_seq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] selectAdView("+ param_seq +")");}
		AdDao adDao = sqlSessionOracle.getMapper(AdDao.class); 
		return adDao.selectAdView(param_seq);
	}

	/* 유니원 관련 */
	public Map<String, Object> selectUnioneSyncList(SearchModel searchVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] selectUnioneSyncList(searchVo)");}
		UnioneDao unioneDao = sqlSessionOracle.getMapper(UnioneDao.class); 
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<DeptModel> deptList = unioneDao.selectUnioneSyncList(searchVo);
			if(deptList != null) {
				resultMap.put("Result", "OK");
				resultMap.put("TotalRecordCount", unioneDao.selectUnioneSyncListCnt(searchVo));
				resultMap.put("Records", deptList);
			}else {
				resultMap.put("Result", "ERROR");
				resultMap.put("Message", "데이터를 불러오는데 오류가 발생했습니다.");
			}
		}catch(Exception ex) {
			resultMap.put("Result", "ERROR");
			resultMap.put("Message", "데이터를 불러오는데 오류가 발생했습니다.");
		}
		return resultMap;
	}

	public Map<String, Object> setUnioneSync(UnioneDeptModel unioneVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] selectUnioneSyncList(searchVo)");}
		UnioneDao unioneDao = sqlSessionOracle.getMapper(UnioneDao.class); 
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			String[] deptlistSp = unioneVo.getSyncDept().split(",");
			ArrayList<Long> deptlist = new ArrayList<Long>();
			unioneVo.setGojlsurl(QUEUE_GOJLS_URL.toString());
			
			for(int i=0; i < deptlistSp.length; i++) { 	deptlist.add(Long.parseLong(deptlistSp[i].toString())); }
			unioneVo.setDeptlist(deptlist);
			List<UnioneDeptModel> deptVoList = unioneDao.selectDeptList(unioneVo);
			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("deptList", deptVoList);
			
			JSONObject jsonObj = new JSONObject();
			jsonObj.putAll(dataMap);
			
			// API 전달 QUEUE_UNIONE_SYNC , QUEUE_AUTH_KEY
			byte[] bytesEncoded = Base64.encodeBase64(QUEUE_AUTH_KEY.getBytes());
			StringBuffer sb = new StringBuffer();
			String authKey = sb.append(new String(bytesEncoded)).toString();
			System.out.println(authKey);
			
			HttpHeaders headers = new HttpHeaders();
			headers.set("X-JLS-Event", unioneVo.getSyncCode());
			headers.set("Authorization", "Basic ".concat(authKey));
			headers.set("Accept-Charset", "UTF-8");
			headers.set("Content-Type", "application/json");
			_HttpComponent http = new _HttpComponent();
			String[] rtnData = http.sendPut(QUEUE_UNIONE_SYNC, jsonObj.get("deptList").toString(), headers);
			
			System.out.println(rtnData[0] +","+ rtnData[1]);
			
			ScheduleLogModel schVo = new ScheduleLogModel();
			schVo.setPartnerNm("Unione");
			schVo.setEventCode(unioneVo.getSyncCode());
			schVo.setEventSubCode("");
			schVo.setTranType("O");
			if(rtnData[0].equals("200")) {
				schVo.setTranResult("Y");
				schVo.setTranMsg("Success");
				
				UnioneDeptModel uniVo = new UnioneDeptModel();
				uniVo.setCorpNm("Unione");
				if(unioneVo.getSyncCode().equals("API-DEPT_MOD")) { 
					uniVo.setStatus("2");
				}else {
					uniVo.setStatus("0");
				}
				uniVo.setRegUserSeq(unioneVo.getRegUserSeq());
				uniVo.setRegUserId(unioneVo.getRegUserId());
				uniVo.setRegUserNm(unioneVo.getRegUserNm());
				for(int i=0; i < unioneVo.getDeptlist().size(); i++){
					uniVo.setDeptSeq(Integer.parseInt(unioneVo.getDeptlist().get(i).toString()));
					unioneDao.margeDeptApi(uniVo);
					
					schVo.setTranSeq(unioneVo.getDeptlist().get(i).toString());
					unioneDao.insertScheduleLog(schVo);
				}
				resultMap = _Request.setResult("success", "", null);
			}else {
				schVo.setTranResult("N");
				schVo.setTranMsg("Http Connection fail Code : " + rtnData[1]);
				for(int i=0; i < unioneVo.getDeptlist().size(); i++){
					schVo.setTranSeq(unioneVo.getDeptlist().get(i).toString());
					unioneDao.insertScheduleLog(schVo);
				}
				resultMap = _Request.setResult("error", "API 연결에러발생", null);
			}
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly(); 
			resultMap = _Request.setResult("error", ex.getMessage(), null);
		}
		return resultMap;
	}

	public List<DeptModel> selectGetCodeDeptTop() {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] selectGetCodeDeptTop()");}
		DeptDao deptDao = sqlSessionOracle.getMapper(DeptDao.class); 
		return deptDao.selectDeptTopList();
	}

	public List<DeptModel> selectGetCodeDeptSec(int parentDeptSeq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonServiceImpl] selectGetCodeDeptSec("+ parentDeptSeq +")");}
		DeptDao deptDao = sqlSessionOracle.getMapper(DeptDao.class); 
		return deptDao.selectDeptSecList(parentDeptSeq);
	}
}
