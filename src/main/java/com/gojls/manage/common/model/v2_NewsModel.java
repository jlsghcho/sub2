package com.gojls.manage.common.model;

import java.util.List;

public class v2_NewsModel {
    private int rnum;

    private int notice_seq;
    private int notice_content_seq;
    private int dept_seq;
    private String dept_nm;				
    private String title;
    private String reg_user_seq;
    private String reg_user_nm;
    private String reg_ts;
    private String start_dt;
    private String end_dt;
    private int use_status;
    private int view_cnt;
    private int view_yn;
    private int notice_type;
    private String news_img_thumb;
    private String inup_type;
    private List<String> tag_select_type;
    private String preview_txt;
    private String editor_txt;
    private String org_reg_ts;
    
	public int getRnum() {
		return rnum;
	}
	public void setRnum(int rnum) {
		this.rnum = rnum;
	}
	public int getNotice_seq() {
		return notice_seq;
	}
	public void setNotice_seq(int notice_seq) {
		this.notice_seq = notice_seq;
	}
	public int getNotice_content_seq() {
		return notice_content_seq;
	}
	public void setNotice_content_seq(int notice_content_seq) {
		this.notice_content_seq = notice_content_seq;
	}
	public int getDept_seq() {
		return dept_seq;
	}
	public void setDept_seq(int dept_seq) {
		this.dept_seq = dept_seq;
	}
	public String getDept_nm() {
		return dept_nm;
	}
	public void setDept_nm(String dept_nm) {
		this.dept_nm = dept_nm;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
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
	public String getReg_ts() {
		return reg_ts;
	}
	public void setReg_ts(String reg_ts) {
		this.reg_ts = reg_ts;
	}
	public String getStart_dt() {
		return start_dt;
	}
	public void setStart_dt(String start_dt) {
		this.start_dt = start_dt;
	}
	public String getEnd_dt() {
		return end_dt;
	}
	public void setEnd_dt(String end_dt) {
		this.end_dt = end_dt;
	}
	public int getUse_status() {
		return use_status;
	}
	public void setUse_status(int use_status) {
		this.use_status = use_status;
	}
	public int getView_cnt() {
		return view_cnt;
	}
	public void setView_cnt(int view_cnt) {
		this.view_cnt = view_cnt;
	}
	public int getView_yn() {
		return view_yn;
	}
	public void setView_yn(int view_yn) {
		this.view_yn = view_yn;
	}
	public int getNotice_type() {
		return notice_type;
	}
	public void setNotice_type(int notice_type) {
		this.notice_type = notice_type;
	}
	public String getNews_img_thumb() {
		return news_img_thumb;
	}
	public void setNews_img_thumb(String news_img_thumb) {
		this.news_img_thumb = news_img_thumb;
	}
	public String getInup_type() {
		return inup_type;
	}
	public void setInup_type(String inup_type) {
		this.inup_type = inup_type;
	}
	public List<String> getTag_select_type() {
		return tag_select_type;
	}
	public void setTag_select_type(List<String> tag_select_type) {
		this.tag_select_type = tag_select_type;
	}
	public String getPreview_txt() {
		return preview_txt;
	}
	public void setPreview_txt(String preview_txt) {
		this.preview_txt = preview_txt;
	}
	public String getEditor_txt() {
		return editor_txt;
	}
	public void setEditor_txt(String editor_txt) {
		this.editor_txt = editor_txt;
	}
	public String getOrg_reg_ts() {
		return org_reg_ts;
	}
	public void setOrg_reg_ts(String org_reg_ts) {
		this.org_reg_ts = org_reg_ts;
	}

}
