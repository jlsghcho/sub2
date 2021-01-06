package com.gojls.manage.common.service;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

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

@Transactional(readOnly=true, rollbackFor={Exception.class})
public interface v2_AbroadService {

	public List<v2_SiteMenuModel> sv_select_menu_list(String site_type);
	public List<v2_SiteMenuModel> sv_select_sub_menu_list();
	public int sv_insert_menu(v2_SiteMenuModel menuVo);
	public int sv_update_menu(v2_SiteMenuModel menuVo);
	public int sv_update_sort_menu(v2_SiteMenuModel menuVo, String data);
	
	public List<v2_SiteBannerModel> sv_select_site_main_banner(String site_type);
	public int sv_site_banner_save_sort(String data);
	public int sv_site_banner_save(v2_SiteBannerModel bannerVo);
	
	public List<v2_SitePartnerModel> sv_select_site_partner(String site_type);
	public int sv_site_partner_save(v2_SitePartnerModel partnerVo);
	public int sv_site_partner_save_sort(String data);
	public int sv_site_partner_delete(int partner_seq);
	
	public List<v2_SiteManagerModel> sv_select_site_manager(String site_type);
	public int sv_site_manager_save(v2_SiteManagerModel managerVo);
	public int sv_site_manager_delete(int manager_seq);
	public int sv_site_manager_save_sort(String data);

	public List<v2_SiteProgramModel> sv_select_site_program(String site_type);
	public List<v2_SiteProgramModel> sv_select_site_program_info(v2_SiteProgramModel programVo);
	public int sv_site_program_save(v2_SiteProgramModel programVo);

	/* 프로그램 컨텐츠 삭제 */
	public int sv_site_program_delete(int menu_content_seq);
	
	
	/* 커뮤니티 > 태그 */
	public List<v2_SiteTagModel> sv_select_site_tag(v2_SiteSearchModel searchVo);
	public int sv_site_tag_save(v2_SiteTagModel tagVo);
	
	public List<v2_SiteContentModel> sv_select_site_content(v2_SiteSearchModel searchVo);
	public int sv_select_site_content_save(v2_SiteContentModel contentVo);
	public int sv_select_site_content_delete(v2_SiteContentModel contentVo);
	public int sv_select_site_content_tag_update(v2_SiteContentModel contentVo);
	public v2_SiteContentModel sv_select_site_content_detail(int site_content_seq);
	
	/* MY유학 > 1:1상담 */
	public List<v2_SiteCounselModel> sv_select_site_counsel_list(v2_SiteSearchModel searchVo);
	public int sv_site_counsel_save(v2_SiteCounselModel counselVo);
	public List<v2_SiteCounselModel> sv_select_site_counsel_view(int site_counsel_seq);
	public List<v2_SiteFileModel> sv_select_site_counsel_reply_file(int site_counsel_reply_seq);
	public int sv_site_counsel_reply_save(v2_SiteCounselModel counselVo);
	public int sv_delete_site_counsel_list(int site_counsel_seq);
	public int sv_delete_site_counsel_reply(int site_counsel_reply_seq);
	
	/* MY유학 > 리포트 */
	public List<v2_SiteReportModel> sv_select_site_report_list(v2_SiteSearchModel searchVo);
	public int sv_site_report_save(v2_SiteReportModel reportVo);
	public int sv_delete_site_report_list(int site_report_user_seq);
	public List<v2_SiteReportModel> sv_select_site_report_view(int param_site_report_seq);

	/* 예약관리 > 설명회/캠프 예약설정
	public List<v2_ReserveMstModel> sv_select_reserve_mst_list(v2_SearchModel searchVo);
	public List<v2_ReserveMstModel> sv_select_reserve_info(v2_ReserveMstModel reserveMstVo);
	public int sv_reserve_save(v2_ReserveMstModel reserveMstVo);
	public int sv_delete_reserve_mst(v2_ReserveProgramModel reserveProgramVo);
	public int sv_delete_reserve_program(v2_ReserveProgramModel reserveProgramVo);
	public int sv_delete_reserve_seminar_user(v2_ReserveSeminarUserModel reserveSeminarUserVo);
	public int sv_delete_reserve_camp_user(v2_ReserveCampUserModel reserveCampUserVo);
	 */
}