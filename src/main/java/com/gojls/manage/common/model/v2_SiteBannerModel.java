package com.gojls.manage.common.model;

public class v2_SiteBannerModel {
	private int menu_seq;
	private int menu_banner_seq;
	private String title;
	private int status;
	private int view_yn;
	private String img_path;
	private int order_num;
	private String reg_ts;
	private String reg_user_seq;
	private String reg_user_nm;
	private String reg_user_id;
	private String site_type;
	
	public int getMenu_seq() {
		return menu_seq;
	}
	public void setMenu_seq(int menu_seq) {
		this.menu_seq = menu_seq;
	}
	public int getMenu_banner_seq() {
		return menu_banner_seq;
	}
	public void setMenu_banner_seq(int menu_banner_seq) {
		this.menu_banner_seq = menu_banner_seq;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public int getView_yn() {
		return view_yn;
	}
	public void setView_yn(int view_yn) {
		this.view_yn = view_yn;
	}
	public String getImg_path() {
		return img_path;
	}
	public void setImg_path(String img_path) {
		this.img_path = img_path;
	}
	public int getOrder_num() {
		return order_num;
	}
	public void setOrder_num(int order_num) {
		this.order_num = order_num;
	}
	public String getReg_ts() {
		return reg_ts;
	}
	public void setReg_ts(String reg_ts) {
		this.reg_ts = reg_ts;
	}
	public String getReg_user_seq() {
		return reg_user_seq;
	}
	public void setReg_user_seq(String reg_user_seq) {
		this.reg_user_seq = reg_user_seq;
	}
	public String getReg_user_nm() {
		return reg_user_nm;
	}
	public void setReg_user_nm(String reg_user_nm) {
		this.reg_user_nm = reg_user_nm;
	}
	public String getReg_user_id() {
		return reg_user_id;
	}
	public void setReg_user_id(String reg_user_id) {
		this.reg_user_id = reg_user_id;
	}
	public String getSite_type() {
		return site_type;
	}
	public void setSite_type(String site_type) {
		this.site_type = site_type;
	}
}
