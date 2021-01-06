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
	
	$("#frm_img_path").attr("src", "<spring:eval expression="@globalContext['IMG_SERVER']" />/manage/img/admin/thumb_empty.png");
	//$("select[name='frm_banner_dept']").change(function(){ $.when(fnBannerLocTyp("frm_banner_loc")).done(function(){ fnBannerLocTyp("frm_banner_typ"); });  });
	//$("select[name='frm_banner_loc']").change(function(){ fnBannerLocTyp("frm_banner_typ");	});
	$("select[name='frm_banner_typ']").change(function(){ fnSelChange(); });
	
	fnStartSetting();
	
	$("select[name='frm_dept_seq1']").change(function(){
		//$("#frm_dept_seq2").empty().show();
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
		fnSelChange();
	});
	
	/* Image 관련 소스 */
	$("#imagePop").click(function(){
		var image_size = $("input[name='frm_img_size']").val();
		if(image_size == ""){ common_alert.big('warning','배너위치를 선택해 주세요. '); return; }
		var image_size_sp = image_size.split("*");
		$("#pop_upload_img").load("/common/make_thumb?upload_type=AD1&w="+ image_size_sp[0] +"&h="+ image_size_sp[1], function(response, status, xhr) {
			$('#pop_upload_img, .black_bg').fadeIn();
			$('body').removeClass('noscroll');
			fnUniform();
		});
	});
	
});

function fnThumbResult(image_url){
	$("#frm_img_path").attr('src', image_url).css("display","");
	$("input[name='frm_img_thumb']").val(image_url);
}

function fnStartSetting(){
	$(".title h2").text("바로가기 관리");
	$("input[name='frm_reg_user_seq']").val(param_empSeq);
	$("input[name='frm_reg_user_nm']").val(param_empNm);
	
	if(param_seq != ""){ //수정모드 
		$(".title h3").text("> 수정");
		$("#frm_dept_seq1, #frm_dept_seq2").hide();
		$("#frm_dept_nm").show();
		fnAdView(param_seq);
	}else{ // 새글쓰기모드
		if(param_empType == 'S'){
			fnDeptList();
			$("#frm_dept_seq1").show();
			$("#frm_dept_seq2").hide();
		}else{
			$("#frm_dept_seq1").empty().hide();
			var deptStr = param_deptList.split(",");
			var inclass = "";
			if(deptStr.length > 0){
				$("select[name='frm_dept_seq2']").empty().append("<option value='' selected>선택</option>").show(); 
				for(var i = 0; i < deptStr.length; i++){
					var deptinfo = deptStr[i].split(":");
					$("select[name='frm_dept_seq2']").append("<option value='"+ deptinfo[0]+"' "+ inclass +">"+ deptinfo[1]+"</option>").show();
				}
			}
		}
		fnBannerLocTyp("frm_banner_typ");

		$("#frm_dept_nm").hide();

		$("input[name='frm_start_dt']").datepicker("setDate", common_date.strToDate(nowDate) );
		$("input[name='frm_end_dt']").datepicker("setDate", common_date.strToDate(common_date.monthAdd(common_date.convertType(nowDate,4), 12)));

		$(".title h3").text("> 등록");
		$(".jtable-main-container .jtable tr:eq(4)").find("td:eq(0)").text("-");
		$(".jtable-main-container .jtable tr:eq(4)").find("td:eq(1)").text(param_empNm);
		$("input:radio[name='frm_link_fl']").eq(0).prop("checked", true);
	}
	$.uniform.update();
}

function fnDeptList(){
	var obj_result = JSON.parse(common_ajax.inter("/service/code/topdept", "json", false, "GET", ""));
	if(obj_result.header.isSuccessful == true){
		var obj_data = JSON.parse(obj_result.data);
		var input_data = "<option value=''>선택</option>";
		for(var i=0; i < obj_data.length; i++){
			input_data += "<option value='"+ obj_data[i]["dltDeptSeq"]+"' >"+ obj_data[i]["dltDeptNm"] +"</option>";
		}
		$("select[name='frm_dept_seq1']").empty().append(input_data);
	}
}

/* 
 * 정책에 대한 하드코딩 ********* 
 * 어학원 120 : BN1001, 002, 003, 004
 * 학원 130 : BN1001, 004
 */

function fnBannerLocTyp(param_code){
	//var dept_seq = (param_code == "frm_banner_loc") ? $("select[name='frm_dept_seq1'] option:selected").val() : 0 ;
	var url = "/service/code/adsub?groupCode="+ $("input[name='frm_banner_loc']").val();
	var obj_result = JSON.parse(common_ajax.inter(url, "json", false, "GET", ""));
	if(obj_result.header.isSuccessful == true){
		var obj_data = JSON.parse(obj_result.data);
		var input_data = "";
		for(var i=0; i < obj_data.length; i++){
			input_data += "<option value='"+ obj_data[i]["commonCode"]+"'>"+ obj_data[i]["codeNm"] +"</option>"; 
		}
		$("select[name='"+ param_code +"']").empty().append(input_data);
	}else{
		$("select[name='"+ param_code +"']").empty().append("<option value=''>배너타입 오류발생</option>");
	}
	fnSelChange();
}

function fnSelChange(){
	// 위치선택시에 상태값과 사이즈변경 
	var image_size = "400*250";
	var google_code = ""
	var gt_dept_seq = $("select[name='frm_dept_seq1'] option:selected").val();
	var gt_2_Code = $("select[name='frm_banner_typ'] option:selected").val();

	if(gt_dept_seq == "130"){
		if(gt_2_Code == "BN2051"){ google_code = "MFSF1";
		} else if(gt_2_Code == "BN2052"){ google_code = "MFSF2";
		} else if(gt_2_Code == "BN2053"){ google_code = "MFSF3";
		}
	}else{
		if(gt_2_Code == "BN2051"){ google_code = "FSF1";
		} else if(gt_2_Code == "BN2052"){ google_code = "FSF2";
		} else if(gt_2_Code == "BN2053"){ google_code = "FSF3";
		}
	}

	var image_size_sp = image_size.split("*");
	$(".jtable-main-container .imagesize").text(image_size);
	$("input[name='frm_img_size']").val(image_size);
	$("#frm_img_path").attr("width", image_size_sp[0]); 
	$("#frm_img_path").attr("height", image_size_sp[1]);
	$("input[name='frm_google_code']").val(google_code);
	$(".jtable-main-container .googleCode").text(google_code);
}

function fnBtnSize(){
	var button_width = 0;
	for(var i=0; i < $(".submit button").length; i++){ button_width += $('.submit button').eq(i).width(); }
	$('.submit .space').css('margin-left', $('.submit').width() - button_width - 200);
}

function fnAdView(param_seq){
	var obj_result = JSON.parse(common_ajax.inter("/service/ad/view/"+ param_seq, "json", false, "GET", ""));
	if(obj_result.header.isSuccessful == true){
		var obj_data = JSON.parse(obj_result.data);
		$("input[name='frm_param_seq']").val(obj_data[0]["bannerSeq"]);
		$("input[name='frm_img_thumb']").val(obj_data[0]["bannerImgPath"]);
		$("#frm_img_path").attr('src', obj_data[0]["bannerImgPath"]).css("display","");
		$("input[name='frm_title1']").val(obj_data[0]["title"].split("#")[0]);
		$("input[name='frm_title2']").val(obj_data[0]["title"].split("#")[1]);
		
		$("input[name='frm_banner_dept']").val(obj_data[0]["deptSeq"]);
		$("#frm_dept_seq1, #frm_dept_seq2").hide();
		$("#frm_dept_nm").text(obj_data[0]["deptNm"] );
		
		//$("select[name='frm_banner_loc']").empty().append("<option value='"+ obj_data[0]["gtBannerLoc"] +"'>"+ obj_data[0]["gtBannerLocNm"] +"</option>");
		$("select[name='frm_banner_typ']").empty().append("<option value='"+ obj_data[0]["gtBannerTyp"] +"'>"+ obj_data[0]["gtBannerTypNm"] +"</option>");
		$(".jtable-main-container .jtable tr:eq(4)").find("td:eq(0)").text(obj_data[0]["regTs"]);
		$(".jtable-main-container .jtable tr:eq(4)").find("td:eq(1)").text(obj_data[0]["regUserNm"]);
		
		$("input[name='frm_start_dt']").datepicker("setDate", common_date.strToDate(obj_data[0]["startDt"]) );
		$("input[name='frm_end_dt']").datepicker("setDate", common_date.strToDate(obj_data[0]["endDt"]));

		$("input:radio[name='frm_link_fl']").eq(obj_data[0]["linkTargetFl"]).prop("checked", true);

		var link_url = obj_data[0]["linkUrl"];
		link_url = (link_url.substr(link_url.length -1) == "?") ? link_url.substr(0, link_url.length -1) : link_url ;
		link_url = (link_url.indexOf("&&") > -1 ) ? link_url.replace("&&","&") : link_url ;
		$("input[name='frm_link_url']").val(link_url);

		// fnSelChange(); 링크중에 from 코드를 읽어서 다음껄 가지고 온다.
		var google_code = (link_url.indexOf("from=") > -1 ) ? link_url.substring(link_url.indexOf("from=")) : "" ;
		if(google_code != ""){
			if(google_code.indexOf("&") > -1){
				google_code = google_code.substring(google_code.indexOf("&")).replace("from=","");
			}else{
				console.log(google_code +">>");
				google_code = google_code.replace("from=","");
			}
			$("input[name='frm_google_code']").val(google_code);
			$(".jtable-main-container .googleCode").text(google_code);
		}
		var image_size = "400*250";
		var image_size_sp = image_size.split("*");
		$(".jtable-main-container .imagesize").text(image_size);
		$("input[name='frm_img_size']").val(image_size);
		$("#frm_img_path").attr("width", image_size_sp[0]); 
		$("#frm_img_path").attr("height", image_size_sp[1]);
		
	}else{
		common_alert.big('warning', '데이터를 가지고오는데 오류가 발생했습니다. ');
	}
	$.uniform.update();
}

$(window).resize(function(){ fnBtnSize(); }).resize();

function fnListClick(){ location.href = "/jls/direct?param_page=${param_page}&"+ $('#searchForm').serialize(); }
function fnCancelClick(){ location.href = "/jls/direct?param_page=${param_page}&"+ $('#searchForm').serialize(); }

function fnSaveClick(){
	// 필수항목 검수(제목, 게시기간, 내용, 태그 )
	if(param_seq == ""){
		if($("select[name='frm_dept_seq1']").val() != ""){
			if($("select[name='frm_dept_seq2']").val() == ""){
				$("input[name='frm_banner_dept']").val($("select[name='frm_dept_seq1']").val());
			}else{
				$("input[name='frm_banner_dept']").val($("select[name='frm_dept_seq2']").val());
			}
		}else{
			$("input[name='frm_banner_dept']").val("");
		}
	}

	$("input[name='frm_title']").val($("input[name='frm_title1']").val() +"#"+ $("input[name='frm_title2']").val());
	
	if($("input[name='frm_title']").val() == ""){ common_alert.big('warning','제목을 입력해 주세요.'); return; }
	if($("input[name='frm_banner_dept']").val() == ""){ common_alert.big('warning','분원을 입력해 주세요.'); return; }
	if($("input[name='frm_reg_user_nm']").val() == ""){ common_alert.big('warning','등록자 정보가 없습니다. 다시 로그인해주세요.'); return; }
	if($("input[name='frm_start_dt']").val() == ""){ common_alert.big('warning','게시기간 시작일을 입력해 주세요.'); return; }
	if($("input[name='frm_end_dt']").val() == ""){ common_alert.big('warning','게시기간 종료일을 입력해 주세요.'); return; }
	if($("input[name='frm_link_url']").val() == ""){ common_alert.big('warning','링크 URL을 입력해 주세요.'); return; }
	if($("input[name='frm_img_thumb']").val() == ""){ common_alert.big('warning','배너이미지가 없습니다.'); return; }
	
	$.ajax({
		data : $('#adForm').find("select, textarea, input").serialize(),
		type : "POST",
		url : "/service/ad/save",
		success : function(data){
			var obj_result = JSON.parse(data);
			if(obj_result.header.isSuccessful == true){
				common_alert.big_move('success', '데이터 저장이 완료 되었습니다.', "/jls/direct?param_page=${param_page}&"+ $('#searchForm').serialize());
			}else{
				common_alert.big('warning', obj_result.header.resultMessage);
			}
		},
		error : function(xhr, ajaxOpts, thrownErr){
			console.log(xhr +"/"+ ajaxOpts +"/"+ thrownErr );
		}
	});
}
</script>

	<div id="right_area">
		<div class="title">
			<h2></h2><h3></h3>
		</div>
		<div class="jtable-main-container">
			<form name='adForm' id="adForm">
			<input type="hidden" name="frm_param_seq" value="" />
			<input type="hidden" name="frm_reg_user_seq" value="" />
			<input type="hidden" name="frm_reg_user_nm" value="" />
			<input type="hidden" name="frm_google_code" value="" />
			<input type='hidden' name='frm_img_thumb' />
			<input type='hidden' name='frm_img_size' />
			<input type='hidden' name='frm_title' />
			<input type="hidden" name='frm_banner_dept' />
			<table class="jtable default">
				<tbody>
					<tr><th>제목(작은사이즈)</th><td colspan=3 style="text-align:left !important;">
						<input type='text' name='frm_title1' style='width:50%;' /> <span>* 글자수 17자이상은 깨질수 있습니다. </span> 
					</td></tr>
					<tr><th>제목(큰사이즈)</th><td colspan=3 style="text-align:left !important;">
						<input type='text' name='frm_title2' style='width:50%;' /> <span>* 글자수 25자이상은 깨질수 있습니다.</span>
					</td></tr>
					<tr><th>위치</th><td colspan=3 style="text-align:left !important;">
						<input type="hidden" name='frm_banner_loc' value='BN1005' />
						<select id="frm_dept_seq1" name="frm_dept_seq1"></select>
						<select id="frm_dept_seq2" name="frm_dept_seq2"></select>
						<span id="frm_dept_nm"></span>

						<select name='frm_banner_typ'></select>
						<span>* 수정시엔 위치변경이 불가능 합니다.</span> 
					</td></tr>
					<tr>
						<th >이미지</th>
						<td colspan=3 style="text-align:left !important; line-height: 2;">
							<i class="fa fa-exclamation" aria-hidden="true"></i> 배너사이즈 : <span class='imagesize'>760*400</span><br>
							<img src="" id="frm_img_path" width=268 height=200 style='margin-bottom:5px;' /><br>
							<button type='button' id='imagePop' class="yellow" title="SelectFile" ><span><i class="fa fa-file-image-o" aria-hidden="true"></i> Select File..</span></button>
						</td>
					</tr>
					<tr><th>등록일</th><td style="text-align:left !important;"></td><th>등록자</th><td style="text-align:left !important;"></td></tr>
					<tr>
						<th>타겟</th><td style="text-align:left !important;">
							<input type='radio' name='frm_link_fl' id='frm_link_fl1' value='0'> <label for="frm_link_fl1" style="margin-right:5px !important;"> 현재창 </label>
							<input type='radio' name='frm_link_fl' id='frm_link_fl2' value='1'> <label for="frm_link_fl2" style="margin-right:5px !important;"> 새창 </label>
						</td>
						<th>게시기간</th><td style="text-align:left !important;">
							<input type="text" name="frm_start_dt" readonly  /> ~ <input type="text" name="frm_end_dt" readonly />
						</td>
					</tr>
					<tr><th>랜딩URL</th><td class='tag_td' colspan=3 style="text-align:left !important;"><input type='text' name='frm_link_url' style='width:100%;'/></td></tr>
					<tr><td class='tag_td' colspan=4 style="text-align:left !important;">* Google Analytics Code : <span class='googleCode'>FBR1</span> (link에 from이 있을경우 안넣습니다.)</td></tr>
				</tbody>
			</table>
			</form>
		</div>
		<div class="submit">
			<button type="button" title="View List" id="btnList" onclick='fnListClick()'><span><i class="fa fa-list" aria-hidden="true"></i> 목록</span></button> 
			<span class='space'></span>
			<button type="button" title="Cancel" id="btnCancel" onclick='fnCancelClick()'><span><i class="fa fa-ban" aria-hidden="true"></i> 취소</span></button>
			<button type="button" class="yellow" title="Save" id="btnSave" onclick='fnSaveClick()'><span><i class="fa fa-floppy-o" aria-hidden="true"></i> 저장</span></button>
		</div>
	</div>
	<form name="searchForm" id="searchForm">
		<input type="hidden" name="param_page" value="${param_page}" />
		<input type="hidden" name="param_pageSize" value="${param_pageSize}" />
		<input type="hidden" name="searchTitle" value="${searchTitle}" />
		<input type="hidden" name="searchType" value="${searchType}" />
		<input type="hidden" name="searchDeptSeq" value="${searchDeptSeq}" />
		<input type="hidden" name="searchDeptSeq2" value="${searchDeptSeq2}" />
	</form>
	
