package com.gojls.manage.common.controller;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.gojls.manage.common.model.AdModel;
import com.gojls.manage.common.model.DeptModel;
import com.gojls.manage.common.model.NewsModel;
import com.gojls.manage.common.model.SearchModel;
import com.gojls.manage.common.model.TagModel;
import com.gojls.manage.common.model.UnioneDeptModel;
import com.gojls.manage.common.service.CommonService;
import com.gojls.util._Request;
import com.gojls.util._Response;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@RestController
@RequestMapping ("/service")
public class CommonServiceController extends BaseController {
	@Autowired CommonService commonService;
	
	/* 소식지 - jtable  */
	@RequestMapping(value="/news", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void getNewsList(HttpServletRequest req, HttpServletResponse res, @RequestParam int jtStartIndex, @RequestParam int jtPageSize) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/IndexServiceController] getNewsList");	}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			Map<String, Object> fromParam = formDataConvert(req);
			List<Integer> dept_int_arr = new ArrayList<Integer>();
			if(!fromParam.get("searchDeptSeq").toString().equals("") && fromParam.get("searchDeptSeq").toString() != null) {
				String[] dept_arr = URLDecoder.decode(fromParam.get("searchDeptSeq").toString()).split(",");
				for(int i = 0; i < dept_arr.length; i++) {
					dept_int_arr.add(Integer.parseInt(dept_arr[i]));
				}
			}

			SearchModel searchVo = new SearchModel();
			searchVo.setSearchDeptSeq(fromParam.get("searchDeptSeq").toString());
			searchVo.setSearchDeptArr(dept_int_arr);
			searchVo.setSearchStartDt(fromParam.get("searchStartDt").toString());
			searchVo.setSearchEndDt(fromParam.get("searchEndDt").toString());
			searchVo.setSearchViewYn(fromParam.get("searchViewYn").toString());
			searchVo.setSearchTitle(URLDecoder.decode(fromParam.get("searchTitle").toString()));
			searchVo.setSearchTag(fromParam.get("searchTag").toString());
			searchVo.setSearchBranchType(fromParam.get("searchBranchType").toString());
			searchVo.setJtStartIndex(jtStartIndex);
			searchVo.setJtPageSize(jtPageSize);

			resultMap = commonService.selectNewsList(searchVo); 
		}catch(Exception ex){
			System.out.println(ex);
			resultMap.put("Result", "ERROR");
			resultMap.put("Message", ex.getMessage());
		}
		_Response.outJson(res, resultMap, false, "");
	}

	/* 소식 상세목록/수정  */
	@RequestMapping(value="/news/view/{param_seq}", method=RequestMethod.GET)
	public void getNewsView(HttpServletRequest req, HttpServletResponse res, @PathVariable int param_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/IndexServiceController] getNewsView");	}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			resultMap = _Request.setResult("success", "", JSONArray.fromObject(commonService.selectNewsView(param_seq)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			resultMap = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, resultMap, false, "");
	}

	/* 소식 저장  */
	@RequestMapping(value="/news/save", method=RequestMethod.POST)
	public void setNewsSave(HttpServletRequest req, HttpServletResponse res
			, @RequestParam(value="frm_param_seq", defaultValue="0",required=false) Integer frm_param_seq
			, @RequestParam(value="frm_param_content_seq", defaultValue="0",required=false) Integer frm_param_content_seq
			, @RequestParam(value="frm_reg_user_seq", defaultValue="", required=false) String frm_reg_user_seq
			, @RequestParam(value="frm_reg_user_nm", defaultValue="", required=false) String frm_reg_user_nm
			, @RequestParam(value="frm_tag_list", defaultValue="", required=false) String frm_tag_list
			, @RequestParam(value="frm_img_thumb", defaultValue="", required=false) String frm_img_thumb
			, @RequestParam(value="frm_title", defaultValue="", required=false) String frm_title
			, @RequestParam(value="frm_dept_seq", defaultValue="",required=false) Integer frm_dept_seq
			//, @RequestParam(value="frm_dept_seq2", defaultValue="",required=false) Integer frm_dept_seq2
			, @RequestParam(value="frm_start_dt", defaultValue="", required=false) String frm_start_dt
			, @RequestParam(value="frm_end_dt", defaultValue="", required=false) String frm_end_dt
			, @RequestParam(value="frm_view_yn", defaultValue="1", required=false) Integer frm_view_yn
			, @RequestParam(value="frm_contents", defaultValue="", required=false) String frm_contents
			, @RequestParam(value="frm_summary", defaultValue="", required=false) String frm_summary
			) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/IndexServiceController] setNewsSave");	}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			NewsModel newsVo = new NewsModel();
			if(frm_param_seq > 0) { 
				newsVo.setNoticeSeq(frm_param_seq);
				newsVo.setNoticeContntSeq(frm_param_content_seq);
			}
			newsVo.setRegUserNm(frm_reg_user_nm);
			newsVo.setRegUserSeq(frm_reg_user_seq);
			newsVo.setDeptSeq(frm_dept_seq);
			newsVo.setViewYn(frm_view_yn);
			newsVo.setContents(frm_contents);
			newsVo.setStartDt(frm_start_dt);
			newsVo.setEndDt(frm_end_dt);
			newsVo.setTitle(frm_title);
			newsVo.setThumbPath(frm_img_thumb);
			newsVo.setTaglist(frm_tag_list);
			newsVo.setSummary(frm_summary);
			
			resultMap = _Request.setResult("success", "", JSONArray.fromObject(commonService.setNewsSave(newsVo)).toString());
		}catch(Exception ex){
			System.out.println(ex);
			logger.error(ex.getMessage());
			resultMap = _Request.setResult("error", "저장오류가 발생했습니다.", null);
		}
		_Response.outJson(res, resultMap, false, "");
	}
	
	/* 소식지 - TAG Short 목록  */
	@RequestMapping(value="/tag/{param_contnt_seq}", method=RequestMethod.GET)
	public void getTagView(HttpServletRequest req, HttpServletResponse res, @PathVariable int param_contnt_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/IndexServiceController] getTagView");	}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			resultMap = _Request.setResult("success", "", JSONArray.fromObject(commonService.selectTagView(param_contnt_seq)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			resultMap = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, resultMap, false, "");
	}
	
	/* 태그관리 - jtable */
	@RequestMapping(value="/tag", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void getTagList(HttpServletRequest req, HttpServletResponse res, @RequestParam int jtStartIndex, @RequestParam int jtPageSize) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/IndexServiceController] getTagList");	}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			Map<String, Object> fromParam = formDataConvert(req);

			SearchModel searchVo = new SearchModel();
			searchVo.setSearchStartDt(fromParam.get("searchStartDt").toString());
			searchVo.setSearchEndDt(fromParam.get("searchEndDt").toString());
			searchVo.setSearchViewYn(fromParam.get("searchViewYn").toString());
			searchVo.setSearchTitle(URLDecoder.decode(fromParam.get("searchTitle").toString()));
			searchVo.setJtStartIndex(jtStartIndex);
			searchVo.setJtPageSize(jtPageSize);
			
			resultMap = commonService.selectTagList(searchVo); 
		}catch(Exception ex){
			logger.error(ex.getMessage());
			resultMap.put("Result", "ERROR");
			resultMap.put("Message", ex.getMessage());
		}
		_Response.outJson(res, resultMap, false, "");
	}
	
	/* 태그관리 - 등록,수정 (메인노출목록) */
	@RequestMapping(value="/tag/mainview", method=RequestMethod.GET)
	public void getTagMainView(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/IndexServiceController] getTagMainView");	}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			resultMap = _Request.setResult("success", "", JSONArray.fromObject(commonService.getTagMainView()).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			resultMap = _Request.setResult("error", "오류가 발생했습니다.", null);
		}
		_Response.outJson(res, resultMap, false, "");
	}
	
	/* 태그관리 - 등록/수정 */
	@RequestMapping(value="/tag/mng", method=RequestMethod.POST)
	public void getTagManage(HttpServletRequest req, HttpServletResponse res
			, @RequestParam(value="param_tag_nm", defaultValue="",required=false) String param_tag_nm
			, @RequestParam(value="param_tag_seq", defaultValue="",required=false) Integer param_tag_seq
			, @RequestParam(value="param_main_view", defaultValue="", required=false) Integer param_main_view
			, @RequestParam(value="param_tag_view", defaultValue="", required=false) Integer param_tag_view
			, @RequestParam(value="param_user_seq", defaultValue="", required=false) String param_user_seq
			, @RequestParam(value="param_user_nm", defaultValue="", required=false) String param_user_nm
			) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/IndexServiceController] getTagList");	}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			TagModel tagVo = new TagModel();
			if(param_tag_seq != null) { tagVo.setBranchTagSeq(param_tag_seq); }
			tagVo.setTagNm(param_tag_nm);
			tagVo.setMainViewYn(param_main_view);
			tagVo.setViewYn(param_tag_view);
			tagVo.setRegUserSeq(param_user_seq);
			tagVo.setRegUserNm(param_user_nm);
			
			resultMap = commonService.setTagSave(tagVo);
		}catch(Exception ex){
			logger.error(ex.getMessage());
			resultMap = _Request.setResult("error", "저장오류가 발생했습니다.", null);
		}
		_Response.outJson(res, resultMap, false, "");
	}	

	/* 바로가기 관리 - jtable */
	@RequestMapping(value="/direct", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void getDirectList(HttpServletRequest req, HttpServletResponse res, @RequestParam int jtStartIndex, @RequestParam int jtPageSize) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/IndexServiceController] getAdList");	}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			Map<String, Object> fromParam = formDataConvert(req);
			List<Integer> dept_int_arr = new ArrayList<Integer>();
			if(!fromParam.get("searchDeptSeq").toString().equals("") && fromParam.get("searchDeptSeq").toString() != null) {
				String[] dept_arr = URLDecoder.decode(fromParam.get("searchDeptSeq").toString()).split(",");
				for(int i = 0; i < dept_arr.length; i++) {
					dept_int_arr.add(Integer.parseInt(dept_arr[i]));
				}
			}
			
			SearchModel searchVo = new SearchModel();
			searchVo.setSearchType(fromParam.get("searchType").toString());
			searchVo.setSearchTitle(URLDecoder.decode(fromParam.get("searchTitle").toString()));
			searchVo.setSearchDeptSeq(fromParam.get("searchDeptSeq").toString());
			searchVo.setSearchDeptArr(dept_int_arr);
			searchVo.setJtStartIndex(jtStartIndex);
			searchVo.setJtPageSize(jtPageSize);
			
			resultMap = commonService.selectDirectList(searchVo); 
		}catch(Exception ex){
			logger.error(ex.getMessage());
			resultMap.put("Result", "ERROR");
			resultMap.put("Message", ex.getMessage());
		}
		_Response.outJson(res, resultMap, false, "");
	}
	
	/* 배너관리 - jtable */
	@RequestMapping(value="/ad", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void getAdList(HttpServletRequest req, HttpServletResponse res, @RequestParam int jtStartIndex, @RequestParam int jtPageSize) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/IndexServiceController] getAdList");	}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			Map<String, Object> fromParam = formDataConvert(req);

			SearchModel searchVo = new SearchModel();
			searchVo.setSearchType(fromParam.get("searchType").toString());
			searchVo.setSearchTitle(URLDecoder.decode(fromParam.get("searchTitle").toString()));
			searchVo.setSearchDeptSeq(fromParam.get("searchDeptSeq").toString());
			searchVo.setJtStartIndex(jtStartIndex);
			searchVo.setJtPageSize(jtPageSize);
			
			resultMap = commonService.selectAdList(searchVo); 
		}catch(Exception ex){
			logger.error(ex.getMessage());
			resultMap.put("Result", "ERROR");
			resultMap.put("Message", ex.getMessage());
		}
		_Response.outJson(res, resultMap, false, "");
	}

	/* 배너 상세목록/수정  */
	@RequestMapping(value="/ad/view/{param_seq}", method=RequestMethod.GET)
	public void getAdView(HttpServletRequest req, HttpServletResponse res, @PathVariable int param_seq) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/IndexServiceController] getAdView");	}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			resultMap = _Request.setResult("success", "", JSONArray.fromObject(commonService.selectAdView(param_seq)).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			resultMap = _Request.setResult("error", "데이터가 없습니다.", null);
		}
		_Response.outJson(res, resultMap, false, "");
	}
	
	/* 배너 저장  */
	@RequestMapping(value="/ad/save", method=RequestMethod.POST)
	public void setAdSave(HttpServletRequest req, HttpServletResponse res
			, @RequestParam(value="frm_param_seq", defaultValue="",required=false) Integer frm_param_seq
			, @RequestParam(value="frm_reg_user_seq", defaultValue="", required=false) String frm_reg_user_seq
			, @RequestParam(value="frm_reg_user_nm", defaultValue="", required=false) String frm_reg_user_nm
			, @RequestParam(value="frm_img_thumb", defaultValue="", required=false) String frm_img_thumb
			, @RequestParam(value="frm_title", defaultValue="", required=false) String frm_title
			, @RequestParam(value="frm_banner_dept", defaultValue="120",required=false) Integer frm_dept_seq
			, @RequestParam(value="frm_start_dt", defaultValue="", required=false) String frm_start_dt
			, @RequestParam(value="frm_end_dt", defaultValue="", required=false) String frm_end_dt
			, @RequestParam(value="frm_google_code", defaultValue="", required=false) String frm_google_code
			, @RequestParam(value="frm_banner_loc", defaultValue="", required=false) String frm_banner_loc
			, @RequestParam(value="frm_banner_typ", defaultValue="", required=false) String frm_banner_typ
			, @RequestParam(value="frm_link_fl", defaultValue="", required=false) Integer frm_link_fl
			, @RequestParam(value="frm_link_url", defaultValue="", required=false) String frm_link_url
			) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/IndexServiceController] setAdSave");	}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			
			if(frm_link_url.indexOf("?") > -1) {
				if(frm_link_url.indexOf("from=") < 0) { frm_link_url = frm_link_url +"&from="+ frm_google_code; }
			}else {
				frm_link_url = frm_link_url +"?from="+ frm_google_code;
			}
			
			AdModel adVo = new AdModel();
			if(frm_param_seq != null) { adVo.setBannerSeq(frm_param_seq); }
			adVo.setRegUserNm(frm_reg_user_nm);
			adVo.setRegUserSeq(frm_reg_user_seq);
			adVo.setDeptSeq(frm_dept_seq);
			adVo.setStartDt(frm_start_dt.replaceAll("-", ""));
			adVo.setEndDt(frm_end_dt.replaceAll("-", ""));
			adVo.setTitle(frm_title);
			adVo.setBannerImgPath(frm_img_thumb);
			adVo.setLinkTargetFl(frm_link_fl);
			adVo.setLinkUrl(frm_link_url);
			adVo.setGtBannerLoc(frm_banner_loc);
			adVo.setGtBannerTyp(frm_banner_typ);

			resultMap = commonService.setAdSave(adVo);
		}catch(Exception ex){
			logger.error(ex.getMessage());
			resultMap = _Request.setResult("error", "저장오류가 발생했습니다.", null);
		}
		_Response.outJson(res, resultMap, false, "");
	}
	
	/* 유니원 분원동기화 - jtable  */
	@RequestMapping(value="/unione/sync", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	public void getUnioneSyncList(HttpServletRequest req, HttpServletResponse res, @RequestParam int jtStartIndex, @RequestParam int jtPageSize) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/IndexServiceController] getUnioneSyncList");	}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			Map<String, Object> fromParam = formDataConvert(req);

			SearchModel searchVo = new SearchModel();
			if(!fromParam.get("searchDeptSeq").equals("")) {
				searchVo.setSearchDeptSeq(fromParam.get("searchDeptSeq").toString());
			}
			searchVo.setSearchCourse(fromParam.get("searchCourse").toString());
			searchVo.setJtStartIndex(jtStartIndex);
			searchVo.setJtPageSize(jtPageSize);
			
			resultMap = commonService.selectUnioneSyncList(searchVo); 
		}catch(Exception ex){
			logger.error(ex.getMessage());
			resultMap.put("Result", "ERROR");
			resultMap.put("Message", ex.getMessage());
		}
		_Response.outJson(res, resultMap, false, "");
	}
	
	@RequestMapping(value="/unione/apidept", method=RequestMethod.POST)
	public void getUnioneDeptSync(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if(logger.isDebugEnabled()) { logger.debug("[jls-manage/IndexServiceController] getUnioneDeptSync"); }
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			
			UnioneDeptModel unioneVo = new UnioneDeptModel();
			unioneVo.setSyncCode(obj_body.get("syncCode").toString());
			unioneVo.setSyncDept(obj_body.get("syncDept").toString());
			unioneVo.setRegUserSeq(obj_body.get("regUserSeq").toString());
			unioneVo.setRegUserId(obj_body.get("regUserId").toString());
			unioneVo.setRegUserNm(obj_body.get("regUserNm").toString());
			
			resultMap = commonService.setUnioneSync(unioneVo);
			
		}catch(Exception ex) {
			logger.error(ex.getMessage());
			resultMap = _Request.setResult("error", "저장오류가 발생했습니다.", null);
		}
		_Response.outJson(res, resultMap, false, "");
	}
	
	/* Combobox Code */
	@RequestMapping(value="/code/{param_type}", method=RequestMethod.GET)
	public void getCodeList(HttpServletRequest req, HttpServletResponse res, @PathVariable String param_type) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/IndexServiceController] getCodeList");	}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			if(param_type.equals("tag")) {
				List<TagModel> resultList = commonService.selectGetCodeTag();
				resultMap = _Request.setResult("success", "", JSONArray.fromObject(resultList).toString());
			} else if(param_type.equals("dept")) {
				List<DeptModel> resultList = commonService.selectGetCodeDept();
				resultMap = _Request.setResult("success", "", JSONArray.fromObject(resultList).toString());
			} else if(param_type.equals("topdept")) {
				List<DeptModel> resultList = commonService.selectGetCodeDeptTop();
				resultMap = _Request.setResult("success", "", JSONArray.fromObject(resultList).toString());
			} else if(param_type.equals("secdept")) {
				List<DeptModel> resultList = commonService.selectGetCodeDeptSec(Integer.parseInt(req.getParameter("parentDeptSeq").toString()));
				resultMap = _Request.setResult("success", "", JSONArray.fromObject(resultList).toString());
			} else if(param_type.equals("ad")) {
				String ad_code = "BN1";
				List<AdModel> resultList = commonService.selectGetCodeAd(ad_code);
				resultMap = _Request.setResult("success", "", JSONArray.fromObject(resultList).toString());
			} else if(param_type.equals("adsub")) {
				String ad_code = req.getParameter("groupCode");
				List<AdModel> resultList = commonService.selectGetCodeAdSub(ad_code);
				resultMap = _Request.setResult("success", "", JSONArray.fromObject(resultList).toString());
			} else if(param_type.equals("course")) {
				List<DeptModel> resultList = commonService.selectGetCodeCourse();
				resultMap = _Request.setResult("success", "", JSONArray.fromObject(resultList).toString());
			} else if(param_type.equals("coursedept")) {
				String courseSeq = req.getParameter("courseSeq");
				List<DeptModel> resultList = commonService.selectGetCodeCourseDept(courseSeq);
				resultMap = _Request.setResult("success", "", JSONArray.fromObject(resultList).toString());
			}else {
				resultMap = _Request.setResult("error", "데이터가 없습니다.", null);
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			resultMap = _Request.setResult("error", "9999:"+ ex.getMessage(), null);
		}
		_Response.outJson(res, resultMap, false, "");
	}
	
	/* jtable용으로 form seriallize로 보냈을때 */
	@SuppressWarnings("unused")
	private Map<String, Object> formDataConvert(HttpServletRequest req) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/IndexServiceController] formDataConvert");	}
		Map<String, Object> reqmap = new HashMap<String, Object>();
		try{
			String reqdata = _Request.getBody(req);
			System.out.println(reqdata);
			String[] req_param = reqdata.split("\\&",-1);
			for(int i=0; i < req_param.length; i++) {
				String[] req_param_data = req_param[i].split("\\=",-1);
				if(req_param_data[1] != null) {
					reqmap.put(req_param_data[0], req_param_data[1]);
				}
			}
		}catch(Exception ex) {
			logger.error(">> formDataConvert ERROR : "+ ex);
		}
		return reqmap;
	}
}
