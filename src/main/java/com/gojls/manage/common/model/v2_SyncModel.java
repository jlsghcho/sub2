package com.gojls.manage.common.model;

import java.util.ArrayList;

public class v2_SyncModel {
	private int rnum;
	private int dept_seq;
	private String dept_nm;
	private String dept_mobile_nm;
	private String boss_nm;
	private String dept_tel;
	private int dept_intro;
	private String zip_code;
	private String corp_nm;
	private int status;
	
	private ArrayList<Long> param_dept_arr;
	private String param_sync_type;
	private String param_link_url;
	private String reg_user_seq;
	private String reg_user_id;
	private String reg_user_nm;
	
	public int getRnum() {
		return rnum;
	}
	public void setRnum(int rnum) {
		this.rnum = rnum;
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
	public String getDept_mobile_nm() {
		return dept_mobile_nm;
	}
	public void setDept_mobile_nm(String dept_mobile_nm) {
		this.dept_mobile_nm = dept_mobile_nm;
	}
	public String getBoss_nm() {
		return boss_nm;
	}
	public void setBoss_nm(String boss_nm) {
		this.boss_nm = boss_nm;
	}
	public String getDept_tel() {
		return dept_tel;
	}
	public void setDept_tel(String dept_tel) {
		this.dept_tel = dept_tel;
	}
	public int getDept_intro() {
		return dept_intro;
	}
	public void setDept_intro(int dept_intro) {
		this.dept_intro = dept_intro;
	}
	public String getZip_code() {
		return zip_code;
	}
	public void setZip_code(String zip_code) {
		this.zip_code = zip_code;
	}
	public String getCorp_nm() {
		return corp_nm;
	}
	public void setCorp_nm(String corp_nm) {
		this.corp_nm = corp_nm;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public ArrayList<Long> getParam_dept_arr() {
		return param_dept_arr;
	}
	public void setParam_dept_arr(ArrayList<Long> param_dept_arr) {
		this.param_dept_arr = param_dept_arr;
	}
	public String getParam_link_url() {
		return param_link_url;
	}
	public void setParam_link_url(String param_link_url) {
		this.param_link_url = param_link_url;
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
	public String getParam_sync_type() {
		return param_sync_type;
	}
	public void setParam_sync_type(String param_sync_type) {
		this.param_sync_type = param_sync_type;
	}

}
