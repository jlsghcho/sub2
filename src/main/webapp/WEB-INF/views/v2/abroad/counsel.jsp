<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
	<script type="text/javascript">
	var now_year_date = "${serverDate}";
	var param_page_num ,param_page_size, param_page_last;
	
	$(document).ready(function() {
		param_page_num = 0;
		param_page_size = 30;
		param_page_last = false;
		
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
		
		$.when(fn_get_abroad_branch()).then(function(){ fn_get_abroad_counsel_list(); fn_table_sorter(); });
		
		$("#container .search_box input[type='button']").click(function(){ param_page_last=false; param_page_num = 0; $.when(fn_get_abroad_counsel_list()).then(function(){ fn_table_sorter(); });  }); // 검색 > 버튼 클릭시
	});
	
	/* 검색박스에서 엔터시 조회되게끔 변경 */
	$(document).on("keypress", "#container .search_box input[name='search_context']", function(){
		param_page_last=false; param_page_num = 0; $.when(fn_get_abroad_counsel_list()).then(function(){ fn_table_sorter(); }); 
	});
	
	/* 유학분원명단을 가지고 온다. 명단은 HardCoding Properties 참조 */
	function fn_get_abroad_branch(){
		var param_input_data = "<h5>Branch</h5>";
		if(param_emp_type == 'B'){
			var param_b_dept_list_sp = param_b_dept_list.split(",");
			for(var i=0; i < param_b_dept_list_sp.length; i++){
				param_input_data += "<label><input type='checkbox' name='search_dept' value='"+ param_b_dept_list_sp[i].split(":")[0] +"'> <span>"+ param_b_dept_list_sp[i].split(":")[1] +"</span></label>";
			}
		}else{
			var obj_result = JSON.parse(common_ajax.inter("/service/v2/dept/abroad", "json", false, "GET", ""));
			if(obj_result.header.isSuccessful == true){
				var obj_data = JSON.parse(obj_result.data);
				for(var i=0; i < obj_data.length; i++){
					param_input_data += "<label><input type='checkbox' name='search_dept' value='"+ obj_data[i]["dept_seq"] +"'> <span>"+ obj_data[i]["dept_nm2"] +"</span></label>";
				}
			}
		}
		$("#container #detail_list .sort_option .sort").empty().append(param_input_data);
	}
	
	function fn_default_set(){
		$("#container .contents .basic .name input[name='page_start_num']").val(param_page_num);
		$("#container .contents .basic .name input[name='page_size']").val(param_page_size);
	}
	
	/* 상담 목록 */
	function fn_get_abroad_counsel_list(){
		var no_data = "<tr><td colspan='6' class='nodata' data-guide='No data available!'></td></tr>";
		fn_default_set();

		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/counsel", "json", false, "POST", search.get_abroad_parameter("container")));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var insert_table_data = "";
			if(obj_data.length == 0){ 
				param_page_last = true; 
				if(param_page_num == 0){ $("#container #detail_list .list .hms_table .tablesorter tbody").empty().append(no_data); }
				$("#container #detail_list .list .hms_table .tablesorter tbody").append(insert_table_data);
			}else{
				var param_contents = "";
				for(var i=0; i < obj_data.length; i++){
					insert_table_data += "<tr seq='"+ obj_data[i]["site_counsel_seq"] +"' code='"+ obj_data[i]["site_counsel_reply_seq"] +"'>";
					insert_table_data += "<td class='name_record left'>"+ obj_data[i]["user_nm"] +" ("+ obj_data[i]["dept_nm2"] +")</td>";
					
					param_contents = obj_data[i]["contents"].replace(/\<br\>/gi, " ");
					param_contents = (param_contents.length > 40) ? param_contents.substr(0, 40) +"..." : param_contents ;
					//console.log(param_contents);
					
					var param_read_yn = (obj_data[i]["reg_user_type"] == 'USER') ? "<label class='parent'>Parent</label>" : " ";
					var param_unread = (obj_data[i]["read_yn"] == 0 && obj_data[i]["reg_user_type"] == 'ADMIN') ? "<label class='unread'>Unread</label>" : "";
					insert_table_data += "<td class='qna_record left'><div class='q'>"+ param_contents +" "+ param_unread +"</div></td>";
					
					var param_label_t = (obj_data[i]["reg_user_type"] == 'USER') ? "<label class='parent'>Parent</label>" : " ";
					insert_table_data += "<td class='author_record'>"+ obj_data[i]["reg_user_nm"] +" "+ param_label_t +"</td>";
					insert_table_data += "<td class='date_record'>"+ common_date.convertType(obj_data[i]["reg_ts"],8) +"</td>";
					
					var param_reply_not_read = (obj_data[i]["reply_no_read_cnt"] > 0) ? "<span class='new_reply'>"+ obj_data[i]["reply_no_read_cnt"] +"</span>" : "";
					insert_table_data += "<td class='replynum_record'><span class='total_reply'>"+ obj_data[i]["reply_cnt"] +"</span>"+ param_reply_not_read +"</td>";
					var param_del_btn = (obj_data[i]["reply_cnt"] == 0 && obj_data[i]["read_yn"] == 0) ? "" : "disabled"; 
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
		param_page_last=false; param_page_num = 0; $.when(fn_get_abroad_counsel_list()).then(function(){ fn_table_sorter(); });
	});
	
	/* 등록시 학생 목록 가지고 오기 */
	function fn_get_abroad_user(){
		/* 작업할것 : 분원직원일때 와 직원일때 구분하기 */
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
		$("#detail_info .viewbar>h4>b").text("유학생활 1:1 상담 등록");
		$("#container .contents .qna_title p").attr("contenteditable", true).text("");
		$("#container #detail_info .qna_title button.edit").addClass("hide");
		$("#container #detail_info .qna_title button.save").addClass("hide");
		$("#container #detail_info").attr("seq", "");
		
		// check title height
		var qna_tit = $("#detail_info .new .qna_title").height();
		$("#detail_info .new .edit_answer").css("top", qna_tit);
		$("#detail_info .create_btn").removeClass("hide");
		
		$("#detail_info .page .edit_answer .answer_talk").empty();
		$("#container #detail_info .qna_title .info span:eq(0)").text("");
		$("#container #detail_info .qna_title .info span:eq(1)").text("");
		
		setTimeout(function(){ $(window).trigger("resize"); }, 100);
		
		fn_get_abroad_user();
	});
	
	/* 질문입력시 길이가 길어지면 실행 */
	$(document).on("input","#container .contents .new .qna_title p[contenteditable]", function() {
		var qna_tit = $(this).closest(".qna_title").height();
		$(this).closest(".qna_title").next(".edit_answer").css("top", qna_tit);
	});
	
	/* 취소및 X버튼 눌렀을때 */
	$(document).on("click", "#detail_info button.cancel, #detail_info .close_detail", function() {
		$("#detail_list .hms_table tr").removeClass("selected");
		$("#detail_info").removeClass("new");
		$("#container").removeClass("expand");
		setTimeout(function() { $(window).trigger("resize"); }, 100);
	});
	
	/* 목록에서 삭제버튼 눌렀을때 */
	$(document).on("click", "#detail_list .hms_table tr td.delete_record button.delete", function() {
		var param_rtn_value = $(this).closest("tr").attr("seq");
		dialog.list_delete_confirm_btn($(this), "This item will be deleted. Are you sure?", fn_del_counsel, param_rtn_value); 
	});

	function fn_del_counsel(param_site_counsel_seq){
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/counsel/"+ param_site_counsel_seq, "json", false, "DELETE", ""));
		if(obj_result.header.isSuccessful == true){
			$.when(fn_get_abroad_counsel_list()).then(function(){ fn_table_sorter(); });
		}else{
			alert(obj_result.header.resultMessage);
		}
	}

	/* 저장 버튼 클릭시 */
	$(document).on("click", "#detail_info .create_btn .create, #container #detail_info .qna_title button.save", function() {
		var param_inup_type = ($("#detail_info").attr("class") == "new") ? "insert" : "update";
		var param_content = fn_edit_table_convert($("#detail_info .page p[contenteditable]").html());
		//param_content = param_content.replace(/<[\/]{0,1}(p)[^><]*>/gi, "<br>");
		//param_content = param_content.replace(/<br><br>/gi,"<br>");
		var param_user_dept = $("#detail_info .viewbar .items select[name='student_name']").val();
		var param_site_counsel_reply_seq = $("#container #detail_info").attr("seq");
		
		if(param_content == ""){ alert("내용을 입력해 주세요."); return; }
		if(param_user_dept == ""){ alert("학생을 선택해 주세요."); return; }
		
		var param_obj = new Object();
		param_obj["param_site_counsel_reply_seq"] = param_site_counsel_reply_seq;
		param_obj["param_content"] = param_content;
		param_obj["param_user"] = param_user_dept.split(",")[1];
		param_obj["param_dept"] = param_user_dept.split(",")[0];

		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/counsel/"+ param_inup_type, "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			alert("저장이 완료 되었습니다.");
			$.when(fn_get_abroad_counsel_list()).then(function(){ fn_table_sorter(); });
			
			$("#detail_list tbody tr").removeClass("selected");
			$("#container").removeClass("expand");
			$("#detail_info").removeClass("new");
			setTimeout(function(){ $(window).trigger("resize"); }, 100);
		}else{
			alert(obj_result.header.resultMessage);
		}
	});
	
	/* 게시된 글을 선택시 */
	$(document).on('click','#detail_list .hms_table tbody tr',function() {
		$('#detail_info').removeClass('new');
		$('#detail_info .create_btn').addClass('hide');
		$('#detail_info .viewbar>h4>b').text('유학생활 1:1 대화 내용');
		
		if($(this).hasClass('selected')){
			$(this).toggleClass('selected');
			$('#container').toggleClass('expand');
			$("#container #detail_info").attr("seq", "");
		}else{
			$(this).closest('tbody').find('tr').removeClass('selected');
			$(this).addClass('selected');
			$('#container').addClass('expand');
			$("#container #detail_info .qna_title p").attr("contenteditable", false);
			$("#container #detail_info .qna_title button.edit").removeClass("hide");
			$("#container #detail_info .qna_title button.save").addClass("hide");
			$("#container #detail_info").attr("seq", $(this).attr("code"));
			
			$.when(fn_get_abroad_counsel_view($(this).attr("seq"))).then(function(){
				var tempheight = $('#detail_info .contents .answer_talk').height();
				$('#detail_info .contents.contents .edit_answer').animate({ scrollTop: tempheight }, 'slow');
			});
		}
		setTimeout(function() { $(window).trigger('resize'); }, 100);
	});
	
	/* 상세보기 */
	function fn_get_abroad_counsel_view(param_counsel_seq){
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/counsel/"+ param_counsel_seq, "json", false, "GET", ""));
		var param_input_chat = "";
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			for(var i=0; i < obj_data.length; i++){
				if(obj_data[i]["qa_type"] == "Q"){
					
					$("#container #detail_info select[name='student_name']").empty().append("<option value='"+ obj_data[i]["dept_seq"]+","+ obj_data[i]["user_seq"] +"'>"+ obj_data[i]["user_nm"]+" ("+ obj_data[i]["dept_nm2"] +")</option>");
					$("#container #detail_info select[name='student_name']").select2({ placeholder: 'Select Student', minimumResultsForSearch: 20 });
					
					$("#container #detail_info .qna_title p").html(obj_data[i]["contents"]);
					$("#container #detail_info .edit_answer").css("top", $("#container .contents .qna_title").height());
					$("#container #detail_info .qna_title .info span:eq(0)").text(obj_data[i]["reg_user_nm"]);
					$("#container #detail_info .qna_title .info span:eq(1)").text(obj_data[i]["reg_ts"]);
					if(obj_data[i]["reg_user_type"] != 'ADMIN'){ $("#container #detail_info .qna_title button.edit").addClass("hide"); } // 어드민에서 글을 달았을때만 보인다. 

					/* 만약 질문에 첨부파일이 존재 한다면 쿼리를 날려서 데이터를 가지고 온다. */
					if(obj_data[i]["counsel_file_cnt"] > 0){
						var param_user_type = (obj_data[i]["reg_user_type"] == 'ADMIN') ? "teacher" : "user";
						param_input_chat += "<div class='"+ param_user_type +"'>";
						param_input_chat += "<div class='txt'><div class='file'>첨부파일 : ";
						param_input_chat += fn_get_abroad_counsel_reply_files(obj_data[i]["site_counsel_reply_seq"]);
						param_input_chat += "</div></div>";
						param_input_chat += "<div class='name'>"+ obj_data[i]["reg_user_nm"] +"</div>";
						param_input_chat += "<div class='time'>"+ obj_data[i]["reg_ts"] +"</div>";
						param_input_chat += "</div>";
					}
				}else{
					/* 만약 질문에 첨부파일이 존재 한다면 쿼리를 날려서 데이터를 가지고 온다. */
					var param_files = "";
					if(obj_data[i]["counsel_file_cnt"] > 0){
						param_files += "<div class='file'>첨부파일 : ";
						param_files += fn_get_abroad_counsel_reply_files(obj_data[i]["site_counsel_reply_seq"]);
						param_files += "</div>";
					}

					var param_user_type = (obj_data[i]["reg_user_type"] == 'ADMIN') ? "teacher" : "user";
					param_input_chat += "<div class='"+ param_user_type +" reply' seq='"+ obj_data[i]["site_counsel_reply_seq"] +"'>";
					param_input_chat += "<div class='txt'><p>"+ obj_data[i]["contents"] +"</p>"+ param_files +"</div>";
					param_input_chat += "<div class='name'>"+ obj_data[i]["reg_user_nm"] +"</div>";
					param_input_chat += "<div class='time'>"+ obj_data[i]["reg_ts"] +"</div>";
					if(obj_data[i]["read_yn"] == "0"){ param_input_chat += "<div class='read'>unread</div><div class='delete'>Delete</div>"; }
					param_input_chat += "</div>";
				}
			}
		}
		param_input_chat += "<div class='teacher input' seq='"+ param_counsel_seq +"'>";
		param_input_chat += "<div class='txt edit'>";
		param_input_chat += "<div class='talking' contenteditable='true' data-placeholder='상대방을 배려하는 마음으로 글을 작성해주세요.'></div>";
		param_input_chat += "<button type='button' class='yellow small' disabled><span>Reply</span></button>";
		param_input_chat += "</div>";
		param_input_chat += "<div class='name'>${cookieEmpNm}</div>";
		param_input_chat += "<div class='attach'>";
		param_input_chat += "<div class='file_input'>";
		param_input_chat += "<input type='text' name='counsel_reply_files' style='ime-mode:inactive;' placeholder='첨부파일 (최대 10MB)' disabled />";
		param_input_chat += "<button type='button' class='small'><span>Attach File</span></button>";
		param_input_chat += "<input type='file' class='edit_upload' name='upload_files' multiple />";
		param_input_chat += "</div>";
		param_input_chat += "</div>";
		param_input_chat += "</div>";

		$("#container #detail_info .edit_answer .answer_talk").empty().append(param_input_chat);
	}
	
	function fn_get_abroad_counsel_reply_files(param_site_counsel_reply_seq){
		//<a href='#'>대학진학관련가이드 2018.pdf</a> <a href='#'>대학진학 관련 가이드 2017.pdf</a>
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/counsel/files/"+ param_site_counsel_reply_seq, "json", false, "GET", ""));
		var param_input_files = "";
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			for(var i=0; i < obj_data.length; i++){ param_input_files += "<a href='/lib/v2/download?file_path="+ obj_data[i]["file_path"] +"&file_nm="+ obj_data[i]["file_nm"] +"'>"+ obj_data[i]["file_nm"] +"</a> "; }
		}
		return param_input_files;
	}
	
	/* 상세보기 수정버튼 클릭시 */
	$(document).on("click", "#container #detail_info .qna_title button.edit", function(){
		$("#container #detail_info .qna_title button.edit").addClass("hide");
		$("#container #detail_info .qna_title button.save").removeClass("hide");
		$("#container #detail_info .qna_title p").attr("contenteditable", true);
	});
	
	/* 댓글에 글을 남겼을때 저장 버튼 활성화  */
	$(document).on('input','#detail_info .edit_answer [contenteditable]',function() {
		if($(this).text().length == 0){
			$('#detail_info .edit_answer .txt.edit button').attr('disabled', true);
		}else{
			$('#detail_info .edit_answer .txt.edit button').attr('disabled', false);
		}
	});
	
	/* 댓글에 첨부파일을 등록했을때 */
	$(document).on("change", "#detail_info .page.counseling .answer_talk .attach input:file", function(){
		for(var i=0; i < $(this).prop("files").length; i++){ fn_set_counsel_reply_files($(this).prop("files")[i]); }
	});
	
	function fn_set_counsel_reply_files(param_files){
		var form_data = new FormData();
		form_data.append("files", param_files);

		$.ajax({
			type : "POST"
			, processData : false
			, contentType : false
			, cache : false
			, data : form_data
			, url : "/lib/v2/upload/files"
			, dataType : "json"
			, success : function(obj_result){
				var obj_data = JSON.parse(obj_result.data);
				// 첨부파일 아래쪽에 데이터 축적 한다. 
				$("#detail_info .page.counseling .answer_talk .attach .file_input").append("<div class='file hide'><span class='file_path'>"+ obj_data["file_full_path"] +"</span><span class='file_nm'>"+ obj_data["file_origin_name"] +"</span></div>");
				$("#detail_info .page.counseling .answer_talk .attach input[name='counsel_reply_files']").val("첨부파일 "+ $("#detail_info .page.counseling .answer_talk .attach .file_input .file").length +"개");
				$("#detail_info .page.counseling .answer_talk .txt button.yellow").prop("disabled", false);
			}
			, error : function(xhr, ajaxOpts, thrownErr){
				console.log(xhr +"/"+ ajaxOpts +"/"+ thrownErr );
				alert(xhr +"/"+ ajaxOpts +"/"+ thrownErr);
			}
		});
	}
	
	/* 댓글 저장 할때 */
	$(document).on("click", "#detail_info .edit_answer .txt.edit button", function(){
		var param_content = fn_edit_table_convert($(this).closest(".answer_talk").find(".input div[contenteditable]").html());
		//param_content = param_content.replace(/<[\/]{0,1}(p)[^><]*>/gi, "<br>");
		//param_content = param_content.replace(/<br><br>/gi,"<br>");
		var param_site_counsel_seq = $(this).closest(".answer_talk").find(".input").attr("seq");
		
		if(param_content == ""){ alert("내용을 입력해 주세요."); return; }
		
		var param_obj = new Object();
		param_obj["param_site_counsel_seq"] = param_site_counsel_seq;
		param_obj["param_content"] = param_content;
		
		var param_files = $(this).closest(".answer_talk").find(".input .file");
		var param_file_path = "";
		var param_file_nm = "";
		for(var i=0; i < param_files.length; i++){
			param_file_path += (param_file_path == "") ? param_files.eq(i).find(".file_path").text() : ","+param_files.eq(i).find(".file_path").text();
			param_file_nm += (param_file_nm == "") ? param_files.eq(i).find(".file_nm").text() : ","+param_files.eq(i).find(".file_nm").text();
		}
		param_obj["param_file_path"] = param_file_path;
		param_obj["param_file_nm"] = param_file_nm;
		
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/counsel/reply/insert", "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			alert("저장이 완료 되었습니다.");
			fn_get_abroad_counsel_view(param_site_counsel_seq);
			fn_get_abroad_counsel_list();
			
		}else{
			alert(obj_result.header.resultMessage);
		}
	});
	
	/* 목록에서 삭제버튼 눌렀을때 */
	$(document).on("click", "#detail_info .edit_answer .reply .delete", function() {
		var param_rtn_value = $(this).closest(".reply").attr("seq");
		dialog.list_delete_confirm_btn($(this), "This item will be deleted. Are you sure?", fn_del_counsel_reply, param_rtn_value); 

	});
	
	function fn_del_counsel_reply(param_site_counsel_reply_seq){
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/counsel/reply/"+ param_site_counsel_reply_seq, "json", false, "DELETE", ""));
		if(obj_result.header.isSuccessful == true){
			fn_get_abroad_counsel_view($("#detail_info .answer_talk .input").attr("seq"));
			$.when(fn_get_abroad_counsel_list()).then(function(){ fn_table_sorter(); });
		}else{
			alert(obj_result.header.resultMessage);
		}
	}
	</script>
	<div id="container">
		<div class="browser sidebar expand">
			<div class="burger_icon"><span></span></div>
			<h3>Study Abroad</h3>
			<div class="scroll"><jsp:include page="../layout/abroad_menu.jsp" flush="true" /></div>
		</div>
		<div class="contents movie_edit">
			<div class="basic">
				<dl class="">
					<dd class="name">
						<input type="hidden" name="page_start_num" />
						<input type="hidden" name="page_size" />
						<h3>MY 유학 <span class="depth_txt">></span> <b>유학생활 1:1 대화</b></h3>
						<div class="items"><label class="period"><input type="text" name="search_date" class="daterange" value="" style="width:160px;" readonly /><span></span></label></div>
						<div class="search_box">
							<input type="text" name="search_context" placeholder="Student name, Contents text">
							<input type="button" class="search_btn">
						</div>
					</dd>
					<dd class="new"><button type="button" class="small black"><span>New Counseling</span></button></dd>
				</dl>
			</div>
			<div id="detail_list">
				<div class="sort_option"><div class="inquiry group expand"><div class="sort first"></div></div></div>
				<div class="list">
					<div class="hms_table">
						<table class="tablesorter">
							<colgroup><col style="width:15%;"><col style="width:55%;"><col style="width:10%;"><col style="width:10%;"><col style="width:10%;"><col style="width:35px;"></colgroup>
							<thead><tr><th class="name_record">Name (Branch)</th><th class="qna_record">Contents</th><th class="author_record">Author</th><th class="date_record">Issue Date</th><th class="replynum_record">Reply</th><th class="delete_record"></th></tr></thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
			</div>
			<div id="detail_info">
				<div class="viewbar">
					<h4><b></b></h4>
					<div class="items"><select name="student_name" style="width:200px;"></select></div>
					<div class="close_detail"></div>
				</div>
				<div class="page counseling">
					<div class="contents new">
						<div class="qna_title">
							<h5 class="q">
								<span>Question</span>
								<div class="info"><span></span><span></span></div>
							</h5>
							<div class="qtext"><p></p><button type="button" class="xsmall edit hide"><span>Edit</span></button><button type="button" class="small yellow save hide"><span>Save</span></button></div>
							<h6><span>Answer</span></h6>
						</div>
						<div class="edit_answer"><div class="answer_talk"></div></div>
					</div>
					<div class="create_btn hide">
						<button type="button" class="small cancel" disabled><span>Cancel</span></button>
						<button type="button" class="small blue create" disabled><span>Create</span></button>
					</div>
				</div>
			</div>
		</div>
	</div>