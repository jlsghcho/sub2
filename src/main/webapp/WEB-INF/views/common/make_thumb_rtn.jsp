<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<script language="JavaScript" type="text/JavaScript">
	var result = "${result}";
	var param_msg = "${param_msg}";
	var file_nm = "${file_nm}";
	var file_ori_nm = "${file_ori_nm}";
	var fullpath = "${fullpath}";
	var ori_ext_nm = "${ori_ext_nm}";
	var file_size = "${file_size}";
	var upload_type = "${upload_type}";
	
	var param_upload_file_path = "<spring:eval expression="@globalContext['UPLOAD_FILE_PATH']" />";
	var param_upload_url = "<spring:eval expression="@globalContext['UPLOAD_FILE_DOMAIN']" />";
	var param_upload_rootfl = "<spring:eval expression="@globalContext['UPLOAD_ROOTFL']" />";
	
	var image_url = (param_upload_rootfl == 'Y') ? param_upload_url + fullpath : fullpath.substring(fullpath.indexOf(param_upload_file_path));
	
	switch(result){
		case "success":
			parent.fileupload_return(file_ori_nm, fullpath, image_url, upload_type, file_nm);
			break;
		case "fail":
			alert(param_msg);
			break;
	}
</script>
