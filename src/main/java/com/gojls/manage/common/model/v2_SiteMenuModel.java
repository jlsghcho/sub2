package com.gojls.manage.common.model;

public class v2_SiteMenuModel {
	private int menu_seq;
	private String menu_nm;
	private int parent_menu_seq;
	private int sort_num;
	private String use_yn;
	private int tree_lev;
	private String menu_cat_arr;
	private String menu_url;
	private String site_type;
	private String sub_menu_codes;
	
	private String sub_menu_code;
	private String sub_menu_nm;
		
	private String save_type;
	private String reg_user_seq;
	private String reg_user_id;
	private String reg_user_nm;
	
	public int getMenu_seq() {
		return menu_seq;
	}
	public void setMenu_seq(int menu_seq) {
		this.menu_seq = menu_seq;
	}
	public String getMenu_nm() {
		return menu_nm;
	}
	public void setMenu_nm(String menu_nm) {
		this.menu_nm = menu_nm;
	}
	public int getParent_menu_seq() {
		return parent_menu_seq;
	}
	public void setParent_menu_seq(int parent_menu_seq) {
		this.parent_menu_seq = parent_menu_seq;
	}
	public int getSort_num() {
		return sort_num;
	}
	public void setSort_num(int sort_num) {
		this.sort_num = sort_num;
	}
	public String getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}
	public int getTree_lev() {
		return tree_lev;
	}
	public void setTree_lev(int tree_lev) {
		this.tree_lev = tree_lev;
	}
	public String getMenu_cat_arr() {
		return menu_cat_arr;
	}
	public void setMenu_cat_arr(String menu_cat_arr) {
		this.menu_cat_arr = menu_cat_arr;
	}
	public String getMenu_url() {
		return menu_url;
	}
	public void setMenu_url(String menu_url) {
		this.menu_url = menu_url;
	}
	public String getSave_type() {
		return save_type;
	}
	public void setSave_type(String save_type) {
		this.save_type = save_type;
	}
	public String getReg_user_seq() {
		return reg_user_seq;
	}
	public void setReg_user_seq(String reg_user_seq) {
		this.reg_user_seq = reg_user_seq;
	}
	public String getReg_user_id() {
		return reg_user_id;
	}
	public void setReg_user_id(String reg_user_id) {
		this.reg_user_id = reg_user_id;
	}
	public String getReg_user_nm() {
		return reg_user_nm;
	}
	public void setReg_user_nm(String reg_user_nm) {
		this.reg_user_nm = reg_user_nm;
	}
	public String getSite_type() {
		return site_type;
	}
	public void setSite_type(String site_type) {
		this.site_type = site_type;
	}
	public String getSub_menu_codes() {
		return sub_menu_codes;
	}
	public void setSub_menu_codes(String sub_menu_codes) {
		this.sub_menu_codes = sub_menu_codes;
	}
	public String getSub_menu_code() {
		return sub_menu_code;
	}
	public void setSub_menu_code(String sub_menu_code) {
		this.sub_menu_code = sub_menu_code;
	}
	public String getSub_menu_nm() {
		return sub_menu_nm;
	}
	public void setSub_menu_nm(String sub_menu_nm) {
		this.sub_menu_nm = sub_menu_nm;
	}
}
