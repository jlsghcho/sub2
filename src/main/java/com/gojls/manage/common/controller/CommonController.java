package com.gojls.manage.common.controller;

import java.util.Enumeration;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.gojls.util._Cookie;
import com.gojls.util._Response;

import net.sf.json.JSONObject;

@Controller
@RequestMapping ("/")
public class CommonController extends BaseController {
	
	@Value("#{globalContext['COOKIE_NAME']?:'jlsadm'}") private String COOKIE_NAME;
	
	@RequestMapping(value={"/", "/index"}, method=RequestMethod.GET)
	public ModelAndView indexView(HttpServletRequest req) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonController] indexView");	}
		ModelAndView mav = new ModelAndView();
		
//		mav.setViewName("redirect:/jls/news");
		
		String[] cookieData = _Cookie.getTokenData(req, _Cookie.getCookieStr(req.getCookies(), COOKIE_NAME));
		Object cookieObj = JSONObject.fromObject(cookieData[1]);
		Map<String, Object> cookieMap = _Response.formatJsonToMap(cookieObj);
		String MAIN_MENU = (String) cookieMap.get("MAIN_MENU");
		String loginMenu = MAIN_MENU.split(",")[0];
		mav.setViewName("redirect:/v2/"+loginMenu);
		return mav;
	}
	
//	@RequestMapping(value={"/", "/index"}, method=RequestMethod.GET)
//	public ModelAndView indexView(HttpServletRequest req) throws Exception{
//		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonController] indexView");	}
//		ModelAndView mav = new ModelAndView();
//		//mav.setViewName("redirect:/jls/news");
//		mav.setViewName("redirect:/v2/banner");
//		return mav;
//	}
	
	@RequestMapping(value="/{param_step:[a-z0-9]+}/{param_detail:[a-z0-9]+}", method=RequestMethod.GET)
	public ModelAndView indexCommonView(HttpServletRequest req, @PathVariable String param_step, @PathVariable String param_detail) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonController] indexCommonView");	}
		ModelAndView mav = new ModelAndView();
		try {
			/* 파라메터 확인후 피드백 */
			Enumeration params = req.getParameterNames();
			while (params.hasMoreElements()) {
				String param_name = (String)params.nextElement();
				if(param_name.toLowerCase().indexOf("title") > -1) {
					mav.addObject(param_name , new String(req.getParameter(param_name).getBytes("8859_1"), "UTF-8"));
				}else {
					mav.addObject(param_name , req.getParameter(param_name));
				}
			}
			mav.setViewName("/"+ param_step +"/"+ param_detail +".tiles");
		}catch(Exception ex) {
			mav.clear();
			mav.setViewName("redirect:/");
		}
		return mav;
	}

	@RequestMapping(value="/v2/popup/{param_step:[\\w]+}", method=RequestMethod.GET)
	public ModelAndView indexCommonAbroadPopupView(HttpServletRequest req, @PathVariable String param_step) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonController] indexCommonAbroadPopupView");	}
		ModelAndView mav = new ModelAndView();
		try {
			/* 파라메터 확인후 피드백 */
			Enumeration params = req.getParameterNames();
			while (params.hasMoreElements()) {
				String param_name = (String)params.nextElement();
				if(param_name.toLowerCase().indexOf("title") > -1) {
					mav.addObject(param_name , new String(req.getParameter(param_name).getBytes("8859_1"), "UTF-8"));
				}else {
					mav.addObject(param_name , req.getParameter(param_name));
				}
			}
			mav.setViewName("/v2/popup/"+ param_step +".tiles");
		}catch(Exception ex) {
			mav.clear();
			mav.setViewName("redirect:/");
		}
		return mav;
	}
	
	@RequestMapping(value="/v2/abroad/{param_step:[a-z0-9]+}", method=RequestMethod.GET)
	public ModelAndView indexCommonAbroadView(HttpServletRequest req, @PathVariable String param_step) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonController] indexCommonAbroadView");	}
		ModelAndView mav = new ModelAndView();
		try {
			/* 파라메터 확인후 피드백 */
			Enumeration params = req.getParameterNames();
			while (params.hasMoreElements()) {
				String param_name = (String)params.nextElement();
				if(param_name.toLowerCase().indexOf("title") > -1) {
					mav.addObject(param_name , new String(req.getParameter(param_name).getBytes("8859_1"), "UTF-8"));
				}else {
					mav.addObject(param_name , req.getParameter(param_name));
				}
			}
			mav.setViewName("/v2/abroad/"+ param_step +".tiles");
		}catch(Exception ex) {
			mav.clear();
			mav.setViewName("redirect:/");
		}
		return mav;
	}
	
	@RequestMapping(value="/{param_step:[a-z0-9]+}/{param_detail:[a-z0-9]+}/{param_sub:[a-z0-9]+}", method=RequestMethod.GET)
	public ModelAndView indexCommonViewSub(HttpServletRequest req, @PathVariable String param_step, @PathVariable String param_detail,  @PathVariable String param_sub) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonController] indexCommonViewSub");	}
		ModelAndView mav = new ModelAndView();
		try {
			/* 파라메터 확인후 피드백 */
			Enumeration params = req.getParameterNames();
			while (params.hasMoreElements()) {
				String param_name = (String)params.nextElement();
				if(param_name.toLowerCase().indexOf("title") > -1) {
					mav.addObject(param_name , new String(req.getParameter(param_name).getBytes("8859_1"), "UTF-8"));
				}else {
					mav.addObject(param_name , req.getParameter(param_name));
				}
			}
			mav.setViewName("/"+ param_step +"/"+ param_detail +"_"+ param_sub +".tiles");
		}catch(Exception ex) {
			mav.clear();
			mav.setViewName("redirect:/");
		}
		return mav;
	}

	@RequestMapping(value="/import/{param_step:[a-z0-9]+}/{param_detail:[a-z0-9]+}", method=RequestMethod.GET)
	public ModelAndView indexCommonImportView(HttpServletRequest req, @PathVariable String param_step, @PathVariable String param_detail) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonController] indexCommonImportView");	}
		ModelAndView mav = new ModelAndView();
		Enumeration params = req.getParameterNames();
		while (params.hasMoreElements()) {
			String param_name = (String)params.nextElement();
			mav.addObject(param_name , req.getParameter(param_name));
		}
		mav.setViewName("/import/"+ param_step +"/"+ param_detail +".tiles");
		return mav;
	}
	
	/* 모든 팝업 View */
	@RequestMapping(value="/common/{param_path}", method=RequestMethod.GET, produces="text/html")
	public String commonPopupPage(HttpServletRequest req, @PathVariable String param_path) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/CommonController] commonPopupPage /common/"+ param_path ); }
		/* 파라메터 확인후 피드백 */
		Enumeration params = req.getParameterNames();
		while (params.hasMoreElements()) {
			String param_name = (String)params.nextElement();
			req.setAttribute(param_name , req.getParameter(param_name));
		}
		return "/common/"+ param_path;
	}
	
}
