package com.gojls.manage.member.controller;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.gojls.manage.common.controller.BaseController;
import com.gojls.manage.member.model.EmpModel;
import com.gojls.manage.member.service.LoginService;
import com.gojls.util._Cookie;
import com.gojls.util._Request;
import com.gojls.util._Response;

import net.sf.json.JSONObject;

@Controller
public class LoginController extends BaseController {
	@Autowired LoginService loginService;

	@Value("#{globalContext['COOKIE_NAME']?:'jlsadm'}") private String COOKIE_NAME;
	@Value("#{globalContext['COOKIE_DOMAIN']?:'.gojls.com'}") private String COOKIE_DOMAIN;
	
	@RequestMapping(value="/login", method=RequestMethod.GET)
	public String loginForm(HttpServletRequest req, @RequestParam(value="preURL", defaultValue="") String preURL){
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/LoginController] loginForm");	}
		req.setAttribute("preURL", preURL);
		return "/member/login"; 
	}

	@RequestMapping(value="/login", method=RequestMethod.POST)
	public void loginProcess(HttpServletRequest req, HttpServletResponse res, @ModelAttribute EmpModel empVo) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/LoginController] loginProcess");	}
		Map<String, Object> map = new HashMap<String, Object>();
		try{
			if(empVo.getEmpId() == null || empVo.getPassWd() == null){
				map = _Request.setResult("error", "아이디와 패스워드가 없습니다.", null);
			}else{
				map = loginService.loginProcess(req, res, empVo);
			}
		}catch(Exception ex){
			map = _Request.setResult("error", ex.getMessage(), null);
			logger.error("[jls-manage/LoginController] loginProcess - error="+ ex.getMessage());
		}
		_Response.outJson(res, map , false, "");
	}
	
	// lp 에서 넘어 올때 코드 EMP_SEQ=S001551608&EN_PASS_WD=c356475de884947a17737dca5f2c1da87bcd4e7272a2d780a391d81fa0b8e9a1&LP_FLAG=Y
	@RequestMapping(value="/exlogin", method=RequestMethod.POST)
	public void extraLoginProcess(HttpServletRequest req, HttpServletResponse res, @RequestParam String EN_PASS_WD, @RequestParam String EMP_SEQ, @RequestParam String LP_FLAG) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/LoginController] extraLoginProcess");	}
		Map<String, Object> map = new HashMap<String, Object>();
		try{
			EmpModel empVo = new EmpModel();
			empVo.setEmpSeq(EMP_SEQ);
			empVo.setEnPassWd(EN_PASS_WD);
			empVo.setLoginStay(false);

			map = loginService.exLoginProcess(req, res, empVo);
			System.out.println(map);
		}catch(Exception ex){
			map = _Request.setResult("error", ex.getMessage(), null);
			logger.error("[jls-manage/LoginController] extraLoginProcess - error="+ ex.getMessage());
		}
		
		JSONObject obj = JSONObject.fromObject(map.get("header"));
		if(Boolean.parseBoolean(obj.get("isSuccessful").toString())) {
			res.sendRedirect("/");
		}else {
			String script = "location.href='/login';";
			String msg = obj.get("resultMessage").toString();

			res.setCharacterEncoding("UTF-8");
			res.setContentType("text/html;charset=UTF-8");
			PrintWriter outs = res.getWriter();
	        outs.println("<script type=\"text/javascript\">");
	        if(!msg.equals("")) outs.println("alert(\"" + msg + "\");");
	        outs.println(script);
	        outs.println("</script>");
	        outs.flush();
		}
	}
	
	@RequestMapping(value="/logout", method=RequestMethod.GET)
	public void logout(HttpServletRequest req, HttpServletResponse res, @RequestParam(value="preURL", defaultValue="") String preURL) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/LoginController] logout");	}
		String[] result = _Cookie.deleteCookie(res, COOKIE_NAME, COOKIE_DOMAIN); if(!result[0].equals("0")){ }
		res.sendRedirect("/login");
	}
	
}
