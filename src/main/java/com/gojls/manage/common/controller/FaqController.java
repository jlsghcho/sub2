package com.gojls.manage.common.controller;

import java.nio.charset.StandardCharsets;
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

import com.gojls.manage.common.model.v2_NewsModel;
import com.gojls.manage.common.model.v2_SearchModel;
import com.gojls.manage.common.model.v2_TagModel;
import com.gojls.manage.common.service.FaqService;
import com.gojls.util._Request;
import com.gojls.util._Response;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@RestController
public class FaqController extends BaseController{
	@Autowired FaqService faqService;
	
	@Value("#{globalContext['ABROAD_CODE']?:''}") private String ABROAD_CODE;
	@Value("#{globalContext['ABROAD_NM']?:''}") private String ABROAD_NM;
	@Value("#{globalContext['ABROAD_LIST']?:''}") private String ABROAD_LIST;
	
	
	/* TYPE LIST  */
	@RequestMapping(value="/faq/getTypeList", method=RequestMethod.GET)
	public void getTypeList(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/FaqController] getTypeList");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			Map<String, String> param = new HashMap<String, String>();
			param.put("site_id", "9");
			result_map = _Request.setResult("success", "", JSONArray.fromObject(faqService.selectTypeList(param)).toString());
			
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* FAQ LIST  */
	@RequestMapping(value="/faq/list", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void faqList(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/FaqController] get_news_list");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			Map<String, Object> param = new HashMap<String, Object>();
			
			param.put("site_id",obj_body.get("search_dept"));
//			param.put("searchTitle",new String((byte[]) obj_body.get("search_context"), "UTF-8"));
			param.put("searchTitle",obj_body.get("search_context"));
			if(!obj_body.get("search_type").toString().equals("")) {
				param.put("cate_id",Arrays.asList(obj_body.get("search_type").toString().split(",")));
			}
			if(!obj_body.get("search_status").toString().equals("")) {
				param.put("use_yn",Arrays.asList(obj_body.get("search_status").toString().split(",")));
			}
			
			result_map = _Request.setResult("success", "", JSONArray.fromObject(faqService.selectFaqList(param)).toString());
			
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* FAQ 상세보기 */
	@RequestMapping(value="/faq/view/{seq_no}/{site_id}", method=RequestMethod.GET)
	public void selectFaqDetail(HttpServletRequest req, HttpServletResponse res, @PathVariable int seq_no , @PathVariable int site_id) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/FaqController] get_news_view");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("seq_no", seq_no);
			param.put("site_id", site_id);
			
			result_map = _Request.setResult("success", "", JSONArray.fromObject(faqService.selectFaqDetail(param)).toString() );
		}catch(Exception ex) {
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	/* FAQ 저장 */
	@RequestMapping(value="/faq/save", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void faqSave(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/FaqController] faqSave");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));

			Map<String, Object> param = new HashMap<String, Object>();
			
			param.put("inup_type", obj_body.getString("param_inup_type"));
			param.put("subject", obj_body.getString("param_title").toString());
			param.put("site_id", obj_body.getString("param_site_type"));
			param.put("cate_id", obj_body.getString("param_qust_type"));
			param.put("contents", obj_body.getString("param_editor_text"));
			param.put("reg_seq", obj_body.getString("param_empSeq"));
			param.put("seq_no", obj_body.getString("param_seq_no"));
			param.put("reg_name",obj_body.getString("param_empNm"));
			param.put("use_yn",obj_body.getString("param_use_yn"));
			
			
			int param_rtn_val = faqService.faq_save(param);
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
	
	@RequestMapping(value="/faq/del/{site}/{seq}", method=RequestMethod.DELETE)
	public void faq_delete(HttpServletRequest req, HttpServletResponse res, @PathVariable int site, @PathVariable int seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/FaqController] set_news_delete");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("seq_no", seq);
			param.put("site_id", site);
			
			int param_rtn_val = faqService.faq_delete(param);
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
	
	@RequestMapping(value="/type/save", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void type_save(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/FaqController] get_tag_save");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			Map<String, Object> param = new HashMap<String, Object>();
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			param.put("cate_id", obj_body.getString("param_cate_id"));
			param.put("cate_name", obj_body.getString("param_cate_name"));
			param.put("cate_sort", obj_body.getString("param_cate_sort"));
			param.put("reg_seq", obj_body.getString("param_reg_seq"));

			result_map = _Request.setResult("success", "", JSONArray.fromObject(faqService.type_save(param)).toString());
			
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	@RequestMapping(value="/type/remove", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void type_remove(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/FaqController] type_remove");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			Map<String, Object> param = new HashMap<String, Object>();
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			param.put("cate_id", obj_body.getString("cate_id"));

			result_map = _Request.setResult("success", "", JSONArray.fromObject(faqService.type_delete(param)).toString());
			
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, result_map, false, "");
	}
	
	
	
	
}
