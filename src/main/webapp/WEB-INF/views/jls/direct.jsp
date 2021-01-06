<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<script type="text/javascript">
	var nowYear = "${serverDate}";
	var param_empType = "${cookieEmpType}";
	var param_deptList = "${cookieDeptList}";
	var param_page = 1;
	var param_pageSize = 10;
	var searchTitle='', searchDeptSeq='';

	if ('${param_page}' != "") { param_page = parseInt('${param_page}'); }
	if ('${param_pageSize}' != "") { param_pageSize = parseInt('${param_pageSize}'); }	
	if ('${searchTitle}' != "") { searchTitle = '${searchTitle}'; }	
	if ('${searchDeptSeq}' != "") { searchDeptSeq = '${searchDeptSeq}'; }	

	$(document).ready(function(){

		if(searchTitle != ""){ $("input[name='searchTitle']").val(searchTitle); $("#label_access1").addClass("hide"); }
		$.when(fnListView(param_empType, param_deptList)).done(function(){
			$.when(fnListSet()).done(function(){ fnListDetail(); }); 
		});		
		
		$("select[name='searchDeptSeq1']").change(function(){ dept_change($(this).val()); });
	});
		
	function fnGoView(param_seq){
		param_page = ($(".jtable-goto-page select option:selected").val() != undefined) ? $(".jtable-goto-page select option:selected").val() : param_page ;
		param_pageSize = $(".jtable-page-size-change select option:selected").val();
		location.href = "/jls/direct/read?param_seq="+ param_seq +"&param_page="+ param_page +"&param_pageSize="+ param_pageSize +"&"+ $('#searchForm').serialize();
	}
	
	function fnGoWrite(){
		param_page = ($(".jtable-goto-page select option:selected").val() != undefined) ? $(".jtable-goto-page select option:selected").val() : param_page ;
		param_pageSize = $(".jtable-page-size-change select option:selected").val();
		location.href = "/jls/direct/write?param_page="+ param_page +"&param_pageSize="+ param_pageSize +"&"+ $('#searchForm').serialize();
	}
	
	var fnListView = function (param_empType, param_deptList){
		var inclass = "";
		
		$("select[name='searchDeptSeq1'], select[name='searchDeptSeq2']").empty().hide();
		$("input[name='searchDeptSeq']").val();
		
		if(param_empType == 'S'){
			$(".title h2").text("바로가기 관리");
			var obj_result = JSON.parse(common_ajax.inter("/service/code/topdept", "json", false, "GET", ""));
			if(obj_result.header.isSuccessful == true){
				var obj_data = JSON.parse(obj_result.data);
				var input_data = "<option value=''>전체</option>";
				for(var i=0; i < obj_data.length; i++){
					if(searchDeptSeq != "" && obj_data[i]["dltDeptSeq"] == searchDeptSeq ){ inclass = "selected"; } else { inclass = ""; }
					input_data += "<option value='"+ obj_data[i]["dltDeptSeq"]+"' "+ inclass +">"+ obj_data[i]["dltDeptNm"] +"</option>";
				}
				$("select[name='searchDeptSeq1']").append(input_data).show();
				if(searchDeptSeq != ""){ dept_change(searchDeptSeq); }
			}else{
				$("select[name='searchDeptSeq1']").append("<option value=''>정보 오류발생</option>").show();
			}
		}else{
			$(".title h2").text("바로가기 관리(분원)");
			var deptStr = param_deptList.split(",");
			if(deptStr.length > 0){
				$("select[name='searchDeptSeq2']").prepend("<option value=''>전체</option>").show();
				for(var i = 0; i < deptStr.length; i++){
					var deptinfo = deptStr[i].split(":");
					//console.log(deptStr[i] +"/"+ searchDeptSeq);
					if(searchDeptSeq != "" && deptinfo[0] == searchDeptSeq ){ 
						inclass = "selected"; 
					} else { inclass = ""; 	}
					$("select[name='searchDeptSeq2']").append("<option value='"+ deptinfo[0] +"' "+ inclass +">"+ deptinfo[1]+"</option>").show();
				}
			}else{
				$("select[name='searchDeptSeq2']").append("<option value=''>정보 오류발생</option>").show();
			}
		}
	}
	
	function searchBtnClick(){
		$.when(fnListSet()).done(function(){ fnListDetail(); }); 
	}

	var fnListSet = function(){
		// 분원선택시 
		var dept_seq = "";
		if(param_empType == 'S'){
			if($("select[name='searchDeptSeq1']").val() == ""){
				if($("select[name='searchDeptSeq2']").val() != ""){
					dept_seq = $("select[name='searchDeptSeq2']").val();
				}
			}else{
				if($("select[name='searchDeptSeq2']").val() == ""){
					dept_seq = $("select[name='searchDeptSeq1']").val();
				}else{
					dept_seq = $("select[name='searchDeptSeq2']").val();
				}
			}
		}else{
			if($("select[name='searchDeptSeq2']").val() == ""){
				$("select[name='searchDeptSeq2'] option").each(function(){
					dept_seq += (dept_seq == "") ? $(this).val() : ","+ $(this).val();
				});
			}else{
				dept_seq = $("select[name='searchDeptSeq2']").val();
			}
		}
		$("input[name='searchDeptSeq']").val(dept_seq);
	}
	
	function dept_change(param_dept_select){
		if(param_dept_select == ""){
			$("select[name='searchDeptSeq2']").empty().hide();
		}else{
			var obj_result = JSON.parse(common_ajax.inter("/service/code/secdept?parentDeptSeq="+ param_dept_select, "json", false, "GET", ""));
			if(obj_result.header.isSuccessful == true){
				var obj_data = JSON.parse(obj_result.data);
				var input_data = "<option value='"+ param_dept_select +"'>전체</option>";
				for(var i=0; i < obj_data.length; i++){
					if(searchDeptSeq != "" && obj_data[i]["dltDeptSeq"] == searchDeptSeq ){ inclass = "selected"; } else { inclass = ""; }
					input_data += "<option value='"+ obj_data[i]["dltDeptSeq"]+"' "+ inclass +">"+ obj_data[i]["dltDeptNm"] +"</option>";
				}
				$("select[name='searchDeptSeq2']").empty().append(input_data).show();
			}else{
				$("select[name='searchDeptSeq2']").empty().append("<option value=''>정보 오류발생</option>").show();
			}
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
				listAction : "/service/direct"
			},
			fields: {
				bannerSeq: { key: true, list: false, edit: false },
				deptNm : { },
				gtBannerTypNm : { listClass:'left' },
				title: {
					listClass:'left',
					display : function(data){
						var title = data.record.title.split("#");
						return "<a href='javascript:fnGoView(\""+ data.record.bannerSeq +"\")'>"+ title[0] +"</a>";
					}
				},
				title2: {
					listClass:'left',
					display : function(data){
						var title = data.record.title.split("#"); 
						return "<a href='javascript:fnGoView(\""+ data.record.bannerSeq +"\")'>"+ title[1] +"</a>";
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
				header += "<th class='jtable-column-header' style='width:7%;'>분원</th>";
				header += "<th class='jtable-column-header' style='width:10%;'>타입</th>";
				header += "<th class='jtable-column-header' style='width:17%;'>제목1</th>";
				header += "<th class='jtable-column-header' style='width:20%;'>제목2</th>";
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
	<div class="title"><h2>바로가기 관리</h2></div>
	<div class="option">
		<div class="items">
			<form name="searchForm" id="searchForm">
			<input type="hidden" name="searchType" value="BN1005" />
			<div class="period">
				<input type="hidden" name="searchDeptSeq" id="searchDeptSeq" />
				<select name="searchDeptSeq1" id="searchDeptSeq1"></select>
				<select name="searchDeptSeq2" id="searchDeptSeq2"></select>
			</div>
			<div class="search_box">
				<input type="text" id="searchTitle" name="searchTitle" value="" class="input_focus" onkeydown="if(event.keyCode==13){ fnListDetail(); }" onfocus="label_access1.className='input_hide_word hide';" onblur="if (this.value.length==0) {label_access1.className='input_hide_word';}else {label_access1.className='input_hide_word hide';}">
				<label id="label_access1" for="searchTitle" class="input_hide_word ">제목</label>
			</div>
			</form>
		</div>
		<div class="search_btn">
			<button type="button" title="Search" id="searchBtn" onclick='searchBtnClick();'><span class=""><i class="fa fa-search" aria-hidden="true"></i> 검색</span></button>
		</div>
		<div class="change_status">
			<button type="button" title="Write" id="writeBtn" class="yellow" onclick="fnGoWrite();"><span class=""><i class="fa fa-pencil-square-o" aria-hidden="true"></i> 등록</span></button>
		</div>
	</div>
	<div id="BranchTableContainer"></div>
</div>