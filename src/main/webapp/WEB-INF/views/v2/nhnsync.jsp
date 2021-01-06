<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script type="text/javascript">
	var now_year_date = "${serverDate}";
	var param_emp_type = "${cookieEmpType}";
	var param_emp_dept_list = "${cookieDeptList}";

	var param_page_num ,param_page_size, param_page_last;
	
	$(document).ready(function() {
		param_page_num = 0;
		param_page_size = 30;
		param_page_last = false;
		
		if(param_emp_type == "B"){ alert("관리자 전용입니다."); location.href="/"; }
		
		search.get_course_list("container");
		
		fn_sync_list();
		fn_table_sorter();
		
		$("#container .search_box input[type='button']").click(function(){ param_page_last=false; param_page_num = 0; fn_sync_list();  }); // Search Button Click
		
		// Scroll param_page_num Add after append  
		$("#detail_list .list").scroll(function(){ 
			if($(this).scrollTop() >= ($(this).find(".hms_table").height() - $(this).height())){
				if(param_page_last == false){
					++param_page_num; 
					fn_sync_list(); 
				}
			}
		});
		
		// All Checked box 
		$("#container .list .hms_table :checkbox[name='check_all']").change(function(){
			var param_checked = $(this).is(":checked");
			var param_checkbox_list = $("#container .list .hms_table tbody tr :checkbox[name='check_sync']");
			for(var i=0; i < param_checkbox_list.length; i++){
				if(param_checkbox_list.eq(i).is(":checked")){
					if(!param_checked){ 
						param_checkbox_list.eq(i).prop("checked" , false); 
					}else{
						if(param_checkbox_list.eq(i).closest("tr").attr("status") != "1"){
							param_checkbox_list.eq(i).prop("checked" , true);
						}
					}
				}else{
					if(param_checked){ 
						if(param_checkbox_list.eq(i).closest("tr").attr("status") != "1"){
							param_checkbox_list.eq(i).prop("checked" , true);
						}
					}
				}
			}
		});
		
		// Sync Button Event
		$("#container #detail_list .sort_view button").click(function(){
			var param_checkbox_list = $("#container .list .hms_table tbody tr :checkbox[name='check_sync']");
			var tmp_status_code = "";
			var tmp_next_yn = false;
			var tmp_type_yn = true;
			var param_api_type = "";
			for(var i=0; i < param_checkbox_list.length; i++){
				if(param_checkbox_list.eq(i).is(":checked")){
					if(param_api_type == ""){ 
						param_api_type = param_checkbox_list.eq(i).val().split(":")[0]; 
					}else{
						if(param_api_type != param_checkbox_list.eq(i).val().split(":")[0]){ tmp_type_yn = false; }
					}
					tmp_status_code += (tmp_status_code == "") ? param_checkbox_list.eq(i).val() : ","+ param_checkbox_list.eq(i).val();
					
					tmp_next_yn = true;
				}
			}
			
			if(!tmp_next_yn){
				alert("체크된 항목이 없습니다."); return;
			}else{
				if(!tmp_type_yn){
					alert("In Sync 와 Not In Sync는 같이 동기화 하실수 없습니다. 상타값이 같은 항목만 선택해주세요."); return;
				}else{
					var api_data = new Object();
					api_data["sync_dept_list"] = tmp_status_code;
					
					var obj_result = JSON.parse(common_ajax.inter("/service/v2/sync/exec", "json", false, "POST", api_data));
					if(obj_result.header.isSuccessful == false){ alert("데이터 연동시 오류가 발생했습니다. 다시 시도해 주세요. "); return; }
				}
			}
		});
	});
	
	function fn_default_set(){
		$("#container .search input[name='page_start_num']").val(param_page_num);
		$("#container .search input[name='page_size']").val(param_page_size);
	}
	
	$(window).on('resize', function() {
		var option_height = $('.sort_option').height();
		if($('#detail_list .inquiry').hasClass('expand')){
			$('#detail_list .list').css('top', option_height+'px');
		}else{
			$('#detail_list .list').removeAttr('style');
		}
		var table_height = $('#detail_list .list').height()-34;
		$('#detail_list .tablesorter-scroller-table').css('maxHeight',table_height);
	});
	
	$(document).on('mouseenter','#detail_list .hms_table td',function() { $(this).closest('tr').addClass('hover'); });
	$(document).on('mouseleave','#detail_list .hms_table td',function() { $(this).closest('tr').removeClass('hover'); });
	$(document).on('mouseenter', 'td.delete_record',function(e){ $(this).closest('tr').removeClass('hover'); e.stopPropagation(); });
	$(document).on('click', 'td.delete_record',function(e){ e.stopPropagation(); });
	
	function fn_table_sorter(){
		var table_height = $('#detail_list .list').height()-34;
		
		$("#detail_list .tablesorter").tablesorter({
			headers : { 
				'.delete_record, .edit_record' : {sorter:false}
			},
			widgets: [ 'scroller' ],
			widgetOptions : {
				scroller_height : table_height,
				scroller_upAfterSort: true,
				scroller_jumpToHeader: true,
				scroller_barWidth : null
			}
		});
		$("#detail_list .tablesorter").on('scrollerComplete', function(){ });
		
		var option_height = $('.sort_option').height();
		if($('#detail_list .inquiry').hasClass('expand')){
			$('#detail_list .list').css('top', option_height+'px');
		}else{
			$('#detail_list .list').removeAttr('style');
		}
		
		// 스크롤했을때 param_page_num 추가해서 append 한다. 
		$("#detail_list .tablesorter-scroller-table").scroll(function(){ 
			if($(this).scrollTop() >= ($(this).find(".tablesorter").height() - $(this).height())){
				if(param_page_last == false){
					++param_page_num; 
					$.when(fn_sync_list()).then(function(){ fn_table_sorter(); });
				}
			}
		});
		
	}
	
	function fn_sync_list(){
		$(".nodata").hide();
		fn_default_set();
		
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/sync/list", "json", false, "POST", search.get_parameter("container")));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var insert_table_data = "";
			if(obj_data.length == 0){ 
				param_page_last = true; 
				if(param_page_num == 0){ $("#container #detail_list .list .hms_table .tablesorter tbody").empty(); $(".nodata").show(); }
				$("#container #detail_list .list .hms_table .tablesorter tbody").append(insert_table_data);
			}else{
				for(var i=0; i < obj_data.length; i++){
					var status_nm = (obj_data[i]["status"] == 1)? "In Sync" : (obj_data[i]["status"] == 0 || obj_data[i]["status"] == 2)? "Syncing" : (obj_data[i]["status"] == 3 || obj_data[i]["status"] == 4)? "Failure" : "Not in Sync" ;  
					var class_nm = (obj_data[i]["status"] == 1)? "green" : "yellow";
					var intro_nm = (obj_data[i]["dept_intro"] == 1 ) ? "O" : "X";
					
					insert_table_data += "<tr key='"+ obj_data[i]["dept_seq"] +"' status='"+ obj_data[i]["status"] +"'>";
					insert_table_data += "<td class='branch_record left'>"+ obj_data[i]["dept_nm"] +"</td>";
					insert_table_data += "<td class='unione_record left'>"+ obj_data[i]["dept_mobile_nm"] +"</td>";
					insert_table_data += "<td class='manager_record'>"+ obj_data[i]["boss_nm"] +"</td>";
					insert_table_data += "<td class='phone_record'>"+ obj_data[i]["dept_tel"] +"</td>";
					insert_table_data += "<td class='zip_record'>"+ obj_data[i]["zip_code"] +"</td>";
					insert_table_data += "<td class='intro_record'>"+ intro_nm +"</td>";
					insert_table_data += "<td class='status_record'><span class='status sync "+ class_nm +"'>"+ status_nm +"</span></td>";
					insert_table_data += "<td class='edit_record'><label class='check'><input type='checkbox' name='check_sync' value='"+ obj_data[i]["status"] +":"+ obj_data[i]["dept_seq"] +"' /><span></span></label></td>";
					insert_table_data += "</tr>";
				}
				if(param_page_num == 0){ $("#container #detail_list .list .hms_table .tablesorter tbody").empty(); }
				$("#container #detail_list .list .hms_table .tablesorter tbody").append(insert_table_data);
				if(obj_data.length < param_page_size){ param_page_last = true; }
			}
		}else{
			$("#container #detail_list .list .hms_table .tablesorter tbody").empty();
			$(".nodata").show()
		}

	}
	/* sort 조건 눌렀을때 */
	$(document).on("click", "#detail_list .sort input:checkbox", function(){
		param_page_last=false; param_page_num = 0; $.when(fn_sync_list()).then(function(){ fn_table_sorter(); });
	});
</script>
	<div id="container">
		<div class="tit_area">
			<h3>Sync UNIONE</h3>
			<div class="search">
				<div class="search_box">
					<input type="hidden" name="page_start_num" />
					<input type="hidden" name="page_size" />

					<input type="text" name="search_context" placeholder="Branch Name" />
					<input type="button" class="search_btn" />
				</div>
			</div>
		</div>
		<div id="detail_list">
			<div class="sort_option">
				<div class="inquiry expand">
					<div class="sort first"></div>
				</div>
				<div class="func">
					<div class="sort_view">
						<button type="button" class="small blue" title="Sync"><span>Sync</span></button>
					</div>
				</div>
			</div>
			<div class="list">
				<div class="hms_table">
					<table class="tablesorter">
						<colgroup>
							<col style="width:20%;">
							<col style="width:20%;">
							<col style="width:10%;">
							<col style="width:15%;">
							<col style="width:15%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:35px;">
						</colgroup>
						<thead>
							<tr>
								<th class="branch_record">Branch Name</th>
								<th class="unione_record">Branch Name (UNIONE)</th>
								<th class="manager_record">Branch Manager</th>
								<th class="phone_record">Phone Number</th>
								<th class="zip_record">ZIP Code</th>
								<th class="intro_record">Intro</th>
								<th class="status_record">Status</th>
								<th class="edit_record"><label class="check"><input type="checkbox" name="check_all" /><span></span></label></th>
							</tr>
						</thead>
						<tbody></tbody>
					</table>
					<div class="nodata" data-guide="No data available!"></div>
				</div>
			</div>
		</div>
	</div>
