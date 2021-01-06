package com.gojls.manage.common.model;

public class v2_SiteProgramModel {
	private int parent_menu_seq;
	private String parent_menu_nm;
	private int menu_seq;
	private String menu_nm;
	
	private int menu_content_seq;
	private String content_type;
	private String video_url;
	private String use_yn;
	private int order_num;
	private String site_type;
	private String title;
	private String contents;
	private String thumbnail_path;
	
	private String reg_user_seq;
	private String reg_user_id;
	private String reg_user_nm;
	private String reg_ts;
	
	public int getParent_menu_seq() {
		return parent_menu_seq;
	}
	public void setParent_menu_seq(int parent_menu_seq) {
		this.parent_menu_seq = parent_menu_seq;
	}
	public String getParent_menu_nm() {
		return parent_menu_nm;
	}
	public void setParent_menu_nm(String parent_menu_nm) {
		this.parent_menu_nm = parent_menu_nm;
	}
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
	public String getContent_type() {
		return content_type;
	}
	public void setContent_type(String content_type) {
		this.content_type = content_type;
	}
	public String getVideo_url() {
		return video_url;
	}
	public void setVideo_url(String video_url) {
		this.video_url = video_url;
	}
	public String getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}
	public int getOrder_num() {
		return order_num;
	}
	public void setOrder_num(int order_num) {
		this.order_num = order_num;
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
	public int getMenu_content_seq() {
		return menu_content_seq;
	}
	public void setMenu_content_seq(int menu_content_seq) {
		this.menu_content_seq = menu_content_seq;
	}
	public String getSite_type() {
		return site_type;
	}
	public void setSite_type(String site_type) {
		this.site_type = site_type;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public String getThumbnail_path() {
		return thumbnail_path;
	}
	public void setThumbnail_path(String thumbnail_path) {
		this.thumbnail_path = thumbnail_path;
	}
	public String getReg_ts() {
		return reg_ts;
	}
	public void setReg_ts(String reg_ts) {
		this.reg_ts = reg_ts;
	}
}
