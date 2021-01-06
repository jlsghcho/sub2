<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script type="text/javascript">
	$(document).on("click", "#pop_upload .footer button.create", function(){
		var param_item = $("#if_assessment").contents().find(".container table tr");
		var param_rtn_data = [];
		for(var i=0; i < param_item.length; i++){
			var param_obj = new Object();
			param_obj["file_path"] = param_item.eq(i).attr("file_path");
			param_obj["file_nm"] = param_item.eq(i).attr("file_nm");
			param_rtn_data.push(param_obj);
		}
		fn_lib_file_upload_return(param_rtn_data);
	});
</script>

<div id="pop_upload" class="pop medium blue">
	<div class="header">
		<h1>Upload File</h1>
		<div class="func"><div class="close">Close</div></div>
	</div>
	<div class="create_area">
		<iframe id="if_assessment" src="/v2/popup/lib_jquery_file_upload" width="100%" height="100%"></iframe>
	</div>
	<div class="footer">
		<button type="button" class="cancel"><span>Cancel</span></button>
		<button type="button" class="create yellow"><span>Confirm</span></button>
	</div>
</div>

