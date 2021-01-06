<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

	<script type="text/javascript">
	var now_year_date = "${serverDate}";
	$(document).ready(function() {
		$.when(fn_main_banner_list()).then(function(){ fn_table_sortable(); });
		
		$("p[contenteditable]").keydown(function(e){ if (e.keyCode === 13) { document.execCommand('insertHTML', false, '<br>'); return false; } }); // contenteditable 일때 꼭 넣어주기 
	});
	
	function fn_main_banner_list(){
		var no_data = "<li class='dd-item dd3-item' data-type='table-row' data-id='1000'><div class='dd3-content'><h4><span class='title_record'>No data available!</span></h4></div></li>";
		
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/banner", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var insert_table_data = "";
			var parent_menu_code = 0;
			if(obj_data.length > 0){ 
				for(var i=0; i < obj_data.length; i++){

					var param_status_stamp = "";
					if(obj_data[i]["status"] == 1){
						param_status_stamp = "<span class='status receipt' title='모집중'>모집중</span>";
					}else if(obj_data[i]["status"] == 2){
						param_status_stamp = "<span class='status imminent' title='마감임박'>마감임박</span>";
					}else if(obj_data[i]["status"] == 3){
						param_status_stamp = "<span class='status finish' title='마감'>마감</span>";
					}else if(obj_data[i]["status"] == 4){
						param_status_stamp = "<span class='status prepare' title='모집준비중'>모집준비중</span>";
					}else if(obj_data[i]["status"] == 5){
						param_status_stamp = "<span class='status spot' title='수시모집'>수시모집</span>";
					}
					var param_view_yn = (obj_data[i]["view_yn"] == 0)? "비노출" : "노출";
					var param_reg_ts = (obj_data[i]["reg_ts"] == "18000101") ? "" : common_date.convertType(obj_data[i]["reg_ts"],8);
					
					insert_table_data += "<li json_code='"+ JSON.stringify(obj_data[i]) +"' class='dd-item dd3-item' data-type='table-row' data-id='"+ obj_data[i]["menu_banner_seq"] +"'>";
					insert_table_data += "<div class='dd3-content'><div class='dd-handle dd3-handle'>Drag</div><h4>";
					insert_table_data += "<span class='title_record left'>"+ obj_data[i]["title"].replace(/<br>/g," ") +"</span>";
					insert_table_data += "<span class='status_record'>"+ param_status_stamp +"</span>";
					insert_table_data += "<span class='active_record'>"+ param_view_yn +"</span>";
					insert_table_data += "<span class='author_record'>"+ obj_data[i]["reg_user_nm"] +"</span>";
					insert_table_data += "<span class='date_record'>"+ param_reg_ts +"</span>";
					insert_table_data += "</h4></div></li>";
					
				}
				$("#container #detail_list #nestable ol").empty().append(insert_table_data);
			}else{
				$("#container #detail_list #nestable ol").empty().append(no_data);
			}
		}else{
			$("#container #detail_list #nestable ol").empty().append(no_data);
		}
	}
	
	function fn_table_sortable(){
		var updateOutput = function(e) {
	        var list = e.length ? e : $(e.target), output = list.data('output');
	        if(window.JSON) {
	        	var sort_execute_yn = true;
	        	var list_arr = list.nestable('serialize');
	        	for(var i=0; i < list_arr.length; i++){ if(list_arr[i]["id"] == 0){ sort_execute_yn = false; break; } }
	        	if(sort_execute_yn){
			        var param_save_obj = new Object();
			        param_save_obj["data"] = list.nestable('serialize');

			    	var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/banner/sort", "json", false, "POST", param_save_obj));
			    	if(obj_result.header.isSuccessful == false){ alert(obj_result.header.resultMessage); }
	        	}else{
	        		alert("데이터를 전체 수정을 하신후에 정렬을 해주시기 바랍니다.");
	        		fn_main_banner_list();
	        	}
	        }
	    };
	    
		$('#nestable').nestable({ maxDepth: '1' }).on('change', updateOutput);
	}
	
	/* 게시물 선택시 */
	$(document).on('click','.dd3-content',function() {
		if($(this).hasClass('selected')){
			$(this).toggleClass('selected');
			$('#container').toggleClass('expand');
		} else{
			$(this).closest('.dd').find('.dd3-content').removeClass('selected');
			$(this).addClass('selected');
			$('#container').addClass('expand');
			
			var param_select_data = JSON.parse($(this).closest("li").attr("json_code"));
			$("#detail_info .viewbar input[name='param_banner_seq']").val(param_select_data["menu_banner_seq"]);
			$("#detail_info .viewbar input[name='param_menu_seq']").val(param_select_data["menu_seq"]);
			$("#detail_info .viewbar input[name='param_order_num']").val($(this).closest("li").index()+1);
			$("#detail_info .academy_program p").html(param_select_data["title"]);
			$("#detail_info .academy_program .thumb img").attr('src', param_select_data["img_path"]);
			$("#detail_info .viewbar select[name='param_status']").val(param_select_data["status"]);
			if(param_select_data["view_yn"] == "0"){
				$("#detail_info .viewbar :checkbox[name='param_use_yn']").prop("checked", false);
			}else{
				$("#detail_info .viewbar :checkbox[name='param_use_yn']").prop("checked", true);
			}
			
			$("#detail_info .viewbar select[name='param_status']").select2({ placeholder: 'Status Type', minimumResultsForSearch: 20 });
		}
	});
	
	$(document).on('click','#detail_info button.cancel, #detail_info .close_detail',function() {
		$('#detail_list .dd3-content').removeClass('selected');
		$('#container').removeClass('expand');
		$(window).trigger('resize');
	});
	
	$(document).on('click','#detail_info button.save',function() {
		var param_status = $("#detail_info .viewbar select[name='param_status'] option:selected").val();
		var param_img_path = $("#detail_info .academy_program .thumb img").attr('src');
		var param_title = $("#detail_info .academy_program p").html();
		
		if(param_status == "" || param_status == undefined){ alert("모집 상태를 선택해 주세요."); return; }
		if(param_img_path == "" || param_img_path == undefined){ alert("모집 이미지를 저장해 주세요."); return; }
		if(param_status == "" || param_status == undefined){ alert("모집 제목을 입력해 주세요."); return; }
		
		var param_banner_seq = $("#detail_info .viewbar input[name='param_banner_seq']").val();
		var param_menu_seq = $("#detail_info .viewbar input[name='param_menu_seq']").val();
		var param_order_num = $("#detail_info .viewbar input[name='param_order_num']").val();
		var param_view_yn = ($("#detail_info .viewbar .onoff :checkbox[name='param_use_yn']").is(":checked")) ? 1 : 0;
		
		var param_obj = new Object();
		param_obj["param_banner_seq"] = param_banner_seq;
		param_obj["param_menu_seq"] = param_menu_seq;
		param_obj["param_order_num"] = param_order_num;
		param_obj["param_status"] = param_status;
		param_obj["param_img_path"] = param_img_path;
		param_obj["param_title"] = param_title;
		param_obj["param_view_yn"] = param_view_yn;

		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/banner", "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			alert("저장이 완료 되었습니다.");
			$.when(fn_main_banner_list()).then(function(){ fn_table_sortable(); });
			$('#container').toggleClass('expand');
		}else{
			alert(obj_result.header.resultMessage);
		}
	});

	/* 썸네일 받기 */
	function fn_popup_thumb_image_return(thumb_image_path){ $("#detail_info .academy_program .thumb img").attr("src", thumb_image_path); }

	</script>
	
	<div id="container">
		<div class="browser sidebar expand">
			<div class="burger_icon"><span></span></div>
			<h3>Study Abroad</h3>
			<div class="scroll"><jsp:include page="../layout/abroad_menu.jsp" flush="true" /></div>
		</div>
		<div class="contents">
			<div class="basic">
				<dl class="">
					<dd class="name"><h3>기본설정 <span class="depth_txt">></span> <b>프로그램 모집 관리(Main Page)</b></h3></dd>
				</dl>
			</div>
			<!-- list area -->
			<div id="detail_list">
				<div class="list">
					<div class="nestable_header">
						<table>
							<colgroup>
								<col style="width:40%">
								<col style="width:15%;">
								<col style="width:15%;">
								<col style="width:15%;">
								<col style="width:15%;">
							</colgroup>
							<thead>
								<tr>
									<th class="title_record"><span>Program Name</span></th>
									<th class="status_record"><span>Status</span></th>
									<th class="active_record"><span>Active</span></th>
									<th class="author_record"><span>Author</span></th>
									<th class="date_record"><span>Issue Date</span></th>
								</tr>
							</thead>
						</table>
					</div>
					<div class="dd" id="nestable"><ol class="dd-list"></ol></div>
				</div>
			</div>
			
			<!-- info area -->
			<div id="detail_info">
				<div class="viewbar">
					<h4><b>모집 관리 수정</b></h4>
					<div class="items">
						<input type="hidden" name="param_banner_seq" />
						<input type="hidden" name="param_menu_seq" />
						<input type="hidden" name="param_order_num" />
						
						<select name="param_status" style="width:90px;">
							<option value="4">모집준비중</option>
							<option value="1">모집중</option>
							<option value="5">수시모집</option>
							<option value="2">마감임박</option>
							<option value="3">마감</option>
						</select>
					</div>
					<div class="items"><label class="onoff"><input type="checkbox" name="param_use_yn" /><span>Active</span></label></div>
					<div class="close_detail"></div>
				</div>
				<div class="page">
					<div class="contents edit">
						<div class="edit_banner">
							<div class="section">
								<ul class="academy_program">
									<li>
										<div class="thumb">
											<span><img src=""></span>
											<button type="button" class="select_img" onclick="fn_thumbnail_img_upload('abroad_banner');"><span></span></button>
										</div>
										<p contenteditable="true" data-placeholder="Title"></p>
									</li>
								</ul>
							</div>
						</div>
					</div>
					<div class="create_btn">
						<button type="button" class="small cancel"><span>Cancel</span></button>
						<button type="button" class="small yellow save"><span>Save</span></button>
					</div>
				</div>
			</div>
			
		</div>
	</div>
