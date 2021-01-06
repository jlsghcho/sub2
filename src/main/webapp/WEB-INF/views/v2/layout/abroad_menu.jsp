<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script type="text/javascript">
$(document).ready(function(){
	var param_loc_url = location.href;
	var abroad_sub_menu = "${cookieSubMenuList}";
	var abroad_sub_menu_list =  abroad_sub_menu.split("abroad=")[1].split(" ")[0].split(',');
	
	if ( abroad_sub_menu_list.includes('aboardMenu') || abroad_sub_menu_list.includes('abroadBanner') ){
		$("#aboardSub1").removeClass("hide");
	}
	if ( abroad_sub_menu_list.includes('abroadPartner') || abroad_sub_menu_list.includes('abroadManager')){
		$("#aboardSub2").removeClass("hide");
	}
	if ( abroad_sub_menu_list.includes('abroadProgram') ){
		$("#aboardSub3").removeClass("hide");
	}
	if ( abroad_sub_menu_list.includes('abroadPost') || abroad_sub_menu_list.includes('abroadGallery') || abroad_sub_menu_list.includes('abroadMovie') ){
		$("#aboardSub4").removeClass("hide");
	}
	
	if ( abroad_sub_menu_list.includes('abroadCounsel') || abroad_sub_menu_list.includes('abroadReport') ){
		$("#aboardSub5").removeClass("hide");
	}
	
	for(var i=0; i < abroad_sub_menu_list.length; i++){
		var subNm = abroad_sub_menu_list[i].trim()
		if ( subNm != ''){$("#"+subNm).removeClass("hide");}
	}
	
	var param_menu_a = $(" ul li ol li").find("a");
	$("#subnav ul li ol li").removeClass('selected');
	for(var i=0; i < param_menu_a.length; i++){
		if(param_loc_url.indexOf(param_menu_a.eq(i).attr('href')) > -1){ param_menu_a.eq(i).parent().addClass('selected'); break; }
	}
	
	$('#wrap .browser .scroll').slimScroll({ height: '100%', size: '5px', allowPageScroll: false, disableFadeOut: true });

	/* burger toggle */
	$('.burger_icon').on('click', function(){ $('.browser.sidebar').toggleClass('expand'); setTimeout(function() { 	$(window).trigger('resize'); }, 100); });
	
	
	
	/* $('#s'+abroad_sub_menu_list[0]).trigger("click"); */
	
});
	

function fn_abroad_community_tag(){
	$('body').addClass('noscroll');
	$('#pop_abroad_tag, .black_bg').fadeIn();
	set_scroll();
	fn_abroad_tag_list();
}

function goMenu(){
	location.replace('/v2/abroad/menu');	
}

function goBanner(){
	location.replace('/v2/abroad/banner');	
}

function goPartner(){
	location.replace('/v2/abroad/partner');	
}

function goManager(){
	location.replace('/v2/abroad/manager');	
}

function goProgram(){
	location.replace('/v2/abroad/program');	
}

function goPost(){
	location.replace('/v2/abroad/post');	
}

function goGallery(){
	location.replace('/v2/abroad/gallery');	
}

function goMovie(){
	location.replace('/v2/abroad/movie');	
}

function goCounsel(){
	location.replace('/v2/abroad/counsel');	
}

function goReport(){
	location.replace('/v2/abroad/report');	
} 

</script>

<div id="subnav">
	<ul>
	<%-- <c:if test="${cookieEmpSubType == '2'}"> --%>
		<li class="hide" id="aboardSub1">
			<h4>
				<span>기본설정</span>
			</h4>
			<ol>
				<li class="hide" id="aboardMenu" onclick="goMenu()"><a href="/v2/abroad/menu"><span>프로그램 메뉴 관리</span></a></li>
				<li class="hide" id="abroadBanner" onclick="goBanner()"><a href="/v2/abroad/banner"><span>프로그램 모집 관리(Main Page)</span></a></li>
			</ol>
		</li>
		<li class="hide" id="aboardSub2">
			<h4><span>소개 페이지</span></h4>
			<ol>
				<li class="hide" id="abroadPartner" onclick="goPartner()"><a href="/v2/abroad/partner"><span>파트너</span></a></li>
				<li class="hide" id="abroadManager" onclick="goManager()"><a href="/v2/abroad/manager"><span>운영진 소개</span></a></li>
			</ol>
		</li>
		<li class="hide" id="aboardSub3">
			<h4><span>프로그램</span></h4>
			<ol>
				<li class="hide" id="abroadProgram" onclick="goProgram()"><a href="/v2/abroad/program"><span>프로그램 소개/모집요강/스케줄</span></a></li>
			</ol>
		</li>
		<li class="hide" id="aboardSub4">
			<h4><span>커뮤니티</span><button type="button" class="xsmall black" onclick="fn_abroad_community_tag();"><span>Set Tag</span></button></h4>
			<ol>
				<li class="hide" id="abroadPost" onclick="goPost()"><a href="/v2/abroad/post"><span>유학/캠프 후기</span></a></li>
				<li class="hide" id="abroadGallery" onclick="goGallery()"><a href="/v2/abroad/gallery"><span>갤러리</span></a></li>
				<li class="hide" id="abroadMovie" onclick="goMovie()"><a href="/v2/abroad/movie"><span>동영상</span></a></li>
			</ol>
		</li>
		<!-- <li>
			<h4><span>예약관리</span></h4>
			<ol>
				<li><a href="/v2/abroad/reserveset"><span>설명회/캠프 예약설정</span></a></li>
				<li><a href="/v2/abroad/reserveseminar"><span>유학/캠프 설명회  신청 관리</span></a></li>
				<li><a href="/v2/abroad/reservecamp"><span>해외캠프 신청 관리</span></a></li>
			</ol>
		</li> -->
	<%-- </c:if> --%>
		<li class="hide" id="aboardSub5">
			<h4><span>MY유학</span></h4>
			<ol>
				<li class="hide" id="abroadCounsel" onclick="goCounsel()"><a href="/v2/abroad/counsel"><span>유학생활 1:1 상담</span></a></li>
				<li class="hide" id="abroadReport" onclick="goReport()"><a href="/v2/abroad/report"><span>리포트</span></a></li>
			</ol>
		</li>
	</ul>
</div>