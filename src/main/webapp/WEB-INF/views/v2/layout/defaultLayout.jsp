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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=1024, user-scalable=yes">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">

<title><tiles:getAsString name="title" /></title>

<!-- SweetAlert -->
<link href="<spring:eval expression="@globalContext['IMG_SERVER']" />/hms/img/favicon_jls.ico" rel="shortcut icon" type="image/x-icon" />
<link rel="stylesheet" type="text/css" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/bootstrap-3.3.7/css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/daterangepicker/daterangepicker.css">

<link rel="stylesheet" type="text/css" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/summernote/summernote.css">

<link rel="stylesheet" type="text/css" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/quill/quill.snow.css?80704896">
<link rel="stylesheet" type="text/css" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/quill/modules/better-table/quill-better-table.css">

<!-- <link rel="stylesheet" type="text/css" href="/resources/quill/quill.snow.css">
<link rel="stylesheet" type="text/css" href="/resources/quill/modules/better-table/quill-better-table.css"> -->

<%-- <link rel="stylesheet" type="text/css" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/quill/modules/better-table-center/quill-better-table-center.css">   --%>
<!-- <link rel="stylesheet" type="text/css" href="https://unpkg.com/quill-better-table@1.2.7/dist/quill-better-table.css"> -->



<link rel="stylesheet" type="text/css" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/css/select2.min.css" />

<link rel="stylesheet" type="text/css" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/hms/css/admin/admin.css?80704897" />

<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/js/jquery-3.1.1.min.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/js/jquery-ui-1.12.1.min.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/jquery.tablesorter-2.31.1/js/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/jquery.tablesorter-2.31.1/js/jquery.tablesorter.widgets.min.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/jquery.tablesorter-2.31.1/js/widgets/widget-scroller.min.js"></script>

<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/js/jquery.nestable.min.js"></script>

<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/js/jquery.slimscroll.min.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/js/select2.min.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/daterangepicker/moment.min.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/daterangepicker/daterangepicker.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/js/MonthPicker.min.js"></script>

<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/bootstrap-3.3.7/js/bootstrap.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/summernote/summernote.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/summernote/summernote-image-attributes.js"></script>

<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/quill/quill.min.2.0.0.js"></script>
<%-- <script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/quill/quill.min.js"></script> --%>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/quill/modules/better-table/quill-better-table.min.js"></script>
<%-- <script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/quill/modules/better-table-center/quill-better-table-center.min.js"></script> --%>

<!-- <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/quill/2.0.0-dev.3/quill.min.js"></script> -->
<!-- <script type="text/javascript" src="https://unpkg.com/quill-better-table@1.2.10/dist/quill-better-table.min.js"></script> -->

<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/hms/js/admin.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/js/jquery.cookie.js"></script>

<!-- SweetAlert -->
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/sweetAlert/sweetalert.js"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/sweetAlert/core.js"></script>

<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" /><spring:eval expression="@globalContext['COMMON_JS_FILE']" />"></script>
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/js/json2.js"></script>
<script type="text/javascript"> $.ajaxSetup({cache:false}); </script>

<script type="text/javascript" src="/resources/js/hms-common-1.0.1.js"></script>
<!-- <script type="text/javascript" src="/resources/quill/quill.min.2.0.0.js"></script>
<script type="text/javascript" src="/resources/quill/modules/better-table/quill-better-table.min.js"></script> -->


<!-- Toast Editor -->
<script src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/toast_editor/js/squire-raw.js"></script>
<script src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/toast_editor/js/highlight.pack.js"></script>
<script src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/toast_editor/js/to-mark.js"></script>
<script src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/toast_editor/js/markdown-it.js"></script>
<script src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/toast_editor/js/tui-code-snippet.js"></script>
<script src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/toast_editor/js/codemirror.js"></script>
<link rel="stylesheet" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/toast_editor/css/codemirror.css">


<link type="text/css" rel="stylesheet" media="all" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/jquery.imgareaselect-0.9.10/css/imgareaselect-animated.css?49779909" />
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/jquery.imgareaselect-0.9.10/scripts/jquery.imgareaselect.pack.js?49779909"></script>

<script type="text/javascript">
var param_image_thumb_type = "";

/* close popup layer 
$(document).on('click','.close, .footer button.cancel, .create_btn button.cancel',function() {
	console.log("close / cancel ");
	$('body').removeClass('noscroll');
	$('.black_bg, .pop').fadeOut();
});
*/
function fnUniform(){
	$uniformed = $('.pop').find('input[type=checkbox], input[type=radio]').not('.jtable');
	$uniformed.uniform();
}

function fn_thumbnail_img_upload(request_type){
	$('body').addClass('noscroll');
	$('#pop_upload_img, .black_bg').fadeIn();
	$("#pop_upload_img .crop_img, #pop_upload_img .thumb_img").hide();
	$("#pop_upload_img .upload_img .file_input input").val("");
	param_image_thumb_type = request_type;
}
</script>
</head>
<body>
	<div id="wrap">
		<tiles:insertAttribute name="header" />
		<tiles:insertAttribute name="content" />
	</div>
	
	<div class="red_bg"></div>
	<div id="alert_box" title=""><p></p></div>
	
	<div class="black_bg">
		<jsp:include page="../popup/banner_select_type.jsp" flush="true" />
		<%-- <jsp:include page="../popup/tag_setting.jsp" flush="true" /> --%>
		<jsp:include page="../popup/thumbnail_img_upload.jsp" flush="true" />
		<jsp:include page="../popup/abroad_tag_setting.jsp" flush="true" />
		<jsp:include page="../popup/abroad_file_upload.jsp" flush="true" />
	</div>
</body>
</html>