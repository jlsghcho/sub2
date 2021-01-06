package com.gojls.manage.common.model;

public class v2_SiteContentModel {
    private int site_content_seq;
    private String title;
    private String contents;
    private String file_path;
    private String thumbnail_path;
    private int view_yn;
    private int view_cnt;
    private String reg_ts;
    private String reg_user_seq;
    private String reg_user_id;
    private String reg_user_nm;
    
    private String site_type;
    private String preview_text;
    private String content_type;
    private String tag_select_list;
    private String tag_select_list_nm;
    private int site_tag_seq;
    
	public int getSite_content_seq() {
		return site_content_seq;
	}
	public void setSite_content_seq(int site_content_seq) {
		this.site_content_seq = site_content_seq;
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
	public String getFile_path() {
		return file_path;
	}
	public void setFile_path(String file_path) {
		this.file_path = file_path;
	}
	public String getThumbnail_path() {
		return thumbnail_path;
	}
	public void setThumbnail_path(String thumbnail_path) {
		this.thumbnail_path = thumbnail_path;
	}
	public int getView_yn() {
		return view_yn;
	}
	public void setView_yn(int view_yn) {
		this.view_yn = view_yn;
	}
	public int getView_cnt() {
		return view_cnt;
	}
	public void setView_cnt(int view_cnt) {
		this.view_cnt = view_cnt;
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
	public String getSite_type() {
		return site_type;
	}
	public void setSite_type(String site_type) {
		this.site_type = site_type;
	}
	public String getPreview_text() {
		return preview_text;
	}
	public void setPreview_text(String preview_text) {
		this.preview_text = preview_text;
	}
	public String getContent_type() {
		return content_type;
	}
	public void setContent_type(String content_type) {
		this.content_type = content_type;
	}
	public int getSite_tag_seq() {
		return site_tag_seq;
	}
	public void setSite_tag_seq(int site_tag_seq) {
		this.site_tag_seq = site_tag_seq;
	}
	public String getReg_user_id() {
		return reg_user_id;
	}
	public void setReg_user_id(String reg_user_id) {
		this.reg_user_id = reg_user_id;
	}
	public String getTag_select_list() {
		return tag_select_list;
	}
	public void setTag_select_list(String tag_select_list) {
		this.tag_select_list = tag_select_list;
	}
	public String getTag_select_list_nm() {
		return tag_select_list_nm;
	}
	public void setTag_select_list_nm(String tag_select_list_nm) {
		this.tag_select_list_nm = tag_select_list_nm;
	}
}
