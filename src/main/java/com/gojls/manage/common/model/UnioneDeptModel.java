package com.gojls.manage.common.model;

import java.util.ArrayList;

public class UnioneDeptModel {
	private String syncCode;
	private String syncDept;
	
	private String gojlsurl;
	private ArrayList<Long> deptlist;
	
	private long organizationNo;
	private String name;
	private String ownerName;
	private String description;
	private String phoneNumber;
	private String postCode;
	private String address;
	private String url;
	
	private String corpNm;
	private String status;
	private int deptSeq;
	private String regUserSeq;
	private String regUserNm;
	private String regUserId;
	
	public String getSyncCode() {
		return syncCode;
	}
	public void setSyncCode(String syncCode) {
		this.syncCode = syncCode;
	}
	public String getSyncDept() {
		return syncDept;
	}
	public void setSyncDept(String syncDept) {
		this.syncDept = syncDept;
	}
	public String getGojlsurl() {
		return gojlsurl;
	}
	public void setGojlsurl(String gojlsurl) {
		this.gojlsurl = gojlsurl;
	}
	public ArrayList<Long> getDeptlist() {
		return deptlist;
	}
	public void setDeptlist(ArrayList<Long> deptlist) {
		this.deptlist = deptlist;
	}
	public long getOrganizationNo() {
		return organizationNo;
	}
	public void setOrganizationNo(long organizationNo) {
		this.organizationNo = organizationNo;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getOwnerName() {
		return ownerName;
	}
	public void setOwnerName(String ownerName) {
		this.ownerName = ownerName;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getPhoneNumber() {
		return phoneNumber;
	}
	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	public String getPostCode() {
		return postCode;
	}
	public void setPostCode(String postCode) {
		this.postCode = postCode;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getCorpNm() {
		return corpNm;
	}
	public void setCorpNm(String corpNm) {
		this.corpNm = corpNm;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public int getDeptSeq() {
		return deptSeq;
	}
	public void setDeptSeq(int deptSeq) {
		this.deptSeq = deptSeq;
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
	public String getRegUserId() {
		return regUserId;
	}
	public void setRegUserId(String regUserId) {
		this.regUserId = regUserId;
	}
	
}
