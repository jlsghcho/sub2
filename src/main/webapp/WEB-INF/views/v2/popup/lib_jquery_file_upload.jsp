<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<meta charset="utf-8">
<title>jQuery File Upload Upgrade v1.0</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" type="text/css" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/bootstrap-3.3.7/css/bootstrap.css">
<link rel="stylesheet" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/jQuery-File-Upload-9.18.0/css/jquery.fileupload.css">
<link rel="stylesheet" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/jQuery-File-Upload-9.18.0/css/jquery.fileupload-ui.css">
<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/js/jquery-3.1.1.min.js"></script>
<style>
body { padding-top : 20px !important; }
table { margin-top : 20px !important; }
div, .name, .size, .label {
	font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
    font-size: 14px !important;
    line-height: 1.42857143;
    width : 100% !important;
}
</style>

<script type="text/javascript">
	/* 첨부파일을 등록했을때 */
	$(document).on("change", ".container .row .btn input:file[name='upload_files']", function(){
		for(var i=0; i < $(this).prop("files").length; i++){ fn_set_files($(this).prop("files")[i]); }
	});

	/* 첨부파일을 삭제 요청  */
	$(document).on("click", ".container .row button.cancel", function(){ $(".container table tbody").empty(); });

	/* 첨부파일을 부분 삭제 요청  */
	$(document).on("click", ".container table button.cancel", function(){ $(".container table tr").eq($(this).closest("tr").index()).remove(); });

	function fn_set_files(param_files){
		var form_data = new FormData();
		form_data.append("files", param_files);

		var param_img_ext = ['jpeg', 'jpg', 'png', 'gif', 'bmp'];
		var param_file_ext = ['zip', 'doc', 'xls', 'xlsx', 'txt', 'ppt', 'pdf', 'mp4', 'mp3', 'avi'];
		var param_input_data = "";
		$.ajax({
			type : "POST"
			, processData : false
			, contentType : false
			, cache : false
			, data : form_data
			, url : "/lib/v2/upload/files"
			, dataType : "json"
			, success : function(obj_result){
				var obj_data = JSON.parse(obj_result.data);
				
				param_input_data += "<tr class='template-upload fade in' file_path='"+ obj_data["file_url_domain"] + obj_data["file_full_path"] +"' file_nm='"+ obj_data["file_origin_name"] +"'>";
				param_input_data += "<td><span class='preview'>";
				if($.inArray(obj_data["file_origin_ext_name"], param_img_ext ) > 0){
					param_input_data += "<img src='"+ obj_data["file_url_domain"] + obj_data["file_full_path"] +"' style='max-height:80px;'/>";
				}else{
					if($.inArray(obj_data["file_origin_ext_name"], param_file_ext ) > 0){
						param_input_data += "<img src='<spring:eval expression="@globalContext['IMG_SERVER']" />/common/jQuery-File-Upload-9.18.0/img/"+ obj_data["file_origin_ext_name"] +".png'/>";
					}else{
						param_input_data += "<img src='<spring:eval expression="@globalContext['IMG_SERVER']" />/common/jQuery-File-Upload-9.18.0/img/etc.png'/>";
					}
				}
				param_input_data += "</span></td>";
				param_input_data += "<td><p class='name' width='100%'>"+ obj_data["file_origin_name"] +"</p></td>";
				param_input_data += "<td><p class='size'>"+ fn_number_with_delimiter(fn_file_format_bytes(obj_data["file_size"])) +"</p></td>";
				param_input_data += "<td><button class='btn btn-warning cancel'><i class='glyphicon glyphicon-ban-circle'></i><span>Cancel</span></button></td>";
				param_input_data += "</tr>";
				$(".container table tbody").append(param_input_data);
			}
			, error : function(xhr, ajaxOpts, thrownErr){
				console.log(xhr +"/"+ ajaxOpts +"/"+ thrownErr );
				alert(xhr +"/"+ ajaxOpts +"/"+ thrownErr);
			}
		});
	}
	
	function fn_file_format_bytes(x)	{
	      var s = ["Bytes", "KB", "MB", "GB", "TB", "PB"];
	      var e = Math.floor(Math.log(x) / Math.log(1024));
	      return (x / Math.pow(1024, e)).toFixed(2) + " " + s[e];
	}
	
	function fn_number_with_delimiter(x) {  return String(x).replace(/\B(?=(?:\d{3})+(?!\d))/g, ","); }
</script>
</head>
<body>
	<div class="container">
		<div class="row fileupload-buttonbar">
			<div class="col-lg-7">
				<span class="btn btn-success fileinput-button">
					<i class="glyphicon glyphicon-plus"></i>
					<span>Add files...</span>
					<input type="file" name='upload_files' multiple>
				</span>
				<button type="reset" class="btn btn-warning cancel"><i class="glyphicon glyphicon-ban-circle"></i><span style='padding-left:5px;'>Cancel upload</span></button>
				<span class="fileupload-process"></span>
			</div>
		</div>
		<table role="presentation" class="table table-striped"><tbody class="files"></tbody></table>
	</div>

</body>
</html>

