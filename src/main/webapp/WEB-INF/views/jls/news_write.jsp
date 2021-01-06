<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<script type="text/javascript">
var nowDate = "${serverDate}";
var param_empType = "${cookieEmpType}";
var param_seq = "${param_seq}";
var param_contnt_seq = "";
var param_dept_seq = 1;
var param_deptList = "${cookieDeptList}";

var param_empSeq = "${cookieEmpSeq}";
var param_empNm = "${cookieEmpNm}";

var param_upload_file_path = "<spring:eval expression="@globalContext['UPLOAD_FILE_PATH']" />";
var param_upload_url = "<spring:eval expression="@globalContext['UPLOAD_FILE_DOMAIN']" />";
var param_upload_rootfl = "<spring:eval expression="@globalContext['UPLOAD_ROOTFL']" />";

$(document).ready(function(){
	$uniformed = $('.jtable-main-container .jtable').find('input[type=checkbox], input[type=radio]').not('.jtable');
	$uniformed.uniform();

	$('#paper_editor').summernote({
		lang: 'ko-KR',
		toolbar: [
		    ['style', ['fontname', 'bold', 'italic', 'underline', 'clear']],
		    ['font', ['strikethrough', 'superscript', 'subscript']],
		    ['fontsize', ['fontsize']],
		    ['color', ['color']],
		    ['para', ['hr','ul', 'ol', 'paragraph']],
		    ['height', ['height']],
		    ['insert', ['picture', 'video', 'link', 'table','codeview']]
		],
		popover : {
			image : [
				['custom', ['imageAttributes']],
				['imagesize', ['imageSize100', 'imageSize50', 'imageSize25']],
				['float', ['floatLeft', 'floatRight', 'floatNone']],
				['remove', ['removeMedia']]
			]
		},
		imageAttributes:{
            imageDialogLayout:'default', // default|horizontal
            icon:'<i class="note-icon-pencil"/>',
            removeEmpty:false // true = remove attributes | false = leave empty if present
        },
        displayFields:{
            imageBasic:true,  // show/hide Title, Source, Alt fields
            imageExtra:true, // show/hide Alt, Class, Style, Role fields
            linkBasic:true,   // show/hide URL and Target fields for link
            linkExtra:false   // show/hide Class, Rel, Role fields for link
        },
		dialogsInBody: true,
		shortcuts: true,
		height: "450px", 
		disableResizeEditor: false, // 사이즈 조절바 (true / false)
		callbacks : {
			onImageUpload: function(files, editor, welEditable){ fnImageUpload(files[0], this, param_upload_file_path); },
			onChange : function(){
				$(".note-editable iframe").each(function(){
					if($(this).parent().attr('class') != 'video-wrapper'){
						$(this).wrap("<div class='video-wrapper'></div>"); 
					}
				}); //비디오태그에 우리쪽 클래스명을 삽입해 준다. 
			}
		}
	});
	
	// calendar datepicker
	$("input[name='frm_start_dt']").datepicker({
		changeMonth: true,
		changeYear: true,
		yearRange : '2014:'+ nowDate.substr(0,4) ,
		dateFormat: "yy-mm-dd",
		onClose: function( selectedDate ) {
			$("input[name='frm_end_dt']").datepicker( "option", "minDate", selectedDate );
		}
	});
	
	var rangeYear = common_date.monthAdd(common_date.convertType(nowDate,4), 12);
	$("input[name='frm_end_dt']" ).datepicker({
		changeMonth: true,
		changeYear: true,
		yearRange : '2014:'+ rangeYear.substr(0,4),
		dateFormat: "yy-mm-dd",
		onClose: function( selectedDate ) {
			$("input[name='frm_start_dt']").datepicker( "option", "maxDate", selectedDate );
		}
	});
	
	fnBtnSize();
	
	if(param_empType != 'S'){ $(".title h2").text("분원소식"); }else{ $(".title h2").text("JLS소식"); }
	
	$("#imageUrl_pic").attr("src", "<spring:eval expression="@globalContext['IMG_SERVER']" />/manage/img/admin/thumb_empty.png");
	$("input[name='frm_reg_user_seq']").val(param_empSeq);
	$("input[name='frm_reg_user_nm']").val(param_empNm);
	
	if(param_seq != ""){ //수정모드 
		$(".title h3").text("> 수정");
		$("input[name='frm_param_seq']").val(param_seq); 
		$("#frm_dept_seq1, #frm_dept_seq2").empty().hide();
		
		$.when(fnNewsView(param_seq)).done(function(){ 
			$.when(fnTagsView(param_contnt_seq)).done(function(){ });
		});
		
	}else{ // 새글쓰기모드
		$("input[name='frm_start_dt']").datepicker("setDate", common_date.strToDate(nowDate) );
		$("input[name='frm_end_dt']").datepicker("setDate", common_date.strToDate(common_date.monthAdd(common_date.convertType(nowDate,4), 12)));

		if(param_empType == 'S'){
			$("#frm_dept_seq2").empty().hide();
			var obj_result = JSON.parse(common_ajax.inter("/service/code/topdept", "json", false, "GET", ""));
			if(obj_result.header.isSuccessful == true){
				var obj_data = JSON.parse(obj_result.data);
				var input_data = "<option value=''>선택</option>";
				for(var i=0; i < obj_data.length; i++){
					input_data += "<option value='"+ obj_data[i]["dltDeptSeq"]+"'>"+ obj_data[i]["dltDeptNm"] +"</option>";
				}
				$("select[name='frm_dept_seq1']").empty().append(input_data).show();
			}else{
				$("select[name='frm_dept_seq1']").empty().append("<option value=''>정보 오류발생</option>").show();
			}
		}else{
			$("#frm_dept_seq1").empty().hide();
			var deptStr = param_deptList.split(",");
			var inclass = "";
			if(deptStr.length > 0){
				$("select[name='frm_dept_seq2']").empty().append("<option value='' selected>선택</option>").show(); 
				for(var i = 0; i < deptStr.length; i++){
					var deptinfo = deptStr[i].split(":");
					//if(i == 0){ inclass = "selected"; }
					$("select[name='frm_dept_seq2']").append("<option value='"+ deptinfo[0]+"' "+ inclass +">"+ deptinfo[1]+"</option>").show();
				}
			}
		}
		
		var noticeTypeNm = (param_empType != 'S') ? "분원소식" : "JLS소식"; 
		$(".jtable-main-container .jtable tr:eq(2)").find("td:eq(1)").text(noticeTypeNm);
		$(".title h3").text("> 등록");
		$(".jtable-main-container .jtable tr:eq(5)").find("td").text("-");
		$(".jtable-main-container .jtable tr:eq(6)").find("td").text(param_empNm);
		$(".jtable-main-container .jtable input:radio[name='frm_view_yn']").eq(0).prop("checked", true);	
	}
	
	$.uniform.update();
	
	$("select[name='frm_dept_seq1']").change(function(){
		$("#frm_dept_seq2").empty();
		if($(this).val() != ""){
			var obj_result = JSON.parse(common_ajax.inter("/service/code/secdept?parentDeptSeq="+ $(this).val(), "json", false, "GET", ""));
			if(obj_result.header.isSuccessful == true){
				var obj_data = JSON.parse(obj_result.data);
				var input_data = "<option value=''>전체</option>";
				for(var i=0; i < obj_data.length; i++){
					input_data += "<option value='"+ obj_data[i]["dltDeptSeq"]+"'>"+ obj_data[i]["dltDeptNm"] +"</option>";
				}
				$("select[name='frm_dept_seq2']").empty().append(input_data).show();
			}else{
				$("select[name='frm_dept_seq2']").empty().append("<option value='0'>정보 오류발생</option>").show();
			}
		}else{
			$("select[name='frm_dept_seq2']").empty().hide();
		}
	});

	$("select[name='frm_dept_seq2']").change(function(){
		var dept_seq1 = $("select[name='frm_dept_seq1']").val();
		console.log(dept_seq1 +"/"+ $(this).val());
		if(dept_seq1 != ""){
			if($(this).val() == ""){
				$(".jtable-main-container .jtable tr:eq(2)").find("td:eq(1)").text("JLS소식");
			}else{
				$(".jtable-main-container .jtable tr:eq(2)").find("td:eq(1)").text("분원소식");
			}
		}else{
			$(".jtable-main-container .jtable tr:eq(2)").find("td:eq(1)").text("분원소식");
		}
	});
	
	/* Thumbnail Image 관련 소스 */
	$("#thumbPop").click(function(){
		$("#pop_upload_img").load("/common/make_thumb?upload_type=NW1", function(response, status, xhr) {
			$('#pop_upload_img, .black_bg').fadeIn();
			$('body').removeClass('noscroll');
			fnUniform();
		});
	});
	
	$("#thumbDel").click(function(){ $("input[name='frm_img_thumb']").val(''); $("#imageUrl_pic").attr('src',''); })
	
	/* Tag 관련 소스 */
	$(".tag_btn").click(function(){
		$("#layer_tag_list, .black_bg").fadeIn('fast');
		$("body.pcta").addClass('noscroll');
		$("#layer_tag_list").center();
		
		//만약 수정일경우나 아래 tagList에 데이터가 있다면 디폴트 체크해 주세요. 
		var tag_input = $(".jtable-main-container input[name='frm_tag_list']").val();
		var input_data = "<dl>";
		var check_class = "";
		var obj_result = JSON.parse(common_ajax.inter("/service/code/tag", "json", false, "GET", ""));
		var cnt = 1;
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			for(var i=0; i < obj_data.length; i++){
				if(tag_input.indexOf(obj_data[i]["tagCode"]) > -1){ check_class = 'checked'; }else{ check_class = ''; }
				input_data += "<dd><input type='checkbox' name='tagType' id='typeTag_"+ i +"' value='"+ obj_data[i]["tagCode"] +":"+ obj_data[i]["tagNm"] +"' "+ check_class +"/> <label for='typeTag_"+ i +"'>"+ obj_data[i]["tagNm"] +"</label></dd>";
				if(cnt % 5 == 0){ input_data += '</dl><dl>'; }
				if(cnt == obj_data.length){ input_data += '</dl>'; }
				cnt++;
			}
		}
		input_data += "</dl>";	
		$("#layer_tag_list .basic").empty().append(input_data);
	});
	
	$("#layer_tag_list .ok").click(function(){
		var input_check_data = "";
		var li_check_data = "";
		$("#layer_tag_list .basic input:checkbox[name='tagType']:checked").each(function(){
			var li_val = $(this).val();
			var li_val_sp = li_val.split(":");
			li_check_data += "<li>#"+ li_val_sp[1] +" <i class='fa fa-ban' style='color:red;cursor:pointer;' aria-hidden='true' code='"+ li_val +"' onclick='fnTagDel(\""+ li_val +"\");'></i></li>";
			if(input_check_data == ""){
				input_check_data = li_val;
			}else{
				input_check_data += ","+ li_val;
			}
		});
		$(".jtable-main-container input[name='frm_tag_list']").val(input_check_data);
		$(".jtable .tag_list").html(li_check_data);
		$(".close, button.cancel").trigger('click');
	});
	
	// 말머리의 글제한 
	$("textarea[name='frm_summary']").keydown(function(){
		var input_text = $(this).val();
		var rows = input_text.split('\n').length;
		var max_rows = $(this).attr("rows");
		var max_cols = $(this).attr("cols");
		if(rows > max_rows){
			modifiedText = input_text.split("\n").slice(0, max_rows);
            $(this).val(modifiedText.join("\n"));
		}
	});
});

function fnBtnSize(){
	var button_width = 0;
	for(var i=0; i < $(".submit button").length; i++){ button_width += $('.submit button').eq(i).width(); }
	$('.submit .space').css('margin-left', $('.submit').width() - button_width - 200);
}

function fnTagDel(tagCode){
	var licnt = $(".jtable .tag_list li");
	var input_data = "";
	for(var i = 0; i < licnt.length; i++){
		if(licnt.eq(i).find('i').attr('code') == tagCode){ 
			licnt.eq(i).remove(); 
		}else{
			input_data = (input_data == "") ? licnt.eq(i).find('i').attr('code') : input_data +","+ licnt.eq(i).find('i').attr('code');
		}
	}
	$(".jtable-main-container input[name='frm_tag_list']").val(input_data);
}

$(window).resize(function(){ fnBtnSize(); }).resize();

var fnNewsView = function (param_seq){
	var obj_result = JSON.parse(common_ajax.inter("/service/news/view/"+ param_seq, "json", false, "GET", ""));
	if(obj_result.header.isSuccessful == true){
		var obj_data = JSON.parse(obj_result.data);

		var thumbPath = (obj_data[0]["thumbPath"] == null)? "" : obj_data[0]["thumbPath"];

		$(".jtable-main-container .jtable input[name='frm_title']").val(obj_data[0]["title"]);
		$(".jtable-main-container .jtable textarea[name='frm_summary']").val(obj_data[0]["summary"]);
		$(".jtable-main-container input[name='frm_param_content_seq']").val(obj_data[0]["noticeContntSeq"]);
		if(thumbPath != ""){
			$(".jtable-main-container .jtable tr:eq(2)").find("img").attr('src', obj_data[0]["thumbPath"]);
			$("input[name='frm_img_thumb']").val(obj_data[0]["thumbPath"]);
		}
		
		// 분원코드가 1일땐 걍.. 나머진 선택후 진행 
		$("input[name='frm_dept_seq']").val(obj_data[0]["deptSeq"]);
		
		if(obj_data[0]["deptSeq"] =="130"){ $("#frm_dept_nm").empty().text("학원 전체"); $(".jtable-main-container .jtable tr:eq(2)").find("td:eq(1)").text("JLS소식"); }
		else if(obj_data[0]["deptSeq"] =="120" || obj_data[0]["deptSeq"] =="1"){ $("#frm_dept_nm").empty().text("어학원 전체"); $(".jtable-main-container .jtable tr:eq(2)").find("td:eq(1)").text("JLS소식"); }
		else {	$("#frm_dept_nm").empty().text(obj_data[0]["deptNm"]); $(".jtable-main-container .jtable tr:eq(2)").find("td:eq(1)").text("분원소식"); }

		var end_dt = (obj_data[0]["endDt"] === undefined) ? "" : obj_data[0]["endDt"];
		var viewYn = obj_data[0]["viewYn"];
		if(end_dt != "" && end_dt.replace(/\-/gi,'') < nowDate){ viewYn = "0"; }
		
		if( viewYn == '1'){
			$(".jtable-main-container .jtable input:radio[name='frm_view_yn']").eq(0).prop("checked", true);
		}else{
			$(".jtable-main-container .jtable input:radio[name='frm_view_yn']").eq(1).prop("checked", true);
		}
		$(".jtable-main-container .jtable tr:eq(5)").find("td").text(obj_data[0]["regTs"]);
		$(".jtable-main-container .jtable tr:eq(6)").find("td").text(obj_data[0]["regUserNm"]);

		$('#paper_editor').summernote('code', obj_data[0]["contents"]);
		
		$("input[name='frm_start_dt']").datepicker("setDate", common_date.strToDate(obj_data[0]["startDt"].replace(/\-/gi,'')) );
		if(obj_data[0]["endDt"] != ""){
			$("input[name='frm_end_dt']").datepicker("setDate", common_date.strToDate(obj_data[0]["endDt"].replace(/\-/gi,'')));
		}
		
		param_contnt_seq = obj_data[0]["noticeContntSeq"];
		param_dept_seq = obj_data[0]["deptSeq"];
	}else{
		common_alert.big('warning', '데이터를 가지고오는데 오류가 발생했습니다. ');
	}
	$.uniform.update();
}

var fnTagsView = function (param_contnt_seq){
	var obj_result = JSON.parse(common_ajax.inter("/service/tag/"+ param_contnt_seq, "json", false, "GET", ""));
	if(obj_result.header.isSuccessful == true){
		var obj_data = JSON.parse(obj_result.data);
		var input_data = "";
		var input_text_data = "";
		for(var i=0; i < obj_data.length; i++){
			if(i > 0){ input_data += ","; input_text_data +=","; }
			input_data += "<li>#"+ obj_data[i]['tagNm'] +" <i class='fa fa-minus-circle' style='color:red;cursor:pointer;' aria-hidden='true' code='"+ obj_data[i]['tagCode'] +":"+ obj_data[i]['tagNm'] +"' onclick='fnTagDel(\""+ obj_data[i]['tagCode'] +":"+ obj_data[i]['tagNm'] +"\");' /></li>";
			input_text_data += obj_data[i]['tagCode'] +":"+ obj_data[i]['tagNm'];
		}
		$(".jtable-main-container input[name='frm_tag_list']").val(input_text_data);
		$(".jtable-main-container .jtable .tag_list").append(input_data);
	}
}

// 에디터에 이미지 업로드 
function fnImageUpload(file, el, path){
	var rootfl = (param_upload_rootfl == 'Y') ? true : false ; //로컬만 false 개발/운영은 true 
	
	var form_data = new FormData();
	form_data.append('files', file);
	form_data.append('path', path);
	form_data.append('rootfl', rootfl); 
	form_data.append('datefl', true);
	
	$.ajax({
		data : form_data,
		type : "POST",
		url : "/lib/fileupload",
		cache : false,
		contentType : false,
		enctype : "multipart/form-data",
		processData : false,
		success : function(data){
			var obj_result = JSON.parse(data);
			if(obj_result.header.isSuccessful == true){
				var obj_data = JSON.parse(obj_result.data);
				var image_url = (rootfl == true) ? param_upload_url + obj_data[0]["fullpath"] : obj_data[0]["fullpath"].substring(obj_data[0]["fullpath"].indexOf(path));
				$(el).summernote('editor.insertImage', image_url);
				
				// 이후에 이미지 사이즈를 결정한다. 
				console.log(image_url.width);
			}else{
				common_alert.big('warning', obj_result.header.resultMessage);
			}
		},
		error : function(xhr, ajaxOpts, thrownErr){
			console.log(xhr +"/"+ ajaxOpts +"/"+ thrownErr );
		}
	});
}

//썸네일 완료후 저장버튼 눌렀을때 
function fnThumbResult(image_url){
	$("#imageUrl_pic").attr('src', image_url).css("display","");
	$("input[name='frm_img_thumb']").val(image_url);
}

// 저장버튼 클릭 
function fnSaveClick(){ 
	// 필수항목 검수(제목, 게시기간, 내용, 태그 )
	if(param_seq == ""){
		if($("select[name='frm_dept_seq1']").val() != ""){
			if($("select[name='frm_dept_seq2']").val() == ""){
				$("input[name='frm_dept_seq']").val($("select[name='frm_dept_seq1']").val());
			}else{
				$("input[name='frm_dept_seq']").val($("select[name='frm_dept_seq2']").val());
			}
		}else{
			$("input[name='frm_dept_seq']").val("");
		}
	}
	
	var editor_text = $('#paper_editor').summernote('code');
	if(editor_text.substring(0,4) != "<div"){ editor_text = "<div style='width:100%;text-align:left;'>"+ editor_text +"</div>"; }
	if(editor_text.indexOf("note-video-clip") > -1){ editor_text = editor_text }
	$("input[name='frm_contents']").val(editor_text);

	if(editor_text == ""){ common_alert.big('warning','소식내용을 입력해 주세요.'); return; }
	if($("input[name='frm_dept_seq']").val() == ""){ common_alert.big('warning','분원을 입력해 주세요.'); return; }
	if($("input[name='frm_title']").val() == ""){ common_alert.big('warning','제목을 입력해 주세요.'); return; }
	if($("input[name='frm_reg_user_nm']").val() == ""){ common_alert.big('warning','등록자 정보가 없습니다. 다시 로그인해주세요.'); return; }
	if($("input[name='frm_start_dt']").val() == ""){ common_alert.big('warning','게시기간 시작일을 입력해 주세요.'); return; }
	if($("input[name='frm_end_dt']").val() == ""){ common_alert.big('warning','게시기간 종료일을 입력해 주세요.'); return; }
	
	$.ajax({
		data : $('#newsForm').find("select, textarea, input").serialize(),
		type : "POST",
		url : "/service/news/save",
		success : function(data){
			var obj_result = JSON.parse(data);
			if(obj_result.header.isSuccessful == true){
				common_alert.big_move('success', '데이터 저장이 완료 되었습니다.', "/jls/news?param_page=${param_page}&"+ $('#searchForm').serialize());
			}else{
				common_alert.big('warning', obj_result.header.resultMessage);
			}
		},
		error : function(xhr, ajaxOpts, thrownErr){
			console.log(xhr +"/"+ ajaxOpts +"/"+ thrownErr );
		}
	});
}

function fnListClick(){ location.href = "/jls/news?param_page=${param_page}&"+ $('#searchForm').serialize(); }
function fnCancelClick(){ location.href = "/jls/news?param_page=${param_page}&"+ $('#searchForm').serialize(); }
function fnPreviewClick(){  }

</script>

	<div id="right_area">
		<div class="title">
			<h2></h2><h3></h3>
		</div>
		<div class="jtable-main-container">
			<form name='newsForm' id="newsForm">
			<input type="hidden" name="frm_param_content_seq" value="" />
			<input type="hidden" name="frm_param_seq" value="" />
			<input type="hidden" name="frm_reg_user_seq" value="" />
			<input type="hidden" name="frm_reg_user_nm" value="" />
			<input type="hidden" name="frm_tag_list" value="" />
			<input type='hidden' name='frm_img_thumb' />
			<input type="hidden" name="frm_contents" />
			<input type="hidden" name="frm_dept_seq" />
			<table class="jtable default">
				<tbody>
					<tr><th>제목</th><td colspan=3 style="text-align:left !important;">
						<input type='text' name='frm_title' style='width:100%;' />
					</td></tr>
					<tr><th>프리뷰</th><td colspan=3 style="text-align:left !important;">
						<textarea name='frm_summary' style='width:100%;' cols=35 rows=4 ></textarea>
					</td></tr>
					<tr>
						<th rowspan="6">썸네일</th>
						<td rowspan="6" style="text-align:center !important; width:300px; line-height: 2;">
							<img src="" id="imageUrl_pic" width=268 height=200 style='margin-bottom:5px;'/>
							<button type='button' id='thumbPop' class="yellow" title="SelectFile" ><span><i class="fa fa-file-image-o" aria-hidden="true"></i> Select File..</span></button>
							<button type='button' id='thumbDel' title="Delete" ><span><i class="fa fa-trash" aria-hidden="true"></i> Delete</span></button>
							<br>
							<a href='https://goo.gl/5KFuhM' target='_black'><i class="fa fa-exclamation" aria-hidden="true"></i> 썸네일 샘플 이미지 & 가이드 </a>
						</td>
						<th>구분</th><td style="text-align:left !important;"></td>
					</tr>
					<tr><th>분원</th><td style="text-align:left !important;">
						<select id="frm_dept_seq1" name="frm_dept_seq1"></select>
						<select id="frm_dept_seq2" name="frm_dept_seq2"></select>
						<span id="frm_dept_nm"></span>
					</td></tr>
					<tr><th>상태</th><td style="text-align:left !important;">
						<input type='radio' name='frm_view_yn' id='frm_view_yn1' value='1'> <label for="frm_view_yn1" style="margin-right:5px !important;"> Visible </label>
						<input type='radio' name='frm_view_yn' id='frm_view_yn2' value='0'> <label for="frm_view_yn2" style="margin-right:5px !important;"> Hidden </label>
					</td></tr>
					<tr><th>등록일</th><td style="text-align:left !important;"></td></tr>
					<tr><th>등록자</th><td style="text-align:left !important;"></td></tr>
					<tr><th>게시기간</th><td style="text-align:left !important;">
						<input type="text" name="frm_start_dt" readonly  /> ~ <input type="text" name="frm_end_dt" readonly />
					</td></tr>
					<tr><th>태그</th><td class='tag_td' colspan=3 style="text-align:left !important;">
						<ul class='tag_list'></ul>
						<button type="button" class="yellow tag_btn" title="Add" ><span><i class="fa fa-tag" aria-hidden="true"></i> 태그선택</span></button>
					</td></tr>
				</tbody>
			</table>
			</form>
		</div>
		<div id="paper_editor" style="display: none;"></div>
		<div class="submit">
			<button type="button" title="View List" id="btnList" onclick='fnListClick()'><span><i class="fa fa-list" aria-hidden="true"></i> 목록</span></button> 
			<!-- <button type="button" title="Preview" id="btnPreview" onclick='fnPreviewClick()'><span><i class="fa fa-file-image-o" aria-hidden="true"></i> 미리보기</span></button> -->
			<span class='space'></span>
			<button type="button" title="Cancel" id="btnCancel" onclick='fnCancelClick()'><span><i class="fa fa-ban" aria-hidden="true"></i> 취소</span></button>
			<button type="button" class="yellow" title="Save" id="btnSave" onclick='fnSaveClick()'><span><i class="fa fa-floppy-o" aria-hidden="true"></i> 저장</span></button>
		</div>
	</div>
	<form name="searchForm" id="searchForm">
		<input type="hidden" name="searchStartDt" value="${searchStartDt}" />
		<input type="hidden" name="searchEndDt" value="${searchEndDt}" />
		<input type="hidden" name="param_pageSize" value="${param_pageSize}" />
		<input type="hidden" name="searchTitle" value="${searchTitle}" />
		<input type="hidden" name="searchTag" value="${searchTag}" />
		<input type="hidden" name="searchViewYn" value="${searchViewYn}" />
		<input type="hidden" name="searchDeptSeq" value="${searchDeptSeq}" />
		<input type="hidden" name="searchDeptSeq2" value="${searchDeptSeq2}" />
	</form>
	
