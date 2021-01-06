package com.gojls.manage.common.model;

public class NewsModel {
	private int rnum;
	private int noticeSeq;
	private int noticeContntSeq;
	private String noticeTypeNm;
    private String contents;
    private String thumbPath;
	private int deptSeq;
	private String deptNm;
	private String title;
	private int viewCnt;
	private int viewYn;
	private String regUserSeq;
	private String regUserNm;
	private String regTs;
	private String startDt;
	private String endDt;
	private String taglist;
	private String summary;
	
	public int getRnum() {
		return rnum;
	}
	public void setRnum(int rnum) {
		this.rnum = rnum;
	}
	public int getNoticeSeq() {
		return noticeSeq;
	}
	public void setNoticeSeq(int noticeSeq) {
		this.noticeSeq = noticeSeq;
	}
	public int getNoticeContntSeq() {
		return noticeContntSeq;
	}
	public void setNoticeContntSeq(int noticeContntSeq) {
		this.noticeContntSeq = noticeContntSeq;
	}
	public String getNoticeTypeNm() {
		return noticeTypeNm;
	}
	public void setNoticeTypeNm(String noticeTypeNm) {
		this.noticeTypeNm = noticeTypeNm;
	}
	public int getDeptSeq() {
		return deptSeq;
	}
	public void setDeptSeq(int deptSeq) {
		this.deptSeq = deptSeq;
	}
	public String getDeptNm() {
		return deptNm;
	}
	public void setDeptNm(String deptNm) {
		this.deptNm = deptNm;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getViewCnt() {
		return viewCnt;
	}
	public void setViewCnt(int viewCnt) {
		this.viewCnt = viewCnt;
	}
	public int getViewYn() {
		return viewYn;
	}
	public void setViewYn(int viewYn) {
		this.viewYn = viewYn;
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
	public String getRegTs() {
		return regTs;
	}
	public void setRegTs(String regTs) {
		this.regTs = regTs;
	}
	public String getStartDt() {
		return startDt;
	}
	public void setStartDt(String startDt) {
		this.startDt = startDt;
	}

	public String getThumbPath() {
		return thumbPath;
	}
	public void setThumbPath(String thumbPath) {
		this.thumbPath = thumbPath;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public String getEndDt() {
		return endDt;
	}
	public void setEndDt(String endDt) {
		this.endDt = endDt;
	}
	public String getTaglist() {
		return taglist;
	}
	public void setTaglist(String taglist) {
		this.taglist = taglist;
	}
	public String getSummary() {
		return summary;
	}
	public void setSummary(String summary) {
		this.summary = summary;
	}
	
}
