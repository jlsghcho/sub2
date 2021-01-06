<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script type="text/javascript">
	var origin_image_file_width = 0, origin_image_file_height = 0, origin_crop_image_width = 0, origin_crop_image_height=0, percenter=0, ratio_width=0, ratio_height=0;
	
	$(document).on("change", "#pop_upload_img .upload_img .file_input input:file", function(){
		console.log(">> request type : "+param_image_thumb_type);

		var form_data = new FormData();
		form_data.append("files", $(this).prop("files")[0]);
		form_data.append("banner_location", "0");
		
		$.ajax({
			type : "POST"
			, processData : false
			, contentType : false
			, cache : false
			, data : form_data
			, url : "/lib/upload/banner"
			, dataType : "json"
			, success : function(obj_result){
				var obj_data = JSON.parse(obj_result.data);
				console.log(obj_data);
				$("#pop_upload_img .crop_img, #pop_upload_img .thumb_img").show();
				$("#pop_upload_img .upload_img .file_input input[name='file_image_real_name']").val(obj_data["file_origin_name"]);
				$("#pop_upload_img .crop_img #file_image_upload_path").attr("src", obj_data["file_url_domain"] + obj_data["file_full_path"]); 
				//$("#pop_upload_img .crop_img #file_image_upload_path").attr("src", "http://devimg.gojls.com/hms/img/admin/login_bg_01.jpg"); //테스트를 위해서 
				
				fn_step2_stage();
			}
			, error : function(xhr, ajaxOpts, thrownErr){
				console.log(xhr +"/"+ ajaxOpts +"/"+ thrownErr );
				alert('warning', xhr +"/"+ ajaxOpts +"/"+ thrownErr);
			}
		});
	});
	
	$(document).on("click", "#pop_upload_img .thumb_img .upload_btn button", function(){
		var param_obj = new Object();
		param_obj["thumb_X"] = $("#thumb_X").val();
		param_obj["thumb_Y"] = $("#thumb_Y").val();
		param_obj["thumb_W"] = $("#thumb_W").val();
		param_obj["thumb_H"] = $("#thumb_H").val();
		param_obj["fixed_size_W"] = ratio_width;
		param_obj["fixed_size_H"] = ratio_height;
		param_obj["origin_image_path"] =$("#pop_upload_img .crop_img #file_image_upload_path").attr("src");

		if($("#thumb_X").val() == "0" && $("#thumb_Y").val() == "0" && $("#thumb_W").val() == "0" && $("#thumb_H").val() == "0"){ alert("이미지에서 사용하실 영역을 선택하세요."); return; }

		var obj_result = JSON.parse(common_ajax.inter("/lib/v2/make/thumbnail", "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			fn_popup_thumb_image_return(obj_data[0]["change_file"]);
		}else{
			alert(obj_result.header.resultMessage);
		}
		$("#pop_upload_img .func .close").trigger("click");
	});

	$(document).on("click", "#pop_upload_img .func .close", function(){
		$('.imgareaselect-selection').parent('div').remove();
		$('.imgareaselect-outer').remove();
	});
	
	function fn_step2_stage(){
		var img = new Image();
		var origin_image_url = $("#pop_upload_img .crop_img #file_image_upload_path").attr("src");
		var layer_popup_width = ($("#pop_upload_img").width() / 2);
		img.src = origin_image_url;
		img.onload = function(){
			origin_image_file_width = img.width;
			origin_image_file_height = img.height;
			
			if(parseInt(origin_image_file_width) > layer_popup_width){
				percenter = ( layer_popup_width * 100 )/origin_image_file_width;
				origin_crop_image_width = layer_popup_width;
				origin_crop_image_height = (origin_image_file_height * percenter)/100;
			}else{
				origin_crop_image_width = origin_image_file_width;
				origin_crop_image_height = origin_image_file_height;
			}
			$("#pop_upload_img .crop_img #file_image_upload_path").css({"width" : origin_crop_image_width, "height" : origin_crop_image_height});
		};
		
		/* 환경설정 */
		if(param_image_thumb_type == "banner_direct") { ratio_width = "370"; ratio_height = "231"; }
		else if(param_image_thumb_type == "partner") { ratio_width = "120"; ratio_height = "80"; }
		else if(param_image_thumb_type == "manager") { ratio_width = "112"; ratio_height = "112"; }
		else if(param_image_thumb_type == "abroad_banner") { ratio_width = "270"; ratio_height = "180"; }
		else{ ratio_width = "400"; ratio_height = "300"; }
		
		$("#pop_upload_img .thumb_img h4").text("View size : "+ ratio_width +" x "+ ratio_height);
		$("#pop_upload_img .thumb_img #file_image_thumb_path").attr('src', origin_image_url);
		if(param_image_thumb_type == "banner_direct" ){
			$("#pop_upload_img .crop_img #file_image_upload_path").imgAreaSelect({ aspectRatio: ratio_width +':'+ ratio_height,  maxWidth: ratio_width, maxHeight: ratio_height, handles: true, onInit : fn_step2_select_preview, onSelectChange : fn_step2_select_preview });
		}else{
			$("#pop_upload_img .crop_img #file_image_upload_path").imgAreaSelect({ aspectRatio: ratio_width +':'+ ratio_height,  handles: true, onInit : fn_step2_select_preview, onSelectChange : fn_step2_select_preview });
		}
		$("#pop_upload_img .thumb_img .thumb").css({width: ratio_width +'px', height: ratio_height +'px',overflow:'hidden'});
	}
	
	function fn_step2_select_preview(img, selection) {
	    var scaleX;
	    var scaleY;
	    scaleX = ratio_width / (selection.width || 1);
	    scaleY = ratio_height / (selection.height || 1);
	  
	    $('#file_image_thumb_path').css({
	        width: Math.round(scaleX * origin_crop_image_width) + 'px',
	        height: Math.round(scaleY * origin_crop_image_height) + 'px',
	        marginLeft: '-' + Math.round(scaleX * selection.x1) + 'px',
	        marginTop: '-' + Math.round(scaleY * selection.y1) + 'px'
	    });

	    if(percenter > 0){
		    $("#thumb_X").val(Math.round((selection.x1*100)/percenter));
		    $("#thumb_Y").val(Math.round((selection.y1*100)/percenter));
		    $("#thumb_W").val(Math.round((selection.x2*100)/percenter));
		    $("#thumb_H").val(Math.round((selection.y2*100)/percenter));
	    }else{
		    $("#thumb_X").val(Math.round(selection.x1));
		    $("#thumb_Y").val(Math.round(selection.y1));
		    $("#thumb_W").val(Math.round(selection.x2));
		    $("#thumb_H").val(Math.round(selection.y2));
	    }
	}	
</script>

<div id="pop_upload_img" class="pop full blue">
	<div class="header">
		<h1>Upload Image</h1>
		<div class="func">
			<div class="close">Close</div>
		</div>
	</div>
	<div class="create_area">
		<div class="scroll">
			<div class="edit_thumb">
				<div class="upload_img">
				
			  		<input type="hidden" name="thumb_X" id="thumb_X" size="3" />
			  		<input type="hidden" name="thumb_Y" id="thumb_Y" size="3" />
			  		<input type="hidden" name="thumb_W" id="thumb_W" size="3" />
			  		<input type="hidden" name="thumb_H" id="thumb_H" size="3" />
				
					<h3><b>STEP 1</b> Please upload a image file to be used as thumbnail image.</h3>
					<div class="file_input">
						<input type="text" name="file_image_real_name" style="ime-mode:inactive;" disabled />
						<button type="button" class="yellow"><span>Import image</span></button>
						<input type="file" class="edit_upload" name="file_image_step1_upload" accept="image/gif, image/jpeg, image/bmp, image/png" />
					</div>
				</div>
				<div class="crop_img">
					<h3><b>STEP 2</b> Click and drag on the image to select an area.</h3>
					<div class="frame"><img id="file_image_upload_path" src=""></div>
				</div>
				<div class="thumb_img">
					<h3><b>STEP 3</b> Click upload button.</h3>
					<div class="thumb"><img id="file_image_thumb_path" src=""></div>
					<h4>View size : 200 x 150<br>Actual size : 400 x 300</h4>
					<div class="upload_btn">
						<button type="button" class="add blue"><span>Upload image</span></button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
