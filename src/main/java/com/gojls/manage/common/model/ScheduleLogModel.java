package com.gojls.manage.common.model;

public class ScheduleLogModel {
	private String partnerNm;
	private String eventCode;
	private String eventSubCode;
	private String tranType;
	private String tranSeq;
	private String tranResult;
	private String tranMsg;
	
	public String getPartnerNm() {
		return partnerNm;
	}
	public void setPartnerNm(String partnerNm) {
		this.partnerNm = partnerNm;
	}
	public String getEventCode() {
		return eventCode;
	}
	public void setEventCode(String eventCode) {
		this.eventCode = eventCode;
	}
	public String getEventSubCode() {
		return eventSubCode;
	}
	public void setEventSubCode(String eventSubCode) {
		this.eventSubCode = eventSubCode;
	}
	public String getTranType() {
		return tranType;
	}
	public void setTranType(String tranType) {
		this.tranType = tranType;
	}
	public String getTranSeq() {
		return tranSeq;
	}
	public void setTranSeq(String tranSeq) {
		this.tranSeq = tranSeq;
	}
	public String getTranResult() {
		return tranResult;
	}
	public void setTranResult(String tranResult) {
		this.tranResult = tranResult;
	}
	public String getTranMsg() {
		return tranMsg;
	}
	public void setTranMsg(String tranMsg) {
		this.tranMsg = tranMsg;
	}
}
