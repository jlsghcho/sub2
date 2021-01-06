package com.gojls.manage.member.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.transaction.annotation.Transactional;

import com.gojls.manage.member.model.EmpModel;

@Transactional
public interface LoginService {
	public Map<String, Object> loginProcess(HttpServletRequest req, HttpServletResponse res, EmpModel empVo);
	public Map<String, Object> exLoginProcess(HttpServletRequest req, HttpServletResponse res, EmpModel empVo);
}
