<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<script type="text/javascript">
	var nowYear = "${serverDate}";
	var param_empType = "${cookieEmpType}";
	var param_deptList = "${cookieDeptList}";

	var param_page = 1;
	var param_pageSize = 10;
	var searchStartDt='',searchEndDt='',searchTitle='',searchDeptSeq='',searchTag='',searchViewYn='',searchDeptSeq2='';

	if ('${param_page}' != "") { param_page = parseInt('${param_page}'); }
	if ('${param_pageSize}' != "") { param_pageSize = parseInt('${param_pageSize}'); }	
	if ('${searchStartDt}' != "") { searchStartDt = '${searchStartDt}'; }	
	if ('${searchEndDt}' != "") { searchEndDt = '${searchEndDt}'; }	
	if ('${searchTitle}' != "") { searchTitle = '${searchTitle}'; }	
	if ('${searchDeptSeq}' != "") { searchDeptSeq = '${searchDeptSeq}'; }	
	if ('${searchTag}' != "") { searchTag = '${searchTag}'; }	
	if ('${searchViewYn}' != "") { searchViewYn = '${searchViewYn}'; }	
	if ('${searchViewYn}' != "") { searchViewYn = '${searchViewYn}'; }	

	$(document).ready(function(){
		$uniformed = $('#right_area').find('input[type=checkbox], input[type=radio]').not('.jtable');
		$uniformed.uniform();		
		
		// calendar datepicker
		$( "#searchStartDt" ).datepicker({
			changeMonth: true,
			changeYear: true,
			yearRange : '2014:'+ nowYear.substr(0,4) ,
			dateFormat: "yy-mm-dd",
			onClose: function( selectedDate ) {
				$( "#searchEndDt" ).datepicker( "option", "minDate", selectedDate );
			}
		});
		
		$( "#searchEndDt" ).datepicker({
			changeMonth: true,
			changeYear: true,
			yearRange : '2014:'+ nowYear.substr(0,4) ,
			dateFormat: "yy-mm-dd",
			onClose: function( selectedDate ) {
				$( "#searchStartDt" ).datepicker( "option", "maxDate", selectedDate );
			}
		});
		
		if(searchStartDt != ""){ $("input[name='searchStartDt']").datepicker("setDate", searchStartDt ); }
		if(searchEndDt != ""){ $("input[name='searchEndDt']").datepicker("setDate", searchEndDt); }
		if(searchTitle != ""){ $("input[name='searchTitle']").val(searchTitle); $("#label_access1").addClass("hide"); }
		if(searchViewYn != ""){ $("input:radio[name='viewYn']:input[value='"+ searchViewYn +"']").attr("checked", true); }
		
		$.when(fnListView(param_empType, param_deptList)).done(function(){
			$.when(fnListSet()).done(function(){ fnListDetail(); }); 
		});
		
		$("select[name='searchDeptSeq1']").change(function(){ dept_change($(this).val()); });
	});
	
	function searchBtnClick(){
		$.when(fnListSet()).done(function(){ fnListDetail(); }); 
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
		
	var fnListView = function (param_empType, param_deptList){
		var inclass = "";
		
		$("select[name='searchDeptSeq1'], select[name='searchDeptSeq2']").empty().hide();
		$("input[name='searchDeptSeq']").val();
		
		if(param_empType == 'S'){
			$(".title h2").text("JLS 소식");
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
			$(".title h2").text("분원 소식");
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
		
		$("#searchTag").empty();
		var obj_result = JSON.parse(common_ajax.inter("/service/code/tag", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var input_data = "<option value=''>태그전체</option>";
			var option_sel = "";
			for(var i=0; i < obj_data.length; i++){
				if(searchTag != "" && obj_data[i]["tagCode"] == searchTag ){ option_sel = "selected"; } else { option_sel = ""; }
				input_data += "<option value='"+ obj_data[i]["tagCode"]+"' "+ option_sel +">"+ obj_data[i]["tagNm"] +"</option>";
			}
			$("#searchTag").append(input_data);
		}else{
			$("#searchTag").append("<option value=''>태그정보 오류발생</option>");
		}
	}
	
	function fnGoView(param_seq){
		param_page = ($(".jtable-goto-page select option:selected").val() != undefined) ? $(".jtable-goto-page select option:selected").val() : param_page ;
		param_pageSize = $(".jtable-page-size-change select option:selected").val();
		location.href = "/jls/news/read?param_seq="+ param_seq +"&param_page="+ param_page +"&param_pageSize="+ param_pageSize +"&"+ $('#searchForm').serialize();
	}
	
	function fnGoWrite(){
		param_page = ($(".jtable-goto-page select option:selected").val() != undefined) ? $(".jtable-goto-page select option:selected").val() : param_page ;
		param_pageSize = $(".jtable-page-size-change select option:selected").val();
		location.href = "/jls/news/write?param_page="+ param_page +"&param_pageSize="+ param_pageSize +"&"+ $('#searchForm').serialize();
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
				listAction : "/service/news"
			},
			fields: {
				noticeSeq: { key: true, list: false, edit: false },
				noticeTypeNm: { 
					display : function(data){
						if(data.record.deptSeq == "1" || data.record.deptSeq == "130" || data.record.deptSeq == "120"){
							return "JLS소식";
						}else{
							return "분원소식";
						}
					}
				},
				deptNm : {  
					display : function(data){
						var deptNm = (data.record.deptNm != "")? data.record.deptNm : "JLS본사";
						return deptNm;
					}
				},
				title: {
					listClass:'left',
					display : function(data){
						return "<a href='javascript:fnGoView(\""+ data.record.noticeSeq +"\")'>"+ data.record.title +"</a>";
					}
				},
				viewYn: {
					display : function(data){
						if(data.record.viewYn == 1){
							var end_dt = (data.record.endDt === undefined) ? "" : data.record.endDt;
							if(end_dt != "" && end_dt.replace(/\-/gi,'') < nowYear){
								return "<span class='notinuse'>Hidden</span>";
							}else{
								return "<span class='inuse'>Visible</span>";
							}
						}else{
							return "<span class='notinuse'>Hidden</span>";
						}
					}
				},
				regUserNm: {  },
				regTs: {  },
				ranges: { 
					listClass:'left',
					display : function(data){
						var end_dt = (data.record.endDt === undefined) ? "" : data.record.endDt;
						return data.record.startDt +"~"+ end_dt ;
					}
				},
				viewCnt: {  }
			},
			loadingRecords :function () {
				//var helper = "<img src='<spring:eval expression="@globalContext['IMG_SERVER']" />/manage/img/icon_help.png' align='absmiddle' class='help_icon' />";
				//helper += "<span class='layer'><b class='notinuse'>정보</b> : Visible상태에서 게시기간이 지났다면 홈페이지에서 안보임</span>";
				
				var header = "<tr>";
				header += "<th class='jtable-column-header' style='width:6%;'>구분</th>";
				header += "<th class='jtable-column-header' style='width:10%;'>분원</th>";
				header += "<th class='jtable-column-header' style='width:27%;'>제목</th>";
				header += "<th class='jtable-column-header' style='width:6%;'>상태</th>";
				header += "<th class='jtable-column-header' style='width:10%;'>등록자</th>";
				header += "<th class='jtable-column-header' style='width:10%;'>등록일</th>";
				header += "<th class='jtable-column-header' style='width:16%;'>게시기간</th>";
				header += "<th class='jtable-column-header' style='width:5%;'>조회수</th>";
				header += "</tr>";
				
				$('.jtable thead').html(header);
			}
		});
		
		$('#BranchTableContainer').jtable('load', $('#searchForm').serialize());
	}
</script>

<div id="right_area">
	<div class="title"><h2>JLS 소식</h2></div>
	<div class="option">
		<div class="items">
			<form name="searchForm" id="searchForm">
			<div class="period">
				검색일자 : 
				<input type="text" id="searchStartDt" name="searchStartDt" readonly  /> ~ 
				<input type="text" id="searchEndDt" name="searchEndDt" readonly />
			</div>
			<div class="search_box">
				<input type="text" id="searchTitle" name="searchTitle" value="" class="input_focus" onkeydown="if(event.keyCode==13){ return; }" onfocus="label_access1.className='input_hide_word hide';" onblur="if (this.value.length==0) {label_access1.className='input_hide_word';}else {label_access1.className='input_hide_word hide';}">
				<label id="label_access1" for="searchTitle" class="input_hide_word ">제목</label>
			</div>
			<div class="check_box">
				<input type="hidden" name="searchDeptSeq" id="searchDeptSeq" />
				<select name="searchDeptSeq1" id="searchDeptSeq1"></select>
				<select name="searchDeptSeq2" id="searchDeptSeq2"></select>
				<span class="space">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
				
				<select id="searchTag" name="searchTag"></select>
				<span class="space">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
				<input type='radio' name='searchBranchType' id='type1' value='' checked> <label for="type1" style="margin-right:5px !important;"> 전체</label>
				<input type='radio' name='searchBranchType' id='type2' value='1'> <label for="type2" style="margin-right:5px !important;"> JLS소식</label>
				<input type='radio' name='searchBranchType' id='type3' value='2'> <label for="type3" style="margin-right:5px !important;"> 분원소식</label>
				<span class="space">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
				<input type="radio" id="viewYn1" name="searchViewYn" value="" checked><label for="viewYn1" style="margin-right:5px !important;"> All</label>
				<input type="radio" id="viewYn2" name="searchViewYn" value="1"><label for="viewYn2" style="margin-right:5px !important;"> Visible</label>
				<input type="radio" id="viewYn3" name="searchViewYn" value="0"><label for="viewYn3" style="margin-right:5px !important;"> Hidden</label>
			</div>
			</form>
		</div>
		<div class="search_btn">
			<button type="button" title="Search" id="searchBtn" onclick='searchBtnClick();'><span class="large"><i class="fa fa-search" aria-hidden="true"></i> 검색</span></button>
		</div>
		<div class="change_status">
			<button type="button" title="Write" id="writeBtn" class="yellow" onclick="fnGoWrite();"><span class=""><i class="fa fa-pencil-square-o" aria-hidden="true"></i> 새글</span></button>
		</div>
	</div>
	<div id="BranchTableContainer"></div>
	<div class="help">
		<h3>도움말</h3>
		<ul>
			<li>분원소식은 JLS소식+분원소식으로 이뤄져 있습니다.</li>
			<li>상태값이 Visible이더라도 게시기간이 지났다면 보이지 않습니다.</li>
			<li>분원관리자의 경우 JLS소식을 편집하실수 없습니다.</li>
		</ul>
		<p>관련 문의사항은 <b>고객센터를 이용해 주세요. 1644-0500</b></p>
	</div>
</div>