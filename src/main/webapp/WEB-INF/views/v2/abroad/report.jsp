<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

	<script type="text/javascript">
	var now_year_date = "${serverDate}";
	var param_page_num ,param_page_size, param_page_last;
	var param_emp_type = "${cookieEmpType}";
	var param_emp_dept_list = "${cookieDeptList}";
	
	$(document).ready(function() {

		param_page_num = 0;
		param_page_size = 30;
		param_page_last = false;
		
		$("#detail_info .page .file_list").empty();
		
		fn_get_abroad_branch();

		// 날짜관련 
		var start_date = moment(common_date.monthDel(common_date.convertType(now_year_date,4), 12));
		var end_date = moment(common_date.monthAdd(common_date.convertType(now_year_date,4), 12));
		$("#container .contents .daterange").daterangepicker({
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
		}, function(start, end, label) { console.log("New date range selected: " + start.format("YYYY.MM.DD") + " to " + end.format("YYYY.MM.DD") + " (predefined range: " + label + ")"); });
		
		
		$.when(fn_get_abroad_report_list()).then(function(){ fn_table_sorter(); });
		
		$("#container .search_box input[type='button']").click(function(){ param_page_last=false; param_page_num = 0; $.when(fn_get_abroad_report_list()).then(function(){ fn_table_sorter(); });  }); // 검색 > 버튼 클릭시

		$("#container #detail_info select[name='report_type']").select2({ placeholder: 'Select Category', minimumResultsForSearch: 20 });
	});
	
	/* 검색박스에서 엔터시 조회되게끔 변경 */
	$(document).on("keypress", "#container .search_box input[name='search_context']", function(){
		param_page_last=false; param_page_num = 0; $.when(fn_get_abroad_report_list()).then(function(){ fn_table_sorter(); }); 
	});
	
	/* 유학분원명단을 가지고 온다. 명단은 HardCoding Properties 참조 */
	function fn_get_abroad_branch(){
		var param_input_data = "";
		if(param_emp_type == 'B'){
			var param_b_dept_list_sp = param_b_dept_list.split(",");
			for(var i=0; i < param_b_dept_list_sp.length; i++){
				param_input_data += (param_input_data == "") ? param_b_dept_list_sp[i].split(":")[0] : ","+ param_b_dept_list_sp[i].split(":")[0];
			}
		}else{
			var obj_result = JSON.parse(common_ajax.inter("/service/v2/dept/abroad", "json", false, "GET", ""));
			if(obj_result.header.isSuccessful == true){
				var obj_data = JSON.parse(obj_result.data);
				for(var i=0; i < obj_data.length; i++){
					param_input_data += (param_input_data == "") ? obj_data[i]["dept_seq"] : ","+ obj_data[i]["dept_seq"] ;
				}
			}
		}
		$("#container #detail_list .sort_option input[name='search_dept']").val(param_input_data);
	}

	
	function fn_default_set(){
		$("#container .contents .basic .name input[name='page_start_num']").val(param_page_num);
		$("#container .contents .basic .name input[name='page_size']").val(param_page_size);
	}
	
	/* 리포트 목록 */
	function fn_get_abroad_report_list(){
		var no_data = "<tr><td colspan='6' class='nodata' data-guide='No data available!'></td></tr>";
		
		$("#detail_list tbody tr").removeClass("selected");
		$("#container").removeClass("expand");
		$("#detail_info").removeClass("new");

		fn_default_set();

		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/report", "json", false, "POST", search.get_report_parameter("container")));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var insert_table_data = "";
			if(obj_data.length == 0){ 
				param_page_last = true; 
				if(param_page_num == 0){ $("#container #detail_list .list .hms_table .tablesorter tbody").empty().append(no_data); }
				$("#container #detail_list .list .hms_table .tablesorter tbody").append(insert_table_data);
			}else{
				for(var i=0; i < obj_data.length; i++){
					var param_report_type_nm = (obj_data[i]["report_type"] == "RRT001") ? "용돈내역서" : (obj_data[i]["report_type"] == "RRT002") ? "생활기록부" : (obj_data[i]["report_type"] == "RRT003") ? "성적표" : "기타" ;
					insert_table_data += "<tr seq='"+ obj_data[i]["site_report_user_seq"] +"'>";
					insert_table_data += "<td class='category_record'>"+ param_report_type_nm +"</td>";
					insert_table_data += "<td class='name_record left'>"+ obj_data[i]["user_nm"] +" ("+ obj_data[i]["dept_nm2"] +")</td>";
					insert_table_data += "<td class='title_record left'>"+ obj_data[i]["title"] +"</td>";
					insert_table_data += "<td class='author_record'>"+ obj_data[i]["reg_user_nm"] +"</td>";
					insert_table_data += "<td class='date_record'>"+ common_date.convertType(obj_data[i]["reg_ts"],8) +"</td>";
					insert_table_data += "<td class='date_record'>"+ common_date.convertType(obj_data[i]["read_ts"],8) +"</td>";
					insert_table_data += "<td class='delete_record'><button title='Delete' class='icon delete'><span>Delete</span></button></td>";
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
					$.when(fn_get_abroad_counsel_list()).then(function(){ fn_table_sorter(); });
				}
			}
		});
	}
	
	$(document).on("mouseenter","#detail_list .hms_table td",function() { $(this).closest("tr").addClass("hover"); });
	$(document).on("mouseleave","#detail_list .hms_table td",function() { $(this).closest("tr").removeClass("hover"); });
	$(document).on("click", "td.delete_record",function(e){ e.stopPropagation(); });
	$(document).on("mouseenter", "td.delete_record",function(e){ $(this).closest("tr").removeClass("hover"); e.stopPropagation(); });

	/* sort 조건 눌렀을때 */
	$(document).on("click", "#detail_list .sort input:checkbox", function(){
		param_page_last=false; param_page_num = 0; $.when(fn_get_abroad_report_list()).then(function(){ fn_table_sorter(); });
	});
	
	/* 등록시 학생 목록 가지고 오기 */
	function fn_get_abroad_user(){
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/dept/user", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var param_input_data = "<option value=''></option>";
			var param_pre_dept = "";
			for(var i=0; i < obj_data.length; i++){
				if(param_emp_type == 'B'){
					if(param_b_dept_list.indexOf(obj_data[i]["dept_seq"]) > -1){
						if(param_pre_dept == "" || param_pre_dept != obj_data[i]["dept_seq"] ){ 
							if(param_pre_dept != ""){ param_input_data += "</optgroup>"; }
							param_input_data += "<optgroup label='"+ obj_data[i]["dept_nm2"] +"'>";
							param_pre_dept = obj_data[i]["dept_seq"];
						}
						param_input_data += "<option value='"+ obj_data[i]["dept_seq"] +","+ obj_data[i]["user_seq"] +"'>"+ obj_data[i]["user_nm"] +" ("+ obj_data[i]["dept_nm2"] +")</option>";
					}
				}else{
					if(param_pre_dept == "" || param_pre_dept != obj_data[i]["dept_seq"] ){ 
						if(param_pre_dept != ""){ param_input_data += "</optgroup>"; }
						param_input_data += "<optgroup label='"+ obj_data[i]["dept_nm2"] +"'>";
						param_pre_dept = obj_data[i]["dept_seq"];
					}
					param_input_data += "<option value='"+ obj_data[i]["dept_seq"] +","+ obj_data[i]["user_seq"] +"'>"+ obj_data[i]["user_nm"] +" ("+ obj_data[i]["dept_nm2"] +")</option>";
				}
			}
			$("#container #detail_info select[name='student_name']").empty().append(param_input_data);
			$("#container #detail_info select[name='student_name']").select2({ placeholder: 'Select Student', minimumResultsForSearch: 20 });
			$("#container #detail_info select[name='student_name']").val("").trigger("change");
		}
	}
	
	/* 신규생성 */
	$(document).on("click", "#container .contents .new button.black", function(){
		$("#detail_list tbody tr").removeClass("selected");
		$("#container").addClass("expand");
		$("#detail_info").addClass("new");
		$("#detail_info .viewbar>h4>b").text("리포트 등록");
		$("#container #detail_info").attr("seq", "");
		$("#container #detail_info .create_btn button.create").removeClass("hide");
		$("#container #detail_info .create_btn button.save").addClass("hide");
		
		/* 본문 리셋 */
		$("#container #detail_info select[name='report_type']").val("").trigger("change");
		$("#detail_info .page .form_table p[contenteditable]").html("");
		$("#detail_info .page .form_table input[name='title']").val("");
		$("#detail_info .page ul.file_list").empty();
		
		fn_get_abroad_user();
	});
	
	/* 취소및 X버튼 눌렀을때 */
	$(document).on("click", "#detail_info button.cancel, #detail_info .close_detail", function() {
		$("#detail_list .hms_table tr").removeClass("selected");
		$("#detail_info").removeClass("new");
		$("#container").removeClass("expand");
		setTimeout(function() { $(window).trigger("resize"); }, 100);
	});
	
	/* 저장 버튼 클릭시 */
	$(document).on("click", "#detail_info .create_btn .create, #detail_info .create_btn button.save", function() {
		var param_inup_type = ($("#detail_info").attr("class") == "new") ? "insert" : "update";
		var param_content = $("#detail_info .page .form_table p[contenteditable]").html();
		param_content = param_content.replace(/<[\/]{0,1}(p)[^><]*>/gi, "<br>");
		param_content = param_content.replace(/<br><br>/gi,"<br>");
		
		
		
		var param_user_dept = $("#detail_info .viewbar .items select[name='student_name']").val();
		var param_report_type = $("#detail_info .viewbar .items select[name='report_type']").val();
		var param_site_report_seq = $("#container #detail_info").attr("seq");
		var param_title = $("#detail_info .page .form_table input[name='title']").val();
		
		if(param_title == ""){ alert("제목을 입력해 주세요."); return; }
		if(param_report_type == ""){ alert("리포트 종류를 선택해 주세요."); return; }
		if(param_content == ""){ alert("내용을 입력해 주세요."); return; }
		if(param_user_dept == ""){ alert("학생을 선택해 주세요."); return; }
		
		var param_obj = new Object();
		param_obj["param_site_report_seq"] = param_site_report_seq;
		param_obj["param_content"] = param_content;
		param_obj["param_title"] = param_title;
		param_obj["param_report_type"] = param_report_type;
		param_obj["param_user"] = param_user_dept.split(",")[1];
		param_obj["param_dept"] = param_user_dept.split(",")[0];

		var param_files = $("#detail_info .page .form_table .file_list li");
		var param_file_path = "";
		var param_file_nm = "";
		for(var i=0; i < param_files.length; i++){
			param_file_path += (param_file_path == "") ? param_files.eq(i).find(".file_path").text() : ","+param_files.eq(i).find(".file_path").text();
			param_file_nm += (param_file_nm == "") ? param_files.eq(i).find(".file_nm").text() : ","+param_files.eq(i).find(".file_nm").text();
		}
		param_obj["param_file_path"] = param_file_path;
		param_obj["param_file_nm"] = param_file_nm;
		
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/report/"+ param_inup_type, "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			alert("저장이 완료 되었습니다.");
			param_page_last=false; param_page_num = 0;
			$.when(fn_get_abroad_report_list()).then(function(){ fn_table_sorter(); });
			setTimeout(function() { $(window).trigger("resize"); }, 100);
		}else{
			alert(obj_result.header.resultMessage);
		}
	});
	
	/* 첨부파일 팝업창 클릭 */
	function fn_lib_file_upload_open() {
		$("#pop_upload, .black_bg").fadeIn();
		$("#pop_upload #if_assessment").attr("src", "/v2/popup/lib_jquery_file_upload");
	}

	/* 첨부파일 리턴값 */
	function fn_lib_file_upload_return(param_rtn_data){
		if(param_rtn_data.length > 0){
			var param_input_file_info = "";
			for(var i = 0; i < param_rtn_data.length; i++){
				param_input_file_info += "<li>";
				param_input_file_info += "<span class='file_path hide'>"+ param_rtn_data[i]["file_path"] +"</span>";
				param_input_file_info += "<span class='name file_nm'>"+ param_rtn_data[i]["file_nm"] +"</span>";
				param_input_file_info += "<span class='del'></span>";
				param_input_file_info += "</li>";
			}
			$("#detail_info .page ul.file_list").append(param_input_file_info);
		}
		$("#pop_upload").fadeOut();
		$('.white_bg, .black_bg, .layer_bg').fadeOut();
		$('.pop').removeAttr('style');
	}
	
	/* 입력 수정 화면에서 첨부파일 삭제시 */
	$(document).on("click", "#detail_info .page ul.file_list li .del" , function(){ $("#detail_info .page ul.file_list li").eq($(this).closest("li").index()).remove(); });

	
	/* 목록에서 삭제버튼 눌렀을때 */
	$(document).on("click", "#detail_list .hms_table tr td.delete_record button.delete", function() {
		var param_rtn_value = $(this).closest("tr").attr("seq");
		dialog.list_delete_confirm_btn($(this), "This item will be deleted. Are you sure?", fn_del_report, param_rtn_value); 
	});

	function fn_del_report(param_site_report_user_seq){
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/report/"+ param_site_report_user_seq, "json", false, "DELETE", ""));
		if(obj_result.header.isSuccessful == true){
			$.when(fn_get_abroad_report_list()).then(function(){ fn_table_sorter(); });
		}else{
			alert(obj_result.header.resultMessage);
		}
	}
	 
	/* 게시된 글을 선택시 */
	$(document).on('click','#detail_list .hms_table tbody tr',function() {
		$('#detail_info').removeClass('new');
		$('#detail_info .viewbar>h4>b').text('리포트 내용');
		
		if($(this).hasClass('selected')){
			$(this).toggleClass('selected');
			$('#container').toggleClass('expand');
			$("#container #detail_info").attr("seq", "");
		}else{
			$(this).closest('tbody').find('tr').removeClass('selected');
			$(this).addClass('selected');
			$('#container').addClass('expand');
			$("#container #detail_info").attr("seq", $(this).attr("code"));
			$("#container #detail_info .create_btn button.create").addClass("hide");
			$("#container #detail_info .create_btn button.save").removeClass("hide");
			
			fn_get_abroad_report_view($(this).attr("seq"));
		}
		setTimeout(function() { $(window).trigger('resize'); }, 100);
	});
	
	function fn_get_abroad_report_view(param_site_report_seq){
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/report/"+ param_site_report_seq, "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var param_input_file_info = "";
			for(var i=0; i < obj_data.length; i++){
				if(i == 0){
					$("#detail_info .viewbar .items select[name='report_type']").val(obj_data[i]["report_type"]).trigger("change");
					$("#detail_info .viewbar select[name='student_name']").empty().append("<option value='"+ obj_data[i]["dept_seq"] +","+ obj_data[i]["user_seq"] +"'>"+ obj_data[i]["user_nm"] +" ("+ obj_data[i]["dept_nm2"] +")</option>");
					$("#detail_info .viewbar select[name='student_name']").select2({ placeholder: 'Select Student', minimumResultsForSearch: 20 });
					$("#detail_info .page .form_table input[name='title']").val(obj_data[i]["title"]);
					$("#detail_info .page .form_table p[contenteditable]").html(obj_data[i]["contents"]);
					$("#detail_info").attr("seq", obj_data[i]["site_report_user_seq"]);
				}
				if(obj_data[i]["param_file_path"] != ""){
					param_input_file_info += "<li>";
					param_input_file_info += "<span class='file_path hide'>"+ obj_data[i]["param_file_path"] +"</span>";
					param_input_file_info += "<span class='name file_nm'><a href='/lib/v2/download?file_path="+ obj_data[i]["param_file_path"] +"&file_nm="+ obj_data[i]["param_file_nm"] +"'>"+ obj_data[i]["param_file_nm"] +"</a></span>";
					param_input_file_info += "<span class='del'></span>";
					param_input_file_info += "</li>";
				}
			}
			$("#detail_info .page ul.file_list").empty().append(param_input_file_info);
		}
	}
	</script>
	
	<div id="container">
		<div class="browser sidebar expand">
			<div class="burger_icon"><span></span></div>
			<h3>Study Abroad</h3>
			<div class="scroll"><jsp:include page="../layout/abroad_menu.jsp" flush="true" /></div>
		</div>
		<div class="contents my_edit">
			<div class="basic">
				<dl class="">
					<dd class="name">
						<input type="hidden" name="page_start_num" />
						<input type="hidden" name="page_size" />
						<h3>MY 유학 <span class="depth_txt">></span> <b>리포트</b></h3>
						<div class="items">
							<label class="period"><input type="text" name="search_date" class="daterange" value="" style="width:160px;" readonly /><span></span></label>
						</div>
						<div class="search_box">
							<input type="text" name="search_context" placeholder="Student name, Title text">
							<input type="button" class="search_btn">
						</div>
					</dd>
					<dd class="new">
						<button type="button" class="small black"><span>New Report</span></button>
					</dd>
				</dl>
			</div>
			<div id="detail_list">
				<div class="sort_option">
					<div class="inquiry group expand">
						<input type="hidden" name="search_dept">
						<div class="sort first">
							<h5>Category</h5>
							<label><input type="checkbox" name="content_type" value="RRT001"><span>용돈내역서</span></label>
							<label><input type="checkbox" name="content_type" value="RRT002"><span>생활기록부</span></label>
							<label><input type="checkbox" name="content_type" value="RRT003"><span>성적표</span></label>
							<label><input type="checkbox" name="content_type" value="RRT004"><span>기타</span></label>
						</div>
					</div>
				</div>
				<div class="list">
					<div class="hms_table">
						<table class="tablesorter">
							<colgroup>
								<col style="width:10%;">
								<col style="width:15%;">
								<col style="width:35%;">
								<col style="width:10%;">
								<col style="width:15%;">
								<col style="width:15%;">
								<col style="width:35px;">
							</colgroup>
							<thead>
								<tr>
									<th class="category_record">Category</th>
									<th class="name_record">Name (Branch)</th>
									<th class="title_record">Title</th>
									<th class="author_record">Author</th>
									<th class="date_record">Issue Date</th>
									<th class="date_record">Read Date</th>
									<th class="delete_record"></th>
								</tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
			</div>
			
			<div id="detail_info">
				<div class="viewbar">
					<h4><b>리포트 수정</b></h4>
					<div class="items">
						<select name="report_type" style="width:120px;">
							<option value=""></option>
							<option value="RRT001">용돈내역서</option>
							<option value="RRT002">생활기록부</option>
							<option value="RRT003">성적표</option>
							<option value="RRT004">기타</option>
						</select>
					</div>
					<div class="items"><select name="student_name" style="width:200px;"></select></div>
					<div class="close_detail"></div>
				</div>
				<div class="page report">
					<div class="contents">
						<ul class="form_table">
							<li><div class="cell title"><input type="text" name="title" value="" placeholder="Please enter title" /></div></li>
							<li><div class="cell"><p contenteditable="true" data-placeholder="Please enter description."></p></div></li>
							<li>
								<div class="cell file">
									<h6>
										<span>Attachments</span>
										<button type="button" class="xsmall blue attach" onclick="fn_lib_file_upload_open();"><span>Upload file</span></button>
									</h6>
									<ul class="file_list"></ul>
								</div>
							</li>
						</ul>
					</div>
					<div class="create_btn">
						<button type="button" class="small cancel"><span>Cancel</span></button>
						<button type="button" class="small yellow save hide"><span>Save</span></button>
						<button type="button" class="small blue create"><span>Create</span></button>
					</div>
				</div>
			</div>
			
		</div>
	</div>