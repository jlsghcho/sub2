package com.gojls.manage.common.model;

public class TagModel {
	private int branchTagSeq;
	private String tagCode;
	private String tagNm;
	private int viewYn;
	private int mainViewYn;
	private String regTs;
	private String regUserSeq;
	private String regUserNm;
	private int branchContentSeq;
	private int rnum;
	private int tagContntCnt;
	
	public String getTagCode() {
		return tagCode;
	}
	public void setTagCode(String tagCode) {
		this.tagCode = tagCode;
	}
	public String getTagNm() {
		return tagNm;
	}
	public void setTagNm(String tagNm) {
		this.tagNm = tagNm;
	}
	public int getViewYn() {
		return viewYn;
	}
	public void setViewYn(int viewYn) {
		this.viewYn = viewYn;
	}
	public String getRegTs() {
		return regTs;
	}
	public void setRegTs(String regTs) {
		this.regTs = regTs;
	}
	public String getRegUserSeq() {
		return regUserSeq;
	}
	public void setRegUserSeq(String regUserSeq) {
		this.regUserSeq = regUserSeq;
	}
	public String getRegUserNm() {
		return regUserNm;
	}
	public void setRegUserNm(String regUserNm) {
		this.regUserNm = regUserNm;
	}
	public int getBranchContentSeq() {
		return branchContentSeq;
	}
	public void setBranchContentSeq(int branchContentSeq) {
		this.branchContentSeq = branchContentSeq;
	}
	public int getBranchTagSeq() {
		return branchTagSeq;
	}
	public void setBranchTagSeq(int branchTagSeq) {
		this.branchTagSeq = branchTagSeq;
	}
	public int getRnum() {
		return rnum;
	}
	public void setRnum(int rnum) {
		this.rnum = rnum;
	}
	public int getMainViewYn() {
		return mainViewYn;
	}
	public void setMainViewYn(int mainViewYn) {
		this.mainViewYn = mainViewYn;
	}
	public int getTagContntCnt() {
		return tagContntCnt;
	}
	public void setTagContntCnt(int tagContntCnt) {
		this.tagContntCnt = tagContntCnt;
	}
}
