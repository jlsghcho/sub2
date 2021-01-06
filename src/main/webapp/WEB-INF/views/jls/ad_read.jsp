<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<script type="text/javascript">
var param_seq = "${param_seq}";

$(document).ready(function(){
	fnBtnSize();
	fnStartSetting();
});

function fnStartSetting(){
	$(".title h2").text("배너관리");
	$.when(fnAdView(param_seq)).done(function(){ fnSelChange(); });
}

function fnSelChange(){
	// 위치선택시에 상태값과 사이즈변경 
	var image_size = "";
	var google_code = ""
	var gt_dept_seq = $("select[name='frm_banner_dept'] option:selected").val();
	var gt_1_Code = $("select[name='frm_banner_loc'] option:selected").val();
	var gt_2_Code = $("select[name='frm_banner_typ'] option:selected").val();

	if(gt_dept_seq == 120){
		if( gt_1_Code != ""){
			if(gt_1_Code == "BN1001"){ image_size = "760*400";
			} else if(gt_1_Code == "BN1002"){ image_size = "480*200";
			} else if(gt_1_Code == "BN1003"){ image_size = "500*270";
			} else if(gt_1_Code == "BN1004"){ if(gt_2_Code == "BN2041"){ image_size = "810*45"; }else{ image_size = "750*140"; } //너무커서 50% 축소 
			}
		}
		if( gt_2_Code != ""){
			if(gt_2_Code == "BN2011"){ google_code = "FBR1";
			} else if(gt_2_Code == "BN2012"){ google_code = "FBR2";
			} else if(gt_2_Code == "BN2013"){ google_code = "FBR3";
			} else if(gt_2_Code == "BN2021"){ google_code = "FBF1";
			} else if(gt_2_Code == "BN2022"){ google_code = "FBF2";
			} else if(gt_2_Code == "BN2023"){ google_code = "FBF3";
			} else if(gt_2_Code == "BN2031"){ google_code = "FCB1";
			} else if(gt_2_Code == "BN2032"){ google_code = "FCB2";
			} else if(gt_2_Code == "BN2033"){ google_code = "FCB3";
			} else if(gt_2_Code == "BN2041"){ google_code = "FTOP";
			} else if(gt_2_Code == "BN2042"){ google_code = "FTOP";
			}
		}
	}else{
		if( gt_1_Code != ""){
			if(gt_1_Code == "BN1001"){ image_size = "1920*520";
			} else if(gt_1_Code == "BN1004"){ if(gt_2_Code == "BN2041"){ image_size = "1920*90"; }else{ image_size = "750*140"; }
			}
		}
		if( gt_2_Code != ""){
			if(gt_2_Code == "BN2011"){ google_code = "MFBR1";
			} else if(gt_2_Code == "BN2012"){ google_code = "MFBR2";
			} else if(gt_2_Code == "BN2013"){ google_code = "MFBR3";
			} else if(gt_2_Code == "BN2041"){ google_code = "MFTOP";
			} else if(gt_2_Code == "BN2042"){ google_code = "MFTOP";
			}
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
		$("#frm_img_path").attr('src', obj_data[0]["bannerImgPath"]);
		$(".jtable-main-container .frm_title").text(obj_data[0]["title"]);
		$("select[name='frm_banner_dept']").empty().append("<option value='"+ obj_data[0]["deptSeq"] +"'>"+ obj_data[0]["deptNm"] +"</option>");
		$("select[name='frm_banner_loc']").empty().append("<option value='"+ obj_data[0]["gtBannerLoc"] +"'>"+ obj_data[0]["gtBannerLocNm"] +"</option>");
		$("select[name='frm_banner_typ']").empty().append("<option value='"+ obj_data[0]["gtBannerTyp"] +"'>"+ obj_data[0]["gtBannerTypNm"] +"</option>");
		$(".jtable-main-container .jtable tr:eq(3)").find("td:eq(0)").text(obj_data[0]["regTs"]);
		$(".jtable-main-container .jtable tr:eq(3)").find("td:eq(1)").text(obj_data[0]["regUserNm"]);
		$(".jtable-main-container .frm_start_dt").text(obj_data[0]["startDt"]);
		$(".jtable-main-container .frm_end_dt").text(obj_data[0]["endDt"]);
		var link_fl = (obj_data[0]["linkTargetFl"] == "0")? "현재창" : "새창";
		$(".jtable-main-container .frm_link_fl").text(link_fl);
		$(".jtable-main-container .frm_link_url").text(obj_data[0]["linkUrl"]);
	}else{
		common_alert.big('warning', '데이터를 가지고오는데 오류가 발생했습니다. ');
	}
	$.uniform.update();
}

$(window).resize(function(){ fnBtnSize(); }).resize();

function fnListClick(){ location.href = "/jls/ad?param_page=${param_page}&"+ $('#searchForm').serialize(); }
function fnModClick(){ location.href = "/jls/ad/write?param_seq=${param_seq}&param_page=${param_page}&"+ $('#searchForm').serialize(); }
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
					<tr><th>제목</th><td colspan=3 style="text-align:left !important;">
						<span class='frm_title'></span>
					</td></tr>
					<tr><th>구분/위치/타입</th><td colspan=3 style="text-align:left !important;">
						<select name='frm_banner_dept'></select>
						<select name='frm_banner_loc'></select>
						<select name='frm_banner_typ'></select>
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
	
