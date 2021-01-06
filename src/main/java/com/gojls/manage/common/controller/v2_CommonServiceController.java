package com.gojls.manage.common.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.gojls.manage.common.model.v2_BannerModel;
import com.gojls.manage.common.model.v2_DeptModel;
import com.gojls.manage.common.model.v2_IRFileModel;
import com.gojls.manage.common.model.v2_IRModel;
import com.gojls.manage.common.model.v2_NewsModel;
import com.gojls.manage.common.model.v2_SearchModel;
import com.gojls.manage.common.model.v2_SiteFileModel;
import com.gojls.manage.common.model.v2_SyncModel;
import com.gojls.manage.common.model.v2_TagModel;
import com.gojls.manage.common.service.v2_CommonService;
import com.gojls.util._Cookie;
import com.gojls.util._Request;
import com.gojls.util._Response;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@RestController
@RequestMapping ("/service/v2")
public class v2_CommonServiceController extends BaseController{
	@Autowired v2_CommonService v2_commonService;
	
	@Value("#{globalContext['ABROAD_CODE']?:''}") private String ABROAD_CODE;
	@Value("#{globalContext['ABROAD_NM']?:''}") private String ABROAD_NM;
	@Value("#{globalContext['ABROAD_LIST']?:''}") private String ABROAD_LIST;
	@Value("#{globalContext['COOKIE_NAME']?:'jlsadm'}") private String COOKIE_NAME;
	
	String[] cookieData ;
	Object cookieObj ;
	Map<String, Object> cookieMap ;
	/* 분원/코스 목록  */
	@RequestMapping(value="/dept/{param_type}", method=RequestMethod.GET)
	public void get_dept_list(HttpServletRequest req, HttpServletResponse res, @PathVariable String param_type) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] get_dept_list");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		
		cookieData = _Cookie.getTokenData(req, _Cookie.getCookieStr(req.getCookies(), COOKIE_NAME));
		cookieObj = JSONObject.fromObject(cookieData[1]);
		cookieMap = _Response.formatJsonToMap(cookieObj);
		
		try{
			if(param_type.equals("top")) {
				v2_DeptModel deptVo = new v2_DeptModel();
				deptVo.setDlt_abroad_seq(Integer.parseInt(ABROAD_CODE));
				deptVo.setDlt_abroad_nm(ABROAD_NM);
				System.out.println("EMP_NM : " + cookieMap.get("EMP_NM"));
				result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_dept_top_list(deptVo)).toString());
			}else if(param_type.equals("course")) {
				result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_dept_course_list()).toString());
			}else if(param_type.equals("abroad")) {
				List<String> param_dept_arr = Arrays.asList(ABROAD_LIST.split(","));
				v2_SearchModel searchVo = new v2_SearchModel();
				searchVo.setSearch_dept_arr(param_dept_arr);
				result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_dept_abroad_list(searchVo)).toString());
			}else if(param_type.equals("user")) {
				List<String> param_dept_arr = Arrays.asList(ABROAD_LIST.split(","));
				v2_SearchModel searchVo = new v2_SearchModel();
				searchVo.setSearch_dept_arr(param_dept_arr);
				result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_dept_abroad_user(searchVo)).toString());
			}
//			else if(param_type.equals("news")) {
//				result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.select_dept_news_top_list()).toString());
//				System.out.println(cookieMap);
//			}
			else if("news banner faq".indexOf(param_type) >= 0 ) {
				result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.select_dept_combobox_list(cookieMap, param_type)).toString());
			}
			else {
				result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_dept_sub_list(Integer.parseInt(param_type))).toString());
			}
			
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}

	/* 태그 목록  */
	@RequestMapping(value="/tag/{param_type}", method=RequestMethod.GET)
	public void get_tag_view_list(HttpServletRequest req, HttpServletResponse res, @PathVariable String param_type) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] get_tag_view_list");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			if(param_type.equals("main")) {
				result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_tag_view_list()).toString());
			}else {
				result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_tag_box_list()).toString());
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* 배너 목록  */
	@RequestMapping(value="/banner/list", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void get_banner_list(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] get_banner_list");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			
			v2_SearchModel schVo = new v2_SearchModel();
			schVo.setSearch_emp_type(obj_body.get("search_emp_type").toString());
			schVo.setSearch_context(obj_body.get("search_context").toString());
			schVo.setSearch_dept(obj_body.get("search_dept").toString());
			if(obj_body.get("search_emp_type").toString().equals("B")) { schVo.setSearch_dept_arr(Arrays.asList(obj_body.get("search_dept_arr").toString().split(","))); }
			schVo.setSearch_status(Arrays.asList(obj_body.get("search_status").toString().split(",")));
			schVo.setSearch_type(Arrays.asList(obj_body.get("search_type").toString().split(",")));
			schVo.setPage_size(Integer.parseInt(obj_body.getString("page_size")));
			schVo.setPage_start_num(Integer.parseInt(obj_body.getString("page_start_num")));
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_banner_list(schVo)).toString());
			
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* 배너 저장 */
	@RequestMapping(value="/banner/save", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void set_banner_save(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] set_banner_save");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));

			String param_link_url = obj_body.getString("param_link_url");
			if(param_link_url.indexOf("?") > -1) {
				if(param_link_url.indexOf("from=") < 0) { 
					param_link_url = param_link_url +"&from="+ obj_body.getString("param_google_code"); 
				}
			}else {
				param_link_url = param_link_url +"?from="+ obj_body.getString("param_google_code");
			}
			
			int param_link_target_fl = (obj_body.getBoolean("param_link_target_fl")) ? 1 : 0 ;
			v2_BannerModel bannerVo = new v2_BannerModel();
			bannerVo.setGt_banner_loc(obj_body.getString("param_gt_code"));
			bannerVo.setGt_banner_type(obj_body.getString("param_sort_gt_code"));
			bannerVo.setDept_seq(obj_body.getInt("param_dept_seq"));
			bannerVo.setTitle(obj_body.getString("param_title"));
			bannerVo.setBanner_img_path(obj_body.getString("param_img_url"));
			bannerVo.setMobi_banner_img_path(obj_body.getString("param_mobi_img_url"));
			bannerVo.setLink_url(param_link_url);
			bannerVo.setLink_target_fl(param_link_target_fl);
			bannerVo.setStart_dt(obj_body.getString("param_start_dt"));
			bannerVo.setEnd_dt(obj_body.getString("param_end_dt"));
			bannerVo.setReg_user_nm(req.getAttribute("cookieEmpNm").toString());
			bannerVo.setReg_user_seq(req.getAttribute("cookieEmpSeq").toString());
			bannerVo.setInup_type(obj_body.getString("param_inup_type"));
			if(!obj_body.getString("param_banner_seq").equals("")) { bannerVo.setBanner_seq(obj_body.getInt("param_banner_seq")); } 
			
			int param_rtn_val = v2_commonService.sv_banner_save(bannerVo);
			if(param_rtn_val == 1) {
				result_map = _Request.setResult("success", "", "");
			}else if(param_rtn_val == 99) {
				result_map = _Request.setResult("error", "해당 항목에 날짜가 중복된 게시물이 있습니다.", null);
			}else {
				result_map = _Request.setResult("error", "저장오류가 발생했습니다.", null);
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "저장오류가 발생했습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* 배너 삭제 */
	@RequestMapping(value="/banner/delete/{banner_seq}", method=RequestMethod.GET)
	public void set_banner_delete(HttpServletRequest req, HttpServletResponse res, @PathVariable int banner_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] set_banner_delete");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			v2_BannerModel bannerVo = new v2_BannerModel();
			bannerVo.setBanner_seq(banner_seq);
			
			int param_rtn_val = v2_commonService.sv_banner_delete(bannerVo);
			if(param_rtn_val == 1) {
				result_map = _Request.setResult("success", "", "");
			}else {
				result_map = _Request.setResult("error", "저장오류가 발생했습니다.", null);
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "저장오류가 발생했습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}	
	
	/* 싱크 목록 */
	@RequestMapping(value="/sync/list", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void get_sync_list(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] get_sync_list");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			
			v2_SearchModel schVo = new v2_SearchModel();
			schVo.setSearch_context(obj_body.get("search_context").toString());
			schVo.setSearch_type(Arrays.asList(obj_body.get("search_type").toString().split(",")));
			schVo.setPage_size(Integer.parseInt(obj_body.getString("page_size")));
			schVo.setPage_start_num(Integer.parseInt(obj_body.getString("page_start_num")));
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_sync_list(schVo)).toString());
			
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* 싱크 저장 */
	@RequestMapping(value="/sync/exec", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void get_sync_exec(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] get_sync_exec");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			
			String[] param_dept_list_spt = obj_body.get("sync_dept_list").toString().split(",");
			
			ArrayList<Long> param_dept_list_arr = new ArrayList<Long>();
			for(int i=0; i < param_dept_list_spt.length; i++) {	param_dept_list_arr.add(Long.parseLong(param_dept_list_spt[i].toString().split(":")[1])); }
			String param_sync_type = (param_dept_list_spt[0].toString().split(":")[0].equals("1")) ? "API-DEPT_MOD" : "API-DEPT_ADD";
			
			
			v2_SyncModel sync_vo = new v2_SyncModel();
			sync_vo.setParam_sync_type(param_sync_type);
			sync_vo.setParam_dept_arr(param_dept_list_arr);
			sync_vo.setReg_user_seq(req.getAttribute("cookieEmpSeq").toString());
			sync_vo.setReg_user_id(req.getAttribute("cookieEmpId").toString());
			sync_vo.setReg_user_nm(req.getAttribute("cookieEmpNm").toString());
			result_map = _Request.setResult("success", "", String.valueOf(v2_commonService.sv_exec_sync(sync_vo)));
			
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}

	/* 공지사항 목록  */
	@RequestMapping(value="/news/list", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void get_news_list(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] get_news_list");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			
			v2_SearchModel schVo = new v2_SearchModel();
			schVo.setSearch_emp_type(obj_body.get("search_emp_type").toString());
			schVo.setSearch_context(obj_body.get("search_context").toString());
			schVo.setSearch_dept(obj_body.get("search_dept").toString());
			if(obj_body.get("search_emp_type").toString().equals("B")) { 
				schVo.setSearch_dept_arr(Arrays.asList(obj_body.get("search_dept_arr").toString().split(","))); 
			}
//			if (schVo.getSearch_dept_arr() == null || schVo.getSearch_dept_arr().size() == 0 ) {
//				String subMemuData = ((String) cookieMap.get("SUB_MENU")).split("news=")[1];
//				subMemuData = subMemuData.split(" ")[0];	 
//				subMemuData = subMemuData.split("}")[0];
//				schVo.setSearch_dept_arr(Arrays.asList(subMemuData.split(","))); 
//			}
			schVo.setSearch_status(Arrays.asList(obj_body.get("search_status").toString().split(",")));
			schVo.setSearch_type(Arrays.asList(obj_body.get("search_type").toString().split(",")));
			if(!obj_body.get("search_tag").toString().equals("")) {
				schVo.setSearch_tag(Arrays.asList(obj_body.get("search_tag").toString().split(",")));
			}
			schVo.setSearch_start_dt(obj_body.get("search_start_dt").toString());
			schVo.setSearch_end_dt(obj_body.get("search_end_dt").toString());
			schVo.setPage_size(Integer.parseInt(obj_body.getString("page_size")));
			schVo.setPage_start_num(Integer.parseInt(obj_body.getString("page_start_num")));
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_news_list(schVo)).toString());
			
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}

	/* 공지사항 상세보기 */
	@RequestMapping(value="/news/view/{notice_seq}/{notice_content_seq}/{dept_nm}", method=RequestMethod.GET)
	public void get_news_view(HttpServletRequest req, HttpServletResponse res, @PathVariable int notice_seq, @PathVariable int notice_content_seq, @PathVariable String dept_nm) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] get_news_view");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try {
			if ( "학교".equals(dept_nm)) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("notice_seq", notice_seq);
				result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_news_chessplus_view(param)).toString());
			}else {
				v2_NewsModel newsVo = new v2_NewsModel();
				newsVo.setNotice_seq(notice_seq);
				newsVo.setNotice_content_seq(notice_content_seq);
				result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_news_view(newsVo)).toString());
			}
			
		}catch(Exception ex) {
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* 공지사항 저장 */
	@RequestMapping(value="/news/save", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void set_news_save(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] set_news_save");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));

			v2_NewsModel newsVo = new v2_NewsModel();
			if(!obj_body.getString("param_news_seq").equals("")) { newsVo.setNotice_seq(obj_body.getInt("param_news_seq")); }
			if(!obj_body.getString("param_news_content_seq").equals("")) { newsVo.setNotice_content_seq(obj_body.getInt("param_news_content_seq")); }
			newsVo.setInup_type(obj_body.getString("param_inup_type"));
			newsVo.setNotice_type(obj_body.getInt("param_notice_type"));
			newsVo.setDept_seq(obj_body.getInt("param_dept_seq"));
			newsVo.setTitle(obj_body.getString("param_title"));
			newsVo.setNews_img_thumb(obj_body.getString("param_img_url"));
			newsVo.setStart_dt(obj_body.getString("param_start_dt"));
			newsVo.setEnd_dt(obj_body.getString("param_end_dt"));
			newsVo.setPreview_txt(obj_body.getString("param_preview_txt"));
			newsVo.setEditor_txt(obj_body.getString("param_editor_text"));
			newsVo.setReg_user_nm(req.getAttribute("cookieEmpNm").toString());
			newsVo.setReg_user_seq(req.getAttribute("cookieEmpSeq").toString());
			String param_tag_list = obj_body.get("param_tag_list").toString().replaceAll("\\[", "").replaceAll("\\]", "").replaceAll("\\\"","");
			if(!param_tag_list.equals("")) { newsVo.setTag_select_type(Arrays.asList(param_tag_list.split(","))); }
			
			int param_rtn_val = v2_commonService.sv_news_save(newsVo);
			if(param_rtn_val == 1) {
				result_map = _Request.setResult("success", "", "");
			}else {
				result_map = _Request.setResult("error", "저장오류가 발생했습니다.", null);
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "저장오류가 발생했습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* 공지사항 저장(학교) */
	@RequestMapping(value="/news/chessplusSave", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void set_news_chessplus_save(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] set_news_save");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));

			v2_NewsModel newsVo = new v2_NewsModel();
			if(!obj_body.getString("param_news_seq").equals("")) { newsVo.setNotice_seq(obj_body.getInt("param_news_seq")); }
			if(!obj_body.getString("param_news_content_seq").equals("")) { newsVo.setNotice_content_seq(obj_body.getInt("param_news_content_seq")); }
			newsVo.setInup_type(obj_body.getString("param_inup_type"));
			newsVo.setNotice_type(obj_body.getInt("param_notice_type"));
			newsVo.setDept_seq(obj_body.getInt("param_dept_seq"));
			newsVo.setTitle(obj_body.getString("param_title"));
			newsVo.setNews_img_thumb(obj_body.getString("param_img_url"));
			newsVo.setStart_dt(obj_body.getString("param_start_dt"));
			newsVo.setEnd_dt(obj_body.getString("param_end_dt"));
			newsVo.setPreview_txt(obj_body.getString("param_preview_txt"));
			newsVo.setEditor_txt(obj_body.getString("param_editor_text"));
			newsVo.setReg_user_nm(req.getAttribute("cookieEmpNm").toString());
			newsVo.setReg_user_seq(req.getAttribute("cookieEmpSeq").toString());
			newsVo.setUse_status(obj_body.getInt("use_status"));
			
			String param_tag_list = obj_body.get("param_tag_list").toString().replaceAll("\\[", "").replaceAll("\\]", "").replaceAll("\\\"","");
			if(!param_tag_list.equals("")) { newsVo.setTag_select_type(Arrays.asList(param_tag_list.split(","))); }
			
			int param_rtn_val = v2_commonService.sv_news_chessplus_save(newsVo);
			if(param_rtn_val == 1) {
				result_map = _Request.setResult("success", "", "");
			}else {
				result_map = _Request.setResult("error", "저장오류가 발생했습니다.", null);
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "저장오류가 발생했습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	
	/* 공지사항 삭제 */
	@RequestMapping(value="/news/del/{notice_content_seq}/{dept_nm}", method=RequestMethod.DELETE)
	public void set_news_delete(HttpServletRequest req, HttpServletResponse res, @PathVariable int notice_content_seq, @PathVariable String dept_nm) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] set_news_delete");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			
			int param_rtn_val = 0; 
			if ( "학교".equals(dept_nm)) {
				param_rtn_val = v2_commonService.sv_news_chessplus_delete(notice_content_seq);
			}else {
				param_rtn_val = v2_commonService.sv_news_delete(notice_content_seq);
			}
			
			if(param_rtn_val > 0) {
				result_map = _Request.setResult("success", "", "");
			}else {
				result_map = _Request.setResult("error", "저장오류가 발생했습니다.", null);
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "저장오류가 발생했습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}	
	
	/* 태그 목록  */
	@RequestMapping(value="/tag/list", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void get_tag_list(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] get_tag_list");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			
			v2_SearchModel schVo = new v2_SearchModel();
			schVo.setSearch_context(obj_body.get("search_context").toString());
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_tag_list(schVo)).toString());
			
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* 태그 가져오기   */
	@RequestMapping(value="/tag/view/{notice_content_seq}/{dept_nm}", method=RequestMethod.GET)
	public void get_tag_view(HttpServletRequest req, HttpServletResponse res, @PathVariable int notice_content_seq, @PathVariable String dept_nm) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] get_tag_view");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			if ( "학교".equals(dept_nm)) {
				result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_chessplus_tag_view(notice_content_seq)).toString());
			}else {
				result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_tag_view(notice_content_seq)).toString());
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}

	/* 태그 저장 */
	@RequestMapping(value="/tag/save", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void get_tag_save(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] get_tag_save");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			
			v2_TagModel tagVo = new v2_TagModel();
			tagVo.setTag_code(obj_body.getString("tag_code"));
			tagVo.setTag_nm(obj_body.getString("tag_nm"));
			tagVo.setMain_view_yn(obj_body.getInt("main_view_yn"));
			tagVo.setView_yn(obj_body.getInt("view_yn"));
			tagVo.setReg_user_nm(req.getAttribute("cookieEmpNm").toString());
			tagVo.setReg_user_seq(req.getAttribute("cookieEmpSeq").toString());

			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_tag_save(tagVo)).toString());
			
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}

	/* 태그 저장 */
	@RequestMapping(value="/tag/remove", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void get_tag_remove(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] get_tag_remove");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			
			v2_TagModel tagVo = new v2_TagModel();
			tagVo.setTag_code(obj_body.getString("tag_code"));

			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_tag_remove(tagVo)).toString());
			
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* get form data and object post data  */
	@SuppressWarnings("unused")
	private Map<String, Object> get_object_param_data(HttpServletRequest req) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] get_object_param_data");	}
		Map<String, Object> req_param = new HashMap<String, Object>();
		try{
			String reqdata = _Request.getBody(req);
			System.out.println(reqdata);
			String[] req_parameter = reqdata.split("\\&",-1);
			for(int i=0; i < req_parameter.length; i++) {
				String[] req_param_data = req_parameter[i].split("\\=",-1);
				if(req_param_data[1] != null) {
					req_param.put(req_param_data[0], req_param_data[1]);
				}
			}
		}catch(Exception ex) {
			logger.error(">> get_object_param_data ERROR : "+ ex);
		}
		return req_param;
	}
	
	/* 분원 리스트  */
	@RequestMapping(value="/dept/list", method=RequestMethod.GET)
	public void get_dept_list(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] get_dept_list");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_dept_list()).toString());
			
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	


	/* IR 게시판 목록  */
	@RequestMapping(value="/ir/list", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void get_ir_list(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] get_ir_list");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			
			v2_SearchModel schVo = new v2_SearchModel();
			schVo.setSearch_context(obj_body.get("search_context").toString());
			schVo.setSearch_type(Arrays.asList(obj_body.get("search_type").toString().split(",")));
			schVo.setSearch_start_dt(obj_body.get("search_start_dt").toString());
			schVo.setSearch_end_dt(obj_body.get("search_end_dt").toString());
			schVo.setPage_size(Integer.parseInt(obj_body.getString("page_size")));
			schVo.setPage_start_num(Integer.parseInt(obj_body.getString("page_start_num")));
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_ir_list(schVo)).toString());
			
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* IR FILE LIST */
	@RequestMapping(value="/ir/file/list/{ir_board_seq}", method=RequestMethod.GET)
	public void get_ir_file_list(HttpServletRequest req, HttpServletResponse res, @PathVariable int ir_board_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] get_ir_file_list");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try {			
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_ir_file_list(ir_board_seq)).toString());
		}catch(Exception ex) {
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}

	/* IR 게시판 상세보기 */
	@RequestMapping(value="/ir/view/{ir_board_seq}", method=RequestMethod.GET)
	public void get_ir_view(HttpServletRequest req, HttpServletResponse res, @PathVariable int ir_board_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] get_ir_view");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try {
			v2_IRModel irVo = new v2_IRModel();
			irVo.setIr_board_seq(ir_board_seq);
			
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_commonService.sv_select_ir_view(irVo)).toString());
		}catch(Exception ex) {
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* IR 게시판 저장 */
	@RequestMapping(value="/ir/save", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void set_ir_save(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] set_ir_save");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			v2_IRModel irVo = new v2_IRModel();
			if(!obj_body.getString("param_ir_board_seq").equals("")) { irVo.setIr_board_seq(obj_body.getInt("param_ir_board_seq")); }
			irVo.setIr_type(obj_body.getString("param_ir_type"));
			irVo.setTitle(obj_body.getString("param_title"));
			irVo.setUse_yn(obj_body.getInt("param_use_yn"));
			irVo.setView_start_dt(obj_body.getString("param_view_start_dt"));
			irVo.setEditor_txt(obj_body.getString("param_editor_text"));
			irVo.setReg_user_nm(req.getAttribute("cookieEmpNm").toString());
			irVo.setReg_user_seq(req.getAttribute("cookieEmpSeq").toString());
			
			if(!obj_body.getString("param_file_path").equals("")) {
				String sel_file_path = "";
				String[] file_seq_list = obj_body.getString("param_file_seq").split(",");
				String[] file_nm_list = obj_body.getString("param_file_nm").split(",");
				String[] file_path_list = obj_body.getString("param_file_path").split(",");
				ArrayList<v2_IRFileModel> ir_file_arr = new ArrayList<v2_IRFileModel>();
				for(int i=0; i < file_nm_list.length; i++) {
					v2_IRFileModel fileVo = new v2_IRFileModel();
					if(!obj_body.getString("param_ir_board_seq").equals("")) { 
						fileVo.setIr_board_seq(irVo.getIr_board_seq());
					}
					fileVo.setIr_board_file_seq(Integer.parseInt(file_seq_list[i]));
					fileVo.setFile_nm(file_nm_list[i]);
					fileVo.setFile_path(file_path_list[i]);
					ir_file_arr.add(fileVo);
				}				
				irVo.setFile_list(ir_file_arr);
			}
			
			int param_rtn_val = v2_commonService.sv_ir_save(irVo);
			if(param_rtn_val == 1) {
				result_map = _Request.setResult("success", "", "");
			}else {
				result_map = _Request.setResult("error", "저장오류가 발생했습니다.", null);
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "저장오류가 발생했습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* IR 게시판 삭제 */
	@RequestMapping(value="/ir/del/{ir_board_seq}/{ir_board_file_seq}", method=RequestMethod.DELETE)
	public void set_ir_delete(HttpServletRequest req, HttpServletResponse res, @PathVariable int ir_board_seq, @PathVariable int ir_board_file_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_CommonServiceController] set_ir_delete");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		int param_rtn_val = 0;
		v2_IRFileModel irFileModel = new v2_IRFileModel();
		try{
			if(ir_board_seq > 0){
				irFileModel.setIr_board_seq(ir_board_seq);
				irFileModel.setIr_board_file_seq(0);
				param_rtn_val = v2_commonService.sv_ir_delete(irFileModel);				
			}else{
				irFileModel.setIr_board_seq(0);
				irFileModel.setIr_board_file_seq(ir_board_file_seq);
				param_rtn_val = v2_commonService.sv_ir_delete(irFileModel);	
			}
			if(param_rtn_val > 0) {
				result_map = _Request.setResult("success", "", "");
			}else {
				result_map = _Request.setResult("error", "저장오류가 발생했습니다.", null);
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "저장오류가 발생했습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}	
	
	
	
}
