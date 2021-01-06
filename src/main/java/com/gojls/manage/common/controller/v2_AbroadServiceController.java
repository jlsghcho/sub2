package com.gojls.manage.common.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.codehaus.jackson.JsonParser;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.gojls.manage.common.model.v2_ReserveMstModel;
import com.gojls.manage.common.model.v2_ReserveProgramModel;
import com.gojls.manage.common.model.v2_SearchModel;
import com.gojls.manage.common.model.v2_SiteBannerModel;
import com.gojls.manage.common.model.v2_SiteContentModel;
import com.gojls.manage.common.model.v2_SiteCounselModel;
import com.gojls.manage.common.model.v2_SiteManagerModel;
import com.gojls.manage.common.model.v2_SiteMenuModel;
import com.gojls.manage.common.model.v2_SitePartnerModel;
import com.gojls.manage.common.model.v2_SiteProgramModel;
import com.gojls.manage.common.model.v2_SiteReportModel;
import com.gojls.manage.common.model.v2_SiteSearchModel;
import com.gojls.manage.common.model.v2_SiteTagModel;
import com.gojls.manage.common.service.v2_AbroadService;
import com.gojls.util._Request;
import com.gojls.util._Response;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@RestController
@RequestMapping ("/service/v2/abroad")
public class v2_AbroadServiceController extends BaseController{
	@Autowired v2_AbroadService v2_abroadService;
	
	@Value("#{globalContext['ABROAD_SITE_CODE']?:'ABROAD'}") private String ABROAD_SITE_CODE;
	
	/* 메뉴 목록  */
	@RequestMapping(value="/menu", method=RequestMethod.GET)
	public void get_menu_list(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_menu_list");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_select_menu_list(ABROAD_SITE_CODE)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}

	/* 메뉴 목록  */
	@RequestMapping(value="/menu/sub", method=RequestMethod.GET)
	public void get_sub_menu_list(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_sub_menu_list");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_select_sub_menu_list()).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}

	/* 메뉴 저장 */
	@RequestMapping(value="/menu/save", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void set_menu_save(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] set_menu_save");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			int result_val = 0;
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));

			v2_SiteMenuModel menuVo = new v2_SiteMenuModel();
			menuVo.setReg_user_seq(req.getAttribute("cookieEmpSeq").toString());
			menuVo.setReg_user_id(req.getAttribute("cookieEmpId").toString());
			menuVo.setReg_user_nm(req.getAttribute("cookieEmpNm").toString());
			menuVo.setSite_type(ABROAD_SITE_CODE);
				
			if(obj_body.get("type").equals("create")) {
				menuVo.setParent_menu_seq(obj_body.getInt("seq"));
				menuVo.setSub_menu_codes(obj_body.getString("codes"));
				menuVo.setMenu_nm(obj_body.getString("text"));
				if(obj_body.getBoolean("view")) { menuVo.setUse_yn("Y"); } else { menuVo.setUse_yn("N"); }
				result_val = v2_abroadService.sv_insert_menu(menuVo);
			}else if(obj_body.get("type").equals("update")) {
				menuVo.setMenu_seq(obj_body.getInt("seq"));
				menuVo.setSub_menu_codes(obj_body.getString("codes"));
				menuVo.setMenu_nm(obj_body.getString("text"));
				if(obj_body.getBoolean("view")) { menuVo.setUse_yn("Y"); } else { menuVo.setUse_yn("N"); }
				result_val = v2_abroadService.sv_update_menu(menuVo);
			}else {
				result_val = v2_abroadService.sv_update_sort_menu(menuVo, obj_body.getString("data"));
			}
			
			if(result_val > 0) {
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
		

	/* 메인 배너 목록  */
	@RequestMapping(value="/banner", method=RequestMethod.GET)
	public void get_main_banner_list(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_main_banner_list");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_select_site_main_banner(ABROAD_SITE_CODE)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	@RequestMapping(value="/banner", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void set_main_banner_save(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] set_main_banner_save");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			
			v2_SiteBannerModel bannerVo = new v2_SiteBannerModel();
			bannerVo.setMenu_banner_seq(obj_body.getInt("param_banner_seq"));
			bannerVo.setSite_type(ABROAD_SITE_CODE);
			bannerVo.setMenu_seq(obj_body.getInt("param_menu_seq"));
			bannerVo.setOrder_num(obj_body.getInt("param_order_num"));
			bannerVo.setStatus(obj_body.getInt("param_status"));
			bannerVo.setImg_path(obj_body.getString("param_img_path"));
			bannerVo.setTitle(obj_body.getString("param_title"));
			bannerVo.setView_yn(obj_body.getInt("param_view_yn"));
			bannerVo.setReg_user_seq(req.getAttribute("cookieEmpSeq").toString());
			bannerVo.setReg_user_id(req.getAttribute("cookieEmpId").toString());
			bannerVo.setReg_user_nm(req.getAttribute("cookieEmpNm").toString());
			
			int param_rtn_val = v2_abroadService.sv_site_banner_save(bannerVo);
			if(param_rtn_val == 1) {
				result_map = _Request.setResult("success", "", "");
			}else {
				result_map = _Request.setResult("error", "저장오류가 발생했습니다.", null);
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}

	/* 메인 파트너 정렬 저장  */
	@RequestMapping(value="/banner/sort", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void set_main_banner_sort_save(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] set_main_partner_sort_save");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			if(v2_abroadService.sv_site_banner_save_sort(obj_body.getString("data")) > 0) {
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
	

	/* 메인 파트너 목록  */
	@RequestMapping(value="/partner", method=RequestMethod.GET)
	public void get_main_partner_list(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_main_partner_list");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_select_site_partner(ABROAD_SITE_CODE)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* 메인 파트너 저장  */
	@RequestMapping(value="/partner", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void set_main_partner_save(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] set_main_partner_save");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			
			v2_SitePartnerModel partnerVo = new v2_SitePartnerModel();
			partnerVo.setPartner_type(obj_body.getString("param_type"));
			partnerVo.setImg_path(obj_body.getString("param_img_path"));
			partnerVo.setLink_url(obj_body.getString("param_link_url"));
			partnerVo.setPartner_nm(obj_body.getString("param_title"));
			if(obj_body.getString("param_save_type").equals("mod")) { partnerVo.setPartner_seq(obj_body.getInt("param_seq")); }
			partnerVo.setSite_type(ABROAD_SITE_CODE);
			
			int param_rtn_val = v2_abroadService.sv_site_partner_save(partnerVo);
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
	
	/* 메인 파트너 정렬 저장  */
	@RequestMapping(value="/partner/sort", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void set_main_partner_sort_save(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] set_main_partner_sort_save");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			if(v2_abroadService.sv_site_partner_save_sort(obj_body.getString("data")) > 0) {
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
	
	/* 메인 파트너 삭제  */
	@RequestMapping(value="/partner/{partner_seq}", method=RequestMethod.DELETE)
	public void del_main_partner(HttpServletRequest req, HttpServletResponse res, @PathVariable int partner_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] del_main_partner");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			if(v2_abroadService.sv_site_partner_delete(partner_seq) > 0) {
				result_map = _Request.setResult("success", "", "");
			}else {
				result_map = _Request.setResult("error", "저장오류가 발생했습니다.", null);
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	
	/* 메인 운영진 목록  */
	@RequestMapping(value="/manager", method=RequestMethod.GET)
	public void get_main_manager_list(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_main_manager_list");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_select_site_manager(ABROAD_SITE_CODE)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* 메인 파트너 저장  */
	@RequestMapping(value="/manager", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void set_main_manager_save(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] set_main_manager_save");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			
			v2_SiteManagerModel managerVo = new v2_SiteManagerModel();
			managerVo.setImg_path(obj_body.getString("param_img_path"));
			managerVo.setStaff_desc(obj_body.getString("param_desc"));
			managerVo.setStaff_nm(obj_body.getString("param_name"));
			if(obj_body.getString("param_save_type").equals("mod")) { managerVo.setStaff_seq(obj_body.getInt("param_seq")); }
			managerVo.setSite_type(ABROAD_SITE_CODE);
			managerVo.setReg_user_seq(req.getAttribute("cookieEmpSeq").toString());
			managerVo.setReg_user_id(req.getAttribute("cookieEmpId").toString());
			managerVo.setReg_user_nm(req.getAttribute("cookieEmpNm").toString());
			
			int param_rtn_val = v2_abroadService.sv_site_manager_save(managerVo);
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
	
	/* 메인 운영진 삭제  */
	@RequestMapping(value="/manager/{manager_seq}", method=RequestMethod.DELETE)
	public void del_main_manager(HttpServletRequest req, HttpServletResponse res, @PathVariable int manager_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] del_main_manager");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			if(v2_abroadService.sv_site_manager_delete(manager_seq) > 0) {
				result_map = _Request.setResult("success", "", "");
			}else {
				result_map = _Request.setResult("error", "저장오류가 발생했습니다.", null);
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* 메인 운영진 정렬 저장  */
	@RequestMapping(value="/manager/sort", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void set_main_manager_sort_save(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] set_main_manager_sort_save");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			if(v2_abroadService.sv_site_manager_save_sort(obj_body.getString("data")) > 0) {
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

	/* 메인 프로그램 목록  */
	@RequestMapping(value="/program", method=RequestMethod.GET)
	public void get_main_program_list(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_main_program_list");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_select_site_program(ABROAD_SITE_CODE)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}

	/* 메인 프로그램(컨텐츠) 정보  */
	@RequestMapping(value="/program/{menu_seq}", method=RequestMethod.GET)
	public void get_main_program_info(HttpServletRequest req, HttpServletResponse res, @PathVariable int menu_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_main_program_info");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			v2_SiteProgramModel programVo = new v2_SiteProgramModel();
			programVo.setSite_type(ABROAD_SITE_CODE);
			programVo.setMenu_seq(menu_seq);
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_select_site_program_info(programVo)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* 메인 프로그램(컨텐츠) 저장  */
	@RequestMapping(value="/program", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void set_main_program_save(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] set_main_program_save");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			
			v2_SiteProgramModel programVo = new v2_SiteProgramModel();
			if(!obj_body.getString("param_content_menu_seq").equals("")) { programVo.setMenu_content_seq(obj_body.getInt("param_content_menu_seq")); }
			programVo.setContent_type(obj_body.getString("param_content_type"));
			programVo.setSite_type(ABROAD_SITE_CODE);
			programVo.setTitle(obj_body.getString("param_title"));
			programVo.setContents(obj_body.getString("param_contents"));
			programVo.setThumbnail_path(obj_body.getString("param_thumbnail_path"));
			programVo.setVideo_url(obj_body.getString("param_video_url"));
			programVo.setMenu_seq(obj_body.getInt("param_menu_seq"));
			programVo.setOrder_num(1);
			programVo.setUse_yn("Y");
			programVo.setReg_user_seq(req.getAttribute("cookieEmpSeq").toString());
			programVo.setReg_user_id(req.getAttribute("cookieEmpId").toString());
			programVo.setReg_user_nm(req.getAttribute("cookieEmpNm").toString());
			
			int param_rtn_val = v2_abroadService.sv_site_program_save(programVo);
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

	@RequestMapping(value="/program/{param_menu_content_seq}", method=RequestMethod.DELETE)
	public void set_program_delete(HttpServletRequest req, HttpServletResponse res, @PathVariable int param_menu_content_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] set_program_delete");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			if(v2_abroadService.sv_site_program_delete(param_menu_content_seq) > 0) {
				result_map = _Request.setResult("success", "", "");
			}else {
				result_map = _Request.setResult("error", "삭제중 오류가 발생했습니다.", null);
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	
	
	
	/* 커뮤니티 > 태그 */
	@RequestMapping(value="/tag", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void get_community_tag(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_community_tag");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			v2_SiteSearchModel searchVo = new v2_SiteSearchModel();
			searchVo.setSite_type(ABROAD_SITE_CODE);
			searchVo.setSearch_context(obj_body.getString("search_context"));
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_select_site_tag(searchVo)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}	

	@RequestMapping(value="/tag/save", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void get_community_tag_save(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_community_tag_save");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));

			v2_SiteTagModel tagVo = new v2_SiteTagModel();
			if(!obj_body.getString("site_tag_seq").equals("")) { tagVo.setSite_tag_seq(obj_body.getInt("site_tag_seq")); }
			tagVo.setSite_type(ABROAD_SITE_CODE);
			tagVo.setOrder_num(obj_body.getInt("order_num"));
			tagVo.setTag_nm(obj_body.getString("tag_nm"));
			tagVo.setView_yn(obj_body.getString("view_yn"));
			tagVo.setReg_user_seq(req.getAttribute("cookieEmpSeq").toString());
			tagVo.setReg_user_id(req.getAttribute("cookieEmpId").toString());
			tagVo.setReg_user_nm(req.getAttribute("cookieEmpNm").toString());

			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_site_tag_save(tagVo)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}	

	/* 커뮤니티 > 후기/동영상/갤러리 */
	@RequestMapping(value="/content/save", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void get_community_content_save(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_community_content_save");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			v2_SiteContentModel contentVo = new v2_SiteContentModel();
			if(obj_body.getString("param_inup_type").equals("update")) { contentVo.setSite_content_seq(obj_body.getInt("param_content_seq")); }
			contentVo.setSite_type(ABROAD_SITE_CODE);
			contentVo.setTitle(obj_body.getString("param_title"));
			contentVo.setPreview_text(obj_body.getString("param_preview_text"));
			contentVo.setContents(obj_body.getString("param_contents"));
			contentVo.setView_yn(obj_body.getInt("param_view_yn"));
			contentVo.setTag_select_list(obj_body.getString("param_tag_list"));
			contentVo.setContent_type(obj_body.getString("param_content_type"));
			contentVo.setFile_path(obj_body.getString("param_file_path"));
			
			contentVo.setReg_user_seq(req.getAttribute("cookieEmpSeq").toString());
			contentVo.setReg_user_id(req.getAttribute("cookieEmpId").toString());
			contentVo.setReg_user_nm(req.getAttribute("cookieEmpNm").toString());
			
			int param_rtn_value = 0;
			if(contentVo.getContent_type().equals("gallery") && obj_body.getString("param_inup_type").equals("insert")) {
				String[] param_thumb_arr = obj_body.getString("param_thumbnail_path").split(",");
				for(int i=0; i < param_thumb_arr.length; i++) {
					contentVo.setThumbnail_path(param_thumb_arr[i].toString());
					contentVo.setSite_content_seq(0);
					param_rtn_value = v2_abroadService.sv_select_site_content_save(contentVo);
				} 
			}else {
				contentVo.setThumbnail_path(obj_body.getString("param_thumbnail_path"));
				param_rtn_value = v2_abroadService.sv_select_site_content_save(contentVo);
			}
			if( param_rtn_value > 0) { result_map = _Request.setResult("success", "", ""); }else { result_map = _Request.setResult("error", "저장도중 오류가 발생했습니다.", null); }
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	@RequestMapping(value="content/tag/update", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void set_community_content_tag_update(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] set_community_content_tag_update");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));

			v2_SiteContentModel contentVo = new v2_SiteContentModel();
			contentVo.setSite_content_seq(obj_body.getInt("param_content_seq"));
			contentVo.setTag_select_list(obj_body.getString("param_tag_list"));
			
			if(v2_abroadService.sv_select_site_content_tag_update(contentVo) > 0) {
				result_map = _Request.setResult("success", "", "");
			}else {
				result_map = _Request.setResult("error", "저장도중 오류가 발생했습니다.", null);
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	@RequestMapping(value="/content/del/{param_content_seq}", method=RequestMethod.DELETE)
	public void get_community_content_delete(HttpServletRequest req, HttpServletResponse res, @PathVariable int param_content_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_community_content_save");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			v2_SiteContentModel contentVo = new v2_SiteContentModel();
			contentVo.setSite_content_seq(param_content_seq);
			if(v2_abroadService.sv_select_site_content_delete(contentVo) > 0) {
				result_map = _Request.setResult("success", "", "");
			}else {
				result_map = _Request.setResult("error", "저장도중 오류가 발생했습니다.", null);
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	@RequestMapping(value="/content/detail/{param_content_seq}", method=RequestMethod.GET)
	public void get_community_content_detail(HttpServletRequest req, HttpServletResponse res, @PathVariable int param_content_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_community_content_detail");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_select_site_content_detail(param_content_seq)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}	
	
	@RequestMapping(value="/content/{content_type}", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void get_community_content(HttpServletRequest req, HttpServletResponse res, @PathVariable String content_type) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_community_content");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			v2_SiteSearchModel searchVo = new v2_SiteSearchModel();
			searchVo.setSite_type(ABROAD_SITE_CODE);
			searchVo.setContent_type(content_type);
			searchVo.setSearch_context(obj_body.getString("search_context"));
			if(!obj_body.get("tag_type").toString().equals("")) {
				searchVo.setTag_type(Arrays.asList(obj_body.get("tag_type").toString().split(",")));
			}			
			searchVo.setPage_size(obj_body.getInt("page_size"));
			searchVo.setPage_start_num(obj_body.getInt("page_start_num"));
			
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_select_site_content(searchVo)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* MY유학 > 유학생활 1:1상담 */
	@RequestMapping(value="/counsel", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void get_my_counsel_list(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_my_counsel_list");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			v2_SiteSearchModel searchVo = new v2_SiteSearchModel();
			searchVo.setSite_type(ABROAD_SITE_CODE);
			searchVo.setSearch_dept_arr(Arrays.asList(obj_body.get("search_dept_arr").toString().split(",")));
			searchVo.setSearch_start_dt(obj_body.getString("search_start_dt"));
			searchVo.setSearch_end_dt(obj_body.getString("search_end_dt"));
			searchVo.setSearch_context(obj_body.getString("search_context"));
			searchVo.setPage_size(obj_body.getInt("page_size"));
			searchVo.setPage_start_num(obj_body.getInt("page_start_num"));
			
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_select_site_counsel_list(searchVo)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}

	/* MY유학 > 유학생활 1:1상담 > 삭제 */
	@RequestMapping(value="/counsel/{site_counsel_seq}", method=RequestMethod.DELETE)
	public void del_my_counsel_list(HttpServletRequest req, HttpServletResponse res, @PathVariable int site_counsel_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] del_my_counsel_list");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{ result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_delete_site_counsel_list(site_counsel_seq)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* MY유학 > 유학생활 1:1상담 저장 */
	@RequestMapping(value="/counsel/{param_save_type}", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void set_my_counsel_save(HttpServletRequest req, HttpServletResponse res, @PathVariable String param_save_type) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] set_my_counsel_save");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			
			v2_SiteCounselModel counselVo = new v2_SiteCounselModel();
			counselVo.setContents(obj_body.getString("param_content"));
			counselVo.setSite_type(ABROAD_SITE_CODE);
			counselVo.setUser_seq(obj_body.getString("param_user"));
			counselVo.setDept_seq(obj_body.getInt("param_dept"));
			counselVo.setReg_user_type("ADMIN");
			counselVo.setReg_user_seq(req.getAttribute("cookieEmpSeq").toString());
			counselVo.setReg_user_id(req.getAttribute("cookieEmpId").toString());
			counselVo.setReg_user_nm(req.getAttribute("cookieEmpNm").toString());
			counselVo.setUse_yn(1);
			counselVo.setReply_cnt(0);
			counselVo.setQa_type("Q");
			counselVo.setRead_yn(0);
			if(param_save_type.equals("update")) { counselVo.setSite_counsel_reply_seq(obj_body.getInt("param_site_counsel_reply_seq")); }
			
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_site_counsel_save(counselVo)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* MY유학 > 유학생활 1:1상담 > 상세정보  */
	@RequestMapping(value="/counsel/{param_site_counsel_seq}", method=RequestMethod.GET)
	public void get_my_counsel_view(HttpServletRequest req, HttpServletResponse res, @PathVariable int param_site_counsel_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_my_counsel_view(param_site_counsel_seq)");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_select_site_counsel_view(param_site_counsel_seq)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}	

	/* MY유학 > 유학생활 1:1상담 > 첨부파일  */
	@RequestMapping(value="/counsel/files/{param_site_counsel_reply_seq}", method=RequestMethod.GET)
	public void get_my_counsel_files(HttpServletRequest req, HttpServletResponse res, @PathVariable int param_site_counsel_reply_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_my_counsel_files(param_site_counsel_reply_seq)");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_select_site_counsel_reply_file(param_site_counsel_reply_seq)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* MY유학 > 유학생활 1:1상담 답글 저장 */
	@RequestMapping(value="/counsel/reply/{param_save_type}", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void set_my_counsel_reply_save(HttpServletRequest req, HttpServletResponse res, @PathVariable String param_save_type) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] set_my_counsel_reply_save");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			
			v2_SiteCounselModel counselVo = new v2_SiteCounselModel();
			counselVo.setSite_counsel_seq(obj_body.getInt("param_site_counsel_seq"));
			counselVo.setReg_user_type("ADMIN");
			counselVo.setQa_type("A");
			counselVo.setReg_user_seq(req.getAttribute("cookieEmpSeq").toString());
			counselVo.setReg_user_id(req.getAttribute("cookieEmpId").toString());
			counselVo.setReg_user_nm(req.getAttribute("cookieEmpNm").toString());
			counselVo.setContents(obj_body.getString("param_content"));
			counselVo.setUse_yn(1);
			counselVo.setRead_yn(0);
			
			counselVo.setParam_file_nm(obj_body.getString("param_file_nm"));
			counselVo.setParam_file_path(obj_body.getString("param_file_path"));

			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_site_counsel_reply_save(counselVo)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* MY유학 > 유학생활 1:1상담 > 답글 삭제 */
	@RequestMapping(value="/counsel/reply/{site_counsel_reply_seq}", method=RequestMethod.DELETE)
	public void del_my_counsel_reply(HttpServletRequest req, HttpServletResponse res, @PathVariable int site_counsel_reply_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] del_my_counsel_reply");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{ result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_delete_site_counsel_reply(site_counsel_reply_seq)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	
	/* MY유학 > 리포트  */
	@RequestMapping(value="/report", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void get_my_report_list(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_my_report_list");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			v2_SiteSearchModel searchVo = new v2_SiteSearchModel();
			searchVo.setSite_type(ABROAD_SITE_CODE);
			searchVo.setContent_type_arr(Arrays.asList(obj_body.get("search_type_arr").toString().split(",")));
			searchVo.setSearch_start_dt(obj_body.getString("search_start_dt"));
			searchVo.setSearch_end_dt(obj_body.getString("search_end_dt"));
			searchVo.setSearch_context(obj_body.getString("search_context"));
			searchVo.setPage_size(obj_body.getInt("page_size"));
			searchVo.setPage_start_num(obj_body.getInt("page_start_num"));
			
			/* 분원 코드 넣기 */
			searchVo.setSearch_dept_arr(Arrays.asList(obj_body.get("search_dept_arr").toString().split(",")));
			
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_select_site_report_list(searchVo)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* MY유학 > 리포트 저장 */
	@RequestMapping(value="/report/{param_save_type}", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void set_my_report_save(HttpServletRequest req, HttpServletResponse res, @PathVariable String param_save_type) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] set_my_report_save");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			
			v2_SiteReportModel reportVo = new v2_SiteReportModel();
			reportVo.setTitle(obj_body.getString("param_title"));
			reportVo.setContents(obj_body.getString("param_content"));
			reportVo.setSite_type(ABROAD_SITE_CODE);
			reportVo.setUser_seq(obj_body.getString("param_user"));
			reportVo.setDept_seq(obj_body.getInt("param_dept"));
			reportVo.setReg_user_seq(req.getAttribute("cookieEmpSeq").toString());
			reportVo.setReg_user_id(req.getAttribute("cookieEmpId").toString());
			reportVo.setReg_user_nm(req.getAttribute("cookieEmpNm").toString());
			reportVo.setReport_type(obj_body.getString("param_report_type"));
			reportVo.setUse_yn(1);
			
			reportVo.setFile_path_sp(obj_body.getString("param_file_path"));
			reportVo.setFile_nm_sp(obj_body.getString("param_file_nm"));
			
			if(param_save_type.equals("update")) { reportVo.setSite_report_user_seq(obj_body.getInt("param_site_report_seq")); }
			
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_site_report_save(reportVo)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* MY유학 > 리포트 > 삭제 */
	@RequestMapping(value="/report/{site_report_user_seq}", method=RequestMethod.DELETE)
	public void del_my_report_list(HttpServletRequest req, HttpServletResponse res, @PathVariable int site_report_user_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] del_my_report_list");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{ result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_delete_site_report_list(site_report_user_seq)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* MY유학 > 리포트 > 상세정보  */
	@RequestMapping(value="/report/{param_site_report_seq}", method=RequestMethod.GET)
	public void get_my_report_view(HttpServletRequest req, HttpServletResponse res, @PathVariable int param_site_report_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_my_report_view(param_site_report_seq)");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_select_site_report_view(param_site_report_seq)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	

	/* 예약관리 > 설명회/캠프 예약설정 *//*	
	@RequestMapping(value="/reserve/mst/list", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void get_reserve_mst_list(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_reserve_mst_list");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			v2_SearchModel searchVo = new v2_SearchModel();
			searchVo.setSearch_start_dt(obj_body.getString("search_start_dt"));
			searchVo.setSearch_end_dt(obj_body.getString("search_end_dt"));
			searchVo.setSearch_context(obj_body.getString("search_context"));
			searchVo.setPage_size(obj_body.getInt("page_size"));
			searchVo.setPage_start_num(obj_body.getInt("page_start_num"));
			
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_select_reserve_mst_list(searchVo)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
    

	*//* 예약관리 > 설명회/캠프 예약설정 상세 *//*	
	@RequestMapping(value="/reserve/mst/info/{site_reserve_mst_seq}", method=RequestMethod.GET)
	public void get_reserve_mst_info(HttpServletRequest req, HttpServletResponse res, @PathVariable int site_reserve_mst_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] get_reserve_mst_info");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			v2_ReserveMstModel reservVo = new v2_ReserveMstModel();
			reservVo.setSite_reserv_mst_seq(site_reserve_mst_seq);
			
			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_select_reserve_info(reservVo)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
    *//* 예약관리 > 설명회/캠프 예약설정 저장 *//*
	@RequestMapping(value="/reserve/mst/save", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void set_reserve_mst_save(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] set_reserve_mst_save");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));

			v2_ReserveMstModel reserveVo = new v2_ReserveMstModel();
			reserveVo.setSite_reserv_mst_seq(Integer.parseInt(obj_body.getString("site_reserv_mst_seq")));
			reserveVo.setReservation_type(obj_body.getString("reservation_type"));
			String reserv_month = obj_body.getString("reservation_month").replace("년 ", "").replace("월 모집", "");
			reserveVo.setReservation_month(reserv_month);
			reserveVo.setView_start_dt(obj_body.getString("start_dt"));
			reserveVo.setView_end_dt(obj_body.getString("end_dt"));
			reserveVo.setReg_user_seq(req.getAttribute("cookieEmpSeq").toString());
			reserveVo.setReg_user_id(req.getAttribute("cookieEmpId").toString());
			reserveVo.setReg_user_nm(req.getAttribute("cookieEmpNm").toString());
			
			List<v2_ReserveProgramModel> list = new ArrayList<v2_ReserveProgramModel>();
			v2_ReserveProgramModel objModel = new v2_ReserveProgramModel();
			   System.out.println("start");
			JSONArray jsonArray = (JSONArray)obj_body.get("program_list");
			System.out.println("start1"); 
			if (jsonArray != null) { 
			   int len = jsonArray.size();
			   for (int i=0;i<len;i++){
				   ObjectMapper mapper = new ObjectMapper();
				   objModel = mapper.readValue(jsonArray.get(i).toString(), v2_ReserveProgramModel.class);
			   
				   //objModel.setDept_seq(jsonArray.getJSONObject(i).getString("dept_Seq"));
				   //objModel.setDate_time(jsonArray.getJSONObject(i).getString("date_time"));
				   //objModel.setProgram_nm(jsonArray.getJSONObject(i).getString("program_nm"));
				   System.out.println("start2"); 
				   //System.out.println(objModel.getSite_reserv_mst_seq());
				   //System.out.println(objModel.getSite_reserv_program_seq());
				   System.out.println(objModel.getDept_seq());
				   System.out.println(objModel.getDate_time());
				   System.out.println(objModel.getProgram_nm());
				   objModel.setReg_user_seq(req.getAttribute("cookieEmpSeq").toString());
				   objModel.setReg_user_id(req.getAttribute("cookieEmpId").toString());
				   objModel.setReg_user_nm(req.getAttribute("cookieEmpNm").toString());
				   
				   list.add(objModel);
			   } 
			} 			
			reserveVo.setReserve_program_list(list);

			result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_reserve_save(reserveVo)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}	

	*//* 예약관리 > 설명회/캠프 예약설정  mst 삭제 *//*
	@RequestMapping(value="/reserve/mst/{site_reserv_mst_seq}", method=RequestMethod.DELETE)
	public void del_reserve_mst(HttpServletRequest req, HttpServletResponse res, @PathVariable int site_reserv_mst_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] del_reserve_mst");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		
		v2_ReserveProgramModel objModel = new v2_ReserveProgramModel();	
		objModel.setSite_reserv_mst_seq(site_reserv_mst_seq);
		
		try{ result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_delete_reserve_mst(objModel)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}

	*//* 예약관리 > 설명회/캠프 예약설정  program 삭제 *//*
	@RequestMapping(value="/reserve/program/{site_reserv_mst_seq}/{site_reserv_program_seq}", method=RequestMethod.DELETE)
	public void del_reserve_program(HttpServletRequest req, HttpServletResponse res, @PathVariable int site_reserv_mst_seq, @PathVariable int site_reserv_program_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceController] del_reserve_program");	} 
		Map<String, Object> result_map = new HashMap<String, Object>();
		
		v2_ReserveProgramModel objModel = new v2_ReserveProgramModel();	
		objModel.setSite_reserv_mst_seq(site_reserv_mst_seq);
		if(site_reserv_program_seq > 0){	
			objModel.setSite_reserv_program_seq(site_reserv_program_seq);			
		}
		
		try{ result_map = _Request.setResult("success", "", JSONArray.fromObject(v2_abroadService.sv_delete_reserve_program(objModel)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	*/
	
}
