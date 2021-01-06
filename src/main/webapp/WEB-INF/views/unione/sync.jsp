<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<script type="text/javascript">
	var nowDate = "${serverDate}";
	var param_page = 1;
	var param_pageSize = 30;

	$(document).ready(function(){
		$(".title h2").text("분원 동기화");
		$.when(fnGetCourse()).done(function(){
			fnListDetail();
		});
	});
	
	function fnGetCourse(){
		var obj_result = JSON.parse(common_ajax.inter("/service/code/course", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var input_data = "<option value=''>전체코스</option>";
			if(obj_data.length > 0){
				for(var i=0; i < obj_data.length; i++){
					input_data += "<option value='"+ obj_data[i]["courseSeq"] +"'>"+ obj_data[i]["courseNm"] +"</option>";
				}
				$("select[name='searchCourse']").empty().append(input_data);
			}else{
				common_alert.big('warning', '데이터를 가지고오는데 오류가 발생했습니다. ');
			}
		}else{
			common_alert.big('warning', '데이터를 가지고오는데 오류가 발생했습니다. ');
		}
	}
	
	function fnGetDeptList(param_courseSeq){
		var input_data = "<option value=''>전체코스</option>";
		if(param_courseSeq == ""){
			
		}else{
			var obj_result = JSON.parse(common_ajax.inter("/service/code/coursedept?courseSeq="+ param_courseSeq, "json", false, "GET", ""));
			if(obj_result.header.isSuccessful == true){
				var obj_data = JSON.parse(obj_result.data);
				if(obj_data.length > 0){
					for(var i=0; i < obj_data.length; i++){
						input_data += "<option value='"+ obj_data[i]["deptSeq"] +"'>"+ obj_data[i]["deptNm"] +"</option>";
					}
				}else{
					common_alert.big('warning', '데이터를 가지고오는데 오류가 발생했습니다. ');
				}
			}else{
				common_alert.big('warning', '데이터를 가지고오는데 오류가 발생했습니다. ');
			}
		}
		$("select[name='searchDeptSeq']").empty().append(input_data);
	}
	
	function fnSendDeptApi(){
		var checkedId = $(":checkbox[name='deptSeqs']:checked");
		if( checkedId.length == 0 ){
			common_alert.big('warning', '선택된 분원이 없습니다.'); 
			return;
		}else if(checkedId.length > 10){
			common_alert.big('warning', "한번에 10건 이상 보낼 수 없습니다."); 
			return;
		}else{
			var tmp_status_code = "";
			var tmp_dept_list = "";
			var tmp_fl = false;
			
			for(var i=0; i < checkedId.length; i++){
				if(checkedId.eq(i).is(":checked")){
					var checkVal = checkedId.eq(i).val().split(":");
					if(tmp_status_code == ""){ 
						tmp_status_code = checkVal[0];
						tmp_dept_list = checkVal[1];
						tmp_fl = true;
					}else{
						if(tmp_status_code == checkVal[0]){
							tmp_dept_list += ","+ checkVal[1];
							tmp_fl = true;
						}else{
							tmp_fl = false;
							break;
						}
					}
				}
			}
			
			if(!tmp_fl){
				common_alert.big('warning', "동일한 API제공상태의 분원을 선택해주세요.");
				return;
			}else{
				var ajaxData = new Object();
				ajaxData["syncCode"] = tmp_status_code;
				ajaxData["syncDept"] = tmp_dept_list;
				ajaxData["regUserSeq"] = "${cookieEmpSeq}";
				ajaxData["regUserId"] = "${cookieEmpId}";
				ajaxData["regUserNm"] = "${cookieEmpNm}";
				
				$.ajax({
			        type : "POST",
			        url : "/service/unione/apidept",
			        dataType : "json",
			        contentType: "application/json; charset=utf-8",
			        data : JSON.stringify(ajaxData),
			        success : function(data){
			        	if(data.header.isSuccessful){
			        		$("#deptSeqs:checked").each(function(){
			        			$(this).parent().prev().prev().text("Unione");
			        			$(this).parent().prev().html("<span style='color:#155bbf;font-weight:bold;'>대기중</span>");
			        			$(this).parent().text("-");
			        		});
			        	}else{
			        		$("#deptSeqs:checked").each(function(){ $(this).prop("checked", false); });
			        		common_alert.big("warning","데이터 전송에 실패했습니다. ["+ data.header.resultMessage +"]");
			        	}
			        },
			        error:function(xhr, ajaxOpts, thrownErr){ alert(xhr +'/'+ thrownErr ); }
			    });		
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
				listAction : "/service/unione/sync"
			},
			fields: {
				deptSeq : { key: true, list: false, edit: false },
				rnum : {},
				deptNm : { },
				deptMobileNm : { },
				bossNm: { },
				tel : {},
				zipCode : { },
				deptDescsMobile : {
					display : function(data){
						if(data.record.deptDescsMobile ==  null || data.record.deptDescsMobile == ''){
							return "X";
						}else{
							return "O";
						}
					}
				},
				corpNm : {},
				flagView: {
					width: '12%',
					title : 'API 제공 상태',
					display : function(data){
						if(data.record.status == '1'){
							return "<span class='notinuse'>제공</span>";
						}else if(data.record.status == '0' || data.record.status == '2'){
							return "<span style='color:#155bbf;font-weight:bold;'>대기중</span>";
						}else if(data.record.status == '3' || data.record.status == '4'){
							return "<span class='expired'>실패</span>";
						}else{
							return "<span class='inuse'>제공안함</span>";
						}
					}
				},
				flag: {
					width: '11%',
					title : 'API 제공',
					display : function(data){
						if(data.record.status == '0' || data.record.status == '2'){
							return "-";
						}else if(data.record.status == '1' || data.record.status == '4'){
							return "<input type='checkbox' id='deptSeqs' name='deptSeqs' value='API-DEPT_MOD:"+ data.record.deptSeq +"' >";
						}else {
							return "<input type='checkbox' id='deptSeqs' name='deptSeqs' value='API-DEPT_ADD:"+data.record.deptSeq+"' >";
						}
					}
				}
			},
			loadingRecords :function () {
				var header = "<tr>";
				header += "<th class='jtable-column-header' style='width:5%;'>No.</th>";
				header += "<th class='jtable-column-header' style='width:15%;'>분원명</th>";
				header += "<th class='jtable-column-header' style='width:15%;'>모바일분원명</th>";
				header += "<th class='jtable-column-header' style='width:10%;'>분원장명</th>";
				header += "<th class='jtable-column-header' style='width:15%;'>대표전화번호</th>";
				header += "<th class='jtable-column-header' style='width:10%;'>우편번호</th>";
				header += "<th class='jtable-column-header' style='width:5%;'>인사말</th>";
				header += "<th class='jtable-column-header' style='width:7%;'>업체</th>";
				header += "<th class='jtable-column-header' style='width:10%;'>상태</th>";
				header += "<th class='jtable-column-header' style='width:11%;'>제공</th>";
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
				<select name="searchCourse" onchange="fnGetDeptList(this.value)"></select>
				<select name="searchDeptSeq"><option value=''>전체분원</option></select>
			</div>
			</form>
		</div>
		<div class="search_btn">
			<button type="button" title="Search" id="searchBtn" onclick='fnListDetail();'><span class=""><i class="fa fa-search" aria-hidden="true"></i> 검색</span></button>
		</div>
		<div class="change_status">
			<button type="button" title="Write" id="writeBtn" class="yellow" onclick="fnSendDeptApi();"><span class=""><i class="fa fa-refresh" aria-hidden="true"></i> 동기화</span></button>
		</div>
	</div>
	<div id="BranchTableContainer"></div>
</div>