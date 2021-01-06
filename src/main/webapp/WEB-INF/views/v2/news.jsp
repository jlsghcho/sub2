<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="popup/tag_setting.jsp" flush="true" />

<script type="text/javascript">
	var now_year_date = "${serverDate}";
	var param_emp_type = "${cookieEmpType}";
	var param_emp_dept_list = "${cookieDeptList}";

	var param_abroad_seq = "<spring:eval expression="@globalContext['ABROAD_CODE']" />";
	var param_abroad_nm = "<spring:eval expression="@globalContext['ABROAD_NM']" />";
	
	var param_page_num ,param_page_size, param_page_last;
	
	var quill = '';
	var editorType = '';
	var editorChangeTs = '20201208';
	
	$(document).ready(function() {
		param_page_num = 0;
		param_page_size = 30;
		param_page_last = false;
		
		if(param_emp_type == "S"){
			get_news_dept_list();
			$("#container .search select[name='search_dept_2']").hide();
			$("#container .search select[name='search_dept_1']").change(function(){ search.get_dept_sub_list("container", $(this).find(":selected").val(), param_emp_type); });
		}else{
			$("#container .search select[name='search_dept_1']").hide();
			search.get_dept_sub_list("container", param_emp_dept_list, param_emp_type);
		}
		
		// 날짜관련 
		var start_date = moment(common_date.monthDel(common_date.convertType(now_year_date,4), 12));
		var end_date = moment(common_date.monthAdd(common_date.convertType(now_year_date,4), 12));
		$("#container .tit_area .daterange").daterangepicker({
			startDate: start_date,
			endDate: end_date,
			ranges: {
				'Today': [moment(), moment()],
				'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
				'Last 7 Days': [moment().subtract(6, 'days'), moment()],
				'Last 30 Days': [moment().subtract(29, 'days'), moment()],
				'This Month': [moment().startOf('month'), moment().endOf('month')],
				'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
			},
			locale: { format: 'YYYY.MM.DD' },
			alwaysShowCalendars: true
		}, function(start, end, label) { console.log('New date range selected: ' + start.format('YYYY.MM.DD') + ' to ' + end.format('YYYY.MM.DD') + ' (predefined range: ' + label + ')'); });
		
		search.get_tag_list("container");
		
		//fn_popup_editor();
		$.when(fn_news_list()).then(function(){ fn_table_sorter(); });
		
		$("#container .search_box input[type='button']").click(function(){ param_page_last=false; param_page_num = 0; $.when(fn_news_list()).then(function(){ fn_table_sorter(); });  }); // 검색 > 버튼 클릭시
	});
	
	/* 검색박스에서 엔터시 조회되게끔 변경 */
	$(document).on("keypress", "#container .search_box input[name='search_context']", function(){
		param_page_last=false; param_page_num = 0; $.when(fn_news_list()).then(function(){ fn_table_sorter(); }); 
	});
	
	
	/* 유학분원명단을 가지고 온다. 명단은 HardCoding Properties 참조 */
	function get_news_dept_list(){
		var param_key = $("#container");
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/dept/news", "json", false, "GET", ""));
		
		var select_dept_side_list ;
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var select_dept_top_list = '';
			if ( obj_data.length == 4){
				select_dept_top_list += "<option value='' selected>전체분원</option>";
			}
			for(var i=0; i < obj_data.length; i++){
				select_dept_top_list += "<option value='"+ obj_data[i]["DLT_DEPT_SEQ"] +"'>"+ obj_data[i]["DLT_DEPT_NM"] +"</option>";
				select_dept_side_list += "<option value='"+ obj_data[i]["DLT_DEPT_SEQ"] +"'>"+ obj_data[i]["DLT_DEPT_NM"] +"</option>";
			}
			param_key.find("select[name='search_dept_1']").empty().append(select_dept_top_list);
			param_key.find("select[name='inup_dept_1']").empty().append(select_dept_side_list);
			
		}
		param_key.find("select[name='search_dept_1']").select2({ minimumResultsForSearch: 20, width:'100px', dropdownAutoWidth: 'true' });
		param_key.find("select[name='inup_dept_1']").select2({ minimumResultsForSearch: 20, width:'100px', dropdownAutoWidth: 'true' });
	}

	// 게시예정인 게시물 삭제버튼 클릭시 
	$(document).on("click", ".hms_table button.icon.delete", function(){ 
		var param_cseq_value = $(this).closest("tr").attr("cseq");
		var param_dept_nm = $(this).closest("tr").attr("deptNm");
		var param_rtn_value = param_cseq_value+","+param_dept_nm;
		dialog.list_delete_confirm_btn($(this), "This item will be deleted. Are you sure?", fn_list_delete_yes, param_rtn_value); 
	});
	
	/* Tag Setting open */ 
	function fn_tag_setting_open(){
		$('body').addClass('noscroll');
		$('#pop_tag_setting, .black_bg').fadeIn();
		set_scroll();
		fn_tag_list();
	}
	
	function fn_default_set(){
		$("#container .search input[name='page_start_num']").val(param_page_num);
		$("#container .search input[name='page_size']").val(param_page_size);
	}

	$(window).on('resize', function() {
		/* resize height for sort */
		var option_height = $('.sort_option').height();
		if($('#detail_list .inquiry').hasClass('expand')){
			$('#detail_list .list').css('top', option_height+'px');
		}else{
			$('#detail_list .list').removeAttr('style');
		}
		/* resize height for scroller */
		var table_height = $('#detail_list .list').height()-34;
		$('#detail_list .tablesorter-scroller-table').css('maxHeight',table_height);
		$("#detail_list .hms_table").css("width", $("#container").width());
	});
	
	$(document).on('mouseenter','#detail_list .hms_table td',function() { $(this).closest('tr').addClass('hover'); });
	$(document).on('mouseleave','#detail_list .hms_table td',function() { $(this).closest('tr').removeClass('hover'); });
	$(document).on('mouseenter', 'td.delete_record',function(e){ $(this).closest('tr').removeClass('hover'); e.stopPropagation(); });
	$(document).on('click', 'td.delete_record',function(e){ e.stopPropagation(); });
	
	/* sort 조건 눌렀을때 */
	$(document).on("click", "#detail_list .sort input:checkbox", function(){
		param_page_last=false; param_page_num = 0; $.when(fn_news_list()).then(function(){ fn_table_sorter(); });
	});
	
	function fn_table_sorter(){
		var table_height = $('#detail_list .list').height()-34;
		
		$('#detail_list .tablesorter').trigger('sortReset');
		$("#detail_list .tablesorter").tablesorter({
			headers : { 
				'.delete_record, .edit_record' : {sorter:false}
			},
			widgets: [ 'scroller' ],
			widgetOptions : {
				scroller_height : table_height,
				scroller_upAfterSort: true,
				scroller_jumpToHeader: true,
				scroller_rowHighlight : 'hover',
				scroller_barWidth : null
			}
		});

		var option_height = $('.sort_option').height();
		if($('#detail_list .inquiry').hasClass('expand')){
			$('#detail_list .list').css('top', option_height+'px');
		}else{
			$('#detail_list .list').removeAttr('style');
		}
		$("#detail_list .hms_table").css("width", $("#container").width());
		
		// 스크롤했을때 param_page_num 추가해서 append 한다. 
		$("#detail_list .hms_table .tablesorter-scroller-table").scroll(function(){ 
			if($(this).scrollTop() >= ($(this).find(".tablesorter").height() - $(this).height())){
				if(param_page_last == false){
					++param_page_num; 
					$.when(fn_news_list()).then(function(){ fn_table_sorter(); });
				}
			}
		});
	}
	
	function fn_news_list(){
		var no_data = "<tr><td colspan='8' class='nodata' data-guide='No data available!'></td></tr>";
		fn_default_set();
		
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/news/list", "json", false, "POST", search.get_parameter("container")));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var insert_table_data = "";
			if(obj_data.length == 0){ 
				param_page_last = true; 
				if(param_page_num == 0){ $("#container #detail_list .list .hms_table .tablesorter tbody").empty().append(no_data); }
				$("#container #detail_list .list .hms_table .tablesorter tbody").append(insert_table_data);
			}else{
				for(var i=0; i < obj_data.length; i++){
					var status_nm = (obj_data[i]["use_status"] == 1)? "게시중" : (obj_data[i]["use_status"] == 2)? "게시예정": "게시종료" ;  
					var class_nm = (obj_data[i]["use_status"] == 1)? "green" : (obj_data[i]["use_status"] == 2)? "yellow": "gray" ;  
					var delete_btn_status = (obj_data[i]["use_status"] == 2 ) ? "" : "disabled";
					var notice_type = (obj_data[i]["notice_type"] == 1) ? "JLS소식" : "분원소식" ;
					/* insert_table_data += "<tr seq='"+ obj_data[i]["notice_seq"] +"' cseq='"+ obj_data[i]["notice_content_seq"] +"'    >"; */ 
					insert_table_data += "<tr seq='"+ obj_data[i]["notice_seq"] +"' cseq='"+ obj_data[i]["notice_content_seq"] +"' deptNm='"+ obj_data[i]["dept_nm"] +"' orgRegTs='"+ obj_data[i]["org_reg_ts"] +"' >";
					insert_table_data += "<td class='newstype_record'>"+ notice_type +"</td>";
					insert_table_data += "<td class='branch_record left'>"+ obj_data[i]["dept_nm"] +"</td>";
					insert_table_data += "<td class='title_record left'>"+ obj_data[i]["title"] +"</td>";
					insert_table_data += "<td class='status_record'><span class='status "+ class_nm +"' title='"+ status_nm +"'>"+ status_nm +"</span></td>";
					insert_table_data += "<td class='author_record'>"+ obj_data[i]["reg_user_nm"] +"</td>";
					insert_table_data += "<td class='date_record'>"+ common_date.convertType(obj_data[i]["reg_ts"],8) +"</td>";
					insert_table_data += "<td class='period_record'><span class='start_date'>"+ common_date.convertType(obj_data[i]["start_dt"],8) +"</span>~<span class='end_date'>"+ common_date.convertType(obj_data[i]["end_dt"],8) +"</span></td>";
					insert_table_data += "<td class='count_record'>"+ obj_data[i]["view_cnt"] +"</td>";
					
					// 게시예정인것만 삭제할수 있다(날짜를 과거날짜로 바꿔서 저장) 
					insert_table_data += "<td class='delete_record'><button title='Delete' class='icon delete' "+ delete_btn_status +"><span>Delete</span></button></td>";
					insert_table_data += "</tr>";
				}
				if(param_page_num == 0){ $("#container #detail_list .list .hms_table .tablesorter tbody").empty(); }
				$("#container #detail_list .list .hms_table .tablesorter tbody").append(insert_table_data);
				if(obj_data.length < param_page_size){ param_page_last = true; }
			}
		}else{
			$("#container #detail_list .list .hms_table .tablesorter tbody").empty().append(no_data);
		}
		$("#container #detail_list .list .hms_table .tablesorter").trigger("update");

	}
	
	function fn_list_delete_yes(param_rtn_value){
		;
		var cseq = param_rtn_value.split(",")[0];
		var deqtNm = param_rtn_value.split(",")[1];
		var obj_tag_result = JSON.parse(common_ajax.inter("/service/v2/news/del/"+ cseq +"/" + deqtNm , "json", false, "DELETE", ""));
		if(obj_tag_result.header.isSuccessful == true){ fn_news_list(); }
	}
	
	/* 게시물 추가 > 레이어 오픈  */ 
	function fn_new_post_open(){
		
		$('.edit_news').children().remove();
		$('.edit_news').append('<div id="paper_editor"></div>');
		
		fn_popup_editor_quill();
		editorType = 'quill';
		
		$("#container .tit_area button").prop("disabled", true);
		$('#detail_list tbody tr').removeClass('selected');
		$('#container').addClass('expand');
		$('#detail_info').addClass('new');
		$("#thumbnail_btn").prop('disabled', false);
		
		$("#detail_info input[name='news_seq']").val("");
		$("#detail_info .viewbar select[name='notice_type']").select2({ minimumResultsForSearch: 20, width:'100px', dropdownAutoWidth: 'true' });
		
		if(param_emp_type == 'S'){
			/* layer.get_dept_news_list("detail_info"); */
			$("#detail_info .viewbar select[name='inup_dept_1']").trigger('change');
		}else{
			var param_emp_dept_list_sp = param_emp_dept_list.split(",");
			var param_dept_input = "";
			for(var i=0; i < param_emp_dept_list_sp.length; i++){ param_dept_input += "<option value='"+ param_emp_dept_list_sp[i].split(":")[0] +"'>"+ param_emp_dept_list_sp[i].split(":")[1] +"</option>"; }
			
			$("#detail_info .viewbar select[name='inup_dept_1']").empty().append(param_dept_input).select2({ minimumResultsForSearch: 20, width:'100px', dropdownAutoWidth: 'true' });
			$("#detail_info .viewbar select[name='inup_dept_1']").trigger('change');
			$("#detail_info .viewbar select[name='inup_dept_2']").empty().hide();
			if($("#detail_info .viewbar select[name='inup_dept_2']").hasClass("select2-hidden-accessible")){ $("#detail_info .viewbar select[name='inup_dept_2']").select2('destroy'); }
		}
		$('#detail_info .page .form_table input, #detail_info .page .form_table textarea').not(":radio, :checkbox").val("");

		// 날짜관련 
		var start_date = moment(now_year_date);
		var end_date = moment(common_date.monthAdd(common_date.convertType(now_year_date,4), 12));
		$("#detail_info .page .contents .daterange").daterangepicker({
			startDate: start_date,
			endDate: end_date,
			ranges: {
				'Today': [moment(), moment()],
				'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
				'Last 7 Days': [moment().subtract(6, 'days'), moment()],
				'Last 30 Days': [moment().subtract(29, 'days'), moment()],
				'This Month': [moment().startOf('month'), moment().endOf('month')],
				'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
			},
			locale: { format: 'YYYY.MM.DD' },
			alwaysShowCalendars: true
		}, function(start, end, label) { console.log('New date range selected: ' + start.format('YYYY.MM.DD') + ' to ' + end.format('YYYY.MM.DD') + ' (predefined range: ' + label + ')'); });
		
		search.get_tag_box_list("detail_info", "");
		$("#detail_info .contents .thumb img").attr("src", "");
		
		$('#paper_editor .ql-editor').empty();
		//$("#detail_info .viewbar select[name='notice_type']").select2("val", "1");
		$("#detail_info .viewbar input[name='news_seq'], #detail_info .viewbar select[name='news_content_seq']").val("");
		
		
		
		var param_dept_nm = $("#detail_info select[name='inup_dept_1'] option:selected").text();
		if ( param_dept_nm == '학교'){
			$("#thumbnail_btn").prop('disabled', true);
		}
		
		/* button */
		$("#detail_info .page .create_btn button.save").hide();
		$("#detail_info .page .create_btn button.create").show();
		
		
		var param_dept_nm = $("#detail_info select[name='inup_dept_1'] option:selected").text();
		
		
		fn_popup_editor_modi();
	}

	$(document).on("change", "#detail_info .viewbar select[name='inup_dept_1']", function(){ /* 레이어 오픈 > 분원선택 */ 
		if(param_emp_type == 'S'){
			$("#detail_info .viewbar select[name='notice_type']").attr("disabled", true);
			layer.get_dept_sub_list("detail_info", $(this).find(":selected").val());
			$("#detail_info .viewbar select[name='notice_type']").select2("val", "1");
		}else{
			console.log(">>>> event");
			$("#detail_info .viewbar select[name='notice_type']").attr("disabled", true);
			$("#detail_info .viewbar select[name='notice_type']").select2("val", "2");
		}
	});

	$(document).on('click','#detail_info button.cancel, #detail_info .close_detail',function() {
		$("#container .tit_area button").prop("disabled", false);
		$('#detail_list .hms_table tr').removeClass('selected');
		$('#detail_info').removeClass('new');
		$('#container').removeClass('expand');
		
		resize_sorth();
		//resize_tablesorter();
	});
	
	/* 게시물 수정 > 레이어 오픈 */ 
	$(document).on('click','#detail_list .hms_table tbody tr', function() {
		if($(this).find("td.nodata").length == 0){
			
			$('.edit_news').children().remove();
			$('.edit_news').append('<div id="paper_editor"></div>');
			
			var orgRegTs = $(this).attr("orgRegTs");
			$("#container .tit_area button").prop("disabled", true);
			$("#detail_info .viewbar select[name='notice_type']").prop('disabled', false);
			$("#thumbnail_btn").prop('disabled', false);
			
			if($(this).hasClass('selected')){
				$(this).toggleClass('selected');
				$('#container').toggleClass('expand');
				$("#container .tit_area button").prop("disabled", false);
				$("#thumbnail_btn").prop('disabled', false);
			} else{
				$(this).closest('tbody').find('tr').removeClass('selected');
				$(this).addClass('selected');
				$('#container').addClass('expand');
				
				$('#detail_info .page .form_table input, #detail_info .page .form_table textarea').not(":radio, :checkbox").val("");
				
				
				//$('#paper_editor .ql-editor').empty();
				
				$("#detail_info .contents .thumb img").attr("src", "");
				$("#detail_info .page .create_btn button.save").show();
				$("#detail_info .page .create_btn button.create").hide();
				
				/* 타입 입력하고 내용/링크 등등 가지고 온다. */
				$("#detail_info .viewbar input[name='news_seq']").val($(this).attr("seq"));
				$("#detail_info .viewbar input[name='news_content_seq']").val($(this).attr("cseq"));
				
				/*학교는 썸네일 비활성*/
				if ( $(this).attr("deptNm") == '학교'){ 
					$("#thumbnail_btn").prop('disabled', true); 
				}
				
				var obj_result = JSON.parse(common_ajax.inter("/service/v2/news/view/"+ $(this).attr("seq") +"/"+ $(this).attr("cseq") +"/"+ $(this).attr("deptNm"), "json", false, "GET", ""));
				if(obj_result.header.isSuccessful == true){
					var obj_data = JSON.parse(obj_result.data);
					
					obj_data[0]["editor_txt"] = obj_data[0]["editor_txt"].replace("<div style='width:100%;text-align:left;'>", "");
					obj_data[0]["editor_txt"] = obj_data[0]["editor_txt"].replace("</div>", "");
					if ( obj_data[0]["editor_txt"].indexOf('ops') == 2){
						editorType = 'quill';
						fn_popup_editor_quill();
						var editorData = obj_data[0]["editor_txt"];
						editorData = editorData.replace("<div style='width:100%;text-align:left;'>", "");
						editorData = editorData.replace('<div style="width:100%;text-align:left;">', '');
						editorData = editorData.replace('</div>', '');
						var editorJson = JSON.parse(editorData) 
	        			quill.setContents(editorJson, 'silent');
					}else{
						editorType = 'summernote';
						$('#paper_editor').summernote('code', "");
						fn_popup_editor_summernote();
						$('#paper_editor').summernote('code', obj_data[0]["editor_txt"]);
					}
        
					$("#detail_info .viewbar select[name='notice_type']").select2({ minimumResultsForSearch: 20, width:'100px', dropdownAutoWidth: 'true' }).select2("val", ""+ obj_data[0]["notice_type"]);
					$("#detail_info .viewbar select[name='notice_type']").prop('disabled', true);
					$("#detail_info select[name='inup_dept_1']").empty().append("<option value='"+ obj_data[0]["dept_seq"] +"'>"+ obj_data[0]["dept_nm"] +"</option>").select2({ minimumResultsForSearch: 20, width:'100px', dropdownAutoWidth: 'true' });
					$("#detail_info select[name='inup_dept_2']").empty().hide();
					if($("#detail_info .viewbar select[name='inup_dept_2']").hasClass("select2-hidden-accessible")){ $("#detail_info .viewbar select[name='inup_dept_2']").select2('destroy'); }
					$("#detail_info input[name='title']").val(obj_data[0]["title"]);
					$("#detail_info .contents .thumb img").attr("src", obj_data[0]["news_img_thumb"]);
					$("#detail_info textarea").val(obj_data[0]["preview_txt"]);
					var start_date = moment(obj_data[0]["start_dt"]);
					var end_date = moment(obj_data[0]["end_dt"]);
					$("#detail_info .page .contents .daterange").daterangepicker({
						startDate: start_date,
						endDate: end_date,
						ranges: {
							'Today': [moment(), moment()],
							'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
							'Last 7 Days': [moment().subtract(6, 'days'), moment()],
							'Last 30 Days': [moment().subtract(29, 'days'), moment()],
							'This Month': [moment().startOf('month'), moment().endOf('month')],
							'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
						},
						locale: { format: 'YYYY.MM.DD' },
						alwaysShowCalendars: true
					}, function(start, end, label) { console.log('New date range selected: ' + start.format('YYYY.MM.DD') + ' to ' + end.format('YYYY.MM.DD') + ' (predefined range: ' + label + ')'); });
					
					if(obj_data[0]["notice_type"] == 1 && param_emp_type == 'B'){ $("#detail_info .page .create_btn button.save").hide(); }
					
				}
				
				var obj_tag_result = JSON.parse(common_ajax.inter("/service/v2/tag/view/"+ $(this).attr("cseq") +"/"+ $(this).attr("deptNm") , "json", false, "GET", ""));
				if(obj_tag_result.header.isSuccessful == true){ search.get_tag_box_list("detail_info", obj_tag_result.data); }
				fn_popup_editor_modi();
			}
		}
	});	
</script>

<div id="container" class="main">
	<div class="tit_area">
		<h3>JLS News</h3>
		<div class="search">
			<div class="items">
				<input type="hidden" name="page_start_num" />
				<input type="hidden" name="page_size" />
				
				<select name="search_dept_1"></select>
				<select name="search_dept_2"></select>
			</div>
			<div class="items">
				<label class="period"><input type="text" name="search_date" class="daterange" value="" style="width:190px;" readonly /><span></span></label>
			</div>
			<div class="search_box">
				<input type="text" name="search_context" placeholder="Title text" />
				<input type="button" class="search_btn" />
			</div>
		</div>
		<button type="button" class="black new" onclick="fn_new_post_open()"><span>New Post</span></button>
		<c:if test="${cookieEmpType == 'S'}">
		<button type="button" class="setting" onclick="fn_tag_setting_open()"><span>Tag Setting</span></button>
		</c:if>
	</div>
	<div id="detail_list">
		<div class="sort_option">
			<div class="inquiry">
				<div class="more" title="Detail Inquiry"><span>Detail Inquiry</span></div>
				<div class="sort first">
					<h5>News Type</h5>
					<label><input type="checkbox" name="search_type" value="1" /> <span>JLS소식</span></label>
					<label><input type="checkbox" name="search_type" value="2" /> <span>분원소식</span></label>
					<h5>Status</h5>
					<label><input type="checkbox" name="search_status" value="1" checked/> <span>게시중</span></label>
					<label><input type="checkbox" name="search_status" value="2" checked/> <span>게시예정</span></label>
					<label><input type="checkbox" name="search_status" value="99,0" /> <span>게시종료</span></label>
				</div>
				<div class="sort" id="tag_list"></div>
			</div>
		</div>
		<div class="list">
			<div class="hms_table">
				<table class="tablesorter">
					<colgroup>
						<col style="width:8%;">
						<col style="width:8%;">
						<col style="width:35%">
						<col style="width:9%;">
						<col style="width:9%;">
						<col style="width:9%;">
						<col style="width:15%;">
						<col style="width:7%;">
						<col style="width:35px;">
					</colgroup>
					<thead>
						<tr>
							<th class="newstype_record">News Type</th>
							<th class="branch_record">Branch Type</th>
							<th class="title_record">Title</th>
							<th class="status_record">Status</th>
							<th class="author_record">Author</th>
							<th class="date_record">Issue Date</th>
							<th class="period_record">Period</th>
							<th class="count_record">Count</th>
							<th class="delete_record"></th>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
		</div>
	</div>
	
	<div id="cts"></div>
	<script type="text/javascript">
	/* 오픈될때 에디터 기능 오픈 */
	function fn_popup_editor_summernote(){
		$('#paper_editor').summernote({
			lang: 'ko-KR',
			fontNamesIgnoreCheck : ['Nanum Gothic'],
			toolbar: [
			    ['style', ['fontname', 'bold', 'italic', 'underline', 'clear']],
			    ['font', ['strikethrough', 'superscript', 'subscript']],
			    ['fontsize', ['fontsize']],
			    ['color', ['color']],
			    ['para', ['hr','ul', 'ol', 'paragraph']],
			    ['height', ['height']],
			    ['insert', ['picture', 'video', 'link', 'table','codeview']]
			],
			popover : {
				image : [
					['custom', ['imageAttributes']],
					['imagesize', ['imageSize100', 'imageSize50', 'imageSize25']],
					['float', ['floatLeft', 'floatRight', 'floatNone']],
					['remove', ['removeMedia']]
				]
			},
			imageAttributes:{
	            imageDialogLayout:'default', // default|horizontal
	            icon:'<i class="note-icon-pencil"/>',
	            removeEmpty:false // true = remove attributes | false = leave empty if present
	        },
	        displayFields:{
	            imageBasic:true,  // show/hide Title, Source, Alt fields
	            imageExtra:true, // show/hide Alt, Class, Style, Role fields
	            linkBasic:true,   // show/hide URL and Target fields for link
	            linkExtra:false   // show/hide Class, Rel, Role fields for link
	        },
			dialogsInBody: true,
			shortcuts: true,
			height: "450px", 
			disableResizeEditor: false, // 사이즈 조절바 (true / false)
			callbacks : {
				onImageUpload: function(files, editor, welEditable){ fn_editor_image_upload_summner(files[0], this); },
				onChange : function(){
					$(".note-editable iframe").each(function(){
						if($(this).parent().attr('class') != 'video-wrapper'){
							$(this).wrap("<div class='video-wrapper'></div>"); 
						}
					}); //비디오태그에 우리쪽 클래스명을 삽입해 준다. 
				}
			}
		}); 
	}
	
	function fn_popup_editor_quill(){
		 
		/* import QuillBetterTable  from 'modules/quill-better-table.js'
		import 'src/assets/quill-better-table.scss' */
		var Font = Quill.import('formats/font');
		Font.whitelist = ['nanumgothic', 'malgungothic', 'gulim', 'dotum'];
	    Quill.register({ 'modules/better-table': quillBetterTable }, true)  
		Quill.register(Font , true)  
		quill = new Quill('#paper_editor', {
			theme: 'snow',
		    modules: {
		    	 toolbar: [
		    		  [{ 'font': ['nanumgothic', 'malgungothic', 'gulim', 'dotum'] }, { 'size': [] }],
				      ['bold', 'italic', 'underline', 'strike'],
				      [{ 'script': 'sub'}, { 'script': 'super' }], 
				      [{ 'color': []}, { 'background': []}],   
				      [{ 'list': 'bullet' }, { 'list': 'ordered'},{ 'align': [] } ],
				      [ 'link', 'image', 'video', 'formula'],
				      ['table'] 
				    ],  
				    //toolbar: false,
		      table: false,  // disable table module
		         'better-table': {
			        operationMenu: {
			          items: {
			            unmergeCells: {
			              text: 'Another unmerge cells name'
			            }
			          }
			        }
			      },    
		      // keyboard: {
		      //  bindings: QuillBetterTable.keyboardBindings
		      //}
		    }
		  })
		
		quill.getModule('toolbar').addHandler('image',function(){
			fn_editor_image_upload_quill(quill);
		});
		quill.getModule('toolbar').addHandler('table',function(){
			Quill.register({
				  'modules/better-table': quillBetterTable,
				}, true) 
			var focus_bf = quill.focus();
			tableModule = quill.getModule('better-table')
			tableModule.insertTable(3, 3)
			console.log(quill.getSelection());
			var focus_af = quill.focus();
			console.log(focus_af); 
		});  
	
		if ( $('.qlbt-col-tool').length > 0 ) {
			$('.qlbt-col-tool').remove();
		}
	}
	
	/* 에디터에서 이미지 업로드 했을때 */
	function fn_editor_image_upload_summner(file, editor_id){
		var form_data = new FormData();
		form_data.append("files", file);
		form_data.append("banner_location", "");

		$.ajax({
			type : "POST"
			, processData : false
			, contentType : false
			, cache : false
			, data : form_data
			, url : "/lib/v2/upload/banner"
			, dataType : "json"
			, success : function(obj_result){
				var obj_data = JSON.parse(obj_result.data);
				$(editor_id).summernote('editor.insertImage', obj_data["file_url_domain"] + obj_data["file_full_path"]);
				 
			}
			, error : function(xhr, ajaxOpts, thrownErr){
				console.log(xhr +"/"+ ajaxOpts +"/"+ thrownErr );
				alert('warning', xhr +"/"+ ajaxOpts +"/"+ thrownErr);
			}
		});
	}
	
	function fn_editor_image_upload_quill(quill){
		
		const input = document.createElement('input');
		input.setAttribute('type', 'file');
		input.setAttribute('accept', 'image/*');
		input.click();
		
		input.onchange = function(){
			if(!/\.(jpeg|jpg|png|gif|bmp)$/i.test(this.value)){
				alert('이지미 파일만 등록 가능합니다');
				$(this).value = '';
				$(this).focus();
			}else{
				var form_data = new FormData();
				var file = $(this)[0].files[0];
				form_data.append("files", file);
				form_data.append("banner_location", "");
				$.ajax({
					type : "POST"
					, processData : false
					, contentType : false
					, cache : false
					, data : form_data
					, url : "/lib/v2/upload/banner"
					, dataType : "json"
					, success : function(obj_result){
						var obj_data = JSON.parse(obj_result.data);
						const range = quill.getSelection();
						quill.insertEmbed(range.index, 'image', obj_data["file_url_domain"] + obj_data["file_full_path"]);
					}
					, error : function(xhr, ajaxOpts, thrownErr){
						console.log(xhr +"/"+ ajaxOpts +"/"+ thrownErr );
						alert('warning', xhr +"/"+ ajaxOpts +"/"+ thrownErr);
					}
				});
			}
			
		}
	}
	
	function fn_popup_editor_modi(){
		$("#paper_editor .dropdown-fontname li a").removeClass("checked");
		$("#paper_editor .dropdown-fontname li:eq(0) a").addClass("checked");
		$("#paper_editor .note-current-fontname").text($(".dropdown-fontname li:eq(0) a").attr('data-value'));
	}
	
	/* 추가 및 수정 버튼 클릭시 */
	$(document).on("click", "#detail_info .create_btn .create, #detail_info .create_btn .save", function(){
		var inup_dept_1 = $("#detail_info select[name='inup_dept_1'] option:selected").val();
		var inup_dept_2 = $("#detail_info select[name='inup_dept_2'] option:selected").val();
		inup_dept_1 = (inup_dept_1 == undefined) ? "" : inup_dept_1;
		inup_dept_2 = (inup_dept_2 == undefined) ? "" : inup_dept_2;
		var param_dept_seq = (inup_dept_2 == "")? inup_dept_1 : inup_dept_2;
		var param_dept_nm = $("#detail_info select[name='inup_dept_1'] option:selected").text();
		
		var param_notice_type = $("#detail_info select[name='notice_type'] option:selected").val();
		var param_inup_type = ($("#detail_info").attr("class") == "new") ? "insert" : "update";
		var param_title = $("#detail_info .contents .form_table input[name='title']").val();
		var param_start_dt = common_date.convertType(common_date.dateToStr($("#detail_info .contents .form_table input[name='range_dt']").data("daterangepicker").startDate._d),4);
		
		var param_end_dt = common_date.convertType(common_date.dateToStr($("#detail_info .contents .form_table input[name='range_dt']").data("daterangepicker").endDate._d),4);
		
		var param_img_url = $("#detail_info .contents .thumb img").attr("src");
		var param_preview_txt = $("#detail_info .contents .form_table textarea[name='preview_text']").val();
		
		var param_editor_text = '';
		//var param_editor_text = $('#paper_editor').summernote('code');
		
		// quill
		if ( editorType == 'quill'){
      		param_editor_text = JSON.stringify(quill.getContents())
		}else{
			param_editor_text = $('#paper_editor').summernote('code');
			if(param_editor_text.substring(0,4) != "<div"){ param_editor_text = "<div style='width:100%;text-align:left;'>"+ param_editor_text +"</div>"; }
		}
		
		if(param_editor_text.indexOf("note-video-clip") > -1){ param_editor_text = param_editor_text; }
		var param_tag_list = $("#detail_info .contents .form_table select[name='select_tag']").select2("val");
		
		if(param_title == ""){ alert("제목을 입력해 주세요."); return; } 
		if(param_start_dt == ""){ alert("게시기간을 선택해 주세요."); return; } 
		if(param_editor_text == ""){ alert("내용을 입력해 주세요."); return; }
		if ( param_preview_txt.length > 150){
			alert('description은 150글자까지 입력 가능합니다');
			return;
		}
		if ( param_dept_nm != '학교'){
			if(param_tag_list.length == 0){ alert("태그를 선택해 주세요."); return; }
		}
		
		var param_obj = new Object();
		param_obj["param_inup_type"] = param_inup_type;
		param_obj["param_notice_type"] = param_notice_type;
		param_obj["param_dept_seq"] = param_dept_seq;
		param_obj["param_title"] = param_title;
		param_obj["param_start_dt"] = param_start_dt;
		param_obj["param_end_dt"] = param_end_dt;
		param_obj["param_preview_txt"] = param_preview_txt;
		param_obj["param_img_url"] = param_img_url;
		param_obj["param_editor_text"] = param_editor_text;
		param_obj["param_news_seq"] = $("#detail_info input[name='news_seq']").val();
		param_obj["param_news_content_seq"] = $("#detail_info input[name='news_content_seq']").val();
		param_obj["param_tag_list"] = param_tag_list;
		
		var obj_result = '';
		if ( param_dept_nm != '학교' ){
			obj_result = JSON.parse(common_ajax.inter("/service/v2/news/save", "json", false, "POST", param_obj));
		}else{
			
			/*var useYn = 0;
			var today = new Date();   
			var now_date =  moment(today).format('YYYY-MM-DD')
			if ( now_date < param_start_dt ){
				useYn = 2;
			}else if ( now_date < param_end_dt ){
				useYn = 1;
			} */
			param_obj["use_status"] = 1
			obj_result = JSON.parse(common_ajax.inter("/service/v2/news/chessplusSave", "json", false, "POST", param_obj));
		}
		
		if(obj_result.header.isSuccessful == true){
			alert("저장이 완료 되었습니다.");
			$("#detail_info button.cancel").trigger("click");
			fn_news_list();
		}else{
			alert(obj_result.header.resultMessage);
		}
	});
	
	
	
	/* 썸네일 받기 */
	function fn_popup_thumb_image_return(thumb_image_path){ $("#detail_info .contents .thumb img").attr("src", thumb_image_path); }
	
	</script>
	
	
	<div id="detail_info">
		<div class="viewbar">
			<input type="hidden" name="news_seq" />
			<input type="hidden" name="news_content_seq" />
			<h4><b>JLS News</b></h4>
			<div class="items">
				<select name="notice_type">
					<option value="1">JLS소식</option>
					<option value="2">분원소식</option>
				</select>
			</div>
			<div class="items"><select name="inup_dept_1"></select></div>
			<div class="items branch"><select name="inup_dept_2"></select></div>
			<div class="close_detail"></div>
		</div>
		<div class="page">
			<div class="contents">
				<div class="set_news">
					<div class="thumb">
						<img src="">
						<button type="button" class="select_type" onclick="fn_thumbnail_img_upload('news')"><span></span></button>
					</div>
					<ul class="form_table">
						<li>
							<div class="cell title"><input type="text" name="title" value="" placeholder="Please enter title" /></div>
							<div class="cell date">
								<span class="label">Period</span>
								<label class="period"><input type="text" name="range_dt" class="daterange" value="" style="width:180px;" readonly /><span></span></label>
							</div>
						</li>
						<li>
							<div class="cell tag"><select name="select_tag" style="width:100%;" multiple="multiple"></select></div>
						</li>
						<li><textarea name="preview_text" placeholder="Please enter description."></textarea></li>
					</ul>
				</div>
				<div class="edit_news"><div id="paper_editor"></div></div>
			</div>
			<div class="create_btn">
				<button type="button" class="small cancel"><span>Cancel</span></button>
				<button type="button" class="small yellow save"><span>Save</span></button>
				<button type="button" class="small blue create"><span>Create</span></button>
			</div>
		</div>
	</div>
	
</div>