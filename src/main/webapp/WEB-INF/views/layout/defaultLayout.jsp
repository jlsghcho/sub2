<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
response.setDateHeader("Expires", -1);
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta name="viewport" content="width=1100, user-scalable=yes">
<META NAME=”ROBOTS” CONTENT=”NOINDEX, NOFOLLOW”>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 

<title><tiles:getAsString name="title" /></title>
<!-- SweetAlert -->
<link href="<spring:eval expression="@globalContext['IMG_SERVER']" />/newjls/img/jls.ico" rel="shortcut icon" type="image/x-icon" />
<link rel="stylesheet" type="text/css" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/bootstrap-3.3.7/css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/summernote/summernote.css">
<link rel="stylesheet" type="text/css" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/font-awesome-4.7.0/css/font-awesome.min.css">

<link rel="stylesheet" type="text/css" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/jtable.2.3.1/themes/lightcolor/gray/jtable.min.css" />
<link rel="stylesheet" type="text/css" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/sweetAlert/sweetalert.css" />
<link rel="stylesheet" type="text/css" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/manage/css/manage.css" />

<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/js/jquery-3.1.1.min.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/js/jquery-ui-1.12.1.min.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/js/jquery.uniform.min.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/js/jquery.cookie.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/js/jquery.slimscroll.min.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/js/imagesloaded.pkgd.min.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/jtable.2.3.1/jquery.jtable.min.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/manage/js/manage.js"></script>

<!-- SweetAlert -->
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/sweetAlert/sweetalert.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/sweetAlert/core.js"></script>

<script type="text/javascript"> $.ajaxSetup({cache:false}); </script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" /><spring:eval expression="@globalContext['COMMON_JS_FILE']" />"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/js/json2.js"></script>

<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/summernote/summernote.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/summernote/summernote-image-attributes.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/bootstrap-3.3.7/js/bootstrap.js"></script>

<script type="text/javascript">
/* close popup layer */
$(document).on('click','.close, button.cancel',function() {
	$('body').removeClass('noscroll');
	$('.black_bg, .pop').fadeOut();
});

function fnUniform(){
	$uniformed = $('.pop').find('input[type=checkbox], input[type=radio]').not('.jtable');
	$uniformed.uniform();
}
</script>
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-93708311-9"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-93708311-9');
</script>	
</head>
<body>
	<div id="wrap">
		<tiles:insertAttribute name="header" />
		<tiles:insertAttribute name="lnb" />
		<tiles:insertAttribute name="content" />
	</div>
	
	<div class="black_bg"></div>
	<div id="layer_tag_list" class="pop fit small blue">
		<div class="header"><h1>태그선택</h1></div>
		<div class="create_area"><div class='basic'></div></div>
		<div class="footer">
			<button type="button" class="cancel"><span>취소</span></button>
			<button type="button" class="ok yellow"><span>확인</span></button>
		</div>
	</div>
	<div id="pop_upload_img" class="pop large blue"></div>
	<div id="pop_tag" class="pop fit small blue"></div>
	<!-- 네이버  -->
	<script type="text/javascript" src="https://wcs.naver.net/wcslog.js"></script>
	<script type="text/javascript">
		if(!wcs_add) var wcs_add = {};
		wcs_add["wa"] = "fa443c6ea1c";
		wcs_do();
	</script>
</body>
</html>