<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
	<script type="text/javascript">
	$(document).ready(function(){
		var uri = location.href;
		var alink = $("#left_area ul").find("a");
		$("#left_area ul li").removeClass('selected');
		for(var i=0; i < alink.length; i++){
			if(uri.indexOf(alink.eq(i).attr('href')) > -1){ alink.eq(i).parent().addClass('selected'); break; }
		}
	});
	</script>
	<div id="left_area">
		<ul>
			<c:if test="${cookieEmpType eq 'B'}">
			<li>
				<h1 class="stu">분원홈 관리 <span class="arrow"></span></h1>
				<ol>
					<li class="selected"><a href="/jls/news" title="분원소식">분원소식</a></li>
					<li><a href="/jls/direct" title="바로가기 관리">바로가기 관리</a></li>
				</ol>
			<li>
			</c:if>
			<c:if test="${cookieEmpType eq 'S'}">
			<li>
				<h1 class="cus">대표홈 관리 <span class="arrow"></span></h1>
				<ol>
					<li><a href="/jls/news" title="JLS 소식">JLS 소식</a></li>
					<li><a href="/jls/ad" title="JLS 배너">JLS 배너</a></li>
					<li><a href="/jls/direct" title="바로가기 관리">바로가기 관리</a></li>
					<li><a href="/jls/tag" title="태그 관리">태그관리</a></li>
				</ol>
			</li>
			<li>
				<h1 class="cus">유니원 관리 <span class="arrow"></span></h1>
				<ol>
					<li><a href="/unione/sync" title="유니원 분원동기화">분원동기화</a></li>
				</ol>
			</li>
			</c:if>
		</ul>
	</div>
	<div id="btn_fold"><div class="arrow"></div></div>
	