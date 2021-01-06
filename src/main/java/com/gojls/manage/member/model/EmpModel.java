package com.gojls.manage.member.model;

public class EmpModel {
	private String empId;
	private String empNm;
	private String empSeq;
	private String passWd;
	private String enPassWd;
	private String gtEmpType;
	private String mngEmpType;
	private String roleCd;
	private int useYn;
	private String loginAccessHmsYn;
	private String accessLevel;
	
	
	private boolean loginStay;
	private int deptSeq;
	private String deptNm;
	
	public String getEmpId() {
		return empId;
	}
	public void setEmpId(String empId) {
		this.empId = empId;
	}
	public String getPassWd() {
		return passWd;
	}
	public void setPassWd(String passWd) {
		this.passWd = passWd;
	}
	public String getEmpNm() {
		return empNm;
	}
	public void setEmpNm(String empNm) {
		this.empNm = empNm;
	}
	public String getEmpSeq() {
		return empSeq;
	}
	public void setEmpSeq(String empSeq) {
		this.empSeq = empSeq;
	}
	public String getEnPassWd() {
		return enPassWd;
	}
	public void setEnPassWd(String enPassWd) {
		this.enPassWd = enPassWd;
	}
	public String getGtEmpType() {
		return gtEmpType;
	}
	public void setGtEmpType(String gtEmpType) {
		this.gtEmpType = gtEmpType;
	}
	public String getMngEmpType() {
		return mngEmpType;
	}
	public void setMngEmpType(String mngEmpType) {
		this.mngEmpType = mngEmpType;
	}
	public int getUseYn() {
		return useYn;
	}
	public void setUseYn(int useYn) {
		this.useYn = useYn;
	}
	public boolean isLoginStay() {
		return loginStay;
	}
	public void setLoginStay(boolean loginStay) {
		this.loginStay = loginStay;
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
	public String getRoleCd() {
		return roleCd;
	}
	public void setRoleCd(String roleCd) {
		this.roleCd = roleCd;
	}
	public String getAccessLevel() {
		return accessLevel;
	}
	public void setAccessLevel(String accessLevel) {
		this.accessLevel = accessLevel;
	}
	public String getLoginAccessHmsYn() {
		return loginAccessHmsYn;
	}
	public void setLoginAccessHmsYn(String loginAccessHmsYn) {
		this.loginAccessHmsYn = loginAccessHmsYn;
	}
}
