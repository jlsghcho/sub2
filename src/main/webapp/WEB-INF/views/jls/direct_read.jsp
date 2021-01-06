<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<script type="text/javascript">
var param_seq = "${param_seq}";
var param_empType = "${cookieEmpType}";
var param_dept_seq = 1;

$(document).ready(function(){
	fnBtnSize();
	fnStartSetting();
});

function fnStartSetting(){
	$(".title h2").text("바로가기 관리");
	$.when(fnAdView(param_seq)).done(function(){ fnSelChange(); });
}

function fnSelChange(){
	var image_size = "400*250";
	var image_size_sp = image_size.split("*");
	$(".jtable-main-container .imagesize").text(image_size);
	$("input[name='frm_img_size']").val(image_size);
	$("#frm_img_path").attr("width", image_size_sp[0]); 
	$("#frm_img_path").attr("height", image_size_sp[1]);
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
		$("#frm_img_path").attr('src', obj_data[0]["bannerImgPath"]);
		$(".jtable-main-container .frm_title1").text(obj_data[0]["title"].split("#")[0]); 
		$(".jtable-main-container .frm_title2").text(obj_data[0]["title"].split("#")[1]);
		//$("select[name='frm_banner_dept']").empty().append("<option value='"+ obj_data[0]["deptSeq"] +"'>"+ obj_data[0]["deptNm"] +"</option>");
		//$("select[name='frm_banner_typ']").empty().append("<option value='"+ obj_data[0]["gtBannerTyp"] +"'>"+ obj_data[0]["gtBannerTypNm"] +"</option>");
		$(".jtable-main-container .jtable tr:eq(4)").find("td:eq(0)").text(obj_data[0]["regTs"]);
		$(".jtable-main-container .jtable tr:eq(4)").find("td:eq(1)").text(obj_data[0]["regUserNm"]);
		$(".jtable-main-container .frm_start_dt").text(obj_data[0]["startDt"]);
		$(".jtable-main-container .frm_end_dt").text(obj_data[0]["endDt"]);
		var link_fl = (obj_data[0]["linkTargetFl"] == "0")? "현재창" : "새창";
		$(".jtable-main-container .frm_link_fl").text(link_fl);
		$(".jtable-main-container .frm_link_url").text(obj_data[0]["linkUrl"]);
		
		$("#frm_dept_nm").text(obj_data[0]["deptNm"] +" / "+ obj_data[0]["gtBannerTypNm"]);

		var link_url = obj_data[0]["linkUrl"];
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
		param_dept_seq = obj_data[0]["deptSeq"];
		if(param_empType != 'S'){
			if(param_dept_seq == 1 || param_dept_seq == 120 || param_dept_seq == 130){ $("#btnMod").hide(); }
		}
		
	}else{
		common_alert.big('warning', '데이터를 가지고오는데 오류가 발생했습니다. ');
	}
	$.uniform.update();
}

$(window).resize(function(){ fnBtnSize(); }).resize();

function fnListClick(){ location.href = "/jls/direct?param_page=${param_page}&"+ $('#searchForm').serialize(); }
function fnModClick(){ location.href = "/jls/direct/write?param_seq=${param_seq}&param_page=${param_page}&"+ $('#searchForm').serialize(); }
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
			<table class="jtable default">
				<tbody>
					<tr><th>제목(작은사이즈)</th><td colspan=3 style="text-align:left !important;">
						<span class='frm_title1'></span>
					</td></tr>
					<tr><th>제목(큰사이즈)</th><td colspan=3 style="text-align:left !important;">
						<span class='frm_title2'></span>
					</td></tr>
					<tr><th>구분/위치/타입</th><td colspan=3 style="text-align:left !important;">
						<span id="frm_dept_nm"></span>
					</td></tr>
					<tr>
						<th >이미지</th>
						<td colspan=3 style="text-align:left !important; width:400px;">
							<i class="fa fa-exclamation" aria-hidden="true"></i> 배너사이즈 : <span class='imagesize'>760*400</span><br>
							<img src="" id="frm_img_path" width="50%"/><br>
						</td>
					</tr>
					<tr><th>등록일</th><td style="text-align:left !important;"></td><th>등록자</th><td style="text-align:left !important;"></td></tr>
					<tr>
						<th>타겟</th><td style="text-align:left !important;"><span class='frm_link_fl'></span></td>
						<th>게시기간</th><td style="text-align:left !important;"><span class="frm_start_dt"></span> ~ <span class="frm_end_dt"></span></td>
					</tr>
					<tr><th>랜딩URL</th><td class='tag_td' colspan=3 style="text-align:left !important;"><span class='frm_link_url'></span></td></tr>
					<tr><td class='tag_td' colspan=4 style="text-align:left !important;">* Google Analytics Code : <span class='googleCode'>FBR1</span> </td></tr>
				</tbody>
			</table>
			</form>
		</div>
		<div class="submit">
			<button type="button" title="View List" id="btnList" onclick='fnListClick()'><span><i class="fa fa-list" aria-hidden="true"></i> 목록</span></button> 
			<span class='space'></span>
			<button type="button" class="yellow" title="Modify" id="btnMod" onclick='fnModClick()'><span><i class="fa fa-pencil-square" aria-hidden="true"></i> 수정</span></button>
		</div>
	</div>
	<form name="searchForm" id="searchForm">
		<input type="hidden" name="param_page" value="${param_page}" />
		<input type="hidden" name="param_pageSize" value="${param_pageSize}" />
		<input type="hidden" name="searchTitle" value="${searchTitle}" />
		<input type="hidden" name="searchType" value="${searchType}" />
		<input type="hidden" name="searchDeptSeq" value="${searchDeptSeq}" />
	</form>
	
