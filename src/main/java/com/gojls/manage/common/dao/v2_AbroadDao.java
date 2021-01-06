package com.gojls.manage.common.dao;

import java.util.List;

import com.gojls.manage.common.model.v2_SiteBannerModel;
import com.gojls.manage.common.model.v2_SiteManagerModel;
import com.gojls.manage.common.model.v2_SiteMenuModel;
import com.gojls.manage.common.model.v2_SitePartnerModel;
import com.gojls.manage.common.model.v2_SiteProgramModel;

public interface v2_AbroadDao {
	public List<v2_SiteMenuModel> select_site_menu_list(String site_type);
	public List<v2_SiteMenuModel> select_site_sub_menu_list();
	public int select_site_menu_add_num(int parent_menu_seq);
	public int insert_site_menu(v2_SiteMenuModel menuVo);
	public int update_site_menu(v2_SiteMenuModel menuVo);
	public int update_site_menu_sort(v2_SiteMenuModel menuVo);
	
	public List<v2_SiteBannerModel> select_site_main_banner(String site_type);
	public int update_site_banner_sort(v2_SiteBannerModel bannerVo);
	public int insert_site_banner(v2_SiteBannerModel bannerVo);
	public int update_site_banner(v2_SiteBannerModel bannerVo);
	
	public List<v2_SitePartnerModel> select_site_partner(String site_type);
	public int select_site_partner_sort(v2_SitePartnerModel partnerVo);
	public int insert_site_partner(v2_SitePartnerModel partnerVo);
	public int update_site_partner(v2_SitePartnerModel partnerVo);
	public int update_site_partner_sort(v2_SitePartnerModel partnerVo);
	public int delete_site_partner(int partner_seq);
	
	public List<v2_SiteManagerModel> select_site_manager(String site_type);
	public int select_site_manager_sort(v2_SiteManagerModel managerVo);
	public int insert_site_manager(v2_SiteManagerModel managerVo);
	public int update_site_manager(v2_SiteManagerModel managerVo);
	public int delete_site_manager(int manager_seq);
	public int update_site_manager_sort(v2_SiteManagerModel managerVo);
	
	public List<v2_SiteProgramModel> select_site_program_list(String site_type);
	public List<v2_SiteProgramModel> select_site_program_sub_list(v2_SiteProgramModel programVo);
	public int insert_site_program(v2_SiteProgramModel programVo);
	public int update_site_program(v2_SiteProgramModel programVo);
	public int delete_site_program(int menu_content_seq);
}
