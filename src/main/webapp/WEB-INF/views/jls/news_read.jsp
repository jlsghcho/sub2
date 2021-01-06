<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
var nowYear = "${serverDate}";
var param_empType = "${cookieEmpType}";
var param_seq = "${param_seq}";
var param_contnt_seq = "";
var param_dept_seq = 1;

$(document).ready(function(){
	fnBtnSize();
	
	$.when(fnNewsView(param_seq)).done(function(){
		$.when(fnTagsView(param_contnt_seq)).done(function(){
			console.log("2 >>"+ param_dept_seq);
			if(param_empType != 'S'){
				$(".title h2").text("분원소식");
				if(param_dept_seq == 1 || param_dept_seq == 120 || param_dept_seq == 130){ $("#btnMod").hide(); }
			}else{
				$(".title h2").text("JLS소식");
			}
		});
	});
});

function fnBtnSize(){
	var button_width = 0;
	for(var i=0; i < $(".submit button").length; i++){ button_width += $('.submit button').eq(i).width(); }
	$('.submit .space').css('margin-left', $('.submit').width() - button_width - 200);
}

$(window).resize(function(){ fnBtnSize(); }).resize();

var fnNewsView = function (param_seq){
	var obj_result = JSON.parse(common_ajax.inter("/service/news/view/"+ param_seq, "json", false, "GET", ""));
	if(obj_result.header.isSuccessful == true){
		var obj_data = JSON.parse(obj_result.data);
		var viewYnNm = (obj_data[0]["viewYn"]) ? "Visible" : "Hidden" ;
		var end_dt = (obj_data[0]["endDt"] === undefined) ? "" : obj_data[0]["endDt"];
		if(end_dt != "" && end_dt.replace(/\-/gi,'') < nowYear){
			viewYnNm  = "Hidden";
		}

		var duration = obj_data[0]["startDt"] +"~"+ end_dt;
		var thumbPath = (obj_data[0]["thumbPath"] == null)? "" : obj_data[0]["thumbPath"];
		
		if(obj_data[0]["deptSeq"] =="130"){ 
			$(".jtable-main-container .jtable tr:eq(3)").find("td").text("학원 전체"); 
			$(".jtable-main-container .jtable tr:eq(2)").find("td:eq(1)").text("JLS소식"); 
		} else if(obj_data[0]["deptSeq"] =="120" || obj_data[0]["deptSeq"] =="1"){ 
			$(".jtable-main-container .jtable tr:eq(3)").find("td").text("어학원 전체"); 
			$(".jtable-main-container .jtable tr:eq(2)").find("td:eq(1)").text("JLS소식"); 
		} else {	
			$(".jtable-main-container .jtable tr:eq(3)").find("td").text(obj_data[0]["deptNm"]); 
			$(".jtable-main-container .jtable tr:eq(2)").find("td:eq(1)").text("분원소식"); 
		}
		
		
		$(".jtable-main-container .jtable tr:eq(0)").find("td").text(obj_data[0]["title"]);
		$(".jtable-main-container .jtable tr:eq(1)").find("td").html(obj_data[0]["summary"].replace(/\n/gi, "<br>"));
		if(thumbPath != ""){
			$(".jtable-main-container .jtable tr:eq(2)").find("img").attr('src', obj_data[0]["thumbPath"]);
		}else{
			$(".jtable-main-container .jtable tr:eq(2)").find("img").hide();
		}
		$(".jtable-main-container .jtable tr:eq(4)").find("td").text(viewYnNm);
		$(".jtable-main-container .jtable tr:eq(5)").find("td").text(obj_data[0]["regTs"]);
		$(".jtable-main-container .jtable tr:eq(6)").find("td").text(obj_data[0]["regUserNm"]);
		$(".jtable-main-container .jtable tr:eq(7)").find("td").text(duration);
		$(".jtable-main-container .jtable tr:eq(9)").find("td").html(obj_data[0]["contents"]);
		
		param_contnt_seq = obj_data[0]["noticeContntSeq"];
		param_dept_seq = obj_data[0]["deptSeq"];
		console.log("1 >>"+ param_dept_seq);
	}
}

var fnTagsView = function (param_contnt_seq){
	var obj_result = JSON.parse(common_ajax.inter("/service/tag/"+ param_contnt_seq, "json", false, "GET", ""));
	if(obj_result.header.isSuccessful == true){
		var obj_data = JSON.parse(obj_result.data);
		var input_data = "";
		for(var i=0; i < obj_data.length; i++){
			if(i > 0){ input_data += ","; }
			input_data += "#"+ obj_data[i]['tagNm'];
		}
		$(".jtable-main-container .jtable tr:eq(8)").find("td").text(input_data);
	}
}

function fnModClick(){ location.href = '/jls/news/write?param_seq='+ param_seq +"&param_page=${param_page}"+ "&"+ $('#searchForm').serialize(); }
function fnListClick(){ location.href = "/jls/news?param_page=${param_page}&"+ $('#searchForm').serialize(); }
function fnPreviewClick(){  }
</script>
	<div id="right_area">
		<div class="title">
			<h2></h2>
			<h3>> 상세내용</h3>
		</div>
		<div class="jtable-main-container">
			<table class="jtable default">
				<tbody>
					<tr><th>제목</th><td colspan=3 style="text-align:left !important;"></td></tr>
					<tr><th>프리뷰</th><td colspan=3 style="text-align:left !important;"></td></tr>
					<tr>
						<th rowspan="6">썸네일</th>
						<td rowspan="6" style="text-align:left !important; width:400px;">
							<img src="" id="imageUrl_pic" width=300 height=224 />
						</td>
						<th>구분</th><td style="text-align:left !important;"></td>
					</tr>
					<tr><th>분원</th><td style="text-align:left !important;"></td></tr>
					<tr><th>상태</th><td style="text-align:left !important;"></td></tr>
					<tr><th>등록일</th><td style="text-align:left !important;"></td></tr>
					<tr><th>등록자</th><td style="text-align:left !important;"></td></tr>
					<tr><th>게시기간</th><td style="text-align:left !important;"></td></tr>
					<tr><th>태그</th><td colspan=3 style="text-align:left !important;"></td></tr>
					<tr><td colspan=4 style="height:300px;text-align:left !important;" id="context"></td></tr>
				</tbody>
			</table>
		</div>
		<div class="submit">
			<button type="button" title="View List" id="btnList" onclick='fnListClick()'><span><i class="fa fa-list" aria-hidden="true"></i> 목록</span></button> 
			<!-- <button type="button" title="Preview" id="btnPreview" onclick='fnPreviewClick()'><span><i class="fa fa-file-image-o" aria-hidden="true"></i> 미리보기</span></button> -->
			<span class='space'></span>
			<button type="button" class="yellow" title="Modify" id="btnMod" onclick='fnModClick()'><span><i class="fa fa-pencil-square" aria-hidden="true"></i> 수정</span></button>
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
