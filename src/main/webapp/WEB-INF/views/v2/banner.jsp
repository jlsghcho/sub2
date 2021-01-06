<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script type="text/javascript">
	var now_year_date = "${serverDate}";
	var param_emp_type = "${cookieEmpType}";
	var param_emp_dept_list = "${cookieDeptList}";


	var param_abroad_seq = "<spring:eval expression="@globalContext['ABROAD_CODE']" />";
	var param_abroad_nm = "<spring:eval expression="@globalContext['ABROAD_NM']" />";
	
	var param_page_num ,param_page_size, param_page_last;
	
	$(document).ready(function() {
		param_page_num = 0;
		param_page_size = 30;
		param_page_last = false;
		
		if(param_emp_type == "S"){
			/* search.get_dept_list("container"); */
			get_banner_dept_list();
			$("#container .search select[name='search_dept_2']").hide();
			$("#container .search select[name='search_dept_1']").change(function(){ search.get_dept_sub_list("container", $(this).find(":selected").val(),param_emp_type); });
		}else{
			$("#container .search select[name='search_dept_1']").hide();
			search.get_dept_sub_list("container", param_emp_dept_list,param_emp_type);
		}
		$("#detail_info .page .contents .daterange").daterangepicker();
		$.when(fn_banner_list()).then(function(){ fn_table_sorter(); });
		
		$("#container .search_box input[type='button']").click(function(){ 
			param_page_last=false; param_page_num = 0; $.when(fn_banner_list()).then(function(){ fn_table_sorter(); }); 
		}); // 검색 > 버튼 클릭시
		
		$("#detail_info .viewbar select[name='inup_dept_1']").change(function(){ 
			if(param_emp_type == 'S'){ layer.get_dept_sub_list("detail_info", $(this).find(":selected").val()); }
		});

		/* 추가 및 수정 레이어 > 취소/X 버튼 클릭시 */ 
		$("#detail_info button.cancel, #detail_info .close_detail").click(function(){ 
			$('#detail_list .hms_table tr').removeClass('selected');
			$('#container').removeClass('expand');
			$('#detail_info').removeClass('new');
			$('#detail_info .page .contents').removeClass().addClass('contents').attr("gt_code","");
			
			if($("#detail_info .viewbar select[name='inup_dept_2']").hasClass("select2-hidden-accessible")){
				$("#detail_info .viewbar select[name='inup_dept_2']").select2('destroy');
			}
			$("#container .tit_area button").prop("disabled", false);
		});
	});
	
	/* 검색박스에서 엔터시 조회되게끔 변경 */
	$(document).on("keypress", "#container .search_box input[name='search_context']", function(){
		param_page_last=false; param_page_num = 0; $.when(fn_banner_list()).then(function(){ fn_table_sorter(); }); 
	});
	
	/* 유학분원명단을 가지고 온다. 명단은 HardCoding Properties 참조 */
	function get_banner_dept_list(){
		var param_key = $("#container");
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/dept/banner", "json", false, "GET", ""));
		var select_dept_side_list ;
		
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var select_dept_top_list = '';
			if ( obj_data.length == 3){
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
	
	
	/* 추가 배너 레이어 오픈 */
	$(document).on("click", "#container .tit_area button", function(){
		$(this).prop("disabled", true);
		$('#detail_list tbody tr').removeClass('selected');
		$('#container').addClass('expand');
		$('#detail_info').addClass('new');
		
		$("#detail_info input[name='banner_seq']").val("");
		if(param_emp_type == 'S'){
			/* layer.get_dept_list("detail_info"); */
			$("#detail_info .viewbar select[name='inup_dept_1']").trigger('change');
		}else{
			var param_emp_dept_list_sp = param_emp_dept_list.split(",");
			var param_dept_input = "";
			for(var i=0; i < param_emp_dept_list_sp.length; i++){ param_dept_input += "<option value='"+ param_emp_dept_list_sp[i].split(":")[0] +"'>"+ param_emp_dept_list_sp[i].split(":")[1] +"</option>"; }
			
			$("#detail_info select[name='inup_dept_1']").empty().append(param_dept_input).select2({ minimumResultsForSearch: 20, width:'100px', dropdownAutoWidth: 'true' });
			$("#detail_info select[name='inup_dept_2']").empty().hide();
			if($("#detail_info .viewbar select[name='inup_dept_2']").hasClass("select2-hidden-accessible")){ $("#detail_info .viewbar select[name='inup_dept_2']").select2('destroy'); }
		}

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
		}, function(start, end, label) { console.log("New date range selected: " + start.format("YYYY.MM.DD") + " to " + end.format("YYYY.MM.DD") + " (predefined range: " + label + ")"); });		
		
		$('#detail_info .page .contents').removeClass().addClass('contents').addClass('none').attr("gt_code","");
		$('#detail_info .page .form_table input').not(":radio, :checkbox").val("").prop("disabled", false);
		$("#pop_banner_select_type .create_area input:radio[name='select_banner']:eq(0)").prop("checked", true);
		$('#detail_info .edit_banner .section').hide();
		$('#detail_info .edit_banner .text h4, #detail_info .edit_banner .text h5').text("");
		$('#detail_info .edit_banner .history h5').text("");
		$('#detail_info .edit_banner .hms_table tbody').empty();
		
		/* button */
		$("#detail_info .page .create_btn button.save").hide();
		$("#detail_info .page .create_btn button.create").show();
		
		/* 달력에 강제로 넣기 */
		$("input[name='range_dt']").val(common_date.convertType(now_year_date,8) +" - "+ common_date.convertType(common_date.monthAdd(common_date.convertType(now_year_date,4), 12),8));
	});	
	
	// 게시예정인 게시물 삭제버튼 클릭시 
	$(document).on("click", "#detail_list .hms_table button.icon.delete", function(){ 
		var param_rtn_value = $(this).closest("tr").attr("key");
		dialog.list_delete_confirm_btn($(this), "This item will be deleted. Are you sure?", fn_list_delete_yes, param_rtn_value); 
	});
	
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
		param_page_last=false; param_page_num = 0; $.when(fn_banner_list()).then(function(){ fn_table_sorter(); });
	});
	
	/* 배너 수정 레이어 오픈 */
	$(document).on('click','#detail_list .hms_table tbody tr', function() {
		if($(this).find("td.nodata").length == 0){
			$("#container .tit_area button").prop("disabled", true);
			$('#detail_info').removeClass('new');

			if($(this).hasClass('selected')){
				$(this).toggleClass('selected');
				$('#container').toggleClass('expand');
				$("#container .tit_area button").prop("disabled", false);
			} else{
				$(this).closest('tbody').find('tr').removeClass('selected');
				$(this).addClass('selected');
				$('#container').addClass('expand');

				$('#detail_info .page .contents').removeClass().addClass('contents').attr("gt_code","");
				$('#detail_info .page .form_table input').not(":radio, :checkbox").val("");
				$("#detail_info .page .create_btn button.save").show();
				$("#detail_info .page .create_btn button.create").hide();
				
				/* 타입 입력하고 내용/링크 등등 가지고 온다. */
				var param_banner_data = JSON.parse($(this).attr('json_code'));
				$("#detail_info input[name='banner_seq']").val(param_banner_data["banner_seq"]);
				$("#detail_info select[name='inup_dept_1']").empty().append("<option value='"+ param_banner_data["dept_seq"] +"'>"+ param_banner_data["dept_nm"] +"</option>").select2({ minimumResultsForSearch: 20, width:'100px', dropdownAutoWidth: 'true' });
				$("#detail_info select[name='inup_dept_2']").empty().hide();
				if($("#detail_info .viewbar select[name='inup_dept_2']").hasClass("select2-hidden-accessible")){
					$("#detail_info .viewbar select[name='inup_dept_2']").select2('destroy');
				}

				fn_layer_select_banner_type(param_banner_data["gt_banner_loc"]);
				$("#detail_info input[name='title']").val(param_banner_data["title"]);
				if(param_banner_data["gt_banner_loc"] == 'BN1005'){
					$('#detail_info .edit_banner .text h4').text(param_banner_data["title"].split("#")[0]);
					$('#detail_info .edit_banner .text h5').text(param_banner_data["title"].split("#")[1]);
				}
				$("#detail_info input[name='link_url']").val(param_banner_data["link_url"]);
				$("#detail_info .contents .form_table input[name='range_dt']").data('daterangepicker').setStartDate(common_date.strToDate(param_banner_data["start_dt"]));
				$("#detail_info .contents .form_table input[name='range_dt']").data('daterangepicker').setEndDate(common_date.strToDate(param_banner_data["end_dt"]));
				if(param_banner_data["gt_banner_loc"] == "BN1005"){ $("#detail_info .edit_banner .section:eq(1) img").attr("src", param_banner_data["banner_img_path"]); }else{ $("#detail_info .edit_banner .section:eq(0) img").attr("src", param_banner_data["banner_img_path"]); }
				if(param_banner_data["gt_banner_loc"] == "BN1004"){ $("#detail_info .edit_banner .section:eq(2) img").attr("src", param_banner_data["mobi_banner_img_path"]); }
				
				if(param_banner_data["banner_img_path"] == ""){ $("#detail_info .edit_banner .preview_img").css("display", "none");	}else{ $("#detail_info .edit_banner .preview_img").css("display", "block"); }
				
				$("#detail_info .edit_banner input:file").val("");
				$("#detail_info .contents .form_table :radio[name='banner_sort'][value='"+ param_banner_data["banner_sort"] +"']").prop("checked", true);
			}
		}
	});
	
	function fn_table_sorter(){
		var table_height = $('#detail_list .list').height()-34;
		
		$('#detail_list .hms_table .tablesorter').trigger('sortReset');
		$("#detail_list .hms_table .tablesorter").tablesorter({
			headers : { '.delete_record, .edit_record' : {sorter:false} },
			widgets: [ 'scroller' ],
			widgetOptions : {
				scroller_height : table_height,
				scroller_upAfterSort: true,
				scroller_jumpToHeader: true,
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
		$("#detail_list .tablesorter-scroller-table").scroll(function(){
			if($(this).scrollTop() >= ($(this).find(".tablesorter").height() - $(this).height())){
				if(param_page_last == false){
					++param_page_num; 
					$.when(fn_banner_list()).then(function(){ fn_table_sorter(); });
				}
			}
		});
	}
	
	function fn_banner_list(){
		var no_data = "<tr><td colspan='8' class='nodata' data-guide='No data available!'></td></tr>";
		fn_default_set();
		
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/banner/list", "json", false, "POST", search.get_parameter("container")));
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
					var sort_nm = (obj_data[i]["banner_sort"] == 1)? "first" : (obj_data[i]["banner_sort"] == 2)? "second" : "third";
					var title_before = (obj_data[i]["use_status"] < 99 ) ? "<span class='order "+ class_nm +" "+ sort_nm +"'></span>" : "";
					var delete_btn_status = (obj_data[i]["use_status"] == 2 ) ? "" : "disabled";
					
					insert_table_data += "<tr key='"+ obj_data[i]["banner_seq"] +"' json_code='"+ JSON.stringify(obj_data[i]) +"'>";
					insert_table_data += "<td class='branch_record left'>"+ obj_data[i]["dept_nm"] +"</td>";
					insert_table_data += "<td class='btype_record'>"+ obj_data[i]["gt_banner_loc_nm"] +"</td>";
					insert_table_data += "<td class='title_record left'>"+ title_before + obj_data[i]["title"] +"</td>";
					insert_table_data += "<td class='status_record'><span class='status "+ class_nm +"' title='"+ status_nm +"'>"+ status_nm +"</span></td>";
					insert_table_data += "<td class='author_record'>"+ obj_data[i]["reg_user_nm"] +"</td>";
					insert_table_data += "<td class='date_record'>"+ common_date.convertType(obj_data[i]["reg_ts"],8) +"</td>";
					insert_table_data += "<td class='period_record'><span class='start_date'>"+ common_date.convertType(obj_data[i]["start_dt"],8) +"</span>~<span class='end_date'>"+ common_date.convertType(obj_data[i]["end_dt"],8) +"</span></td>";
					
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
	
	/* List Delete (일단 게시예정 인것만) */
	function fn_list_delete_yes(param_rtn_value){
		if(param_rtn_value != ""){
			var obj_result = JSON.parse(common_ajax.inter("/service/v2/banner/delete/"+ param_rtn_value, "json", false, "GET", ""));
			if(obj_result.header.isSuccessful == true){
				alert("삭제가 완료 되었습니다.");
				fn_banner_list();
			}else{
				alert(obj_result.header.resultMessage);
			}
		}
	}
</script>

<div id="container" class="main">
	<div class="tit_area">
		<h3>Banner Setting</h3>
		<div class="search">
			<div class="items">
				<input type="hidden" name="page_start_num" />
				<input type="hidden" name="page_size" />
				
				<select name="search_dept_1"></select>
				<select name="search_dept_2"></select>
			</div>
			<div class="search_box">
				<input type="text" name="search_context" placeholder="Title text" />
				<input type="button" class="search_btn" />
			</div>
		</div>
		<button type="button" class="black new"><span>New Banner</span></button>
	</div>
	<div id="detail_list">
		<div class="sort_option">
			<div class="inquiry group expand">
				<div class="sort first">
					<h5>Type</h5>
					<c:if test="${cookieEmpType eq 'S'}">
					<label><input type="checkbox" name="search_type" value="BN1001" /> <span>상단배너롤링</span></label>
					<label><input type="checkbox" name="search_type" value="BN1002" /> <span>상단배너고정</span></label>
					<label><input type="checkbox" name="search_type" value="BN1004" /> <span>탑배너고정</span></label>
					</c:if>
					<label><input type="checkbox" name="search_type" value="BN1005" /> <span>바로가기배너</span></label>
					<h5>Status</h5>
					<label><input type="checkbox" name="search_status" value="1" checked/> <span>게시중</span></label>
					<label><input type="checkbox" name="search_status" value="2" checked/> <span>게시예정</span></label>
					<label><input type="checkbox" name="search_status" value="99" /> <span>게시종료</span></label>
				</div>
			</div>
		</div>
		<div class="list">
			<div class="hms_table">
				<table class="tablesorter">
					<colgroup>
						<col style="width:10%;">
						<col style="width:10%;">
						<col style="width:35%">
						<col style="width:10%;">
						<col style="width:10%;">
						<col style="width:10%;">
						<col style="width:15%;">
						<col style="width:35px;">
					</colgroup>
					<thead>
						<tr>
							<th class="branch_record">Branch</th>
							<th class="btype_record">Banner Type</th>
							<th class="title_record">Title</th>
							<th class="status_record">Status</th>
							<th class="author_record">Author</th>
							<th class="date_record">Issue Date</th>
							<th class="period_record">Period</th>
							<th class="delete_record"></th>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
		</div>
	</div>
	
	<script type="text/javascript">
	/* New & Mod Layer Script */
	$(document).on("click", "#detail_info button.select_type", function(){
		$('body').addClass('noscroll');
		$('#pop_banner_select_type, .black_bg').fadeIn();
		$('#pop_banner_select_type').center();
		$('#pop_banner_select_type').draggable({ handle: ".header" });
		
		var inup_dept_1 = $("#detail_info select[name='inup_dept_1'] option:selected").val();
		if(inup_dept_1 == "130"){
			$("#pop_banner_select_type .create_area .uniform").addClass("math");
			$("#pop_banner_select_type .create_area label:eq(2)").hide(); 
		}else{ 
			$("#pop_banner_select_type .create_area .uniform").removeClass("math");
			$("#pop_banner_select_type .create_area label:eq(2)").show(); 
		}

		var gt_code = $('#detail_info .page div:eq(0)').attr('gt_code');
		if(gt_code != undefined){ $("#pop_banner_select_type .create_area .uniform :radio[name='select_banner']").each(function() { if(this.value == gt_code){ this.checked = true; }}); }
	});
	
	$(document).on("change", "#detail_info :radio[name='banner_sort']", function(){
		if($("#detail_info .contents").attr("gt_code") == "BN1005"){
			var class_color = $(this).val();
			if(class_color == "1"){ $("#detail_info .edit_banner .section:eq(1) ul li").removeClass().addClass("red"); }
			else if(class_color == "2"){ $("#detail_info .edit_banner .section:eq(1) ul li").removeClass().addClass("green"); }
			else { $("#detail_info .edit_banner .section:eq(1) ul li").removeClass().addClass("blue"); }
		}
	});
	
	$(document).on("change", "#detail_info select[name='inup_dept_1'], #detail_info select[name='inup_dept_2']", function(){
		var gt_code = $("#detail_info .contents").attr("gt_code");
		if(gt_code == "" || gt_code == undefined){  } else {
			if($(this).attr("name") == "inup_dept_1"){ fn_layer_select_banner_type(gt_code); }
			fn_layer_select_banner_list(gt_code); 
		}
	});
	
	$(document).on("keypress", "#detail_info .contents .form_table input", function(){ if($(this).val().length > 0){ $("#detail_info .create_btn .create").prop("disabled", false); } });
	
	/* BN1005 일때 타이틀쪽에 내용 넣기 */
	$(document).on("keypress", "#detail_info .contents .module h5, #detail_info .contents .module h4", function(){
		var param_title = ($("#detail_info .contents .module h4").text().length > 0) ? $("#detail_info .contents .module h4").text() : "";
		param_title += ($("#detail_info .contents .module h5").text().length > 0) ? (param_title != "")? "#"+ $("#detail_info .contents .module h5").text() : $("#detail_info .contents .module h5").text() : "";
		$("#detail_info .contents .form_table input[name='title']").val(param_title);
	});
	
	/* 추가 및 수정 버튼 클릭시 */
	$(document).on("click", "#detail_info .create_btn .create, #detail_info .create_btn .save", function(){
		var inup_dept_1 = $("#detail_info select[name='inup_dept_1'] option:selected").val();
		var inup_dept_2 = $("#detail_info select[name='inup_dept_2'] option:selected").val();
		inup_dept_1 = (inup_dept_1 == undefined) ? "" : inup_dept_1;
		inup_dept_2 = (inup_dept_2 == undefined) ? "" : inup_dept_2;
		var param_dept_seq = (inup_dept_2 == "")? inup_dept_1 : inup_dept_2;
			
		var param_inup_type = ($("#detail_info").attr("class") == "new") ? "insert" : "update";
		var param_gt_code = $("#detail_info .contents").attr("gt_code");
		var param_title = $("#detail_info .contents .form_table input[name='title']").val();
		var param_link_url = $("#detail_info .contents .form_table input[name='link_url']").val();
		var param_link_target_fl = $("#detail_info .contents .form_table :checkbox[name='link_target_fl']").is(":checked");
		var param_banner_sort = $("#detail_info .contents .form_table :radio[name='banner_sort']:checked").val();
		var param_start_dt = common_date.dateToStr($("#detail_info .contents .form_table input[name='range_dt']").data("daterangepicker").startDate._d);
		var param_end_dt = common_date.dateToStr($("#detail_info .contents .form_table input[name='range_dt']").data("daterangepicker").endDate._d);
		var param_img_url = (param_gt_code == "BN1005") ? $("#detail_info .edit_banner .section:eq(1) img").attr("src") : $("#detail_info .edit_banner .section:eq(0) img").attr("src");
		var param_mobi_img_url = (param_gt_code == "BN1004") ? $("#detail_info .edit_banner .section:eq(2) img").attr("src") : "" ;
		
		if(param_gt_code == "BN1005"){
			param_title = ($("#detail_info .contents .module h4").text().length > 0) ? $("#detail_info .contents .module h4").text() : "";
			param_title += ($("#detail_info .contents .module h5").text().length > 0) ? (param_title != "")? "#"+ $("#detail_info .contents .module h5").text() : $("#detail_info .contents .module h5").text() : "";
			$("#detail_info .contents .form_table input[name='title']").val(param_title);
		}
		
		if(param_gt_code == ""){ alert("배너 타입을 선택해 주세요."); return; } 
		if(param_title == ""){ alert("배너 제목을 입력해 주세요."); return; } 
		if(param_link_url == ""){ alert("배너 링크를 입력해 주세요."); return; } 
		if(param_start_dt == ""){ alert("게시기간을 선택해 주세요."); return; } 
		if(param_img_url == ""){ alert("배너를 입력해 주세요."); return; } 
		if(param_mobi_img_url == "" && param_gt_code == "BN1004"){ alert("모바일용 배너를 입력해 주세요."); return; } 
		
		var param_google_code = lib.google_code(inup_dept_1, param_gt_code, param_banner_sort);
		var param_sort_gt_code = lib.gt_code(param_gt_code, param_banner_sort);
		
		var param_obj = new Object();
		param_obj["param_dept_seq"] = param_dept_seq;
		param_obj["param_inup_type"] = param_inup_type;
		param_obj["param_gt_code"] = param_gt_code;
		param_obj["param_title"] = param_title;
		param_obj["param_link_url"] = param_link_url;
		param_obj["param_link_target_fl"] = param_link_target_fl;
		param_obj["param_banner_sort"] = param_banner_sort;
		param_obj["param_start_dt"] = param_start_dt;
		param_obj["param_end_dt"] = param_end_dt;
		param_obj["param_img_url"] = param_img_url;
		param_obj["param_mobi_img_url"] = param_mobi_img_url;
		param_obj["param_google_code"] = param_google_code;
		param_obj["param_sort_gt_code"] = param_sort_gt_code;
		param_obj["param_banner_seq"] = $("#detail_info input[name='banner_seq']").val();

		var obj_result = JSON.parse(common_ajax.inter("/service/v2/banner/save", "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			alert("저장이 완료 되었습니다.");
			$("#detail_info button.cancel").trigger("click");
			fn_banner_list();
		}else{
			alert(obj_result.header.resultMessage);
		}
	});

	function fn_layer_select_banner_type(param_type){
		console.log(">>>"+param_type );
		var param_layer = $("#detail_info");
		var param_dept_seq = param_layer.find("select[name='inup_dept_1'] option:selected").val();
		var param_dept_class = (param_dept_seq == "120") ? "english" : (param_dept_seq == "130") ? "math" : "abroad";
		
		param_layer.find(".page").removeClass().addClass("page").addClass(param_dept_class);

		param_layer.find(".edit_banner section").removeClass().addClass("section");
		param_layer.find(".edit_banner .section:eq(0)").show();
		param_layer.find(".edit_banner hr, .edit_banner .section:eq(1), .edit_banner .section:eq(2)").hide();
		param_layer.find("ul.form_table>li input[name='title']").prop("disabled", false);

		if (param_type == "BN1004") { //탑배너고정 BN1004
			param_layer.find(".contents").removeClass().addClass("contents").addClass("top_fixed"); 
			param_layer.find(".contents .form_table .order").hide();
			param_layer.find(".contents").attr("gt_code", "BN1004");
			
			param_layer.find(".edit_banner .section:eq(0)").addClass("pc");
			param_layer.find(".edit_banner .section:eq(2)").addClass("mobile");
			param_layer.find(".edit_banner hr, .edit_banner .section:eq(2)").show();
			
			param_layer.find(".edit_banner .section:eq(0) .top_info h5").text("탑배너고정 PC용 (1920 X 90)");
			param_layer.find(".edit_banner .section:eq(0) .top_info .use_info").empty().append("<span class='icon_pc' title='PC'></span>");
			param_layer.find(".edit_banner .section:eq(2) .top_info h5").text("탑배너고정 Mobile용 (750 X 140)");
			param_layer.find(".edit_banner .section:eq(2) .top_info .use_info").empty().append("<span class='icon_mobile' title='mobile'></span>");
			param_layer.find(".edit_banner .history h5").text("탑배너고정 게재 현황");
			
		} else if (param_type == "BN1001") { //상단배너롤링 BN1001
			param_layer.find(".contents").removeClass().addClass("contents").addClass("main_rolling");
			param_layer.find(".contents .form_table .order").show();
			param_layer.find(".contents").attr("gt_code", "BN1001");
			
			if(param_dept_seq == "120"){
				param_layer.find(".edit_banner .section:eq(0) .top_info h5").text("상단배너롤링 (760 X 400)");
			}else{
				param_layer.find(".edit_banner .section:eq(0) .top_info h5").text("상단배너롤링 (1920 X 520)");
			}
			param_layer.find(".edit_banner .section:eq(0)").addClass("pc");
			param_layer.find(".edit_banner .section:eq(0) .top_info .use_info").empty().append("<span class='icon_pc' title='PC'></span><span class='icon_mobile' title='mobile'></span>");
			param_layer.find(".edit_banner .history h5").text("상단배너롤링 게재 현황");
		} else if (param_type == "BN1002") { //상단배너고정 BN1002
			param_layer.find(".contents").removeClass().addClass("contents").addClass("main_fixed");
			param_layer.find(".contents .form_table .order").hide();
			param_layer.find(".contents").attr("gt_code", "BN1002");

			if(param_dept_seq == "150"){
				param_layer.find(".edit_banner .section:eq(0) .top_info h5").text("상단배너롤링 (300 X 400)");
			}else{
				param_layer.find(".edit_banner .section:eq(0) .top_info h5").text("상단배너고정 (480 X 200)");
			}
			param_layer.find(".edit_banner .section:eq(0)").addClass("pc");
			param_layer.find(".edit_banner .section:eq(0) .top_info .use_info").empty().append("<span class='icon_pc' title='PC'></span><span class='icon_mobile' title='mobile'></span>");
			param_layer.find(".edit_banner .history h5").text("상단배너고정 게재 현황");
		} else { //바로가기배너 BN1005
			param_layer.find(".contents").removeClass().addClass("contents").addClass("go_link");
			param_layer.find(".contents .form_table .order").show();
			param_layer.find(".contents").attr("gt_code", "BN1005");

			param_layer.find(".edit_banner hr, .edit_banner .section:eq(0), .edit_banner .section:eq(2)").hide();
			param_layer.find(".edit_banner .section:eq(1)").show();
			param_layer.find(".edit_banner .history h5").text("바로가기배너 게재 현황");
			
			var class_color = param_layer.find(":radio[name='banner_sort']:checked").val();
			if(class_color == "1"){ param_layer.find(".edit_banner .section:eq(1) ul li").removeClass().addClass("red"); }
			else if(class_color == "2"){ param_layer.find(".edit_banner .section:eq(1) ul li").removeClass().addClass("green"); }
			else { param_layer.find(".edit_banner .section:eq(1) ul li").removeClass().addClass("blue"); }
			
			param_layer.find("ul.form_table>li input[name='title']").prop("disabled", true);
		}
		fn_layer_select_banner_list(param_type);
		$("#detail_info .create_btn .create").prop("disabled", false);
		// image url reset 
		param_layer.find(".edit_banner .preview_img").css("display", "none");
		param_layer.find(".edit_banner img").attr("src", "");
		param_layer.find(".edit_banner input:file").val("");
	}
	
	function fn_layer_select_banner_list(param_type){
		var no_data = "<tr><td colspan='4' class='nodata' data-guide='No data available!'></td></tr>";
		
		var inup_dept_1 = $("#detail_info select[name='inup_dept_1'] option:selected").val();
		var inup_dept_2 = $("#detail_info select[name='inup_dept_2'] option:selected").val();
		inup_dept_1 = (inup_dept_1 == undefined) ? "" : inup_dept_1;
		inup_dept_2 = (inup_dept_2 == undefined) ? "" : inup_dept_2;
		var search_dept = (inup_dept_2 == "")? inup_dept_1 : inup_dept_2;
		
		var param_obj = new Object();
		param_obj["search_emp_type"] = param_emp_type;
		param_obj["search_dept"] = search_dept;
		param_obj["search_dept_arr"] = search_dept;
		param_obj["search_context"] = "";
		param_obj["search_type"] = param_type;
		param_obj["search_status"] = "1,2";
		param_obj["search_tag"] = "";
		param_obj["search_start_dt"] = "";
		param_obj["search_end_dt"] = "";
		param_obj["page_start_num"] = "0";
		param_obj["page_size"] = "10000000";

		var obj_result = JSON.parse(common_ajax.inter("/service/v2/banner/list", "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			if(obj_data.length == 0){
				$("#detail_info .history .hms_table .tablesorter tbody").empty().append(no_data);
			}else{
				var insert_table_data = "";
				for(var i=0; i < obj_data.length; i++){
					var status_nm = (obj_data[i]["use_status"] == 1)? "게시중" : (obj_data[i]["use_status"] == 2)? "게시예정": "게시종료" ;  
					var class_nm = (obj_data[i]["use_status"] == 1)? "green" : (obj_data[i]["use_status"] == 2)? "yellow": "gray" ;  
					var sort_nm = (obj_data[i]["banner_sort"] == 1)? "first" : (obj_data[i]["banner_sort"] == 2)? "second" : "third";
					var title_before = (obj_data[i]["use_status"] < 99 ) ? "<span class='order "+ class_nm +" "+ sort_nm +"'></span>" : "";
					
					insert_table_data += "<tr>";
					insert_table_data += "<td class='branch_record left'>"+ obj_data[i]["dept_nm"] +"</td>";
					insert_table_data += "<td class='title_record left'>"+ title_before + obj_data[i]["title"] +"</td>";
					insert_table_data += "<td class='status_record'><span class='status "+ class_nm +"' title='"+ status_nm +"'>"+ status_nm +"</span></td>";
					insert_table_data += "<td class='author_record'>"+ obj_data[i]["reg_user_nm"] +"</td>";
					insert_table_data += "<td class='period_record'><span class='start_date'>"+ common_date.convertType(obj_data[i]["start_dt"],8) +"</span>~<span class='end_date'>"+ common_date.convertType(obj_data[i]["end_dt"],8) +"</span></td>";
					insert_table_data += "</tr>";
				}
				$("#detail_info .history .hms_table .tablesorter tbody").empty().append(insert_table_data);
			}
		}else{ $("#detail_info .history .hms_table .tablesorter tbody").empty().append(no_data); }
	}
	
	$(document).on("change", "#detail_info .edit_banner .section input:file", function(){
		var form_data = new FormData();
		form_data.append("files", $(this).prop("files")[0]);
		form_data.append("banner_location", $("#detail_info .edit_banner .section").index($(this).closest(".section")));

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
				//console.log(obj_data);
				$("#detail_info .edit_banner .section:eq("+ obj_data["banner_position"] +") img").attr("src", obj_data["file_url_domain"] + obj_data["file_full_path"]); 
			}
			, error : function(xhr, ajaxOpts, thrownErr){
				console.log(xhr +"/"+ ajaxOpts +"/"+ thrownErr );
				alert(xhr +"/"+ ajaxOpts +"/"+ thrownErr);
			}
		});
	});
	
	/* 바로가기 배너 일때 썸네일 받기 */
	function fn_popup_thumb_image_return(thumb_image_path){ $("#detail_info .edit_banner .section:eq(1) .preview_img").css("display", "block"); $("#detail_info .edit_banner .section:eq(1) img").attr("src", thumb_image_path); }
	</script>
	
	<div id="detail_info">
		<div class="viewbar">
			<input type="hidden" name="banner_seq" />
			<h4><b>Banner Setting</b></h4>
			<div class="items"><select name="inup_dept_1"></select></div>
			<div class="items branch"><select name="inup_dept_2"></select></div>
			<div class="close_detail"></div>
		</div>
		<div class="page">
			<div class="contents new">
				<div class="set_banner">
					<div class="btype">
						<span></span>
						<button type="button" class="select_type" ><span></span></button>
					</div>
					<ul class="form_table">
						<li>
							<div class="cell title"><input type="text" name="title" placeholder="Please enter title" /></div>
							<div class="cell date">
								<span class="label">Period</span>
								<label class="period"><input type="text" name="range_dt" class="daterange" value="" style="width:180px;" readonly /><span></span></label>
							</div>
						</li>
						<li>
							<div class="cell url"><input type="text" name="link_url" placeholder="Please enter URL" /></div>
							<div class="cell target"><label class="check vertical"><input type="checkbox" name="link_target_fl" class="url_type" /><span>New Window</span></label></div>
							<div class="cell order">
								<span class="label">Order</span>
								<label class="check"><input type="radio" name="banner_sort" value="1" checked /><span>1st</span></label>
								<label class="check"><input type="radio" name="banner_sort" value="2" /><span>2nd</span></label>
								<label class="check"><input type="radio" name="banner_sort" value="3" /><span>3rd</span></label>
							</div>
						</li>
					</ul>
				</div>
				<div class="edit_banner">
					<div class="section">
						<div class="top_info"><h5></h5><div class="use_info"></div></div>
						<div class="bsize">
							<div class="upload_tool">
								<div class="select_file">
									<div class="preview_img">
										<img src="" />
										<div class="edit_guide"></div>
									</div>
									<input type="file" class="file_upload" accept="image/gif, image/jpeg, image/bmp, image/png" />
								</div>
							</div>
						</div>
						<div class="tip_info"><p>※ 위의 배너 가이드 사이즈는 가로 세로 비율에 따라 축소된 사이즈로 표시됩니다.</p></div>
					</div>
					<div class="section">
						<ul class="module">
							<li class="">
								<div class="thumb">
									<div class="bsize">
										<div class="upload_tool" onclick="fn_thumbnail_img_upload('banner_direct');">
											<div class="select_file">
												<div class="preview_img">
													<img src="" />
													<div class="edit_guide"></div>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="info">
									<div class="text">
										<h5 contenteditable="true" data-placeholder="Subtitle"></h5>
										<h4 contenteditable="true" data-placeholder="Title"></h4>
									</div>
								</div>
								<div class="btn"><a><span>자세히 보기</span></a></div><!-- 표기안함 -->
							</li>
						</ul>
					</div>
					<hr />
					<div class="section">
						<div class="top_info"><h5></h5><div class="use_info"></div></div>
						<div class="bsize">
							<div class="upload_tool">
								<div class="select_file">
									<div class="preview_img">
										<img src="" />
										<div class="edit_guide"></div>
									</div>
									<input type="file" class="file_upload" accept="image/gif, image/jpeg, image/bmp, image/png" />
								</div>
							</div>
						</div>
						<div class="tip_info"><p class="alert" style="padding-top:0px !important;">탑배너고정 사이즈 (750 X 140) 와 다른 크기의 이미지 입니다.</p></div>
					</div>
					
					<div class="history">
						<h5></h5>
						<div class="hms_table">
							<table class="tablesorter">
								<colgroup>
									<col style="width:12%">
									<col style="width:50%">
									<col style="width:12%;">
									<col style="width:12%;">
									<col style="width:14%;">
								</colgroup>
								<thead>
									<tr>
										<th class="header">Branch</th>
										<th class="header">Title</th>
										<th class="header">Status</th>
										<th class="header">Author</th>
										<th class="header">Period</th>
									</tr>
								</thead>
								<tbody></tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="create_btn">
				<!-- <button type="button" class="small delete"><span>Delete</span></button> -->
				<button type="button" class="small cancel"><span>Cancel</span></button>
				<button type="button" class="small yellow save"><span>Save</span></button>
				<button type="button" class="small blue create"><span>Create</span></button>
			</div>
		</div>
	</div>
</div>
<iframe id="iframe_hidden" name="iframe_hidden" src="about:blank" style="display:none"></iframe>
