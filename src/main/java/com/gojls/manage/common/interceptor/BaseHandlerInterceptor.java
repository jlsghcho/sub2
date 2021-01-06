package com.gojls.manage.common.interceptor;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.gojls.manage.common.service.v2_CommonService;
import com.gojls.util._Cookie;
import com.gojls.util._Date;
import com.gojls.util._Response;
import com.gojls.util._Util;

import net.sf.json.JSONObject;

public class BaseHandlerInterceptor  extends HandlerInterceptorAdapter{
	Logger logger = LoggerFactory.getLogger(getClass());

	@Value("#{globalContext['COOKIE_NAME']?:'jlsadm'}") private String COOKIE_NAME;
	
	@Override
	public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object handler) throws Exception {
		String param_request_url = req.getRequestURI();
		if (logger.isDebugEnabled()) {	logger.debug("[jls-manage/BaseHandlerInterceptor] preHandle()"+ param_request_url);	}
		
        req.setAttribute("serverDate", _Date.getNow("yyyyMMdd"));
        req.setAttribute("recentUrl", param_request_url);
        
        Boolean cookieYN = _Cookie.isTokenCookie(req, COOKIE_NAME);
        req.setAttribute("cookieYN", cookieYN);
        
        String osType = "P";
        String os = _Util.getClientOS(req);
        if(os.equals("andro") || os.equals("iphone") || os.equals("ipod") || os.equals("berry")){ osType = "M"; }
        req.setAttribute("os", os);
        req.setAttribute("osType", osType);
        
        String urlNm = null ;
        String authMenuInfo = "empty";
        if(cookieYN){
        	String[] cookieData = _Cookie.getTokenData(req, _Cookie.getCookieStr(req.getCookies(), COOKIE_NAME));
        	if(cookieData[0].equals("0")){
        		Object cookieObj = JSONObject.fromObject(cookieData[1]);
        		Map<String, Object> cookieMap = _Response.formatJsonToMap(cookieObj);
        		req.setAttribute("cookieData", cookieObj);
        		req.setAttribute("cookieEmpSeq", cookieMap.get("EMP_SEQ").toString());
        		req.setAttribute("cookieEmpId", cookieMap.get("EMP_ID").toString());
        		req.setAttribute("cookieEmpNm", cookieMap.get("EMP_NM").toString()); 
        		req.setAttribute("cookieEmpType", cookieMap.get("EMP_TYPE").toString());
        		req.setAttribute("cookieEmpSubType", cookieMap.get("EMP_SUB_TYPE").toString());
        		if ( cookieMap.containsKey("MAIN_MENU")) {
        			req.setAttribute("cookieMainMenuList", cookieMap.get("MAIN_MENU").toString());
        			authMenuInfo = cookieMap.get("MAIN_MENU").toString();
        		}
        		if ( cookieMap.containsKey("SUB_MENU")) {
        			req.setAttribute("cookieSubMenuList", cookieMap.get("SUB_MENU").toString());
        			
        		}
        		req.setAttribute("cookieDeptList", cookieMap.get("DEPT_LIST").toString());
        		
        		
        		urlNm = req.getServletPath();
        		
        		
        	}else {
            	System.out.println(">>"+cookieData[0] +"/"+ cookieData[1]);
        		res.sendRedirect("/logout?preURL=/login");
        		return false;
        	}
        	
        	System.out.println(req.getServletPath());
        	// 메뉴권한없으면 logout 처리
        	if ( urlNm.split("/").length == 3) { 
    			if (  req.getServletPath().split("/")[2] == "v2" && authMenuInfo.indexOf(req.getServletPath().split("/")[2]) < 0){
    				res.sendRedirect("/logout?preURL=/login"); return false; 
    			}
    		}
        	
        	if ( req.getServletPath().indexOf("/v2/abroad") == 0 ) {
        		String targetAbroad = req.getServletPath().split("/")[3];
        		String subMenu = req.getAttribute("cookieSubMenuList").toString();
        		String abroadMenu = subMenu.split("abroad=")[1].split(" ")[0];
        		System.out.println(abroadMenu.toUpperCase().indexOf(targetAbroad.toUpperCase()));
        		if ( !"main".equals(targetAbroad) && abroadMenu.toUpperCase().indexOf(targetAbroad.toUpperCase()) < 0 ) {
        			res.sendRedirect("/logout?preURL=/login"); return false;
        		}
        	}
        	 
        	if ( "/v2/".equals(req.getServletPath()) ) {
        		res.sendRedirect("/logout?preURL=/login"); return false;
        	}
        	
        }else {
        	if(param_request_url.indexOf("login") == -1 && param_request_url.indexOf("exlogin") == -1 && param_request_url.indexOf("import") == -1 ) {
           		res.sendRedirect("/login");
           		return false;
        	}
        }
        
		
        
		return super.preHandle(req, res, handler);
	}
}
