<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
response.setDateHeader("Expires", -1);
%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=1024, user-scalable=yes">
		<meta http-equiv="X-UA-Compatible" content="IE=Edge">

		<title>Homepage Management System</title>
		<link href="<spring:eval expression="@globalContext['IMG_SERVER']" />/hms/img/favicon_jls.ico" rel="shortcut icon" type="image/x-icon" />
		<link rel="stylesheet" type="text/css" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/sweetAlert/sweetalert.css" />
		<link rel="stylesheet" type="text/css" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/hms/css/admin/admin_login.css?64580935"></script>
		<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/js/jquery-3.1.1.min.js"></script>
		
		<!-- SweetAlert -->
		<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/sweetAlert/sweetalert.js"></script>
		<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/sweetAlert/core.js"></script>

		<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" /><spring:eval expression="@globalContext['COMMON_JS_FILE']" />"></script>
		<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/js/json2.js"></script>

		<script type="text/javascript">
		<!--
			//Ajax cache 끄기
			$.ajaxSetup({cache:false});
		//-->
		</script>
		
		<script type="text/javascript">
			window.focus();
			$(document).ready(function() { 
				
				/* input empty */
				$('#empId').keyup(function () {
					if ($(this).val().length > 0) {
						$(this).next('.empty').addClass('txtin');
					} else {
						$(this).next('.empty').removeClass('txtin');
					} 
				});
				$('#passWd').keyup(function () {
					if ($(this).val().length > 0) {
						$(this).next('.empty').addClass('txtin');
					} else {
						$(this).next('.empty').removeClass('txtin');
					} 
				});
				
				$('button.empty').click(function () {
					$(this).prev('input').val('');
					$(this).removeClass('txtin');
				});
				
				$('input').keypress(function(event){
					var s = String.fromCharCode(event.which );
					if((s.toUpperCase() === s && s.toLowerCase() !== s && !event.shiftKey) || (s.toUpperCase() !== s && s.toLowerCase() === s && event.shiftKey)){
						$("#capslock").css('display','block');
					} else {
						$("#capslock").css('display','none');
					}
				});
				
				if(common_cookie.get('hmsTstayLogin') != ""){ 
					$("#loginStay").prop('checked',true); 
					$("#empId").val(common_cookie.get('hmsTstayLogin'));
					$("#label_id").addClass('hide');
					$('#passWd').focus();
				}
			});
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
			<div id="container">
				<div class="box login">
					<div class="mh">
						<h1><span><img src="<spring:eval expression="@globalContext['IMG_SERVER']" />/hms/img/admin/mh_logo.svg" class="logo"></span><span>HMS</span></h1>
						<h2>ADMIN</h2>
					</div>
					<div class="form_section">
					<form id="loginForm">
						<div class="input_row">
							<input type="text" id="empId" name="empId" tabIndex="1" placeholder="ID" onkeypress="if (event.keyCode==13){$('#passWd').focus();}" />
							<button type="button" class="empty"></button>
						</div>
						<div class="input_row">
							<input type="password" id="passWd" name="passWd" tabIndex="1" placeholder="PW" onkeypress="if (event.keyCode==13){ goLoginFn(); }" />
							<button type="button" class="empty"></button>
						</div>
						<button type="button" class="blue log" onclick="goLoginFn()"><span>Sign In</span></button>
					</div>
					<div class="option">
						<input type="checkbox" id="loginStay" name='loginStay' /> <label for="loginStay">Save id</label>
					</div>
					</form>
					<ul class="info">
						<li>Admin에 관련된 문의는 JLS 고객센터를 이용해주세요. <br>JLS고객센터 : 1644-0500</li>
					</ul>
				</div>
			</div>
		</div>

		<script type="text/javascript">
			var openURL = "";
			var winPop = "";
			var param_domain = "<spring:eval expression="@globalContext['COOKIE_DOMAIN']" />";
		    function goLoginFn() {
		    	if(common_trims.trim($("#empId").val()) == ""){
		    		$("#empId").val("").focus();
		    		common_alert.big('warning','아이디를 입력해주세요.');
		    		return;
		    	}else{
		    		$("#empId").val(common_trims.trim($("#empId").val()));
		    	}
		    	
		    	if(common_trims.trim($("#passWd").val()) == ""){
		    		$("#passWd").val("").focus();
		    		common_alert.big('warning','패스워드를 입력해주세요.');
		    		return;
		    	}else{
		    		$("#passWd").val(common_trims.trim($("#passWd").val()));
		    	}
		    	
		    	if($("#loginStay").is(":checked") == true){ 
		    		common_cookie.set_ex('hmsTstayLogin', $("#empId").val(), 1, param_domain); 
		    	}else {
		    		common_cookie.set_ex('hmsTstayLogin', "", 1, param_domain); 
		    	}
		    	
	   			$.ajax({
	   				type:"POST",
	   				dataType:"json",
	   				url:"/login",
	   				data:$("#loginForm").serialize(),
	   				success:function(result) {
	   					if (result.header.isSuccessful) {
	   						document.location = "/";
	   					} else {
   							common_alert.big_func('warning', result.header.resultMessage, fnResultFocus);
	   					}
	   				},
	   				error:function(xhr, ajaxOpts, thrownErr) {
							common_alert.big_func('warning', "에러가 발생했습니다. 관리자에게 문의 바랍니다.", fnResultFocus);
	   				}
	   			});
		    }
		    
		    function fnResultFocus(){ $("#passWd").val("").focus(); }
		</script>
		<!-- 네이버  -->
		<script type="text/javascript" src="https://wcs.naver.net/wcslog.js"></script>
		<script type="text/javascript">
			if(!wcs_add) var wcs_add = {};
			wcs_add["wa"] = "fa443c6ea1c";
			wcs_do();
		</script>
	</body>
</html>
