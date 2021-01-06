package com.gojls.manage.common.model;

import java.util.List;

public class v2_ReserveMstModel {
    private int site_reserv_mst_seq;
    private String site_type;
    private String reservation_type;
    private String location_type;
    private String reservation_month;
    private String view_start_dt;
    private String view_end_dt;
    private String user_yn;
    private String reg_ts;
    private String reg_user_seq;
    private String reg_user_id;
    private String reg_user_nm;
    private int cnt;
	private List<v2_ReserveProgramModel> reserve_program_list;
    
	public int getSite_reserv_mst_seq() {
		return site_reserv_mst_seq;
	}
	public void setSite_reserv_mst_seq(int site_reserv_mst_seq) {
		this.site_reserv_mst_seq = site_reserv_mst_seq;
	}
	public String getSite_type() {
		return site_type;
	}
	public void setSite_type(String site_type) {
		this.site_type = site_type;
	}
	public String getReservation_type() {
		return reservation_type;
	}
	public void setReservation_type(String reservation_type) {
		this.reservation_type = reservation_type;
	}
	public String getLocation_type() {
		return location_type;
	}
	public void setLocation_type(String location_type) {
		this.location_type = location_type;
	}
	public String getReservation_month() {
		return reservation_month;
	}
	public void setReservation_month(String reservation_month) {
		this.reservation_month = reservation_month;
	}
	public String getView_start_dt() {
		return view_start_dt;
	}
	public void setView_start_dt(String view_start_dt) {
		this.view_start_dt = view_start_dt;
	}
	public String getView_end_dt() {
		return view_end_dt;
	}
	public void setView_end_dt(String view_end_dt) {
		this.view_end_dt = view_end_dt;
	}
	public String getUser_yn() {
		return user_yn;
	}
	public void setUser_yn(String user_yn) {
		this.user_yn = user_yn;
	}	
	public String getReg_ts() {
		return reg_ts;
	}
	public void setReg_ts(String reg_ts) {
		this.reg_ts = reg_ts;
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
	public List<v2_ReserveProgramModel> getReserve_program_list() {
		return reserve_program_list;
	}
	public void setReserve_program_list(List<v2_ReserveProgramModel> reserve_program_list) {
		this.reserve_program_list = reserve_program_list;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}

	
}
