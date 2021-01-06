package com.gojls.manage.common.model;

import java.util.List;

public class SearchModel {
	private String searchStartDt;
	private String searchEndDt;
	private String searchTitle;
	private String searchDeptSeq;
	private String searchTag;
	private String searchViewYn;
	private String searchType;
	private String searchBranchType;
	private List<Integer> searchDeptArr;
	
	private String searchCourse;
	
	private int jtStartIndex;
	private int jtPageSize;
	
	public String getSearchStartDt() {
		return searchStartDt;
	}
	public void setSearchStartDt(String searchStartDt) {
		this.searchStartDt = searchStartDt;
	}
	public String getSearchEndDt() {
		return searchEndDt;
	}
	public void setSearchEndDt(String searchEndDt) {
		this.searchEndDt = searchEndDt;
	}
	public String getSearchTitle() {
		return searchTitle;
	}
	public void setSearchTitle(String searchTitle) {
		this.searchTitle = searchTitle;
	}

	public String getSearchTag() {
		return searchTag;
	}
	public void setSearchTag(String searchTag) {
		this.searchTag = searchTag;
	}
	public String getSearchViewYn() {
		return searchViewYn;
	}
	public void setSearchViewYn(String searchViewYn) {
		this.searchViewYn = searchViewYn;
	}
	public int getJtPageSize() {
		return jtPageSize;
	}
	public void setJtPageSize(int jtPageSize) {
		this.jtPageSize = jtPageSize;
	}
	public int getJtStartIndex() {
		return jtStartIndex;
	}
	public void setJtStartIndex(int jtStartIndex) {
		this.jtStartIndex = jtStartIndex;
	}
	public String getSearchType() {
		return searchType;
	}
	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}
	public String getSearchCourse() {
		return searchCourse;
	}
	public void setSearchCourse(String searchCourse) {
		this.searchCourse = searchCourse;
	}
	public String getSearchBranchType() {
		return searchBranchType;
	}
	public void setSearchBranchType(String searchBranchType) {
		this.searchBranchType = searchBranchType;
	}
	public String getSearchDeptSeq() {
		return searchDeptSeq;
	}
	public void setSearchDeptSeq(String searchDeptSeq) {
		this.searchDeptSeq = searchDeptSeq;
	}
	public List<Integer> getSearchDeptArr() {
		return searchDeptArr;
	}
	public void setSearchDeptArr(List<Integer> searchDeptArr) {
		this.searchDeptArr = searchDeptArr;
	}
}
