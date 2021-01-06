<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
	<script type="text/javascript">
	var param_abroad_dept_list = "<spring:eval expression="@globalContext['ABROAD_LIST']" />";
	var param_b_dept_list = "${cookieDeptList}";
	var param_emp_type = "${cookieEmpType}";
	var param_main_menu_list = "${cookieMainMenuList}";
	var param_sub_menu_list = "${cookieSubMenuList}";

	$(document).ready(function(){
		/* user info */
		$('.uh .user').on('click', function(e){
			e.stopPropagation();
			$('.uh .mylayer').toggleClass('expand');
			$('.uh .quick_layer').removeClass('expand');
		});
		$('.uh .mylayer').on('click',function(e){ e.stopPropagation(); });
		
		param_main_menu_list = param_main_menu_list.replace("[","")
		param_main_menu_list = param_main_menu_list.replace("]","")
		param_main_menu_list = param_main_menu_list.split(",")
		for(var i=0; i < param_main_menu_list.length; i++){
			var classNm = param_main_menu_list[i].trim()
			$("#header .nav .menu ."+classNm).removeClass("hide");			
		}
		/*if(param_emp_type == 'B'){
			var param_b_dept_list_sp = param_b_dept_list.split(",");
			//$("#header .nav .menu .aboad").addClass("hide");
			for(var i=0; i < param_b_dept_list_sp.length; i++){
				if(param_abroad_dept_list.indexOf(param_b_dept_list_sp[i].split(":")[0]) > -1){ $("#header .nav .menu .aboad").removeClass("hide"); }
			}
		}*/
	});

	/* disable layer */
	$(document).on('click', function() { $('#header .expand').removeClass('expand'); });
	</script>
	<div id="header">
		<div class="uh">
			<div class="service">
				<ul>
					<!-- <li><a>iMS</a></li>
					<li><a>EMS</a></li>
					<li><a>TCS</a></li> -->
					<li class="selected"><a href="/">HMS</a></li>
				</ul>
			</div>
			<div class="link">
				<div class="user">
					<span>${cookieEmpNm} <c:if test="${cookieEmpType == 'S'}">관리자</c:if> <c:if test="${cookieEmpType == 'B'}">분원관리자</c:if></span>
					<div class="mylayer">
						<ol>
							<!-- <li><a href="#">My Account</a></li> -->
							<li><a href="/logout">Sign Out</a></li>
						</ol>
					</div>
				</div>
			</div>
		</div>
		<div class="nav">
			<div class="mh">
				<h1><img src="<spring:eval expression="@globalContext['IMG_SERVER']" />/hms/img/admin/mh_logo.svg" alt="JLS" /> <span>HMS</span></h1>
				<h2></h2>
			</div>
			<%-- <div class="menu">
				<ul>
					<li class="banner hide">
						<a href="/v2/banner" rel="" title="Banner Setting"><span>Banner Setting</span></a>
					</li>
					<li class="news hide">
						<a href="/v2/news" title="JLS News"><span>JLS News</span></a>
					</li>					
					<c:if test="${cookieEmpSubType == '2'}">
					<li class="ir hide">
						<a href="/v2/ir" rel="" title="IR Library"><span>IR Library</span></a>
					</li>
					</c:if>
					<c:if test="${cookieEmpType eq 'S'}">
					<li class="unione">
						<a href="/v2/nhnsync" title="UNIONE Management"><span>Sync UNIONE</span></a>
					</li>
					</c:if>
					<c:if test="${cookieEmpSubType == '2'}">
					<li class="abroad hide">
						<a href="/v2/abroad/main" 
						rel="/v2/abroad/menu,/v2/abroad/banner,/v2/abroad/menu,/v2/abroad/partner,/v2/abroad/manager,/v2/abroad/program
						,/v2/abroad/post,/v2/abroad/movie,/v2/abroad/gallery,/v2/abroad/counsel,/v2/abroad/report,/v2/abroad/reserveset,/v2/abroad/reserveseminar,/v2/abroad/reservecamp" 
						title="Study Abroad"><span>Study Abroad</span></a>
					</li>
					</c:if>
					<c:if test="${cookieEmpType == 'B'}">
					<li class="abroad hide">
						<a href="/v2/abroad/main" 
						rel="/v2/abroad/banner,/v2/abroad/menu,/v2/abroad/partner,/v2/abroad/manager,/v2/abroad/program,/v2/abroad/counsel
						,/v2/abroad/post,/v2/abroad/movie,/v2/abroad/gallery,/v2/abroad/counsel,/v2/abroad/report" 
						title="Study Abroad"><span>Study Abroad</span></a>
					</li>
					</c:if>
					<c:if test="${cookieEmpSubType == '2'}">
					<li class="faq hide">
						<a href="/v2/faq" rel="" title="FAQ"><span>FAQ Setting</span></a>
					</li>
					</c:if>
				</ul>
			</div> --%>
			<div class="menu">
				<ul>
					<li class="banner hide">
						<a href="/v2/banner" rel="" title="Banner Setting"><span>Banner Setting</span></a>
					</li>
					<li class="news hide">
						<a href="/v2/news" title="JLS News"><span>JLS News</span></a>
					</li>					
					<li class="ir hide">
						<a href="/v2/ir" rel="" title="IR Library"><span>IR Library</span></a>
					</li>
					<li class="abroad hide">
						<a href="/v2/abroad/main" 
						rel="/v2/abroad/menu,/v2/abroad/banner,/v2/abroad/partner,/v2/abroad/manager,/v2/abroad/program
						,/v2/abroad/post,/v2/abroad/movie,/v2/abroad/gallery,/v2/abroad/counsel,/v2/abroad/report,/v2/abroad/reserveset,/v2/abroad/reserveseminar,/v2/abroad/reservecamp" 
						title="Study Abroad"><span>Study Abroad</span></a>
					</li>
					<li class="faq hide">
						<a href="/v2/faq" rel="" title="FAQ"><span>FAQ Setting</span></a>
					</li>
				</ul>
			</div>
		</div>
	</div>
