<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>

	<link type="text/css" rel="stylesheet" media="all" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/jquery.imgareaselect-0.9.10/css/imgareaselect-animated.css" />
	<script type="text/javascript" src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/jquery.imgareaselect-0.9.10/scripts/jquery.imgareaselect.pack.js"></script>
	
	<script type="text/javascript">
	var ImgWidth = 0, ImgHeight = 0, minWidth = 0, minHeight=0, percenter=0;
	var maxSize = 300;
	var ratio_w = "150";
	var ratio_h = "150";
	var upload_type = "${upload_type}";

	var param_upload_file_path = "<spring:eval expression="@globalContext['UPLOAD_FILE_PATH']" />";
	var param_upload_url = "<spring:eval expression="@globalContext['UPLOAD_FILE_DOMAIN']" />";
	var param_upload_rootfl = "<spring:eval expression="@globalContext['UPLOAD_ROOTFL']" />";
	
	$(document).ready(function() {
		$('.pop .scroll').slimScroll({	height: '100%', size: '5px', allowPageScroll: false, disableFadeOut: true });
		$(".upload_info .scroll").empty();

		var input_data = "<ul class='thumb'><li class='green'><span>Upload image</span><input type='radio' name='logo' id='uploadLogo' value='' /></li></ul>";
		$(".upload_info .scroll").append(input_data);
		$(".upload_info .scroll li:eq(0) input:radio").attr('checked', true);
		$('.edit_upload').removeClass('disabled');
		
		$("input[name='upload_type']").val(upload_type); // upload_type 넣기 
		$(".crop_img, .thumb_img").hide();
		$("#previewImg, #previewImgThumb").hide();
		fnUniform();

		// OK 버튼을 눌렀을때 
		$("#imageSave").click(function(){
			var formData = new Object();

			// 이미지 썸네일 만들어서 저장 
			if($("#param_step_url").val() == "" || $("#param_step_path").val() == "" || $("#param_step_file_nm").val() == "" ){ common_alert.big("저장할 이미지파일을 선택해주세요."); return; 	}
			var rootfl = (param_upload_rootfl == 'Y') ? true : false ; //로컬만 false 개발/운영은 true
			if(upload_type == "AD1"){
				var image_url = (rootfl == true) ? param_upload_url + $("#param_step_path").val() : $("#param_step_path").val();
				console.log(image_url);
				fnThumbResult(image_url);
			}else{
				if($("#thumbX").val() == "0" && $("#thumbY").val() == "0" && $("#thumbW").val() == "0" && $("#thumbH").val() == "0"){ common_alert.big("이미지에서 사용하실 영역을 선택하세요."); return; }
				 
				$.ajax({
					type : "POST",
					dataType : "json",
					url : "/lib/thumbnail",
					data : {
						'thumbX': $("#thumbX").val(),
						'thumbY': $("#thumbY").val(),
						'thumbW': $("#thumbW").val(),
						'thumbH': $("#thumbH").val(),
						'oripath' : $("#param_step_path").val().substring(0, $("#param_step_path").val().indexOf($("#param_step_file_nm").val()) -1 ),
						'orifile' : $("#param_step_file_nm").val(),
						'path' : param_upload_file_path ,
						'rootfl' : rootfl,
						'datefl' : true					
					},
					success : function(obj_result){ 
						if(obj_result.header.isSuccessful == true){
							var obj_data = JSON.parse(obj_result.data);
							var image_url = (rootfl == true) ? param_upload_url + obj_data[0]["fullpath"] : obj_data[0]["fullpath"].substring(obj_data[0]["fullpath"].indexOf(param_upload_file_path));
							
							/* 썸네일 만들고 나서 부모창에 토스해 준다. */
							fnThumbResult(image_url);
						}else{
							alert("썸네일 생성실패 ["+ obj_result.header.resultMessage +"]");
						}
					},
					error : function(xhr, ajaxOpts, thrownErr){
						alert(xhr.status,thrownErr);
					}
				});
			}
			$('.footer .cancel').click();
		});
		
		// STEP1. 업로드이미지 버튼 클릭했을때 
		$("input:file[name='uploadfile']").change(function(){
			$("#previewImg").imgAreaSelect({ remove: true }); 
			$("#previewImgThumb").attr('src','');
			
			var frm = document.fileuploadForm;
			frm.target = "hiddenIfrm";
			frm.action = "/lib/fileupload/return";
			frm.submit();
		});
		
		/* 주의 : 이미지 선택시엔 항상 Div 가 생긴다. 그러므로 페이지 하단에 div네임을 찾아서 지워줘야 한다. */
		$('.footer .cancel').click(function(){ 
			$('.imgareaselect-selection').parent('div').remove();
	  		$('.imgareaselect-outer').remove();
	  	});
	});
	
	function imageDataSaveFn(formData){
		$.ajax({
			type : "POST",
			dataType : "json",
			url : "/content/editProgramCourse",
			contentType: "application/json; charset=utf-8",
	        data : JSON.stringify(formData),
			success : function(data){
				if (data.result != "<spring:eval expression="@globalContext['SUCCESS']" />") {
					alert(data.msg);
				}
			},
			error : function(xhr, ajaxOpts, thrownErr){ alert(xhr +'/'+ thrownErr ); return; }
		});			
	}

	// STEP1. 첨부파일 업로드 이후 
	function fileupload_return(file_ori_nm, fullpath, image_url, upload_type, file_nm){
		var img = new Image();
		$('#param_step_nm').val(file_ori_nm);
		$('#param_step_url').val(image_url);
		$('#param_step_path').val(fullpath);
		$("#param_step_file_nm").val(file_nm);
		
		 //##### 여기에서 타입별로 사이즈 조절한다.
		if(upload_type == "AD1"){
			$(".crop_img").show();
			$(".crop_img h3").hide();
			ratio_w = "${w}"; ratio_h = "${h}";
			if(image_url != ""){
				$("#previewImg").show();
				$('#previewImg').attr('src', image_url);
				
				var img = new Image();
				img.src = image_url;
				img.onload = function(){
					$(".sizetext").text("Width : "+ this.width +"px / Height : "+ this.height +"px");
				}
			}
		}else{
			$(".crop_img, .thumb_img").show();

			if(upload_type == "NW1"){ ratio_w = "268"; ratio_h = "200"; }
			if(image_url != ""){
				$("#previewImg, #previewImgThumb").show();
				$('#previewImg').attr('src', image_url);
					
				img.src = $('#param_step_url').val();
				img.onload = function(){
					ImgWidth = img.width;
					ImgHeight = img.height;
					
					if(parseInt(ImgWidth) > maxSize){
						percenter = ( maxSize * 100 )/ImgWidth;
						minWidth = maxSize;
						minHeight = (ImgHeight*percenter)/100;
					}else{
						minWidth = ImgWidth;
						minHeight = ImgHeight;
					}
					$("#previewImg").css({"width" : minWidth, "height" : minHeight});
				};
			}
			$('#previewImgThumb').attr('src', image_url);
			$("#previewImg").imgAreaSelect({ aspectRatio: ratio_w +":"+ ratio_h, handles: true, onInit : preview, onSelectChange : preview });
			$(".thumb_img .thumb").css({width: ratio_w +'px', height: ratio_h +'px',overflow:'hidden'});
		}
	}

	// STEP2. 영역선택시 
	function preview(img, selection) {
	    var scaleX;
	    var scaleY;
	    scaleX = ratio_w / (selection.width || 1);
	    scaleY = ratio_h / (selection.height || 1);
	  
	    $('#previewImgThumb').css({
	        width: Math.round(scaleX * minWidth) + 'px',
	        height: Math.round(scaleY * minHeight) + 'px',
	        marginLeft: '-' + Math.round(scaleX * selection.x1) + 'px',
	        marginTop: '-' + Math.round(scaleY * selection.y1) + 'px'
	    });
	    //console.log(selection.x1 +','+selection.y1 +'/'+ selection.x2 +','+ selection.y2);
	    
	    if(percenter > 0){
		    $("#thumbX").val(Math.round((selection.x1*100)/percenter));
		    $("#thumbY").val(Math.round((selection.y1*100)/percenter));
		    $("#thumbW").val(Math.round((selection.x2*100)/percenter));
		    $("#thumbH").val(Math.round((selection.y2*100)/percenter));
	    }else{
		    $("#thumbX").val(Math.round(selection.x1));
		    $("#thumbY").val(Math.round(selection.y1));
		    $("#thumbW").val(Math.round(selection.x2));
		    $("#thumbH").val(Math.round(selection.y2));
	    }
	}
	</script>
	<div class="header">
		<h1>Upload Image</h1>
		<div class="close">Close</div>
	</div>
	<div class="upload_info">
		<div class="content"><div class="scroll"></div></div>
	</div>
	<div class="edit_upload disabled">
		<div class="content">
			<div class="scroll">
				<div class="upload_img">
			  		<input type="hidden" name="thumbX" id="thumbX" size="3" />
			  		<input type="hidden" name="thumbY" id="thumbY" size="3" />
			  		<input type="hidden" name="thumbW" id="thumbW" size="3" />
			  		<input type="hidden" name="thumbH" id="thumbH" size="3" />
				
					<h3><b>STEP 1</b> Please upload a image file to be used as logo image</h3>
	  				<div class="file_input">
	  					<input type="hidden" id="param_step_url" name="param_step_url" disabled="disabled"/>
	  					<input type="hidden" id="param_step_path" name="param_step_path" disabled="disabled"/>
	  					<input type="hidden" id="param_step_file_nm" name="param_step_file_nm" disabled="disabled"/>
						<input type="text" id="param_step_nm" name="param_step_nm" style="ime-mode:inactive;" disabled="disabled">
					</div>
					<c:set var="rootfl"><spring:eval expression="@globalContext['UPLOAD_ROOTFL']" /></c:set>
				  	<form id="fileuploadForm" name="fileuploadForm" method="post" enctype="multipart/form-data" >
				  	<input type='hidden' name='path' value='<spring:eval expression="@globalContext['UPLOAD_FILE_PATH']" />' />
				  	<c:if test="${rootfl eq 'Y' }">				  	
				  	<input type='hidden' name='rootfl' value='1' />
				  	</c:if>
				  	<c:if test="${rootfl ne 'Y' }">				  	
				  	<input type='hidden' name='rootfl' value='0' />
				  	</c:if>
				  	<input type='hidden' name='datefl' value='1' />
				  	<input type='hidden' name='param_rtn' value='/common/make_thumb_rtn' />
				  	<input type="hidden" name='upload_type' />
					<button type="button" class="yellow"><span>Upload Image</span></button>
					<input type="file" id='uploadfile' name="uploadfile" accept="image/gif, image/jpeg, image/bmp, image/png" />
				  	</form>
				</div>
				<div class="crop_img">
					<h3><b>STEP 2</b> Click and drag on the image to select an area.</h3>
					<div class="frame"><img id="previewImg" src=""><br><span class='sizetext'></span></div>
				</div>
				<div class="thumb_img" >
					<h3><b>STEP 3</b> Please click OK and upload logo.</h3>
					<div class="thumb" ><img id="previewImgThumb" src=""></div>
				</div>
			</div>
		</div>
		<div class="turnoff"><span>This area is...</span></div>
	</div>
	<div class="footer">
		<button type="button" class="cancel"><span>Cancel</span></button>
		<button type="button" id='imageSave' class="add yellow"><span>OK</span></button>
	</div>
	<iframe id="hiddenIfrm" name="hiddenIfrm" src="about:blank" style="display:none"></iframe>