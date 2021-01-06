package com.gojls.manage.common.model;

public class v2_SitePartnerModel {
	private int partner_seq;
	private String partner_type;
	private String partner_nm;
	private String img_path;
	private String link_url;
	private int order_num;
	
	private String site_type;
	
	public int getPartner_seq() {
		return partner_seq;
	}
	public void setPartner_seq(int partner_seq) {
		this.partner_seq = partner_seq;
	}
	public String getPartner_type() {
		return partner_type;
	}
	public void setPartner_type(String partner_type) {
		this.partner_type = partner_type;
	}
	public String getPartner_nm() {
		return partner_nm;
	}
	public void setPartner_nm(String partner_nm) {
		this.partner_nm = partner_nm;
	}
	public String getImg_path() {
		return img_path;
	}
	public void setImg_path(String img_path) {
		this.img_path = img_path;
	}
	public String getLink_url() {
		return link_url;
	}
	public void setLink_url(String link_url) {
		this.link_url = link_url;
	}
	public int getOrder_num() {
		return order_num;
	}
	public void setOrder_num(int order_num) {
		this.order_num = order_num;
	}
	public String getSite_type() {
		return site_type;
	}
	public void setSite_type(String site_type) {
		this.site_type = site_type;
	}
}
