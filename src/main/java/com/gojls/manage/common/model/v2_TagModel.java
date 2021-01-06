package com.gojls.manage.common.model;

public class v2_TagModel {
	private String tag_code;
	private String tag_nm;

	private int branch_tag_seq;
	private int view_yn;
	private String reg_ts;
	private String reg_user_seq;
	private String reg_user_nm;
	private int main_view_yn;
	private int tag_content_cnt;
	
	private int notice_content_seq;
	
	public String getTag_code() {
		return tag_code;
	}
	public void setTag_code(String tag_code) {
		this.tag_code = tag_code;
	}
	public String getTag_nm() {
		return tag_nm;
	}
	public void setTag_nm(String tag_nm) {
		this.tag_nm = tag_nm;
	}
	public int getBranch_tag_seq() {
		return branch_tag_seq;
	}
	public void setBranch_tag_seq(int branch_tag_seq) {
		this.branch_tag_seq = branch_tag_seq;
	}
	public int getView_yn() {
		return view_yn;
	}
	public void setView_yn(int view_yn) {
		this.view_yn = view_yn;
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
	public int getMain_view_yn() {
		return main_view_yn;
	}
	public void setMain_view_yn(int main_view_yn) {
		this.main_view_yn = main_view_yn;
	}
	public int getTag_content_cnt() {
		return tag_content_cnt;
	}
	public void setTag_content_cnt(int tag_content_cnt) {
		this.tag_content_cnt = tag_content_cnt;
	}
	public int getNotice_content_seq() {
		return notice_content_seq;
	}
	public void setNotice_content_seq(int notice_content_seq) {
		this.notice_content_seq = notice_content_seq;
	}
}
