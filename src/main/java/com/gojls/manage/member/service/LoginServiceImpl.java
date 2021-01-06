package com.gojls.manage.member.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.gojls.manage.common.dao.v2_CommonDao;
import com.gojls.manage.common.service.v2_CommonService;
import com.gojls.manage.member.dao.LoginDao;
import com.gojls.manage.member.model.EmpModel;
import com.gojls.util._Cookie;
import com.gojls.util._Request;

@Service
public class LoginServiceImpl implements LoginService{
	protected Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired 
	@Qualifier("oracle")
	private SqlSession sqlSessionOracle;

	@Autowired v2_CommonService v2_commonService;
	
	@Value("#{globalContext['COOKIE_NAME']?:'jlsadm'}") private String COOKIE_NAME;
	@Value("#{globalContext['COOKIE_DOMAIN']?:'.gojls.com'}") private String COOKIE_DOMAIN;

	// 내부 로그인 
	public Map<String, Object> loginProcess(HttpServletRequest req, HttpServletResponse res, EmpModel empVo) {
		if (logger.isDebugEnabled()) {	logger.debug("[jls-main/LoginServiceImpl] loginProcess()");	}
		Map<String, Object> map = new HashMap<String, Object>();
		try{
			LoginDao loginDao = sqlSessionOracle.getMapper(LoginDao.class);
			empVo = loginDao.selectGetEmp(empVo);
			map = loginTotalProcess(req, res, empVo);
		}catch(Exception ex){
			map = _Request.setResult("error", "아이디와 패스워드가 일치하지 않습니다. 다시한번 확인해 주세요.", null);
			logger.error("[jls-manage/LoginServiceImpl] loginProcess - error="+ ex.getMessage());
		}
		return map;
	}
	
	// 외부에서 로그인 할때 쓰임 
	public Map<String, Object> exLoginProcess(HttpServletRequest req, HttpServletResponse res, EmpModel empVo){
		if (logger.isDebugEnabled()) {	logger.debug("[jls-main/LoginServiceImpl] exLoginProcess()");	}
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			LoginDao loginDao = sqlSessionOracle.getMapper(LoginDao.class);
			empVo = loginDao.selectGetEmpExt(empVo);
			map = loginTotalProcess(req, res, empVo);
		}catch(Exception ex) {
			map = _Request.setResult("error", "아이디와 패스워드가 일치하지 않습니다. 다시한번 확인해 주세요.", null);
			logger.error("[jls-manage/LoginServiceImpl] loginProcess - error="+ ex.getMessage());
		}
		return map;
	}

	@SuppressWarnings("unused")
	private Map<String, Object> loginTotalProcess(HttpServletRequest req, HttpServletResponse res, EmpModel empVo) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		int duration = 0; 
		
		if(empVo.isLoginStay() == true) { duration = 300; }
		
		// 기존에 쿠키값들은 모두 초기화 해준다. 
		String[] result = _Cookie.deleteCookie(res, COOKIE_NAME, COOKIE_DOMAIN); if(!result[0].equals("0")){ }
		
		LoginDao loginDao = sqlSessionOracle.getMapper(LoginDao.class);
		
		if(empVo == null){
			map = _Request.setResult("error", "입력하신 정보가 정확하지 않습니다.<br>다시 확인 해 주시고 로그인 해 주세요.", null);
		} else if ( "0".equals(empVo.getLoginAccessHmsYn())) {
			map = _Request.setResult("error", "로그인 접속 권한이 없습니다.", null); 
		}
		else{ 
			 
			String empType = "";
			String deptListStr = "";
			
			// 원본
			// empVo.getAccessLevel = "ACL000"  전체분원값
			if(Integer.parseInt(empVo.getMngEmpType()) > 0 || "000011".equals(empVo.getRoleCd()) || "RTA027".equals(empVo.getRoleCd()) ||  "ACL000".equals(empVo.getAccessLevel()) ) {
				empType="S";
				empVo.setMngEmpType(("2"));
			}
			
			// 권한테스트하기위해 모든 접근아이디를 관리자로 변환
//			if(Integer.parseInt(empVo.getMngEmpType()) >= 0 ) {
//				empType="S";
//				empVo.setMngEmpType(("2"));
//			}
			else {
				empType="B";	
//				empType="S";	// 배포할때 삭제(로컬로그인)
				
				List<EmpModel> deptList = loginDao.selectGetEmpDept(empVo.getEmpSeq());
				if(deptList.size() > 0) {
					for(int i=0; i < deptList.size(); i++) {
						if(i > 0) { deptListStr += ","+ deptList.get(i).getDeptSeq() +":"+ deptList.get(i).getDeptNm() ; } else { deptListStr += deptList.get(i).getDeptSeq() +":"+ deptList.get(i).getDeptNm() ; }
					}
				}
			}
			
			
			if( empType.equals("B") && deptListStr.equals("")) { // 관리자권한이 없는 사람으로 인식 
				map = _Request.setResult("error", "권한이 없습니다. <br>분원관리자의 경우 분원에 소속되어야 합니다.", "");	
			}else {
				HashMap<String, String> cookieMap = new HashMap<String, String>();
				
//				List<String> auth_menu_list = new ArrayList<String>();
//				HashMap<String, ArrayList<String>> auth_menu_sub = new HashMap<String, ArrayList<String>>();
//				List<Map<String, String>> resultData = loginDao.selectAuthMenuList(empVo);
//				if (resultData.size() > 0) {
//					for(int i = 0; i < resultData.size(); i++) {
//						String menuNm = resultData.get(i).get("MENUURL").split("/")[1];
//						String menuSubNm = resultData.get(i).get("MENUURL").split("/")[2];
//						System.out.println(menuNm);
//						if(!auth_menu_list.contains(menuNm)) {
//							auth_menu_list.add(menuNm);
//							System.out.println(auth_menu_list);
//						}
//						if(!auth_menu_sub.containsKey(menuNm)) {
//							ArrayList<String> sub_list = new ArrayList<String>();
//							sub_list.add(menuSubNm);
//							auth_menu_sub.put(menuNm, sub_list);
//						}else{
//							ArrayList<String> sub_list = auth_menu_sub.get(menuNm);
//							sub_list.add(menuSubNm);
//							auth_menu_sub.put(menuNm, sub_list);
//						}
//						
//					}
//				}
				
				String auth_main_menu = "";
				String auth_sub_menu = "";
				HashMap<String, String> auth_sub_menu_data = new HashMap<String, String>();
				List<Map<String, String>> resultData = loginDao.selectAuthMenuList(empVo);
				if (resultData.size() > 0) {
					for(int i = 0; i < resultData.size(); i++) {
						String menuNm = resultData.get(i).get("MENUURL").split("/")[1];
						String menuSubNm = resultData.get(i).get("MENUURL").split("/")[2];
						System.out.println(auth_main_menu.length());
						
						// main_muenu메뉴값
						if(auth_main_menu.length() == 0 ) {
							auth_main_menu = menuNm;
							System.out.println(auth_main_menu);
						}else if(auth_main_menu.indexOf(menuNm) < 0) {
							auth_main_menu += "," + menuNm;
						}
						
						// sub_muenu메뉴값 
						if(!auth_sub_menu_data.containsKey(menuNm)) {
							auth_sub_menu_data.put(menuNm, menuSubNm);
						}else{
							String subNm = auth_sub_menu_data.get(menuNm);
							subNm = subNm + "," + menuSubNm;
							auth_sub_menu_data.put(menuNm, subNm);
						}
						auth_sub_menu_data.put("subM1", "00,01");
					}
				} 
				
				for (String key: auth_sub_menu_data.keySet()){
					auth_sub_menu +=  key ;
					auth_sub_menu +=  "=" + auth_sub_menu_data.get(key) + ", " ;
				    
				}
				
				cookieMap.put("MAIN_MENU", auth_main_menu.toString());
				if ( auth_sub_menu_data.size() == 0 ) {
					cookieMap.put("SUB_MENU", "" );
				}else {
					cookieMap.put("SUB_MENU", auth_sub_menu.toString() );
				}
				
				
				cookieMap.put("EMP_SEQ", empVo.getEmpSeq());
				cookieMap.put("EMP_ID", empVo.getEmpId());
				cookieMap.put("EMP_NM", empVo.getEmpNm());
				cookieMap.put("EMP_TYPE", empType);
				cookieMap.put("EMP_SUB_TYPE", empVo.getMngEmpType());	
//				cookieMap.put("EMP_SUB_TYPE", "2");	// 배포할때 삭제(로컬로그인)
				cookieMap.put("DEPT_LIST", deptListStr);
				
//				req.setAttribute("mainMenuList", auth_main_menu.toString());
//				req.setAttribute("subMenuList", auth_sub_menu.toString());
					
				// 보안쿠키세팅 > 구형쿠키세팅 작업 
				String[] tokenData = _Cookie.getTokenCookie(req, res, cookieMap, COOKIE_NAME, COOKIE_DOMAIN, duration);
				logger.debug("[jls-manage/LoginServiceImpl] loginProcess - tokenData="+ tokenData);
				if(tokenData[0].toString().equals("0")){
					map = _Request.setResult("success", null, "");
				}else{
					map = _Request.setResult("error", tokenData[1].toString(), "");	
				}
				
				if ("".equals(auth_main_menu)) {
					map = _Request.setResult("error", "부여된 권한이 없습니다.", null);
				}
				
				
			}
		}
		return map;
	}
	
}
