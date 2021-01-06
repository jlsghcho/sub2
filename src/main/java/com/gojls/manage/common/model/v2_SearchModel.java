package com.gojls.manage.common.model;

import java.util.List;

public class v2_SearchModel {
	private List<String> search_type;
	private List<String> search_status;
	private String search_dept;
	private List<String> search_dept_arr;
	private String search_context;
	private int page_start_num;
	private int page_size;
	private String search_emp_type;

	private List<String> search_tag;
	private String search_start_dt;
	private String search_end_dt;
	
	private String org_reg_ts;
	
	public List<String> getSearch_type() {
		return search_type;
	}
	public void setSearch_type(List<String> search_type) {
		this.search_type = search_type;
	}
	public List<String> getSearch_status() {
		return search_status;
	}
	public void setSearch_status(List<String> search_status) {
		this.search_status = search_status;
	}
	public String getSearch_dept() {
		return search_dept;
	}
	public void setSearch_dept(String search_dept) {
		this.search_dept = search_dept;
	}
	public String getSearch_context() {
		return search_context;
	}
	public void setSearch_context(String search_context) {
		this.search_context = search_context;
	}
	public int getPage_start_num() {
		return page_start_num;
	}
	public void setPage_start_num(int page_start_num) {
		this.page_start_num = page_start_num;
	}
	public int getPage_size() {
		return page_size;
	}
	public void setPage_size(int page_size) {
		this.page_size = page_size;
	}
	public List<String> getSearch_tag() {
		return search_tag;
	}
	public void setSearch_tag(List<String> search_tag) {
		this.search_tag = search_tag;
	}
	public String getSearch_start_dt() {
		return search_start_dt;
	}
	public void setSearch_start_dt(String search_start_dt) {
		this.search_start_dt = search_start_dt;
	}
	public String getSearch_end_dt() {
		return search_end_dt;
	}
	public void setSearch_end_dt(String search_end_dt) {
		this.search_end_dt = search_end_dt;
	}
	public String getSearch_emp_type() {
		return search_emp_type;
	}
	public void setSearch_emp_type(String search_emp_type) {
		this.search_emp_type = search_emp_type;
	}
	public List<String> getSearch_dept_arr() {
		return search_dept_arr;
	}
	public void setSearch_dept_arr(List<String> search_dept_arr) {
		this.search_dept_arr = search_dept_arr;
	}
	public String getOrg_reg_ts() {
		return org_reg_ts;
	}
	public void setOrg_reg_ts(String org_reg_ts) {
		this.org_reg_ts = org_reg_ts;
	}
}
