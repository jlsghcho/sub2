<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
	<div id="header">
		<div class="uh">
			<h1>
				<a href="/">
					<img src="<spring:eval expression="@globalContext['IMG_SERVER']" />/manage/img/mh_logo.svg">
					<span style="font-size: 30px;color: white;display: inline-block; margin-top: -8px; vertical-align: middle;">HMS</span>
				</a>
			</h1>
			<h2><span>ADMIN</span></h2>
			<div class="info">
				<span class="user">${cookieEmpNm} <c:if test="${cookieEmpType == 'S'}">관리자</c:if> <c:if test="${cookieEmpType == 'B'}">분원관리자</c:if></span>
				<button type="button" class="member yellow" title="Sing Out" onclick="location.href='/logout'"><span><i class="fa fa-sign-out" aria-hidden="true"></i> Sign Out</span></button>
			</div>
			</div>
		</div>
	</div>
