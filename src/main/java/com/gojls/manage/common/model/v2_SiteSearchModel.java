package com.gojls.manage.common.model;

import java.util.List;

public class v2_SiteSearchModel {
	private String search_context;
	private String site_type;
	private List<String> content_type_arr;
	private String content_type;
	private List<String> tag_type;
	private int page_start_num;
	private int page_size;
	private String search_start_dt;
	private String search_end_dt;
	private List<String> search_dept_arr;
	private String search_dept;
	
	public String getSearch_context() {
		return search_context;
	}
	public void setSearch_context(String search_context) {
		this.search_context = search_context;
	}
	public String getSite_type() {
		return site_type;
	}
	public void setSite_type(String site_type) {
		this.site_type = site_type;
	}
	public String getContent_type() {
		return content_type;
	}
	public void setContent_type(String content_type) {
		this.content_type = content_type;
	}
	public List<String> getTag_type() {
		return tag_type;
	}
	public void setTag_type(List<String> tag_type) {
		this.tag_type = tag_type;
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
	public List<String> getSearch_dept_arr() {
		return search_dept_arr;
	}
	public void setSearch_dept_arr(List<String> search_dept_arr) {
		this.search_dept_arr = search_dept_arr;
	}
	public String getSearch_dept() {
		return search_dept;
	}
	public void setSearch_dept(String search_dept) {
		this.search_dept = search_dept;
	}
	public List<String> getContent_type_arr() {
		return content_type_arr;
	}
	public void setContent_type_arr(List<String> content_type_arr) {
		this.content_type_arr = content_type_arr;
	}
}
