<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
	<script type="text/javascript">
	var now_year_date = "${serverDate}";
	var sel_open_date = "";
	var param_page_num ,param_page_size, param_page_last;
	
	var quill = '';
	var editorType = '';
	var editorChangeTs = '20201127';
	
	$(document).ready(function() {

		param_page_num = 0;
		param_page_size = 30;
		param_page_last = false;
		
		var quill = ''; 
		
		$("#detail_info .page .file_list").empty();

		//fn_popup_editor();
		//fn_get_ir_list();
		
		var start_date = moment(common_date.monthDel(common_date.convertType(now_year_date,4), 12));
		var end_date = moment();
		start_date = '20040101';
		$("#container .search .daterange").daterangepicker({
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
		}, function(start_date, end_date, label) { console.log("New date range selected: " + start_date.format("YYYY.MM.DD") + " to " + end_date.format("YYYY.MM.DD") + " (predefined range: " + label + ")"); });
		
		
		$.when(fn_get_ir_list()).then(function(){ fn_table_sorter(); });
		
		$("#container .search_box input[type='button']").click(function(){ param_page_last=false; param_page_num = 0; $.when(fn_get_ir_list()).then(function(){ fn_table_sorter(); });  }); // 검색 > 버튼 클릭시

		$("#container #detail_info select[name='ir_type']").select2({ placeholder: 'Select Category', minimumResultsForSearch: 20 });
		
		sel_open_date = moment().format("YYYY.MM.DD");
	});
	
	/* 검색박스에서 엔터시 조회되게끔 변경 */
	$(document).on("keypress", "#container .search_box input[name='search_context']", function(){
		param_page_last=false; param_page_num = 0; $.when(fn_get_ir_list()).then(function(){ fn_table_sorter(); }); 
	});

	
	function fn_default_set(){
		$("#container .search input[name='page_start_num']").val(param_page_num);
		$("#container .search input[name='page_size']").val(param_page_size);
	}
	
	/* ir list load */
	function fn_get_ir_list(){
		var no_data = "<tr><td colspan='9' class='nodata' data-guide='No data available!'></td></tr>";

		fn_default_set();

		var obj_result = JSON.parse(common_ajax.inter("/service/v2/ir/list", "json", false, "POST", search.get_ir_parameter("container")));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var insert_table_data = "";
			if(obj_data.length == 0){ 
				param_page_last = true; 
				if(param_page_num == 0){ $("#container #detail_list .list .hms_table .tablesorter tbody").empty().append(no_data); }
				$("#container #detail_list .list .hms_table .tablesorter tbody").append(insert_table_data);
			}else{
				for(var i=0; i < obj_data.length; i++){
					//var param_ir_type_nm = (obj_data[i]["ir_type"] == "IRT004") ? "IR자료실" : (obj_data[i]["ir_type"] == "IRT001") ? "공시정보" : (obj_data[i]["ir_type"] == "IRT002") ? "주가정보" : (obj_data[i]["ir_type"] == "IRT003") ? "재무정보" : "공고" ;
					var param_ir_type_nm = (obj_data[i]["ir_type"] == "IR") ? "IR자료실" : "";//(obj_data[i]["ir_type"] == "IRT001") ? "공시정보" : (obj_data[i]["ir_type"] == "IRT002") ? "주가정보" : (obj_data[i]["ir_type"] == "IRT003") ? "재무정보" : "공고" ;
					var param_ir_active_nm = (obj_data[i]["use_yn"] == 1) ? "노출" : "비노출" ;
					var param_ir_board_seq = obj_data[i]["ir_board_seq"];
					var param_view_start_dt = obj_data[i]["view_start_dt"]
					if(param_view_start_dt.length < 10){
						param_view_start_dt = param_view_start_dt.substr(0, 4) + "." + param_view_start_dt.substr(4, 2) + "." + param_view_start_dt.substr(6, 2);
					}
					var param_input_files;
					var param_cnt = 0;
					var org_reg_ts = obj_data[i]["reg_ts"].replace('.','')
					org_reg_ts = org_reg_ts.replace('.','')
					insert_table_data += "<tr seq='"+ param_ir_board_seq +"' orgRegTs='"+ org_reg_ts +"'>";					
					insert_table_data += "<td class='type_record left'>"+ param_ir_type_nm +"</td>";
					insert_table_data += "<td class='title_record left'>"+ obj_data[i]["title"] +"</td>";					
					insert_table_data += "<td class='date_record'>"+ param_view_start_dt +"</td>";					
					insert_table_data += "<td class='active_record'>"+ param_ir_active_nm +"</td>";
					insert_table_data += "<td class='author_record'>"+ obj_data[i]["reg_user_nm"] +"</td>";
					insert_table_data += "<td class='date_record'>"+ common_date.convertType(obj_data[i]["reg_ts"],10) +"</td>";
					insert_table_data += "<td class='count_record'>"+ obj_data[i]["view_cnt"] +"</td>";
					/*file check*/
					param_cnt = obj_data[i]["cnt"];
					param_input_files = "";
					console.log("file num::"+param_cnt);
					if(param_cnt > 0){	
						var obj_sub_result = JSON.parse(common_ajax.inter("/service/v2/ir/file/list/"+param_ir_board_seq, "json", false, "GET", ""));
						if(obj_sub_result.header.isSuccessful == true){
							var obj_sub_data = JSON.parse(obj_sub_result.data);
							for(var j=0; j < obj_sub_data.length; j++){
								param_input_files += "<input type='hidden' id='filenm_"+param_ir_board_seq+"_"+j+"' value='"+obj_sub_data[j]["file_nm"]+"' />";
								param_input_files += "<input type='hidden' id='filepath_"+param_ir_board_seq+"_"+j+"' value='"+obj_sub_data[j]["file_path"]+"' />";					
							}
							param_input_files += "<a href='javascript:downloadFile(\""+ param_ir_board_seq +"\")'>Download</a> "
							insert_table_data += "<td class='file_record'>"+ param_input_files +"</td>";		
						}else{
							insert_table_data += "<td class='file_record'>-</td>";								
						}
					}else{
						insert_table_data += "<td class='file_record'>-</td>";							
					}
					//insert_table_data += "<td class='delete_record'><button title='Delete' class='icon delete' onclick='fn_del_ir("+obj_data[i]["ir_board_seq"]+");'><span>Delete</span></button></td>";
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
	
	function downloadFile(seq){
		var param_file_name = "";
		var param_file_path = "";
		var sel_filename_list = $("#detail_list .list .hms_table .tablesorter tbody").find("input[id^=filenm_"+seq+"]");
		var sel_filepath_list = $("#detail_list .list .hms_table .tablesorter tbody").find("input[id^=filepath_"+seq+"]");
		console.log("seq:"+seq+"|fname size:"+sel_filename_list.length+"|fpath size:"+sel_filepath_list.length);
		
		for(var i=0; i < sel_filename_list.length; i++){
			param_file_name += (param_file_name == "") ? sel_filename_list[i].value : ","+sel_filename_list[i].value;
			param_file_path += (param_file_path == "") ? sel_filepath_list[i].value : ","+sel_filepath_list[i].value;
			console.log("param_file_name:"+param_file_name+"||param_file_path:"+param_file_path);
		}

		var url = "/lib/v2/downloads?file_path="+ param_file_path +"&file_nm="+ encodeURI(encodeURIComponent(param_file_name));
		//var url = "http://beta-download.gojls.com/open/downloads?filepath="+ param_file_path +"&filename="+ encodeURI(encodeURIComponent(param_file_name));
		window.open(url);
	}
	
	/* new post */
	function new_post() {
		
		$('.edit_news').children().remove();
		$('.edit_news').append('<div id="paper_editor"></div>');
		
		fn_popup_editor_quill();
		editorType = 'quill';
		
		
		$('#detail_list tbody tr').removeClass('selected');
		$('#container').addClass('expand');	
		$('#detail_info').addClass('new');
		$('#detail_info .create_btn button.create').removeClass('hide');
		$('#detail_info .create_btn button.save').addClass('hide');		
		$('#detail_info #view_open_date').val("");
		$("#detail_info .page .form_table input[name='title']").val("");
		$("#detail_info .page ul.file_list").empty();
		//$('#paper_editor').summernote('code','');
		$('#view_open_date').val(sel_open_date);
		$("#detail_info").attr("seq", "");
		
		setTimeout(function() {
			$(window).trigger('resize');
		}, 100);
		fn_popup_editor_modi();
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
					$.when(fn_get_ir_list()).then(function(){ fn_table_sorter(); });
				}
			}
		});
	}
	
	$(document).on("mouseenter","#detail_list .hms_table td",function() { $(this).closest("tr").addClass("hover"); });
	$(document).on("mouseleave","#detail_list .hms_table td",function() { $(this).closest("tr").removeClass("hover"); });
	$(document).on("click", "td.file_record",function(e){ e.stopPropagation(); });
	$(document).on("click", "td.delete_record",function(e){ e.stopPropagation(); });
	$(document).on("mouseenter", "td.file_record",function(e){ $(this).closest("tr").removeClass("hover"); e.stopPropagation(); });
	$(document).on("mouseenter", "td.delete_record",function(e){ $(this).closest("tr").removeClass("hover"); e.stopPropagation(); });
	
	/* sort 조건 눌렀을때 */
	$(document).on("click", "#detail_list .sort input:checkbox", function(){
		param_page_last=false; param_page_num = 0; $.when(fn_get_ir_list()).then(function(){ fn_table_sorter(); });
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
		
		var param_ir_board_seq = $("#container #detail_info").attr("seq");
		var param_ir_type = $("#ir_type").val();
		var param_view_start_dt = $("#view_open_date").val();
		if(param_view_start_dt.length > 8){
			param_view_start_dt = param_view_start_dt.replace(/ /gi, '').replace(/\./g, '');
		}
		var param_use_yn = 0;	
		if($("#use_yn").is(":checked")){
			param_use_yn = 1;
		}else{
			param_use_yn = 0;
		}		
		var param_inup_type = ($("#detail_info").attr("class") == "new") ? "insert" : "update";		
		var param_title = $("#detail_info .page .form_table input[name='title']").val();
		//var param_content = $('#paper_editor').summernote('code');
		
		var param_editor_text = '';
		if ( editorType == 'quill'){
			param_editor_text = JSON.stringify(quill.getContents())
		}else{
			param_editor_text = $('#paper_editor').summernote('code');
			if(param_editor_text.substring(0,4) != "<div"){ param_editor_text = "<div style='width:100%;text-align:left;'>"+ param_editor_text +"</div>"; }
		}
		
		if(param_editor_text.indexOf("note-video-clip") > -1){ param_editor_text = param_editor_text; }
		if(param_ir_board_seq == undefined || param_ir_board_seq == ""){
			param_ir_board_seq = 0;				
		}
		console.log(param_use_yn+"||param_ir_board_seq:"+param_ir_board_seq+"||param_ir_type:"+param_ir_type+"||param_view_start_dt:"+param_view_start_dt+"||param_title:"+param_title);
		
		if(param_ir_type == ""){ alert("게시물 종류를 선택해 주세요."); return; }
		if(param_view_start_dt == ""){ alert("게시일자를 선택해 주세요."); return; }
		if(param_title == ""){ alert("제목을 입력해 주세요."); return; }
		if(param_editor_text == ""){ alert("내용을 입력해 주세요."); return; }
		
		var param_obj = new Object();		
		param_obj["param_ir_board_seq"] = param_ir_board_seq;
		param_obj["param_ir_type"] = param_ir_type;
		param_obj["param_view_start_dt"] = param_view_start_dt;
		param_obj["param_use_yn"] = param_use_yn;
		param_obj["param_title"] = param_title;
		param_obj["param_editor_text"] = param_editor_text;
		param_obj["param_inup_type"] = param_inup_type;

		var param_files = $("#detail_info .page .form_table .file_list li");
		var param_file_seq = "";
		var sel_file_Seq = "";
		var param_file_path = "";
		var param_file_nm = "";
		for(var i=0; i < param_files.length; i++){
			sel_file_Seq = param_files.eq(i).attr("seq"); 
			if(sel_file_Seq != undefined){
				param_file_seq += (param_file_seq == "") ? sel_file_Seq : ","+sel_file_Seq;				
			}else{
				param_file_seq += (param_file_seq == "") ? "0" : ",0";				
			}
			param_file_path += (param_file_path == "") ? param_files.eq(i).find(".file_path").text() : ","+param_files.eq(i).find(".file_path").text();
			param_file_nm += (param_file_nm == "") ? param_files.eq(i).find(".file_nm").text() : ","+param_files.eq(i).find(".file_nm").text();
		}
		param_obj["param_file_seq"] = param_file_seq;
		param_obj["param_file_path"] = param_file_path;
		param_obj["param_file_nm"] = param_file_nm;
		console.log("seq::"+param_file_seq+"||param_file_nm::"+param_file_nm);
		
		
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/ir/save", "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			alert("저장이 완료 되었습니다.");
			param_page_last=false; param_page_num = 0;
			$.when(fn_get_ir_list()).then(function(){ fn_table_sorter(); });

			$('#detail_list tbody tr').removeClass('selected');
			$('#container').removeClass('expand');
			$("#detail_info").attr("seq", "");
						
			setTimeout(function() { $(window).trigger("resize"); }, 100);
		}else{
			alert(obj_result.header.resultMessage);
		}
	});
	
	/* 첨부파일 팝업창 클릭 */
	function fn_lib_file_upload_open() {
		$("#pop_upload, .black_bg").fadeIn();
		$("#pop_upload #if_assessment").attr("src", "/v2/popup/lib_jquery_open_file_upload");
	}

	/* 첨부파일 리턴값 */
	function fn_lib_file_upload_return(param_rtn_data){
		console.log("file upload ok||"+param_rtn_data);		
		var param_inup_type = $("#detail_info").attr("class");		
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
			if(param_inup_type != "new"){
				$("#detail_info .create_btn button.save").prop("disabled",false);
			}
		}
		$("#pop_upload").fadeOut();
		$('.white_bg, .black_bg, .layer_bg').fadeOut();
		$('.pop').removeAttr('style');
	}
	
	/* 입력 수정 화면에서 첨부파일 삭제시 */
	$(document).on("click", "#detail_info .page ul.file_list li .del" , function(){ 
		var selseq = $(this).parents("li").attr("seq");
		if(selseq != undefined && selseq != null){
			fn_del_ir_file(selseq);
		}else{		
			$("#detail_info .page ul.file_list li").eq($(this).closest("li").index()).remove();			
		} 
	});

	
	/* 목록에서 삭제버튼 눌렀을때 */
	$(document).on("click", "#detail_list .hms_table tr td.delete_record button.delete", function() {
		var param_rtn_value = $(this).closest("tr").attr("seq");
		dialog.list_delete_confirm_btn($(this), "This item will be deleted. Are you sure?", fn_del_ir, param_rtn_value); 
	});

	function fn_del_ir(param_ir_board_seq){
		console.log("param_ir_board_seq::"+param_ir_board_seq);
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/ir/del/"+param_ir_board_seq+"/0", "json", false, "DELETE", ""));
		if(obj_result.header.isSuccessful == true){
			$.when(fn_get_ir_list()).then(function(){ fn_table_sorter(); });
		}else{
			alert(obj_result.header.resultMessage);
		}
	}

	function fn_del_ir_file(param_ir_board_file_seq){
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/ir/del/0/"+ param_ir_board_file_seq, "json", false, "DELETE", ""));
		if(obj_result.header.isSuccessful == true){
			$("#detail_info .page ul.file_list").find("li[seq="+param_ir_board_file_seq+"]").remove();
			$.when(fn_get_ir_list()).then(function(){ fn_table_sorter(); });
		}else{
			alert(obj_result.header.resultMessage);
		}
	}
	 
	/* 게시된 글을 선택시 */
	$(document).on('click','#detail_list .hms_table tbody tr',function() {
		
		$('.edit_news').children().remove();
		$('.edit_news').append('<div id="paper_editor"></div>');
		
		$('#detail_info').removeClass('new');
		$('#detail_info .viewbar #edittitle>b').text('리포트 내용');
		
		if($(this).hasClass('selected')){
			$(this).toggleClass('selected');
			$('#container').toggleClass('expand');
			$("#container #detail_info").attr("seq", "");
		}else{
			$(this).closest('tbody').find('tr').removeClass('selected');
			$(this).addClass('selected');
			$("#container #detail_info").attr("seq", $(this).attr("code"));
			$('#container').addClass('expand');
			//
			//$('#paper_editor').summernote('code', "");
			//
			
			$("#detail_info .page ul.file_list").empty();	
			$("#container #detail_info .create_btn button.create").addClass("hide");
			$("#container #detail_info .create_btn button.save").removeClass("hide");
			
			fn_get_ir_view($(this).attr("seq"), $(this).attr("orgRegTs"));
		}
		setTimeout(function() { $(window).trigger('resize'); }, 100);
		fn_popup_editor_modi();
	});
	
	// 게시글 클릭했을때
	function fn_get_ir_view(param_ir_board_seq, orgRegTs){
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/ir/view/"+ param_ir_board_seq, "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var sel_ir_board_seq = 0;
			var sel_ir_board_file_seq = 0;
			var sel_ir_type = "";
			var sel_view_start_dt = "";
			var sel_title = "";
			var sel_content = "";
			var sub_file_list = obj_data[0]["file_list"];
			var param_file_info = "";

			sel_ir_board_seq = obj_data[0]["ir_board_seq"];
			sel_ir_type = obj_data[0]["ir_type"];
			sel_title = obj_data[0]["title"]; 
			sel_view_start_dt = obj_data[0]["view_start_dt"];
			if(sel_view_start_dt.length < 10){
				sel_view_start_dt = sel_view_start_dt.substr(0, 4) + "." + sel_view_start_dt.substr(4, 2) + "." + sel_view_start_dt.substr(6, 2);
				$('#view_open_date').val(sel_view_start_dt);
			}
			console.log("sel_ir_board_seq::"+sel_ir_board_seq);
			console.log("sel_view_start_dt::"+sel_view_start_dt);
			console.log("file list cnt ::"+sub_file_list.length);

			$("#detail_info").attr("seq", sel_ir_board_seq);
			$("#detail_info .viewbar .items select[name='ir_type']").val(sel_ir_type).trigger("change");			
			$('#view_open_date').daterangepicker({
				singleDatePicker: true,
				autoUpdateInput: false,
				opens: 'left',
				locale: {
					format: 'YYYY.MM.DD',
					cancelLabel: 'Cancel'
				}
			});
			$('#view_open_date').on('apply.daterangepicker', function(ev, picker) {
				$(this).val(picker.startDate.format('YYYY.MM.DD'));
			});
			$('#view_open_date').on('cancel.daterangepicker', function(ev, picker) {
				$(this).val('');
			});
			$('#view_open_date').on('showCalendar.daterangepicker', function(ev, picker) {
				if (picker.element.offset().top - $(window).scrollTop() + picker.container.outerHeight() > $(window).height()) {
					return picker.drops = 'up';
				} else {
					return picker.drops = 'down';
				}
			});
			$("#detail_info .page .form_table input[name='title']").val(sel_title);

			if(sub_file_list.length > 0){
				for(var i=0; i < sub_file_list.length; i++){
					param_file_info += "<li seq="+sub_file_list[i]["ir_board_file_seq"]+">";
					param_file_info += "<span class='file_path hide'>"+ sub_file_list[i]["file_path"] +"</span>";
					param_file_info += "<span class='name file_nm'><a href='/lib/v2/download?file_path="+ sub_file_list[i]["file_path"] +"&file_nm="+ sub_file_list[i]["file_nm"] +"'>"+ sub_file_list[i]["file_nm"] +"</a></span>";
					param_file_info += "<span class='del'></span>";
					param_file_info += "</li>";
					
				}
				$("#detail_info .page ul.file_list").empty().append(param_file_info);
			}else{
				$("#detail_info .page ul.file_list").empty();				
			}
			
			//$('#paper_editor').summernote('code', obj_data[0]["editor_txt"]);
			//var ct = obj_data[0]["editor_txt"];

			if ( orgRegTs >= editorChangeTs){
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
			
			fn_popup_editor_modi();
		}
	}
	</script>
	
	
	
	<div id="container">
		<div class="tit_area">
			<h3>IR Library</h3>
			<div class="search">
				<div class="items">
					<input type="hidden" name="page_start_num" />
					<input type="hidden" name="page_size" />
					<label class="period"><input type="text" name="search_date" class="daterange" value="" style="width:190px;" readonly /><span></span></label>
				</div>
				<div class="search_box">
					<input type="text" name="search_context" placeholder="Author, Title text">
					<input type="button" class="search_btn">
				</div>
			</div>
			<button type="button" class="black" onclick="new_post();" /><span>New Post</span></button>
		</div>
		<div id="detail_list">
			<div class="sort_option">
				<div class="inquiry expand">
					<div class="sort first">
					<h5>Board Type</h5>
						<label><input type="checkbox" name="search_type" value="IR" checked><span>IR자료실</span></label>
						<!--<label><input type="checkbox" name="search_type" value="IRT001"><span>공시정보</span></label>
						<label><input type="checkbox" name="search_type" value="IRT002"><span>주가정보</span></label>
						<label><input type="checkbox" name="search_type" value="IRT003"><span>재무정보</span></label>
						<label><input type="checkbox" name="search_type" value="IRT005"><span>공고</span></label>-->
					</div>
				</div>
			</div>
			<div class="list">
				<div class="hms_table">
					<table class="tablesorter">
						<colgroup>
							<col style="width:10%;">
							<col style="width:40%;">
							<col style="width:8%;">							
							<col style="width:8%;">
							<col style="width:8%;">
							<col style="width:8%;">
							<col style="width:8%;">
							<col style="width:10%;">
							<col style="width:35px;">
						</colgroup>
						<thead>
							<tr>
								<th class="type_record">Type</th>
								<th class="title_record">Title</th>
								<th class="date_record">Open Date</th>
								<th class="active_record">Active</th>
								<th class="author_record">Author</th>
								<th class="date_record">Issue Date</th>
								<th class="count_record">Count</th>
								<th class="file_record">Files</th>
								<th class="delete_record"></th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
		</div>


	
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
	    Quill.register({
	    	'modules/better-table': quillBetterTable
	    	, Font
			}, true)  
		quill = new Quill('#paper_editor', {
			theme: 'snow',
		    modules: {
		    	toolbar: [
				      [{ 'font': ['nanumgothic', 'malgungothic', 'gulim', 'dotum'] }, { 'size': [] }],
				      ['bold', 'italic', 'underline', 'strike'],
				      [{ 'script': 'sub'}, { 'script': 'super' }], 
				      [{ 'color': []}, { 'background': []}],   
				      [{ 'list': 'bullet' }, { 'list': 'ordered'},{ 'align': [] } ],
				      [ 'link', 'image', 'video', 'formula' ],
				      ['table'] 
				    ],
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
			tableModule = quill.getModule('better-table')
			tableModule.insertTable(3, 3)
		}); 
	
		if ( $('.qlbt-col-tool').length > 0 ) {
			$('.qlbt-col-tool').remove();
		}
	}
	
	function fn_popup_editor_modi(){
		$("#paper_editor .dropdown-fontname li a").removeClass("checked");
		$("#paper_editor .dropdown-fontname li:eq(0) a").addClass("checked");
		$("#paper_editor .note-current-fontname").text($(".dropdown-fontname li:eq(0) a").attr('data-value'));
		
		
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
	
	</script>
		<div id="detail_info">
			<div class="viewbar">
				<h4 id="edittitle"><b>Edit Library</b></h4>
				<div class="items">
					<select id="ir_type" style="width:230px;" tabindex="-1" class="select2-hidden-accessible" aria-hidden="true">						
						<option value="IR" selected>IR자료실</option>
						<!--<option value="IRT001">공시정보</option>
						<option value="IRT002">주가정보</option>
						<option value="IRT003">재무정보</option>
						<option value="IRT005">공고</option>-->
					</select>
					<script type="text/javascript">
					$(document).ready(function() {
						$('#ir_type').select2({
							placeholder: 'IR Type',
							minimumResultsForSearch: 20
						});
					});
					</script>			
				</div>
				<h4><b>오픈일자</b></h4>
				<div class="items">
					<label class="period"><input type="text" class="daterange" id="view_open_date" value="" style="width:120px" readonly /><span></span></label>
					<script type="text/javascript">
					$(document).ready(function() {
						$('#view_open_date').daterangepicker({
							singleDatePicker: true,
							autoUpdateInput: false,
							opens: 'left',
							locale: {
								format: 'YYYY.MM.DD',
								cancelLabel: 'Cancel'
							}
						});
						$('#view_open_date').on('apply.daterangepicker', function(ev, picker) {
							$(this).val(picker.startDate.format('YYYY.MM.DD'));
						});
						$('#view_open_date').on('cancel.daterangepicker', function(ev, picker) {
							$(this).val('');
						});
						$('#view_open_date').on('showCalendar.daterangepicker', function(ev, picker) {
							if (picker.element.offset().top - $(window).scrollTop() + picker.container.outerHeight() > $(window).height()) {
								return picker.drops = 'up';
							} else {
								return picker.drops = 'down';
							}
						});
					
					});
					</script>
				</div>
				<label class="onoff"><input id="use_yn" type="checkbox" checked><span></span></label>
				<div class="close_detail"></div>
			</div>
			<div class="page ir">
				<div class="contents">
					<div class="set_input">
						<ul class="form_table">
							<li>
								<div class="cell title">
									<input type="text" name="title" value="" placeholder="Please enter title" />
								</div>
							</li>
							<li>
								<div class="cell file">
									<h6>
										<span>Attachments</span>
										<button type="button" class="xsmall blue attach" onclick="fn_lib_file_upload_open();"><span>Upload file</span></button>
									</h6>
									<ul class="file_list"><li><span class="name">정상JLS 제26기 재무상태표 공고.pdf</span><span class="del"></span></li></ul>
								</div>
							</li>
						</ul>
						<div class="tip">
							<p><b>How to use editor</b> : 표 영역을 선택한 후 마우스 우클릭을 하면 표의 셀 합치기, 표안의 텍스트 정렬을 하실 수 있습니다.</p>
						</div>
					</div>
					<div class="edit_news">
						<div id="paper_editor"></div>
					</div>
				</div>
				<div class="create_btn">
					<button type="button" class="small cancel" disabled><span>Cancel</span></button>
					<button type="button" class="small yellow save" disabled><span>Save</span></button>
					<button type="button" class="small blue create"><span>Create</span></button>
				</div>
			</div>
		</div>
	</div>