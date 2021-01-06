package com.gojls.manage.common.model;

import java.util.List;

public class v2_IRModel {
	private int ir_board_seq;
	private String ir_type;
	private String title;
    private String editor_txt;
	private String view_start_dt;
	private String view_end_dt;
	private int view_cnt;
	private int use_yn;
	private String reg_user_seq;
	private String reg_user_nm;
	private String reg_ts;
	private int cnt;
	private List<v2_IRFileModel> file_list;
	private String org_reg_ts;
	
	public int getIr_board_seq() {
		return ir_board_seq;
	}
	public void setIr_board_seq(int ir_board_seq) {
		this.ir_board_seq = ir_board_seq;
	}
	public String getIr_type() {
		return ir_type;
	}
	public void setIr_type(String ir_type) {
		this.ir_type = ir_type;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getEditor_txt() {
		return editor_txt;
	}
	public void setEditor_txt(String editor_txt) {
		this.editor_txt = editor_txt;
	}
	public String getView_start_dt() {
		return view_start_dt;
	}
	public void setView_start_dt(String view_start_dt) {
		this.view_start_dt = view_start_dt;
	}
	public String getView_end_dt() {
		return view_end_dt;
	}
	public void setView_end_dt(String view_end_dt) {
		this.view_end_dt = view_end_dt;
	}
	public int getView_cnt() {
		return view_cnt;
	}
	public void setView_cnt(int view_cnt) {
		this.view_cnt = view_cnt;
	}
	public int getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(int use_yn) {
		this.use_yn = use_yn;
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
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	public List<v2_IRFileModel> getFile_list() {
		return file_list;
	}
	public void setFile_list(List<v2_IRFileModel> file_list) {
		this.file_list = file_list;
	}
	public String getOrg_reg_ts() {
		return org_reg_ts;
	}
	public void setOrg_reg_ts(String org_reg_ts) {
		this.org_reg_ts = org_reg_ts;
	} 
	
	
	
}
