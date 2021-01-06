<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

	<script type="text/javascript">
	var now_year_date = "${serverDate}";
	var param_page_num ,param_page_size, param_page_last;
	var dept_arr = "<option value=''></option>";
	var dept_obj_data;
	// 날짜관련 
	var start_date = moment().subtract(29, 'days');
	var end_date = moment();
	var sel_mst_seq;
	
	
	$(document).ready(function() {
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/dept/list", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			dept_obj_data = JSON.parse(obj_result.data);
			for(var i=0; i < dept_obj_data.length; i++){
				dept_arr += "<option value='"+dept_obj_data[i]["dept_seq"]+"'>"+dept_obj_data[i]["dept_nm"]+"</option>";
			}
		}
		console.log("dept_list::"+dept_arr);
		
		param_page_num = 0;
		param_page_size = 30;
		param_page_last = false;

		//var start_date = moment(common_date.monthDel(common_date.convertType(now_year_date,4), 12));
		//var end_date = moment(common_date.monthAdd(common_date.convertType(now_year_date,4), 12));
		$("#container .basic .daterange").daterangepicker({
			startDate: start_date,
			endDate: end_date,
			ranges: {
				"Today": [moment(), moment()],
				"Yesterday": [moment().subtract(1, "days"), moment().subtract(1, "days")],
				"Last 7 Days": [moment().subtract(6, "days"), moment()],
				"Last 30 Days": [moment().subtract(29, "days"), moment()],
				"This Month": [moment().startOf("month"), moment().endOf("month")],
				"Last Month": [moment().subtract(1, "month").startOf("month"), moment().subtract(1, "month").endOf("month")]
			},
			locale: { format: "YYYY.MM.DD" },
			alwaysShowCalendars: true
		}, function(start_date, end_date, label) { console.log("New date range selected: " + start_date.format("YYYY.MM.DD") + " to " + end_date.format("YYYY.MM.DD") + " (predefined range: search range)"); });

		start_date = moment();
		end_date = moment(common_date.monthAdd(common_date.convertType(now_year_date,4), 1));

		$('.page.reserve .daterange').daterangepicker({
			startDate: start_date,
			endDate: end_date,
			opens: 'left',
			locale: {
				format: 'YYYY.MM.DD'
			}
		}, function(start_date, end_date, label) {
			console.log('New date range selected: ' + start_date.format('YYYY.MM.DD') + ' to ' + end_date.format('YYYY.MM.DD') + ' (predefined range: reserve mst range)');
		});
		
		$('input.daterange').on('showCalendar.daterangepicker', function(ev, picker) {
			if (picker.element.offset().top - $(window).scrollTop() + picker.container.outerHeight() > $(window).height()) {
				return picker.drops = 'up';
			} else {
				return picker.drops = 'down';
			}
		});
		
		/* reservation info datepicker */
		$('input.reservation').daterangepicker({
			singleDatePicker: true,
			timePicker: true,
			autoUpdateInput: false,
			opens: 'left',
			locale: {
				format: 'YYYY.MM.DD, hh:mm A',
				cancelLabel: 'Cancel'
			}
		});
		$('input.reservation').on('apply.daterangepicker', function(ev, picker) {
			$(this).val(picker.startDate.format('YYYY.MM.DD, hh:mm A'));
		});
		$('input.reservation').on('cancel.daterangepicker', function(ev, picker) {
			$(this).val('');
		});
		$('input.reservation').on('showCalendar.daterangepicker', function(ev, picker) {
			if (picker.element.offset().top - $(window).scrollTop() + picker.container.outerHeight() > $(window).height()) {
				return picker.drops = 'up';
			} else {
				return picker.drops = 'down';
			}
		});
		
		
		$.when(fn_get_abroad_reserve_list()).then(function(){ fn_table_sorter(); });
		
		$("#container .search_box input[type='button']").click(function(){ param_page_last=false; param_page_num = 0; $.when(fn_get_abroad_reserve_list()).then(function(){ fn_table_sorter(); });  }); // 검색 > 버튼 클릭시

	});
	
	/* 검색박스에서 엔터시 조회되게끔 변경 */
	$(document).on("keypress", "#container .search_box input[name='search_context']", function(){
		param_page_last=false; param_page_num = 0; $.when(fn_get_abroad_reserve_list()).then(function(){ fn_table_sorter(); }); 
	});
	
	function fn_default_set(){
		$("#container .basic input[name='page_start_num']").val(param_page_num);
		$("#container .basic input[name='page_size']").val(param_page_size);
	}

	/* 상담 목록 */
	function fn_get_abroad_reserve_list(){
		var no_data = "<tr><td colspan='6' class='nodata' data-guide='No data available!'></td></tr>";
		fn_default_set();

		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/reserve/mst/list", "json", false, "POST", search.get_parameter("container")));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var insert_table_data = "";
			if(obj_data.length == 0){ 
				param_page_last = true; 
				if(param_page_num == 0){ $("#container #detail_list .list .hms_table .tablesorter tbody").empty().append(no_data); }
				$("#container #detail_list .list .hms_table .tablesorter tbody").append(insert_table_data);
			}else{
				var param_contents = "";
				var param_reserve_type = "";
				var param_reserve_month = "";
				var param_start_dt = "";
				var param_end_dt = "";
				for(var i=0; i < obj_data.length; i++){
					insert_table_data += "<tr seq='"+ obj_data[i]["site_reserv_mst_seq"] +"' code=''>";
					if(obj_data[i]["reservation_type"] == "RT_SEMINAR"){
						param_reserve_type = "유학/캠프 설명회";
					}else if(obj_data[i]["reservation_type"] == "RT_CAMP"){
						param_reserve_type = "해외캠프 일정";						
					}
					insert_table_data += "<td class='type_record'><span class='reservation_type'>"+ param_reserve_type +"</span></td>";
					param_reserve_month = obj_data[i]["reservation_month"];
					param_reserve_month = (param_reserve_month.length > 5) ? param_reserve_month.substr(0, 4) +"년 "+ param_reserve_month.substr(4, 2)+"월 모집" : param_reserve_month;
					insert_table_data += "<td class='schedule_record'>"+ param_reserve_month +"</td>";
					param_start_dt = obj_data[i]["view_start_dt"];
					param_end_dt = obj_data[i]["view_end_dt"];
					insert_table_data += "<td class='date_record'>"+ param_start_dt.substr(0, 4) +"."+ param_start_dt.substr(4, 2)+"."+param_start_dt.substr(6,2)+"~"+param_end_dt.substr(0, 4) +"."+ param_end_dt.substr(4, 2)+"."+param_end_dt.substr(6,2)+"</td>";
					insert_table_data += "<td class='author_record'>"+ obj_data[i]["reg_user_nm"] +"</td>";
					insert_table_data += "<td class='date_record'>"+ common_date.convertType(obj_data[i]["reg_ts"],10) +"</td>";
					var param_del_btn = (obj_data[i]["cnt"] == 0) ? "" : "disabled"; 
					insert_table_data += "<td class='delete_record'><button title='Delete' class='icon delete' "+ param_del_btn +"><span>Delete</span></button></td>";
					insert_table_data += "</tr>";
				}
				if(param_page_num == 0){ $("#container #detail_list .list .hms_table .tablesorter tbody").empty(); }
				$("#container #detail_list .list .hms_table .tablesorter tbody").append(insert_table_data);
			}			
		}else{
			$("#container #detail_list .list .hms_table .tablesorter tbody").empty().append(no_data);
		}
		$("#container #detail_list .list .hms_table .tablesorter").trigger("update");
	}
	
	function fn_table_sorter(){
		var table_height = $('#detail_list .list').height()-34;
		$('#detail_list .tablesorter').trigger('sortReset');
		$("#detail_list .tablesorter").tablesorter({
			headers : { '.delete_record, .edit_record' : {sorter:false} },
			widgets: [ 'scroller' ],
			widgetOptions : {
				scroller_height : table_height,
				scroller_upAfterSort: true,
				scroller_jumpToHeader: true,
				scroller_barWidth : null
			}
		}).on('scrollerComplete', function(){  });
		
		// 스크롤했을때 param_page_num 추가해서 append 한다. 
		$("#detail_list .hms_table .tablesorter-scroller-table").scroll(function(){ 
			if($(this).scrollTop() >= ($(this).find(".tablesorter").height() - $(this).height())){
				if(param_page_last == false){
					++param_page_num; 
					$.when(fn_get_abroad_reserve_list()).then(function(){ fn_table_sorter(); });
				}
			}
		});
	}
	 
	/* 리스트 선택시 */
	$(document).on('click','#detail_list .hms_table tbody tr',function() {
		$('#detail_info').removeClass('new');
		$('#detail_info .viewbar>h4>b').text('예약설정 수정');
		$('#detail_info .create_btn button.create').addClass('hide');
		$('#detail_info .create_btn button.save').removeClass('hide');
		
		console.log("seq::"+$(this).attr("seq"))
		if($(this).hasClass('selected')){
			console.log("sel::")
			$(this).toggleClass('selected');
			$('#container').toggleClass('expand');
		} else{
			console.log("not sel::")
			var selseq = $(this).attr("seq");
			if(selseq != undefined && selseq != null){
				fn_get_abroad_reserve_mst_view($(this).attr("seq"));
				
				$(this).closest('tbody').find('tr').removeClass('selected');
				$(this).addClass('selected');
				$('#container').addClass('expand');
				// check ym
				var ym = $(this).find('.schedule_record').text();
				$('input.month_picker').val(ym);				
			}
		}		
		setTimeout(function() {
			$(window).trigger('resize');
		}, 100);
	});
	

	/* 목록에서 삭제버튼 눌렀을때 */
	$(document).on("click", "#detail_list .hms_table tr td.delete_record button.delete", function() {
		var param_rtn_value = $(this).closest("tr").attr("seq");
		console.log("select delete seq::"+param_rtn_value);
		dialog.list_delete_confirm_btn($(this), "This item will be deleted. Are you sure?", fn_del_reserve_mst, param_rtn_value); 
	});

	function fn_del_reserve_mst(param_site_reserve_mst_seq){
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/reserve/mst/"+ param_site_reserve_mst_seq, "json", false, "DELETE", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			console.log("delete result::"+obj_data);
			if(obj_data == "-2"){
				alert("등록된 정보가 있어 삭제할 수 없습니다.");
			}else{
				$.when(fn_get_abroad_reserve_list()).then(function(){ fn_table_sorter(); });				
			}
		}else{
			alert(obj_result.header.resultMessage);
		}
	}

	function fn_del_reserve_program(param_reserve_mst_seq, param_reserve_program_seq){
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/reserve/program/"+param_reserve_mst_seq+"/"+ param_reserve_program_seq, "json", false, "DELETE", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			console.log("delete result::"+obj_data);
			if(obj_data == "-2"){
				alert("등록된 정보가 있어 삭제할 수 없습니다.");
			}else{		
				fn_get_abroad_reserve_mst_view(sel_mst_seq);
			}
		}else{
			alert(obj_result.header.resultMessage);
		}
	}
	
	function fn_get_abroad_reserve_mst_view(param_reserve_mst_seq){
		sel_mst_seq = param_reserve_mst_seq;
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/reserve/mst/info/"+ param_reserve_mst_seq, "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var sel_reserve_mst_seq = 0;
			var sel_program_seq = 0;
			var sel_reserve_type = "";
			var sel_start_dt = "";			
			var sel_end_dt = "";
			var sub_schedule_str = "";
			var sel_dept_arr;
			var dept_selected = "";
			var sel_date_time = "";
			var sel_sub_start_dt = "";			
			var sel_sub_end_dt = "";
			var sel_program_nm = "";
			var sel_dept = "";
			var obj_dept = "";
			var sub_program_data = obj_data[0]["reserve_program_list"];
			sel_reserve_mst_seq = obj_data[0]["site_reserv_mst_seq"];
			sel_reserve_type = obj_data[0]["reservation_type"];
			sel_start_dt = obj_data[0]["view_start_dt"];
			sel_end_dt = obj_data[0]["view_end_dt"];			
			console.log("site_reserv_mst_seq::"+sel_reserve_mst_seq);
			console.log("sel_reserve_type::"+sel_reserve_type+"||sel_start_dt::"+sel_start_dt+"||sel_end_dt::"+sel_end_dt);
			console.log("program list cnt ::"+sub_program_data.length);
			
			$('select#reservation_type').val(sel_reserve_type).trigger('change');
			$('select#reservation_type').prop('disabled', true);
			// contents view			
			if (sel_reserve_type == 'RT_SEMINAR'){
				
				$('.page.reserve .contents.briefing .daterange').daterangepicker({
					startDate: sel_start_dt,
					endDate: sel_end_dt,
					opens: 'left',
					locale: {
						format: 'YYYY.MM.DD'
					}
				}, function(sel_start_dt, sel_end_dt, label) {
					console.log('New date range selected: ' + sel_start_dt.format('YYYY.MM.DD') + ' to ' + sel_end_dt.format('YYYY.MM.DD') + ' (predefined range: reserve mst range)');
				});
				
				$('#detail_info .page .contents.briefing .edit_reserve .form_table').html('<li><div class="new_list"><div class="add"><span>Add Schedule</span></div></div></li>');
				$('#detail_info .contents.camp_schedule').addClass('hide');
				$('#detail_info .contents.camp_schedule .edit_reserve').addClass('hide');
				$('#detail_info .contents.briefing').removeClass('hide');
				$('#detail_info .contents.briefing .edit_reserve').removeClass('hide');
			}else if (sel_reserve_type == 'RT_CAMP'){		
				
				$('.page.reserve .contents.camp_schedule .daterange').daterangepicker({
					startDate: sel_start_dt,
					endDate: sel_end_dt,
					opens: 'left',
					locale: {
						format: 'YYYY.MM.DD'
					}
				}, function(sel_start_dt, sel_end_dt, label) {
					console.log('New date range selected: ' + sel_start_dt.format('YYYY.MM.DD') + ' to ' + sel_end_dt.format('YYYY.MM.DD') + ' (predefined range: reserve mst range)');
				});

				$('#detail_info .page .contents.camp_schedule .edit_reserve .form_table').html('<li><div class="new_list"><div class="add"><span>Add Schedule</span></div></div></li>');
				$('#detail_info .contents.briefing').addClass('hide');
				$('#detail_info .contents.briefing .edit_reserve').addClass('hide');
				$('#detail_info .contents.camp_schedule').removeClass('hide');
				$('#detail_info .contents.camp_schedule .edit_reserve').removeClass('hide');
			}
			
		    console.log("program cnt ::"+sub_program_data.length);
			
			for(var i=0; i < sub_program_data.length; i++){
				console.log("row::"+i+"|"+sub_program_data[i]["site_reserv_program_seq"]);
				console.log("row::"+i+"|"+sub_program_data[i]["dept_seq"]);
				console.log("row::"+i+"|"+sub_program_data[i]["date_time"]);
				console.log("row::"+i+"|"+sub_program_data[i]["view_start_dt"]);
				console.log("row::"+i+"|"+sub_program_data[i]["view_end_dt"]);
				console.log("row::"+i+"|"+sub_program_data[i]["program_nm"]);
				sub_schedule_str = "";
				sel_program_seq = sub_program_data[i]["site_reserv_program_seq"];
				sel_date_time = sub_program_data[i]["date_time"];
				sel_sub_start_dt = sub_program_data[i]["view_start_dt"];
				sel_sub_end_dt = sub_program_data[i]["view_end_dt"];
				sel_program_nm = sub_program_data[i]["program_nm"];
				sel_dept = sub_program_data[i]["dept_seq"];
				// 하위 카테고리 추가
				if (sel_reserve_type == 'RT_SEMINAR'){		
					console.log("설명회::");
					for(var j=0; j < dept_obj_data.length; j++){
						obj_dept = dept_obj_data[j]["dept_seq"];
						if(obj_dept == sel_dept){
							dept_selected = "selected";
							//console.log("dept_selected Y::"+dept_selected);
						}else{
							dept_selected = "";
							//console.log("dept_selected N::"+dept_selected);
						}
						sel_dept_arr += '<option value="'+obj_dept+'" '+dept_selected+'>'+dept_obj_data[j]["dept_nm"]+'</option>';
					}

					sub_schedule_str = '<li id="'+sel_program_seq+'">';
					sub_schedule_str += '<div class="cell"><select class="branch_info" style="width:160px;">'+sel_dept_arr+'</select></div>';
					sub_schedule_str += '<div class="cell"><label class="period"><input type="text" class="reservation" value="'+sel_date_time+'" style="width:160px" readonly /><span></span></label></div>';
					sub_schedule_str += '<div class="cell delete"><input type="text" class="schdule_item" placeholder="Program Name" value="'+sel_program_nm+'" /><span class="delete"></span></div>';
					sub_schedule_str += '</li>';
					
					//console.log(sub_schedule_str);

					//console.log($('#detail_info .page .contents.briefing .edit_reserve .form_table').find('li').html());
					$('#detail_info .page .contents.briefing .edit_reserve .form_table').find('li').eq(0).after(sub_schedule_str);
					$('.contents.briefing .branch_info').select2({
						placeholder: 'Select Grade',
						minimumResultsForSearch: 20
					});
					
					/* reservation info datepicker */
					$('input.reservation').daterangepicker({
						singleDatePicker: true,
						timePicker: true,
						autoUpdateInput: false,
						opens: 'left',
						locale: {
							format: 'YYYY.MM.DD, hh:mm A',
							cancelLabel: 'Cancel'
						}
					});
					$('input.reservation').on('apply.daterangepicker', function(ev, picker) {
						$(this).val(picker.startDate.format('YYYY.MM.DD, hh:mm A'));
					});
					$('input.reservation').on('cancel.daterangepicker', function(ev, picker) {
						$(this).val('');
					});
					$('input.reservation').on('showCalendar.daterangepicker', function(ev, picker) {
						if (picker.element.offset().top - $(window).scrollTop() + picker.container.outerHeight() > $(window).height()) {
							return picker.drops = 'up';
						} else {
							return picker.drops = 'down';
						}
					});
				} else if (sel_reserve_type == 'RT_CAMP'){
					console.log("캠프::");	

					sub_schedule_str = '<li id="'+sel_program_seq+'">';
					sub_schedule_str += '<div class="cell"><label class="period"><input type="text" class="daterange" value="" style="width:180px" readonly /><span></span></label></div>';
					sub_schedule_str += '<div class="cell delete"><input type="text" class="schdule_item" placeholder="Program Name" value="'+sel_program_nm+'" /><span class="delete"></span></div>';
					sub_schedule_str += '</li>';

					//console.log($('#detail_info .page .contents.briefing .edit_reserve .form_table').find('li').html());
					$('#detail_info .page .contents.camp_schedule .edit_reserve .form_table').find('li').eq(0).after(sub_schedule_str);
										
					//$('#detail_info .page .camp_schedule .edit_reserve .form_table').closest('li').after('<li><div class="cell"><label class="period"><input type="text" class="daterange" value="" style="width:180px" readonly /><span></span></label></div><div class="cell delete"><input type="text" class="schdule_item" placeholder="Program Name" value="" /><span class="delete"></span></div></li>');
					
					//var sub_start_dt, sub_end_dt;
					//sub_start_dt = sel_sub_start_dt;
					//sub_end_dt = sel_sub_end_dt;
					console.log(sel_sub_start_dt+"|"+sel_sub_end_dt);

					$('#'+sel_program_seq+' .daterange').daterangepicker({
						startDate: sel_sub_start_dt,
						endDate: sel_sub_end_dt,
						opens: 'left',
						locale: {
							format: 'YYYY.MM.DD'
						}
					}, function(sel_sub_start_dt, sel_sub_end_dt, label) {
						console.log('New date range selected: ' + sel_sub_start_dt.format('YYYY.MM.DD') + ' to ' + sel_sub_end_dt.format('YYYY.MM.DD') + ' (predefined range: reserve mst range)');
					});
				}
				console.log("no::"+i+"::end");	
			}			
		}
	}

	/* new schedule */
	function new_schedule() {
		sel_mst_seq = "";
		
		$('#detail_list tbody tr').removeClass('selected');
		//$('#detail_list tbody').prepend('<tr class="selected"><td class="type_record"><span class="reservation_type"></span><span class="visit_type"></span></td><td class="schedule_record"></td><td class="author_record left"></td><td class="date_record"></td><td class="delete_record"><button title="Delete" class="icon delete"><span>Delete</span></button></td></tr>');
		$('#container').addClass('expand');
		$('input#visit_branch').prop('disabled', false);
		$('select#reservation_type').prop('disabled', false);	
		$('#detail_info').addClass('new');
		$('#detail_info .viewbar>h4>b').text('예약설정 등록');
		$('#detail_info .viewbar #reservation_type').val('').trigger('change');
		$('#detail_info .viewbar .month_picker').val('');
		$('#detail_info .contents').addClass('hide');
		$('#detail_info .contents.briefing .edit_reserve').addClass('hide');
		//$('#detail_info .contents.briefing').removeClass('hide');
		//$('#detail_info .edit_reserve.headquarter').removeClass('hide');
		$('#detail_info .create_btn button.create').removeClass('hide');
		$('#detail_info .create_btn button.save').addClass('hide');
		
		setTimeout(function() {
			$(window).trigger('resize');
		}, 100);
	}
	
	$(document).on('click','#detail_info button.cancel, #detail_info .close_detail',function() {
		$('#detail_list .hms_table tr').removeClass('selected');
		$('#detail_info').removeClass('new');
		$('#detail_info .create_btn button.create').addClass('hide');
		$('#detail_info .create_btn button.save').removeClass('hide');
		$('#container').removeClass('expand');
		if($('select#reservation_type').prop('disabled')){
			$('select#reservation_type').prop('disabled', false);			
		}
		//상세 내용 초기화
		$(".edit_reserve .form_table").html('<li><div class="new_list"><div class="add"><span>Add Schedule</span></div></div></li>');
		setTimeout(function() {
			$(window).trigger('resize');
		}, 100);
	});

	$(document).on('mouseenter','#detail_list .hms_table td',function() {
		$(this).closest('tr').addClass('hover');
	});
	$(document).on('mouseleave','#detail_list .hms_table td',function() {
		$(this).closest('tr').removeClass('hover');
	});
	$(document).on('click', 'td.delete_record',function(e){
		e.stopPropagation();
	});
	$(document).on('mouseenter', 'td.delete_record',function(e){
		$(this).closest('tr').removeClass('hover');
		e.stopPropagation();
	});

	/* add schedule */
	$(document).on('click','#detail_info .new_list>.add',function() {
		console.log("add click");
		// check reserve type
		var reserve_type = $('#reservation_type').val();
		console.log("reserve_type1"+reserve_type);
		var now_date = now_year_date.substr(0,4)+"."+now_year_date.substr(4,2)+"."+now_year_date.substr(6,2);
		
		if (reserve_type == 'RT_SEMINAR'){		
			console.log("설명회::");
			$(this).closest('li').after('<li><div class="cell"><select class="branch_info" style="width:160px;">'+dept_arr+'</select></div><div class="cell"><label class="period"><input type="text" class="reservation" value="'+now_date+', 12:00 PM" style="width:160px" readonly /><span></span></label></div><div class="cell delete"><input type="text" class="schdule_item" placeholder="Program Name" value="" /><span class="delete"></span></div></li>');
			$('.contents.briefing .branch_info').select2({
				placeholder: 'Select Grade',
				minimumResultsForSearch: 20
			});
			
			/* reservation info datepicker */
			$('input.reservation').daterangepicker({
				singleDatePicker: true,
				timePicker: true,
				autoUpdateInput: false,
				opens: 'left',
				locale: {
					format: 'YYYY.MM.DD, hh:mm A',
					cancelLabel: 'Cancel'
				}
			});
			$('input.reservation').on('apply.daterangepicker', function(ev, picker) {
				$(this).val(picker.startDate.format('YYYY.MM.DD, hh:mm A'));
			});
			$('input.reservation').on('cancel.daterangepicker', function(ev, picker) {
				$(this).val('');
			});
			$('input.reservation').on('showCalendar.daterangepicker', function(ev, picker) {
				if (picker.element.offset().top - $(window).scrollTop() + picker.container.outerHeight() > $(window).height()) {
					return picker.drops = 'up';
				} else {
					return picker.drops = 'down';
				}
			});
		} else if (reserve_type == 'RT_CAMP'){
			console.log("캠프::");	
			$(this).closest('li').after('<li><div class="cell"><label class="period"><input type="text" class="daterange" value="" style="width:180px" readonly /><span></span></label></div><div class="cell delete"><input type="text" class="schdule_item" placeholder="Program Name" value="" /><span class="delete"></span></div></li>');
			
			$('input.daterange').on('showCalendar.daterangepicker', function(ev, picker) {
				if (picker.element.offset().top - $(window).scrollTop() + picker.container.outerHeight() > $(window).height()) {
					return picker.drops = 'up';
				} else {
					return picker.drops = 'down';
				}
			});
			var sub_start_dt, sub_end_dt;
			$('.page.reserve .edit_reserve .daterange').daterangepicker({
				startDate: sub_start_dt,
				endDate: sub_end_dt,
				opens: 'left',
				locale: {
					format: 'YYYY.MM.DD'
				}
			}, function(sub_start_dt, sub_end_dt, label) {
				console.log('New date range selected: ' + start_date.format('YYYY.MM.DD') + ' to ' + end_date.format('YYYY.MM.DD') + ' (predefined range: reserve mst range)');
			});
		}
	});

	/* delete sub schedule */
	$(document).on('click','#detail_info .form_table>li>.cell>.delete',function() {
		console.log("delete click::");
		var sel_mode = $("#detail_info").attr("class");
		var sel_seq;
		console.log("sel_mode click::"+sel_mode);
		if(sel_mode == "new"){		
			$(this).closest('li').remove();			
		}else{
			/* program 삭제 함수 호출  */
			sel_seq = $(this).closest('li').attr('id');
			console.log("sel program id ::"+sel_seq);			
			fn_del_reserve_program(sel_mst_seq, sel_seq);
		}
	});
	

	/* delete base schedule */
	$(document).on('click','#detail_info .page>.create_btn>.delete',function() {
		console.log("delete click2::");
		var sel_mode = $("#detail_info").attr("class");
		console.log("sel_mode click::"+sel_mode);
		if(sel_mode == "new"){		
			$(".edit_reserve .form_table").html('<li><div class="new_list"><div class="add"><span>Add Schedule</span></div></div></li>');			
		}else{
			/* program 리스트 삭제 함수 호출  */
			fn_del_reserve_program(sel_mst_seq, 0);			
		}
	});
	
	</script>
	<script type="text/javascript">
	$(document).ready(function() {
		$('#reservation_type').select2({
			placeholder: 'Select Type',
			minimumResultsForSearch: 20
		});
	});
	$(document).on('change','.new #reservation_type',function() {
		// get effect type from
		var reserve = $('#reservation_type').val();
		console.log("reservation_type::"+reserve);
		$('#detail_info .contents').addClass('hide');
		
		if ( reserve === 'RT_SEMINAR' ) {
			$('#detail_info .contents.briefing .edit_reserve .form_table').html('<li><div class="new_list"><div class="add"><span>Add Schedule</span></div></div></li>');
			$('#detail_info .contents.camp_schedule').addClass('hide');
			$('#detail_info .contents.camp_schedule .edit_reserve').addClass('hide');
			$('#detail_info .contents.briefing').removeClass('hide');
			$('#detail_info .contents.briefing .edit_reserve').removeClass('hide');
			$('#detail_info .contents.briefing .cell.date span.label').text('노출기간');
		}else if ( reserve === 'RT_CAMP' ) {
			$('#detail_info .contents.camp_schedule .edit_reserve .form_table').html('<li><div class="new_list"><div class="add"><span>Add Schedule</span></div></div></li>');
			$('#detail_info .contents.briefing').addClass('hide');
			$('#detail_info .contents.briefing .edit_reserve').addClass('hide');
			$('#detail_info .contents.camp_schedule').removeClass('hide');
			$('#detail_info .contents.camp_schedule .edit_reserve').removeClass('hide');
		}
	});
	
	function save_reserve(){
		var reserve_mst_seq = sel_mst_seq;
		var reserve_type = $('#reservation_type').val();
		var reserve_month = $('#reserve_month').val();		
		console.log("reservetype::"+reserve_type+"||reserve_month::"+reserve_month);

		console.log("month_picker1::"+$('.month_picker').val());
		//console.log("month_picker2::"+$('#reserve_month').val());

		var param_start_dt, param_end_dt, sub_search_date, param_sub_start_dt, param_sub_end_dt;
		
		if(reserve_type != ""){
			if(reserve_type == 'RT_SEMINAR' ) {
				sub_search_date = $("#detail_info .page .form_table").find("input[name='sub_seminar_date']").val().replace(/ /gi, '').replace(/\./g, '').split("-");						
			}else if ( reserve_type === 'RT_CAMP' ) {
				sub_search_date = $("#detail_info .page .form_table").find("input[name='sub_camp_date']").val().replace(/ /gi, '').replace(/\./g, '').split("-");			
			}
			param_start_dt = sub_search_date[0];
			param_end_dt = sub_search_date[1];		
			console.log("param_start_dt::"+param_start_dt+"||param_end_dt::"+param_end_dt);
			
		}
		
		if(reserve_type == ""){ alert("예약타입을 선택해 주세요."); return; } 
		if(reserve_month == undefined||reserve_month == ""){ alert("모집년월을 선택해 주세요."); return; } 
		if(param_start_dt == ""||param_end_dt == ""){ alert("노출기간을 선택해주세요"); return; }
		
		var param_sel_obj;
		if(reserve_type == 'RT_SEMINAR' ) {
			param_sel_obj = $("#detail_info .page .briefing .edit_reserve .form_table").find("li");						
		}else if ( reserve_type === 'RT_CAMP' ) {
			param_sel_obj = $("#detail_info .page .camp_schedule .edit_reserve .form_table").find("li");			
		}
		
		var site_reserv_program_seq = 0;
		var param_program_list = [];
		var program_obj;
		var sub_period = "";
		var view_start_dt = "";
		var view_end_dt = "";
		var cnt = 0;
		var sel_mode = $("#detail_info").attr("class");
		console.log("sel_mode click::"+sel_mode);
		
		if(reserve_mst_seq == ""||reserve_mst_seq == undefined){
			reserve_mst_seq = "0";							
		}
		console.log("reserve_mst_seq:"+reserve_mst_seq);
		
		for(var i=1; i < param_sel_obj.length; i++){ 
			program_obj = new Object();
			program_obj["site_reserv_mst_seq"] = reserve_mst_seq;
			
			if(reserve_type == 'RT_SEMINAR' ) {
				program_obj["dept_seq"] = param_sel_obj.eq(i).find("select").val();
				program_obj["date_time"] = param_sel_obj.eq(i).find(".reservation").val();
				program_obj["view_start_dt"] = "";
				if(param_sel_obj.eq(i).find(".reservation").val().length > 10){
					view_end_dt = param_sel_obj.eq(i).find(".reservation").val();
					console.log("enddt1::"+view_end_dt);
					view_end_dt = view_end_dt.substring(0, 10);
					console.log("enddt2::"+view_end_dt);
					view_end_dt = view_end_dt.replace(/\./g,'');
					console.log("enddt2::"+view_end_dt);
				}
				program_obj["view_end_dt"] = view_end_dt;					
			}else if ( reserve_type === 'RT_CAMP' ) {
				program_obj["dept_seq"] = "";
				program_obj["date_time"] = "";
				sub_period = param_sel_obj.eq(i).find(".daterange").val().replace(/ /gi, '').replace(/\./g, '').split("-");			
				program_obj["view_start_dt"] = sub_period[0];
				program_obj["view_end_dt"] = sub_period[1];	
				//console.log("seldaterange::"+param_sel_obj.eq(i).find(".daterange").val());
				//console.log("seldaterange::"+sub_period[0]+"|"+sub_period[1]);				
			}
			site_reserv_program_seq = param_sel_obj.eq(i).attr("id");
			console.log("program_seq::"+site_reserv_program_seq);
			if(site_reserv_program_seq == undefined||site_reserv_program_seq == ""){
				program_obj["site_reserv_program_seq"] = 0;									
			}else{
				program_obj["site_reserv_program_seq"] = site_reserv_program_seq;	
			}		
			console.log("site_reserv_program_seq:"+program_obj["site_reserv_program_seq"]);		
			program_obj["program_nm"] = param_sel_obj.eq(i).find(".schdule_item").val();			
			
			console.log("dept::"+program_obj["dept_seq"]);
			console.log("date::"+program_obj["date_time"]);
			console.log("name::"+program_obj["program_nm"]);
			console.log("startdt::"+program_obj["view_start_dt"]);
			console.log("enddt::"+program_obj["view_end_dt"]);
			//param_program_list.push(program_obj);
			param_program_list[i-1] = program_obj;
		}

		var param_obj = new Object();
		param_obj["site_reserv_mst_seq"] = reserve_mst_seq;		
		param_obj["reservation_type"] = reserve_type;
		param_obj["reservation_month"] = reserve_month;
		param_obj["start_dt"] = param_start_dt;
		param_obj["end_dt"] = param_end_dt;
		param_obj["program_list"] = param_program_list;

		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/reserve/mst/save", "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			alert("저장이 완료 되었습니다.");
			$("#detail_info button.cancel").trigger("click");
			fn_get_abroad_reserve_list();
		}else{
			alert(obj_result.header.resultMessage);
		}
	}
	</script>
	
	<div id="container">
		<div class="browser sidebar expand">
			<div class="burger_icon"><span></span></div>
			<h3>Study Abroad</h3>
			<div class="scroll">
				<div id="subnav">
					<ul>
						<li>
							<h4>
								<span>기본설정</span>
							</h4>
							<ol>
								<li>
									<a href="03_study_abroad_basic.asp"><span>프로그램 메뉴 관리</span></a>
								</li>
								<li>
									<a href="03_study_abroad_basic_module.asp"><span>프로그램 모집 관리(Main Page)</span></a>
								</li>
							</ol>
						</li>
						<li>
							<h4><span>소개 페이지</span></h4>
							<ol>
								<li>
									<a href="03_study_abroad_intro_partner.asp"><span>파트너</span></a>
								</li>
								<li>
									<a href="03_study_abroad_intro_staff.asp"><span>운영진 소개</span></a>
								</li>
							</ol>
						</li>
						<li>
							<h4><span>프로그램</span></h4>
							<ol>
								<li>
									<a href="03_study_abroad_program.asp"><span>프로그램 소개/모집요강/스케줄</span></a>
								</li>
							</ol>
						</li>
						<li>
							<h4><span>커뮤니티</span></h4>
							<ol>
								<li>
									<a href="03_study_abroad_community_postscript.asp"><span>유학/캠프 후기</span></a>
								</li>
								<li>
									<a href="03_study_abroad_community_gallery.asp"><span>갤러리</span></a>
								</li>
								<li>
									<a href="03_study_abroad_community_movie.asp"><span>동영상</span></a>
								</li>
							</ol>
						</li>
						<li>
							<h4><span>예약관리</span></h4>
							<ol>
								<li>
									<a href="03_study_abroad_reservation_set.asp"><span>설명회/캠프 예약설정</span></a>
								</li>
								<li class="selected">
									<a href="03_study_abroad_reservation_briefing.asp"><span>유학/캠프 설명회  신청 관리</span></a>
								</li>
								<li>
									<a href="03_study_abroad_reservation_camp.asp"><span>해외캠프 신청 관리</span></a>
								</li>
							</ol>
						</li>
						<li>
							<h4><span>MY 유학</span></h4>
							<ol>
								<li>
									<a href="03_study_abroad_my_counseling.asp"><span>유학생활 1:1 대화</span></a>
								</li>
								<li>
									<a href="03_study_abroad_my_report.asp"><span>리포트</span></a>
								</li>
							</ol>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<div class="contents">
			<div class="basic">
				<dl class="">
					<dd class="name">
						<h3>예약관리 <span class="depth_txt">></span> <b>유학/캠프 설명회  신청 관리</b></h3>
						<div class="items">
							<label class="period"><input type="text" class="daterange" value="" style="width:160px;" readonly /><span></span></label>
						</div>
						<div class="search_box">
							<input type="text" id="searchName" placeholder="Student name, Contents text">
							<input type="button" class="search_btn">
						</div>
					</dd>
				</dl>
			</div>
			<div id="detail_list">
				<div class="sort_option">
					<div class="inquiry group expand">
						<div class="sort first">
							<h5>Program</h5>
							<label><input type="checkbox" name="program_type" value="0"> <span>유학</span></label>
							<label><input type="checkbox" name="program_type" value="1"> <span>캠프</span></label>
						</div>
					</div>
					<div class="func">
						<button type="button" class="small excel" title="Download from Excel"><span>Excel Download</span></button>
					</div>
				</div>
				<div class="list">
					<div class="hms_table">
						<table class="tablesorter">
							<colgroup>
								<col style="width:6%;">
								<col style="width:10%;">
								<col style="width:6%;">
								<col style="width:29%;">
								<col style="width:20%;">
								<col style="width:5%;">
								<col style="width:8%;">
								<col style="width:8%;">
								<col style="width:8%;">
								<col style="width:35px;">
							</colgroup>
							<thead>
								<tr>
									<th class="name_record">Name</th>
									<th class="phone_record">Phone Num.</th>
									<th class="branch_record">Branch</th>
									<th class="schedule_record">Schedule</th>
									<th class="email_record">Email</th>
									<th class="type_record">Type</th>
									<th class="country_record">Country</th>
									<th class="program_record">Program</th>
									<th class="date_record">Issue Date</th>
									<th class="delete_record"></th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="name_record left">공태유 (초5)</td>
									<td class="phone_record">010-9053-4208</td>
									<td class="branch_record">죽전CHESS</td>
									<td class="schedule_record left">2019.03.11(월), PM 7:00 / 죽전분원</td>
									<td class="email_record left">bmw1787@nate.com</td>
									<td class="type_record">캠프</td>
									<td class="country_record">캐나다밴쿠버</td>
									<td class="program_record">홈스테이형</td>
									<td class="date_record">2019.02.01</td>
									<td class="delete_record"><button title="Delete" class="icon delete"><span>Delete</span></button></td>
								</tr>
								<tr>
									<td class="name_record left">김무빈 (초5)</td>
									<td class="phone_record">010-6390-7910</td>
									<td class="branch_record">광주경안CHESS</td>
									<td class="schedule_record left">2019.03.11(월), PM 7:00 / 죽전분원</td>
									<td class="email_record left">96521021@hanmail.net</td>
									<td class="type_record">캠프</td>
									<td class="country_record">필리핀</td>
									<td class="program_record">기숙하우스형</td>
									<td class="date_record">2019.02.01</td>
									<td class="delete_record"><button title="Delete" class="icon delete"><span>Delete</span></button></td>
								</tr>
								<tr>
									<td class="name_record left">이승연 (초4)</td>
									<td class="phone_record">010-3775-1015</td>
									<td class="branch_record">수서CHESS</td>
									<td class="schedule_record left">2019.03.12(화), PM 6:30 / 수서분원</td>
									<td class="email_record left">aaa@naver.com</td>
									<td class="type_record">유학</td>
									<td class="country_record">미국시애틀</td>
									<td class="program_record">기숙하우스형</td>
									<td class="date_record">2019.02.01</td>
									<td class="delete_record"><button title="Delete" class="icon delete"><span>Delete</span></button></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>	