<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<script type="text/javascript">
	var now_year_date = "${serverDate}";
	var param_page_num ,param_page_size, param_page_last;
	
	var content_type = "movie";
	
	$(document).ready(function() {
		param_page_num = 0;
		param_page_size = 30;
		param_page_last = false;
		
		fn_post_tag_list();
		$("#detail_info .page select[name='tag_type']").select2({ minimumResultsForSearch: 20, placeholder: 'Select Tag', dropdownAutoWidth: 'true' });
		
		$.when(fn_content_list()).then(function(){ fn_table_sorter(); });
		
		$("#container .search_box input[type='button']").click(function(){ param_page_last=false; param_page_num = 0; $.when(fn_content_list()).then(function(){ fn_table_sorter(); });  }); // 검색 > 버튼 클릭시
	});
	
	/* 검색박스에서 엔터시 조회되게끔 변경 */
	$(document).on("keypress", "#container .search_box input[name='search_context']", function(){
		param_page_last=false; param_page_num = 0; $.when(fn_content_list()).then(function(){ fn_table_sorter(); }); 
	});
	
	$(document).on('mouseenter','#detail_list .hms_table td',function() { $(this).closest('tr').addClass('hover'); });
	$(document).on('mouseleave','#detail_list .hms_table td',function() { $(this).closest('tr').removeClass('hover'); });
	$(document).on('mouseenter', 'td.delete_record',function(e){ $(this).closest('tr').removeClass('hover'); e.stopPropagation(); });
	$(document).on('click', 'td.delete_record',function(e){ e.stopPropagation(); });
	
	$(window).on('resize', function() { });
	
	/* 게시물 추가 */
	$(document).on("click", "#container .contents .basic .new button", function(){
		$("#detail_info .viewbar h4 b").text("동영상 등록");
		$('#detail_list tbody tr').removeClass('selected');
		$('#container').addClass('expand');
		$('#detail_info').addClass('new');
		$('#detail_info .create_btn button.create').removeClass('hide');
		$('#detail_info .create_btn button.save').addClass('hide');
		setTimeout(function() { $(window).trigger('resize'); }, 100);
		
		fn_input_page_reset();
	});
	
	/* 동영상 URL 추가시 미리보기 동영상 처리 */
	$(document).on("keyup", "#detail_info .page .edit_movie input[name='file_path']", function(){
		var param_url_sp = $(this).val().split("/");
		var param_video_url = param_url_sp[param_url_sp.length -1];
		$("#detail_info .page .edit_movie #youtube_frm").attr("src", "https://www.youtube.com/embed/"+ param_video_url);
	});
	
	/* 추가 및 수정 버튼 클릭시 */
	$(document).on("click", "#detail_info .create_btn .create, #detail_info .create_btn .save", function(){
		var param_inup_type = ($("#detail_info").attr("class") == "new") ? "insert" : "update";
		var param_title = $("#detail_info .page input[name='title']").val();
		var param_preview_text = $("#detail_info .page textarea[name='preview_text']").val();
		var param_file_path_sp = $("#detail_info .page .edit_movie input[name='file_path']").val().split("/");
		var param_file_path = param_file_path_sp[param_file_path_sp.length -1];
		
		var param_tag_list_split = $("#detail_info .contents .form_table select[name='tag_type']").val();
		var param_tag_list = "";
		for(var i=0; i < param_tag_list_split.length; i++){ param_tag_list += (param_tag_list == "") ? param_tag_list_split[i] : ","+ param_tag_list_split[i]; }
		
		var param_content_seq = $("#detail_info .viewbar input[name='param_content_seq']").val();
		var param_view_yn = $("#detail_info .viewbar :checkbox[name='active_post']").is(":checked") ? 1 : 0;
		
		if(param_title == ""){ alert("제목을 입력해 주세요."); return; } 
		if(param_file_path == ""){ alert("동영상 URL을 입력해 주세요."); return; }
		if(param_preview_text == ""){ alert("요약글을 입력해 주세요."); return; }
		
		var param_obj = new Object();
		param_obj["param_inup_type"] = param_inup_type;
		param_obj["param_content_seq"] = param_content_seq;
		param_obj["param_thumbnail_path"] = "";
		param_obj["param_title"] = param_title;
		param_obj["param_tag_list"] = param_tag_list;
		param_obj["param_preview_text"] = param_preview_text;
		param_obj["param_contents"] = "";
		param_obj["param_view_yn"] = param_view_yn;
		param_obj["param_content_type"] = content_type;
		param_obj["param_file_path"] = param_file_path;
		
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/content/save", "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			alert("저장이 완료 되었습니다.");
			$("#detail_info button.cancel").trigger("click");
			$.when(fn_content_list()).then(function(){ fn_table_sorter(); });
		}else{
			alert(obj_result.header.resultMessage);
		}
	});
	
	/* 게시물 선택시 (수정항목) */
	$(document).on('click','#detail_list .hms_table tbody tr',function() {
		if($(this).find("td.nodata").length == 0){
			$("#detail_info .viewbar h4 b").text("동영상 수정");
			
			$('#detail_info').removeClass('new');
			fn_input_page_reset();
			if($(this).hasClass('selected')){
				$("#detail_list .hms_table tbody tr").removeClass('selected');
				$('#container').toggleClass('expand');
			} else{
				$(this).closest('tbody').find('tr').removeClass('selected');
				$(this).addClass('selected');
				$('#container').addClass('expand');
				var param_rtn_seq = $(this).attr("seq");
				$.when(fn_post_detail_movie_reset()).then(function(){ fn_post_list_selected(param_rtn_seq); });
			}
			setTimeout(function() { $(window).trigger('resize'); }, 100);
		}
	});
	
	function fn_post_detail_movie_reset(){ 
		var movie = $("#detail_info .page .edit_movie #youtube_frm").attr("src");
		$("#detail_info .page .edit_movie #youtube_frm").attr("src", movie); 
	}
	
	// 게시물 삭제버튼 클릭시 
	$(document).on("click", ".hms_table button.icon.delete", function(){ 
		var param_rtn_value = $(this).closest("tr").attr("seq");
		dialog.list_delete_confirm_btn($(this), "This item will be deleted. Are you sure?", fn_list_delete_yes, param_rtn_value); 
	});

	/* 취소 버튼클릭시 */
	$(document).on('click','#detail_info button.cancel, #detail_info .close_detail',function() {
		$("#container .tit_area button").prop("disabled", false);
		$("#detail_list .hms_table tbody tr").removeClass('selected');
		$('#detail_info').removeClass('new');
		$('#container').removeClass('expand');

		fn_input_page_reset();
		setTimeout(function() { $(window).trigger('resize'); }, 100);
	});		
	
	function fn_input_page_reset(){
		$("#detail_info .page input[type='text'], #detail_info .page input[type='hidden'], #detail_info .page textarea").val("");
		$("#detail_info .viewbar :checkbox[name='active_post']").prop("checked", false);
		$("#detail_info .page select[name='tag_type']").val([]).trigger("change");
		$("#detail_info .page .edit_movie #youtube_frm").attr("src", "");
	}
	
	function fn_default_set(){
		$("#container .search_box input[name='page_start_num']").val(param_page_num);
		$("#container .search_box input[name='page_size']").val(param_page_size);
	}
	
	function fn_content_list(){
		var no_data = "<tr><td colspan='6' class='nodata' data-guide='No data available!'></td></tr>";
		fn_default_set();
		
		var param_obj = new Object();
		param_obj["search_context"] = $("#container .contents .search_box input[name='search_context']").val();
		param_obj["page_size"] = $("#container .contents .search_box input[name='page_size']").val();
		param_obj["page_start_num"] = $("#container .contents .search_box input[name='page_start_num']").val();
		param_obj["tag_type"] = "";
		
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/content/"+ content_type, "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var insert_table_data = "";
			if(obj_data.length == 0){ 
				param_page_last = true; 
				if(param_page_num == 0){ $("#container #detail_list .list .hms_table .tablesorter tbody").empty().append(no_data); }
				$("#container #detail_list .list .hms_table .tablesorter tbody").append(insert_table_data);
			}else{
				for(var i=0; i < obj_data.length; i++){
					var view_nm = (obj_data[i]["view_yn"] == 1)? "노출" : "비노출" ;  
					
					insert_table_data += "<tr seq='"+ obj_data[i]["site_content_seq"] +"'>";
					insert_table_data += "<td class='title_record left'>"+ obj_data[i]["title"] +"</td>";
					insert_table_data += "<td class='active_record'>"+ view_nm +"</td>";
					insert_table_data += "<td class='author_record'>"+ obj_data[i]["reg_user_nm"] +"</td>";
					insert_table_data += "<td class='date_record'>"+ common_date.convertType(obj_data[i]["reg_ts"],8) +"</td>";
					insert_table_data += "<td class='count_record'>"+ obj_data[i]["view_cnt"] +"</td>";
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
					$.when(fn_content_list()).then(function(){ fn_table_sorter(); });
				}
			}
		});
	}
	
	/*  태그 가지고 오기 */
	function fn_post_tag_list(){
		var param_obj = new Object();
		param_obj["search_context"] = "";
		
		var input_select_box = "";
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/tag", "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			for(var i=0; i < obj_data.length; i++){ if(obj_data[i]["view_yn"] == 1){ input_select_box += "<option value='"+ obj_data[i]["site_tag_seq"] +"'>"+ obj_data[i]["tag_nm"] +"</option>"; }}
		}
		$("#detail_info .page select[name='tag_type']").empty().append(input_select_box);
	}
	
	/* 게시물 선택시 Data View */
	function fn_post_list_selected(param_content_seq){
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/content/detail/"+ param_content_seq, "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){ 
			var obj_data = JSON.parse(obj_result.data);
			$("#detail_info .viewbar input[name='param_content_seq']").val(param_content_seq);
			var tag_list_sp = obj_data[0]["tag_select_list"].split(",");
			var tag_list_arr = new Array();
			for(var i = 0; i < tag_list_sp.length; i++){ tag_list_arr[i] = tag_list_sp[i]; }
			$("#detail_info .page select[name='tag_type']").val(tag_list_arr).select2();
			
			$("#detail_info .page .edit_movie input[name='file_path']").val("https://youtu.be/"+ obj_data[0]["file_path"]);
			$("#detail_info .page .edit_movie #youtube_frm").attr("src", "https://www.youtube.com/embed/"+ obj_data[0]["file_path"]);
			
			$("#detail_info .page .form_table input[name='title']").val(obj_data[0]["title"]);
			$("#detail_info .page .form_table textarea[name='preview_text']").val(obj_data[0]["preview_text"]);
			if(obj_data[0]["view_yn"] == 1){
				$("#detail_info .viewbar :checkbox[name='active_post']").prop("checked", true);
			}else{
				$("#detail_info .viewbar :checkbox[name='active_post']").prop("checked", false);
			}
		}else{
			alert(obj_result.header.resultMessage);
			$.when(fn_content_list()).then(function(){ fn_table_sorter(); });
		}
	}
	
	function fn_list_delete_yes(param_rtn_value){
		var obj_tag_result = JSON.parse(common_ajax.inter("/service/v2/abroad/content/del/"+ param_rtn_value, "json", false, "DELETE", ""));
		if(obj_tag_result.header.isSuccessful == true){ $.when(fn_content_list()).then(function(){ fn_table_sorter(); }); }
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
						<h3>커뮤니티 <span class="depth_txt">></span> <b>동영상</b></h3>
						<div class="search_box">
							<input type="hidden" name="page_start_num" />
							<input type="hidden" name="page_size" />

							<input type="text" name="search_context" placeholder="Contents text">
							<input type="button" class="search_btn">
						</div>
					</dd>
					<dd class="new"><button type="button" class="small black"><span>New Post</span></button></dd>
				</dl>
			</div>
			<div id="detail_list">
				<div class="list">
					<div class="hms_table">
						<table class="tablesorter">
							<colgroup>
								<col style="width:55%;">
								<col style="width:10%;">
								<col style="width:10%;">
								<col style="width:15%;">
								<col style="width:10%;">
								<col style="width:35px;">
							</colgroup>
							<thead>
								<tr>
									<th class="title_record">Title Name</th>
									<th class="active_record">Active</th>
									<th class="author_record">Author</th>
									<th class="date_record">Issue Date</th>
									<th class="count_record">Count</th>
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
					<input type="hidden" name="param_content_seq" />
					<h4><b>동영상</b></h4>
					<div class="items">
						<label class="onoff"><input type="checkbox" name="active_post" /><span>Active</span></label>
					</div>
					<div class="close_detail"></div>
				</div>
				<div class="page youtube">
					<div class="contents">
						<div class="set_input">
							<ul class="form_table">
								<li><div class="cell title"><input type="text" name="title" value="" placeholder="Please enter title" /></div></li>
								<li><div class="cell tag"><select name="tag_type" style="width:100%;" multiple="multiple"></select></div></li>
								<li><textarea name="preview_text" placeholder="Please enter description."></textarea></li>
							</ul>
						</div>
						<div class="edit_movie">
							<div class="url"><input type="text" name="file_path" value="" placeholder="https://youtu.be/(Key Value)"></div>
							<div class="msize">
								<div class="video-wrapper" data-placeholder="Preparing to display the teaching learning contents">
									<iframe src="" id="youtube_frm" name="player" scrolling="no" frameborder="0" width="100%" height="100%" allowfullscreen></iframe>
									<div class="frame_line"><span></span></div>
								</div>
							</div>
						</div>
					</div>
					<div class="create_btn">
						<button type="button" class="small cancel"><span>Cancel</span></button>
						<button type="button" class="small yellow save" ><span>Save</span></button>
						<button type="button" class="small blue create hide" ><span>Create</span></button>
					</div>
				</div>
			</div>
			
		</div>
	</div>