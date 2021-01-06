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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.gojls.manage.common.controller._HttpComponent;
import com.gojls.manage.common.dao.v2_AbroadDao;
import com.gojls.manage.common.dao.v2_AbroadPostDao;
import com.gojls.manage.common.dao.v2_ReserveDao;
import com.gojls.manage.common.model.v2_ReserveCampUserModel;
import com.gojls.manage.common.model.v2_ReserveMstModel;
import com.gojls.manage.common.model.v2_ReserveProgramModel;
import com.gojls.manage.common.model.v2_ReserveSeminarUserModel;
import com.gojls.manage.common.model.v2_SearchModel;
import com.gojls.manage.common.model.v2_SiteBannerModel;
import com.gojls.manage.common.model.v2_SiteContentModel;
import com.gojls.manage.common.model.v2_SiteCounselModel;
import com.gojls.manage.common.model.v2_SiteFileModel;
import com.gojls.manage.common.model.v2_SiteManagerModel;
import com.gojls.manage.common.model.v2_SiteMenuModel;
import com.gojls.manage.common.model.v2_SitePartnerModel;
import com.gojls.manage.common.model.v2_SiteProgramModel;
import com.gojls.manage.common.model.v2_SiteReportModel;
import com.gojls.manage.common.model.v2_SiteSearchModel;
import com.gojls.manage.common.model.v2_SiteTagModel;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service
public class v2_AbroadServiceImpl implements v2_AbroadService{
	protected Logger logger = LoggerFactory.getLogger(getClass());

	@Value("#{globalContext['ENCACHE_ABROAD_DEL1']?:''}") private String ENCACHE_ABROAD_DEL1;
	@Value("#{globalContext['ENCACHE_ABROAD_DEL2']?:''}") private String ENCACHE_ABROAD_DEL2;
	@Value("#{globalContext['ENCACHE_ABROAD_DEL3']?:''}") private String ENCACHE_ABROAD_DEL3;
	@Value("#{globalContext['ABROAD_CODE']?:''}") private String ABROAD_CODE;
	
	@Autowired 
	@Qualifier("oracle")
	private SqlSession sqlSessionOracle;

	public List<v2_SiteMenuModel> sv_select_menu_list(String site_type) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_menu_list(site_type)");}
		v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class); 
		return abroadDao.select_site_menu_list(site_type);
	}

	public List<v2_SiteMenuModel> sv_select_sub_menu_list() {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_sub_menu_list()");}
		v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class); 
		return abroadDao.select_site_sub_menu_list();
	}
	
	public int sv_insert_menu(v2_SiteMenuModel menuVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_insert_menu(menuVo)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class);
			menuVo.setSort_num(abroadDao.select_site_menu_add_num(menuVo.getParent_menu_seq()));
			param_rtn_val = abroadDao.insert_site_menu(menuVo);
			
			if(sv_ehcache_delete("site_menu") == 0) { throw new Exception(); }
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;
	}

	public int sv_update_menu(v2_SiteMenuModel menuVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_update_menu(menuVo)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class); 
			param_rtn_val = abroadDao.update_site_menu(menuVo);
			
			if(sv_ehcache_delete("site_menu") == 0) { throw new Exception(); }
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;
	}

	public int sv_update_sort_menu(v2_SiteMenuModel menuVo, String data) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_update_sort_menu(menuVo)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class); 
			JSONArray list_sort_data = JSONArray.fromObject(data);
			for(int z = 0; z < list_sort_data.size(); z++) {
				menuVo.setMenu_seq(Integer.parseInt(list_sort_data.get(z).toString()));
				menuVo.setSort_num(z+1);
				param_rtn_val = abroadDao.update_site_menu_sort(menuVo);
			}

			if(sv_ehcache_delete("site_menu") == 0) { throw new Exception(); }
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;		
	}

	
	public List<v2_SiteBannerModel> sv_select_site_main_banner(String site_type) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_site_main_banner(site_type)");}
		v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class); 
		return abroadDao.select_site_main_banner(site_type);
	}

	public int sv_site_banner_save(v2_SiteBannerModel bannerVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_site_banner_save(bannerVo)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class); 
			if(bannerVo.getMenu_banner_seq() > 0) {
				param_rtn_val = abroadDao.update_site_banner(bannerVo);
			}else {
				param_rtn_val = abroadDao.insert_site_banner(bannerVo);
			}
			
			if(sv_ehcache_delete("site_banner") == 0) { throw new Exception(); }
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;	
	}

	public int sv_site_banner_save_sort(String data) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_site_banner_save_sort(bannerVo)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class); 
			v2_SiteBannerModel bannerVo = new v2_SiteBannerModel();
			JSONArray list_sort_data = JSONArray.fromObject(data);
			for(int z = 0; z < list_sort_data.size(); z++) {
				JSONObject obj_data = JSONObject.fromObject(list_sort_data.get(z).toString());
				bannerVo.setMenu_banner_seq(obj_data.getInt("id"));
				bannerVo.setOrder_num(z+1);
				param_rtn_val = abroadDao.update_site_banner_sort(bannerVo);
			}			

			if(sv_ehcache_delete("site_banner") == 0) { throw new Exception(); }
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;
	}
	
	public List<v2_SitePartnerModel> sv_select_site_partner(String site_type) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_site_partner(site_type)");}
		v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class); 
		return abroadDao.select_site_partner(site_type);
	}

	public int sv_site_partner_save(v2_SitePartnerModel partnerVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_site_partner_save(partnerVo)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class); 
			partnerVo.setOrder_num(abroadDao.select_site_partner_sort(partnerVo));
			if(partnerVo.getPartner_seq() > 0) {
				param_rtn_val = abroadDao.update_site_partner(partnerVo);
			}else {
				param_rtn_val = abroadDao.insert_site_partner(partnerVo);
			}
			
			if(sv_ehcache_delete("site_partner") == 0) { throw new Exception(); }
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;		
	}

	public int sv_site_partner_save_sort(String data) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_site_partner_save_sort(partnerVo)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class); 

			v2_SitePartnerModel partnerVo = new v2_SitePartnerModel();
			JSONArray list_sort_data = JSONArray.fromObject(data);
			for(int z = 0; z < list_sort_data.size(); z++) {
				partnerVo.setPartner_seq(Integer.parseInt(list_sort_data.get(z).toString()));
				partnerVo.setOrder_num(z+1);
				param_rtn_val = abroadDao.update_site_partner_sort(partnerVo);
			}			
			
			if(sv_ehcache_delete("site_partner") == 0) { throw new Exception(); }
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;		
	}

	public int sv_site_partner_delete(int partner_seq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_site_partner_delete(partner_seq)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class); 
			param_rtn_val = abroadDao.delete_site_partner(partner_seq);
			if(sv_ehcache_delete("site_partner") == 0) { throw new Exception(); }
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;		
	}

	
	public List<v2_SiteManagerModel> sv_select_site_manager(String site_type) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_site_manager(site_type)");}
		v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class); 
		return abroadDao.select_site_manager(site_type);
	}

	public int sv_site_manager_save(v2_SiteManagerModel managerVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_site_manager_save(managerVo)");}
		
		int param_rtn_val = 0;
		try {
			v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class); 
			managerVo.setOrder_num(abroadDao.select_site_manager_sort(managerVo));
			if(managerVo.getStaff_seq() > 0) {
				param_rtn_val = abroadDao.update_site_manager(managerVo);
			}else {
				param_rtn_val = abroadDao.insert_site_manager(managerVo);
			}
			
			if(sv_ehcache_delete("site_manager") == 0) { throw new Exception(); }
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;			
	}

	public int sv_site_manager_delete(int manager_seq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_site_partner_delete(partner_seq)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class); 
			param_rtn_val = abroadDao.delete_site_manager(manager_seq);
			if(sv_ehcache_delete("site_manager") == 0) { throw new Exception(); }
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;		
	}

	public int sv_site_manager_save_sort(String data) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_site_manager_save_sort(managerVo)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class);
			v2_SiteManagerModel managerVo = new v2_SiteManagerModel();
			JSONArray list_sort_data = JSONArray.fromObject(data);
			for(int z = 0; z < list_sort_data.size(); z++) {
				managerVo.setStaff_seq(Integer.parseInt(list_sort_data.get(z).toString()));
				managerVo.setOrder_num(z+1);
				param_rtn_val = abroadDao.update_site_manager_sort(managerVo);
			}

			if(sv_ehcache_delete("site_manager") == 0) { throw new Exception(); }
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;		
	}

	
	public List<v2_SiteProgramModel> sv_select_site_program(String site_type) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_site_program(site_type)");}
		v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class); 
		return abroadDao.select_site_program_list(site_type);
	}

	public int sv_site_program_save(v2_SiteProgramModel programVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_site_program_save(programVo)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class); 
			if(programVo.getMenu_content_seq() > 0) {
				param_rtn_val = abroadDao.update_site_program(programVo);
			}else {
				param_rtn_val = abroadDao.insert_site_program(programVo);
			}
			
			if(sv_ehcache_delete("site_menu_cont") == 0) { throw new Exception(); }
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;			
	}

	public List<v2_SiteProgramModel> sv_select_site_program_info(v2_SiteProgramModel programVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_site_program_info(programVo)");}
		v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class); 
		return abroadDao.select_site_program_sub_list(programVo);
	}
	
	/* 프로그램 삭제 */
	public int sv_site_program_delete(int menu_content_seq){
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_site_program_delete(menu_content_seq)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadDao abroadDao = sqlSessionOracle.getMapper(v2_AbroadDao.class); 
			param_rtn_val =  abroadDao.delete_site_program(menu_content_seq);	
			
			if(sv_ehcache_delete("site_menu_cont") == 0) { throw new Exception(); }
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;	
	}
		
	
	/* 커뮤니티 > 태그 */
	public List<v2_SiteTagModel> sv_select_site_tag(v2_SiteSearchModel searchVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_site_tag(searchVo)");}
		v2_AbroadPostDao abroadPostDao = sqlSessionOracle.getMapper(v2_AbroadPostDao.class); 
		return abroadPostDao.select_site_post_tag(searchVo);
	}

	public int sv_site_tag_save(v2_SiteTagModel tagVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_site_tag_save(tagVo)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadPostDao abroadPostDao = sqlSessionOracle.getMapper(v2_AbroadPostDao.class);
			if(tagVo.getOrder_num() > 0) { abroadPostDao.update_site_post_tag_sort(tagVo); }
			if(tagVo.getSite_tag_seq() > 0) {
				param_rtn_val = abroadPostDao.update_site_post_tag(tagVo);
			}else {
				param_rtn_val = abroadPostDao.insert_site_post_tag(tagVo);
			}
			if(sv_ehcache_delete("site_content_tag") == 0) { throw new Exception(); }
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
		}
		return param_rtn_val;
	}
	
	public List<v2_SiteContentModel> sv_select_site_content(v2_SiteSearchModel searchVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_site_content(searchVo)");}
		v2_AbroadPostDao abroadPostDao = sqlSessionOracle.getMapper(v2_AbroadPostDao.class); 
		return abroadPostDao.select_site_content_list(searchVo);
	}
	
	public int sv_select_site_content_save(v2_SiteContentModel contentVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_site_content_save(contentVo)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadPostDao abroadPostDao = sqlSessionOracle.getMapper(v2_AbroadPostDao.class);
			if(contentVo.getSite_content_seq() > 0) {
				param_rtn_val = abroadPostDao.update_site_content(contentVo);
			}else {
				param_rtn_val = abroadPostDao.insert_site_content(contentVo);
			}
			
			if(!contentVo.getTag_select_list().equals("")) {
				Map<String, Object> param_tag_map = new HashMap<String, Object>();
				List<v2_SiteContentModel> param_tag_arr = new ArrayList<v2_SiteContentModel>();
				String[] tag_seq_arr = contentVo.getTag_select_list().split(",");
				for(int i = 0; i < tag_seq_arr.length; i++ ) {
					v2_SiteContentModel sub_contentVo = new v2_SiteContentModel();
					sub_contentVo.setSite_content_seq(contentVo.getSite_content_seq());
					sub_contentVo.setSite_tag_seq(Integer.parseInt(tag_seq_arr[i].toString()));
					param_tag_arr.add(sub_contentVo);
				}
				param_tag_map.put("data", param_tag_arr);
				param_rtn_val = abroadPostDao.delete_site_content_tag(contentVo);
				param_rtn_val = abroadPostDao.insert_site_content_tag(param_tag_map);
			}
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
			param_rtn_val = 0;
		}
		return param_rtn_val;
	}
	
	public int sv_select_site_content_tag_update(v2_SiteContentModel contentVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_site_content_tag_update(contentVo)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadPostDao abroadPostDao = sqlSessionOracle.getMapper(v2_AbroadPostDao.class);
			if(!contentVo.getTag_select_list().equals("")) {
				Map<String, Object> param_tag_map = new HashMap<String, Object>();
				List<v2_SiteContentModel> param_tag_arr = new ArrayList<v2_SiteContentModel>();
				String[] tag_seq_arr = contentVo.getTag_select_list().split(",");
				for(int i = 0; i < tag_seq_arr.length; i++ ) {
					v2_SiteContentModel sub_contentVo = new v2_SiteContentModel();
					sub_contentVo.setSite_content_seq(contentVo.getSite_content_seq());
					sub_contentVo.setSite_tag_seq(Integer.parseInt(tag_seq_arr[i].toString()));
					param_tag_arr.add(sub_contentVo);
				}
				param_tag_map.put("data", param_tag_arr);
				param_rtn_val = abroadPostDao.delete_site_content_tag(contentVo);
				param_rtn_val = abroadPostDao.insert_site_content_tag(param_tag_map);
			}
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
			param_rtn_val = 0;
		}
		return param_rtn_val;
	}
	
	public int sv_select_site_content_delete(v2_SiteContentModel contentVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_site_content_delete(contentVo)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadPostDao abroadPostDao = sqlSessionOracle.getMapper(v2_AbroadPostDao.class);
			param_rtn_val = abroadPostDao.delete_site_content(contentVo);
			param_rtn_val = abroadPostDao.delete_site_content_tag(contentVo);
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
			param_rtn_val = 0;
		}
		return param_rtn_val;
	}
	
	public v2_SiteContentModel sv_select_site_content_detail(int site_content_seq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_site_content_detail(site_content_seq)");}
		v2_AbroadPostDao abroadPostDao = sqlSessionOracle.getMapper(v2_AbroadPostDao.class); 
		return abroadPostDao.select_site_content_detail(site_content_seq);
	}

	
	/* 프론트쪽 캐시 지우기 소스 */
	private int sv_ehcache_delete(String ehcache_type) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_ehcache_delete("+ ehcache_type +")");}
		int param_rtn_val = 1;
		try {
			HttpHeaders headers = new HttpHeaders();
			headers.set("x-event-url", "manage");
			_HttpComponent http = new _HttpComponent();
			
			String param_type = ehcache_type;
			if(ENCACHE_ABROAD_DEL1 != null && !ENCACHE_ABROAD_DEL1.equals("")){ http.sendGet(ENCACHE_ABROAD_DEL1 +"/"+ param_type, "", headers); }
			if(ENCACHE_ABROAD_DEL2 != null && !ENCACHE_ABROAD_DEL2.equals("")){ http.sendGet(ENCACHE_ABROAD_DEL2 +"/"+ param_type, "", headers); }
			if(ENCACHE_ABROAD_DEL3 != null && !ENCACHE_ABROAD_DEL3.equals("")){ http.sendGet(ENCACHE_ABROAD_DEL3 +"/"+ param_type, "", headers); }
			
		}catch(Exception ex){
			ex.printStackTrace();
			param_rtn_val = 0;
		}
		return param_rtn_val;
	}

	/* MY유학 > 1:1상담 */
	public List<v2_SiteCounselModel> sv_select_site_counsel_list(v2_SiteSearchModel searchVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_site_counsel_list(searchVo)");}
		v2_AbroadPostDao abroadPostDao = sqlSessionOracle.getMapper(v2_AbroadPostDao.class); 
		return abroadPostDao.select_site_counsel_list(searchVo);
	}

	public int sv_delete_site_counsel_list(int site_counsel_seq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_delete_site_counsel_list(site_counsel_seq)");}
		v2_AbroadPostDao abroadPostDao = sqlSessionOracle.getMapper(v2_AbroadPostDao.class); 
		abroadPostDao.delete_site_counsel_file(site_counsel_seq);
		abroadPostDao.delete_site_counsel_reply(site_counsel_seq);
		return abroadPostDao.delete_site_counsel(site_counsel_seq); 
	}
	
	public int sv_site_counsel_save(v2_SiteCounselModel counselVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_site_counsel_save(counselVo)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadPostDao abroadPostDao = sqlSessionOracle.getMapper(v2_AbroadPostDao.class);
			if(counselVo.getSite_counsel_reply_seq() > 0) {
				param_rtn_val = abroadPostDao.update_site_counsel_reply(counselVo);
			}else {
				param_rtn_val = abroadPostDao.insert_site_counsel(counselVo);
				param_rtn_val = abroadPostDao.insert_site_counsel_reply(counselVo);
			}
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
			param_rtn_val = 0;
		}
		return param_rtn_val;
	}

	public List<v2_SiteCounselModel> sv_select_site_counsel_view(int site_counsel_seq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_site_counsel_view(site_counsel_seq)");}
		v2_AbroadPostDao abroadPostDao = sqlSessionOracle.getMapper(v2_AbroadPostDao.class);
		abroadPostDao.update_site_counsel_read_save(site_counsel_seq); // 읽을라고 클릭을 하게 되면 업데이트 Read
		return abroadPostDao.select_site_counsel_view(site_counsel_seq);
	}

	public List<v2_SiteFileModel> sv_select_site_counsel_reply_file(int site_counsel_reply_seq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_site_counsel_reply_file(site_counsel_reply_seq)");}
		v2_AbroadPostDao abroadPostDao = sqlSessionOracle.getMapper(v2_AbroadPostDao.class); 
		return abroadPostDao.select_site_counsel_reply_file(site_counsel_reply_seq);
	}

	public int sv_site_counsel_reply_save(v2_SiteCounselModel counselVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_site_counsel_reply_save(counselVo)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadPostDao abroadPostDao = sqlSessionOracle.getMapper(v2_AbroadPostDao.class);
			param_rtn_val = abroadPostDao.insert_site_counsel_reply(counselVo);
			if(!counselVo.getParam_file_nm().equals("")) {
				String[] file_nm_sp = counselVo.getParam_file_nm().split(",");
				String[] file_path_sp = counselVo.getParam_file_path().split(",");
				ArrayList<v2_SiteFileModel> site_file_arr = new ArrayList<v2_SiteFileModel>();
				for(int i=0; i < file_nm_sp.length; i++) {
					v2_SiteFileModel fileVo = new v2_SiteFileModel();
					fileVo.setFile_nm(file_nm_sp[i]);
					fileVo.setFile_path(file_path_sp[i]);
					fileVo.setSite_counsel_reply_seq(counselVo.getSite_counsel_reply_seq());
					site_file_arr.add(fileVo);
				}
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("list", site_file_arr);
				abroadPostDao.insert_site_counsel_file(map);
			}
			if(param_rtn_val == 1) { abroadPostDao.update_site_counsel(counselVo.getSite_counsel_seq()); } // Reply count update
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
			param_rtn_val = 0;
		}
		return param_rtn_val;
	}

	public int sv_delete_site_counsel_reply(int site_counsel_reply_seq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_delete_site_counsel_reply(site_counsel_reply_seq)");}
		v2_AbroadPostDao abroadPostDao = sqlSessionOracle.getMapper(v2_AbroadPostDao.class);
		int param_rtn_val = 0;
		param_rtn_val = abroadPostDao.delete_site_counsel_file_p(site_counsel_reply_seq);
		param_rtn_val = abroadPostDao.delete_site_counsel_reply_p(site_counsel_reply_seq);
		abroadPostDao.update_site_counsel_cnt(site_counsel_reply_seq); // Reply count update
		return param_rtn_val;
	}

	
	/* MY유학 > 리포트 */
	public List<v2_SiteReportModel> sv_select_site_report_list(v2_SiteSearchModel searchVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_site_report_list(searchVo)");}
		v2_AbroadPostDao abroadPostDao = sqlSessionOracle.getMapper(v2_AbroadPostDao.class); 
		return abroadPostDao.select_site_report_list(searchVo);
	}

	public int sv_site_report_save(v2_SiteReportModel reportVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_site_report_save(reportVo)");}
		int param_rtn_val = 0;
		try {
			v2_AbroadPostDao abroadPostDao = sqlSessionOracle.getMapper(v2_AbroadPostDao.class);
			if(reportVo.getSite_report_user_seq() > 0) {
				param_rtn_val = abroadPostDao.update_site_report(reportVo);
			}else {
				param_rtn_val = abroadPostDao.insert_site_report(reportVo);
			}
			
			abroadPostDao.delete_site_report_file(reportVo.getSite_report_user_seq());
			if(!reportVo.getFile_path_sp().equals("")) {
				String[] file_nm_sp = reportVo.getFile_nm_sp().split(",");
				String[] file_path_sp = reportVo.getFile_path_sp().split(",");
				ArrayList<v2_SiteFileModel> site_file_arr = new ArrayList<v2_SiteFileModel>();
				for(int i=0; i < file_nm_sp.length; i++) {
					v2_SiteFileModel fileVo = new v2_SiteFileModel();
					fileVo.setFile_nm(file_nm_sp[i]);
					fileVo.setFile_path(file_path_sp[i]);
					fileVo.setSite_report_user_seq(reportVo.getSite_report_user_seq());
					site_file_arr.add(fileVo);
				}
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("list", site_file_arr);
				abroadPostDao.insert_site_report_file(map);
			}
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
			param_rtn_val = 0;
		}
		return param_rtn_val;
	}

	public int sv_delete_site_report_list(int site_report_user_seq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_delete_site_report_list(site_report_user_seq)");}
		v2_AbroadPostDao abroadPostDao = sqlSessionOracle.getMapper(v2_AbroadPostDao.class); 
		abroadPostDao.del_site_report_file(site_report_user_seq);
		return abroadPostDao.delete_site_report(site_report_user_seq); 
	}

	public List<v2_SiteReportModel> sv_select_site_report_view(int param_site_report_seq) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_site_report_view(param_site_report_seq)");}
		v2_AbroadPostDao abroadPostDao = sqlSessionOracle.getMapper(v2_AbroadPostDao.class); 
		return abroadPostDao.select_site_report_view(param_site_report_seq);
	}
	
	/*
	
	public List<v2_ReserveMstModel> sv_select_reserve_mst_list(v2_SearchModel searchVo){
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_reserve_mst_list(v2_SearchModel)");}
		v2_ReserveDao reserveDao = sqlSessionOracle.getMapper(v2_ReserveDao.class); 
		return reserveDao.select_reserve_list(searchVo);	
	}
	
	public List<v2_ReserveMstModel> sv_select_reserve_info(v2_ReserveMstModel reserveMstVo){
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_select_reserve_info(v2_ReserveMstModel)");}
		v2_ReserveDao reserveDao = sqlSessionOracle.getMapper(v2_ReserveDao.class);
		return reserveDao.select_reserve_info(reserveMstVo);	
	}
	
	public int sv_reserve_save(v2_ReserveMstModel reserveMstVo){
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_reserve_save(v2_ReserveMstModel)");}
		v2_ReserveDao reserveDao = sqlSessionOracle.getMapper(v2_ReserveDao.class);
		int param_rtn_val = 0;
		try {
			if(reserveMstVo.getSite_reserv_mst_seq() == 0){
				param_rtn_val = reserveDao.insert_reserve_mst(reserveMstVo);				
			}else{
				param_rtn_val = reserveDao.update_reserve_mst(reserveMstVo);				
			}
			if(param_rtn_val > 0){
				System.out.println("idx::"+reserveMstVo.getSite_reserv_mst_seq());
				List<v2_ReserveProgramModel> list = reserveMstVo.getReserve_program_list();
				v2_ReserveProgramModel objModel = null;
				for (int i = 0; i < list.size(); i++) {
					objModel = list.get(i);
					objModel.setSite_reserv_mst_seq(reserveMstVo.getSite_reserv_mst_seq());
					System.out.println("Site_reserv_mst_seq:"+reserveMstVo.getSite_reserv_mst_seq());
					if(objModel.getSite_reserv_program_seq() == 0){			
						objModel.setSite_reserv_mst_seq(reserveMstVo.getSite_reserv_mst_seq());				
						reserveDao.insert_reserve_program(objModel);						
					}else{					
						reserveDao.update_reserve_program(objModel);						
					}
					System.out.println("program idx::"+objModel.getSite_reserv_program_seq());				
				}
			}
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
			param_rtn_val = 0;
		}
		return param_rtn_val;
	}
	
	public int sv_delete_reserve_mst(v2_ReserveProgramModel reserveProgramVo){
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_delete_reserve_mst(v2_ReserveProgramModel)");}
		v2_ReserveDao reserveDao = sqlSessionOracle.getMapper(v2_ReserveDao.class); 
		int param_rtn_val = 0;
		int sub_cnt = 0;
		try {			
			sub_cnt = reserveDao.cnt_reserve_program(reserveProgramVo);
			if(sub_cnt > 0){
				param_rtn_val = -2;					
			}else{
				reserveDao.delete_reserve_program(reserveProgramVo);
				
				param_rtn_val = reserveDao.delete_reserve_mst(reserveProgramVo.getSite_reserv_mst_seq());
			}
		}catch(Exception ex) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ex.printStackTrace();
			param_rtn_val = 0;
		}
		return param_rtn_val;	
	}
	
	public int sv_delete_reserve_program(v2_ReserveProgramModel reserveProgramVo){
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_delete_reserve_program(v2_ReserveProgramModel)");}
		v2_ReserveDao reserveDao = sqlSessionOracle.getMapper(v2_ReserveDao.class); 
		int param_rtn_val = 0;

		param_rtn_val = reserveDao.cnt_reserve_program(reserveProgramVo);
		if(param_rtn_val > 0){
			param_rtn_val = -2;
		}else{
			param_rtn_val = reserveDao.delete_reserve_program(reserveProgramVo);
		}
		
		return param_rtn_val;
	}
	
	public int sv_delete_reserve_seminar_user(v2_ReserveSeminarUserModel reserveSeminarUserVo){
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_delete_reserve_seminar_user(v2_ReserveSeminarUserModel)");}
		v2_ReserveDao reserveDao = sqlSessionOracle.getMapper(v2_ReserveDao.class); 
		return reserveDao.delete_reserve_siminar_user(reserveSeminarUserVo);		
	}
	
	public int sv_delete_reserve_camp_user(v2_ReserveCampUserModel reserveCampUserVo){
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/v2_AbroadServiceImpl] sv_delete_reserve_camp_user(v2_ReserveCampUserModel)");}
		v2_ReserveDao reserveDao = sqlSessionOracle.getMapper(v2_ReserveDao.class); 
		return reserveDao.delete_reserve_camp_user(reserveCampUserVo);		
	}
	*/
}
