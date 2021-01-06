<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<script type="text/javascript">
	var nowYear = "${serverDate}";
	var param_empType = "${cookieEmpType}";
	var param_page = 1;
	var param_pageSize = 10;
	var searchTitle='', searchType='', searchDeptSeq='';

	if ('${param_page}' != "") { param_page = parseInt('${param_page}'); }
	if ('${param_pageSize}' != "") { param_pageSize = parseInt('${param_pageSize}'); }	
	if ('${searchTitle}' != "") { searchTitle = '${searchTitle}'; }	
	if ('${searchType}' != "") { searchType = '${searchType}'; }	
	if ('${searchDeptSeq}' != "") { searchDeptSeq = '${searchDeptSeq}'; }	

	$(document).ready(function(){
		fnDeptList();
		if(searchTitle != ""){ $("input[name='searchTitle']").val(searchTitle); $("#label_access1").addClass("hide"); }
		$.when(fnListView()).done(function(){ fnListDetail(); });
	});
		
	var fnListView = function (param_empType, param_deptList){
		var inclass = "";
		
		$("#searchType").empty();
		var obj_result = JSON.parse(common_ajax.inter("/service/code/ad", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var input_data = "<option value=''>배너타입</option>";
			var option_sel = "";
			for(var i=0; i < obj_data.length; i++){
				if(obj_data[i]["commonCode"] != "BN1005"){ // 바로가기 배너만 빼고 
					if(searchType != "" && obj_data[i]["commonCode"] == searchType ){ option_sel = "selected"; } else { option_sel = ""; }
					input_data += "<option value='"+ obj_data[i]["commonCode"]+"' "+ option_sel +">"+ obj_data[i]["codeNm"] +"</option>";
				}
			}
			$("#searchType").append(input_data);
		}else{
			$("#searchType").append("<option value=''>배너타입 오류발생</option>");
		}
	}
	
	function fnGoView(param_seq){
		param_page = ($(".jtable-goto-page select option:selected").val() != undefined) ? $(".jtable-goto-page select option:selected").val() : param_page ;
		param_pageSize = $(".jtable-page-size-change select option:selected").val();
		location.href = "/jls/ad/read?param_seq="+ param_seq +"&param_page="+ param_page +"&param_pageSize="+ param_pageSize +"&"+ $('#searchForm').serialize();
	}
	
	function fnGoWrite(){
		param_page = ($(".jtable-goto-page select option:selected").val() != undefined) ? $(".jtable-goto-page select option:selected").val() : param_page ;
		param_pageSize = $(".jtable-page-size-change select option:selected").val();
		location.href = "/jls/ad/write?param_page="+ param_page +"&param_pageSize="+ param_pageSize +"&"+ $('#searchForm').serialize();
	}
	
	function fnDeptList(){
		var obj_result = JSON.parse(common_ajax.inter("/service/code/topdept", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var input_data = "<option value=''>분원선택</option>";
			for(var i=0; i < obj_data.length; i++){
				if(searchDeptSeq != "" && obj_data[i]["dltDeptSeq"] == searchDeptSeq ){ inclass = "selected"; } else { inclass = ""; }
				input_data += "<option value='"+ obj_data[i]["dltDeptSeq"]+"' "+ inclass +">"+ obj_data[i]["dltDeptNm"] +"</option>";
			}
			$("#searchDeptSeq").empty().append(input_data);
		}
	}
	
	
	function fnListDetail(){
		$('#BranchTableContainer').jtable({
			title : '&nbsp;',
			paging : true,
			page: param_page,
			pageSize : param_pageSize,
			columnResizable : false,
			columnSelectable : false,
			ajaxSettings: {
                type: 'POST',
                dataType: 'json',
                contentType : "application/json; charset=utf-8"
            },
			actions: { 
				listAction : "/service/ad"
			},
			fields: {
				bannerSeq: { key: true, list: false, edit: false },
				deptNm : { },
				gtBannerLocNm : { listClass:'left' },
				gtBannerTypNm : { listClass:'left' },
				title: {
					listClass:'left',
					display : function(data){
						return "<a href='javascript:fnGoView(\""+ data.record.bannerSeq +"\")'>"+ data.record.title +"</a>";
					}
				},
				viewYn: {
					display : function(data){
						if(data.record.startDt > nowYear){
							return "<span class='notinuse'>게시예약</span>";
						}else if(data.record.endDt < nowYear){
							return "<span class='expired'>종료</span>";
						}else{
							return "<span class='inuse'>게시중</span>";
						}
					}
				},
				regUserNm: {  },
				regTs: {  },
				ranges: { 
					listClass:'left',
					display : function(data){
						var end_dt = (data.record.endDt === undefined) ? "" : data.record.endDt;
						return common_date.convertType(data.record.startDt,4) +"~"+ common_date.convertType(end_dt,4) ;
					}
				}
			},
			loadingRecords :function () {
				var header = "<tr>";
				header += "<th class='jtable-column-header' style='width:7%;'>구분</th>";
				header += "<th class='jtable-column-header' style='width:10%;'>위치</th>";
				header += "<th class='jtable-column-header' style='width:10%;'>타입</th>";
				header += "<th class='jtable-column-header' style='width:27%;'>제목</th>";
				header += "<th class='jtable-column-header' style='width:6%;'>상태</th>";
				header += "<th class='jtable-column-header' style='width:10%;'>등록자</th>";
				header += "<th class='jtable-column-header' style='width:10%;'>등록일</th>";
				header += "<th class='jtable-column-header' style='width:20%;'>게시기간</th>";
				header += "</tr>";
				
				$('.jtable thead').html(header);
			}
		});
		
		$('#BranchTableContainer').jtable('load', $('#searchForm').serialize());
	}
</script>

<div id="right_area">
	<div class="title"><h2>배너 관리</h2></div>
	<div class="option">
		<div class="items">
			<form name="searchForm" id="searchForm">
			<div class="period">
				<select name="searchDeptSeq" id="searchDeptSeq"></select>
				<select id="searchType" name="searchType">
					<option value="">배너타입</option>
				</select>
			</div>
			<div class="search_box">
				<input type="text" id="searchTitle" name="searchTitle" value="" class="input_focus" onkeydown="if(event.keyCode==13){ fnListDetail(); }" onfocus="label_access1.className='input_hide_word hide';" onblur="if (this.value.length==0) {label_access1.className='input_hide_word';}else {label_access1.className='input_hide_word hide';}">
				<label id="label_access1" for="searchTitle" class="input_hide_word ">제목</label>
			</div>
			</form>
		</div>
		<div class="search_btn">
			<button type="button" title="Search" id="searchBtn" onclick='fnListDetail();'><span class=""><i class="fa fa-search" aria-hidden="true"></i> 검색</span></button>
		</div>
		<div class="change_status">
			<button type="button" title="Write" id="writeBtn" class="yellow" onclick="fnGoWrite();"><span class=""><i class="fa fa-pencil-square-o" aria-hidden="true"></i> 등록</span></button>
		</div>
	</div>
	<div id="BranchTableContainer"></div>
</div>