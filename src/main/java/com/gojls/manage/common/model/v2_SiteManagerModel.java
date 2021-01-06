package com.gojls.manage.common.model;

public class v2_SiteManagerModel {
	private int staff_seq;
    private String site_type;
    private String staff_nm;
    private String staff_desc;
    private String img_path;
    private int order_num;

	private String reg_user_seq;
	private String reg_user_id;
	private String reg_user_nm;
	
	public int getStaff_seq() {
		return staff_seq;
	}
	public void setStaff_seq(int staff_seq) {
		this.staff_seq = staff_seq;
	}
	public String getSite_type() {
		return site_type;
	}
	public void setSite_type(String site_type) {
		this.site_type = site_type;
	}
	public String getStaff_nm() {
		return staff_nm;
	}
	public void setStaff_nm(String staff_nm) {
		this.staff_nm = staff_nm;
	}
	public String getStaff_desc() {
		return staff_desc;
	}
	public void setStaff_desc(String staff_desc) {
		this.staff_desc = staff_desc;
	}
	public String getImg_path() {
		return img_path;
	}
	public void setImg_path(String img_path) {
		this.img_path = img_path;
	}
	public int getOrder_num() {
		return order_num;
	}
	public void setOrder_num(int order_num) {
		this.order_num = order_num;
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

}
