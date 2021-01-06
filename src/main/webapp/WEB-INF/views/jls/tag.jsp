<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<script type="text/javascript">
	var nowYear = "${serverDate}";
	var param_empType = "${cookieEmpType}";

	var param_page = 1;
	var param_pageSize = 30;
	var searchStartDt='',searchEndDt='',searchTitle='',searchViewYn='';

	if ('${param_page}' != "") { param_page = parseInt('${param_page}'); }
	if ('${param_pageSize}' != "") { param_pageSize = parseInt('${param_pageSize}'); }	
	if ('${searchStartDt}' != "") { searchStartDt = '${searchStartDt}'; }	
	if ('${searchEndDt}' != "") { searchEndDt = '${searchEndDt}'; }	
	if ('${searchTitle}' != "") { searchTitle = '${searchTitle}'; }	
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
		
		$(".title h2").text("태그관리");
		fnListDetail();
	});
		
	function fnTagModify(param_seq, param_tag_nm, param_tag_view, param_main_view){
		$("#pop_tag").load("/common/make_tag?param_seq="+ param_seq +"&param_tag_view="+ param_tag_view +"&param_main_view="+ param_main_view, function(response, status, xhr) {
			$('#pop_tag, .black_bg').fadeIn();
			$('body').removeClass('noscroll');
			fnUniform();
		});
	}
	
	function fnTagWrite(){
		$("#pop_tag").load("/common/make_tag", function(response, status, xhr) {
			$('#pop_tag, .black_bg').fadeIn();
			$('body').removeClass('noscroll');
			fnUniform();
		});
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
				listAction : "/service/tag"
			},
			fields: {
				branchTagSeq: { key: true, list: false, edit: false },
				rnum : {},
				tagCode: { },
				tagNm : { },
				viewYn: {
					display : function(data){
						if(data.record.viewYn == 1){
							return "<span class='inuse'>Visible</span>";
						}else{
							return "<span class='notinuse'>Hidden</span>";
						}
					}
				},
				tagContntCnt : {},
				mainViewYn : {
					display : function(data){
						if(data.record.mainViewYn > 0){ return data.record.mainViewYn; } else { return ''; }
					}
				},
				regUserNm: {},
				regTs: {},
				modbtn: {
					display : function(data){
						return "<a href='javascript:fnTagModify("+ data.record.branchTagSeq +",\""+ data.record.tagNm +"\","+ data.record.viewYn +","+ data.record.mainViewYn +");'>수정</a>";
					}
				}
			},
			loadingRecords :function () {
				var header = "<tr>";
				header += "<th class='jtable-column-header' style='width:5%;'>No.</th>";
				header += "<th class='jtable-column-header' style='width:15%;'>코드</th>";
				header += "<th class='jtable-column-header' style='width:15%;'>태그</th>";
				header += "<th class='jtable-column-header' style='width:6%;'>상태</th>";
				header += "<th class='jtable-column-header' style='width:6%;'>게시물수</th>";
				header += "<th class='jtable-column-header' style='width:6%;'>메인노출</th>";
				header += "<th class='jtable-column-header' style='width:10%;'>등록자</th>";
				header += "<th class='jtable-column-header' style='width:20%;'>등록일</th>";
				header += "<th class='jtable-column-header' style='width:5%;'>수정</th>";
				header += "</tr>";
				
				$('.jtable thead').html(header);
			}
		});
		
		$('#BranchTableContainer').jtable('load', $('#searchForm').serialize());
	}
</script>

<div id="right_area">
	<div class="title"><h2></h2></div>
	<div class="option">
		<div class="items">
			<form name="searchForm" id="searchForm">
			<div class="period">
				검색일자 : 
				<input type="text" id="searchStartDt" name="searchStartDt" readonly  /> ~ 
				<input type="text" id="searchEndDt" name="searchEndDt" readonly />
			</div>
			<div class="search_box">
				<input type="text" id="searchTitle" name="searchTitle" value="" class="input_focus" onkeydown="if(event.keyCode==13){ fnListDetail(); }" onfocus="label_access1.className='input_hide_word hide';" onblur="if (this.value.length==0) {label_access1.className='input_hide_word';}else {label_access1.className='input_hide_word hide';}">
				<label id="label_access1" for="searchTitle" class="input_hide_word ">제목</label>
			</div>
			<div class="check_box">
				<input type="radio" id="viewYn1" name="searchViewYn" value="" checked=""><label for="viewYn1" style="margin-right:5px !important;"> All</label>
				<input type="radio" id="viewYn2" name="searchViewYn" value="1"><label for="viewYn2" style="margin-right:5px !important;"> Visible</label>
				<input type="radio" id="viewYn3" name="searchViewYn" value="0"><label for="viewYn3"> Hidden</label>
			</div>
			</form>
		</div>
		<div class="search_btn">
			<button type="button" title="Search" id="searchBtn" onclick='fnListDetail();'><span class="large"><i class="fa fa-search" aria-hidden="true"></i> 검색</span></button>
		</div>
		<div class="change_status">
			<button type="button" title="Write" id="writeBtn" class="yellow" onclick="fnTagWrite();"><span class=""><i class="fa fa-pencil-square-o" aria-hidden="true"></i> 등록</span></button>
		</div>
	</div>
	<div id="BranchTableContainer"></div>
</div>