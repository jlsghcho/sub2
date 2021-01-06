<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<script type="text/javascript">
	var now_year_date = "${serverDate}";
	var param_page_num ,param_page_size, param_page_last;
	
	var content_type = "gallery";
	var param_image_data = [];
	var param_tag_data;
	
	//Dropzone.autoDiscover = false;
	
	$(document).ready(function() {
		param_page_num = 0;
		param_page_size = 30;
		param_page_last = false;
		
		fn_post_tag_list();
		
		$("#detail_info .page select[name='tag_type']").select2({ minimumResultsForSearch: 20, placeholder: 'Select Tag', dropdownAutoWidth: 'true' });
		
		param_image_data = [];
		$("#dropzone").dropzone({ 
			url: "/lib/v2/dropzone/upload"
			, method : "POST"
			, init: function() {
				this.on("success", function(file, response) {
					var obj_result = JSON.parse(response);
					if(obj_result.header.isSuccessful == true){
						var obj_data = JSON.parse(obj_result.data);
						param_image_data.push(obj_data["file_url_domain"] + obj_data["file_full_path"]);
						$("#dropzone").find("span").hide();
					}else{
						alert(obj_result.header.resultMessage);
					}
				});
			}
		});
		
		$.when(fn_content_list()).then(function(){ fn_table_sorter(); });
	});
	
	/* 게시물 추가 */
	$(document).on("click", "#container .contents .basic .new button", function(){
		$("#detail_info .viewbar h4 b").text("갤러리 등록");
		
		$('#detail_list tbody tr').removeClass('selected');
		$('#container').addClass('expand');
		$('#detail_info').addClass('new');
		$('#detail_info .create_btn button.create').removeClass('hide');
		$('#detail_info .create_btn button.save').addClass('hide');
		setTimeout(function() { $(window).trigger('resize'); }, 100);
		
		fn_input_page_reset();
	});
	
	/* 드랍좀에서 마우스 오버 관련 */
	$(document).on('mouseover', '#dropzone .dz-preview', function(){ $(this).find(".dz-details div, .dz-details span").css('display',''); });
	$(document).on('mouseout', '#dropzone .dz-preview', function(){ $(this).find(".dz-details div,.dz-details span").css('display','none'); });
	
	/* 취소 버튼클릭시 */
	$(document).on('click','#detail_info button.cancel, #detail_info .close_detail',function() {
		$("#container .tit_area button").prop("disabled", false);
		$("#detail_list .hms_table tbody tr").removeClass('selected');
		$('#detail_info').removeClass('new');
		$('#container').removeClass('expand');

		fn_input_page_reset();
		resize_sorth();
	});
	
	/* 추가 버튼 클릭시 */
	$(document).on("click", "#detail_info .create_btn .create", function(){
		var param_tag_list_split = $("#detail_info .contents .form_table select[name='tag_type']").val();
		var param_tag_list = "";
		for(var i=0; i < param_tag_list_split.length; i++){ param_tag_list += (param_tag_list == "") ? param_tag_list_split[i] : ","+ param_tag_list_split[i]; }
		
		if(param_tag_list == ""){ alert("태그를 선택해 주세요."); return; } 
		if(param_image_data.length == 0){ alert("갤러리에 등록할 이미지를 넣어주세요."); return; }
		
		var param_image_data_string = "";
		for(var i=0; i < param_image_data.length; i++){ param_image_data_string += (param_image_data_string == "") ? param_image_data[i] : ","+ param_image_data[i]; }
		
		var param_obj = new Object();
		param_obj["param_inup_type"] = "insert";
		param_obj["param_content_seq"] = "";
		param_obj["param_thumbnail_path"] = param_image_data_string;
		param_obj["param_title"] = "";
		param_obj["param_tag_list"] = param_tag_list;
		param_obj["param_preview_text"] = "";
		param_obj["param_contents"] = "";
		param_obj["param_view_yn"] = 1;
		param_obj["param_content_type"] = content_type;
		param_obj["param_file_path"] = "";
		
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/content/save", "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			alert("저장이 완료 되었습니다.");
			$("#detail_info button.cancel").trigger("click");
			$.when(fn_content_list()).then(function(){ fn_table_sorter(); });
		}else{
			alert(obj_result.header.resultMessage);
		}
	});
	
	/* 갤러리 수정버튼 클릭시  */
	$(document).on('click', '.gallery .set button.edit',function() {
		// 다른쪽에 에디터가 있는지 찾아서 지워준다.
		var param_this_index = $(this).closest("li").index();
		$(this).closest("ul").find("li:not(:eq("+ param_this_index +")) .edit_layer").remove();
		$(this).closest("ul").find("li:not(:eq("+ param_this_index +")) .real button.edit").removeClass("hide");
		
		var param_edit_layer = "<div class='edit_layer' seq='"+ $(this).closest("li").attr("seq") +"'>";
		param_edit_layer += "<ol class='form_table'><li><div class='cell tag'><select id='select_tag_edit' name='tag_type' style='width:100%;' multiple='multiple'>";
		
		var param_selected_tag_list = $(this).closest("li").attr("tag_arr");
		for(var i=0; i < param_tag_data.length; i++){ 
			if(param_tag_data[i]["view_yn"] == 1){ 
				var p_selected = (param_selected_tag_list.indexOf(param_tag_data[i]["site_tag_seq"]) > -1) ? "selected" : "";
				param_edit_layer += "<option value='"+ param_tag_data[i]["site_tag_seq"] +"' "+ p_selected +">"+ param_tag_data[i]["tag_nm"] +"</option>";
			}
		}

		param_edit_layer += "</select></div></li></ol><div class='edit_btnarea'><button type='button' class='red small delete'><span title='Delete'>Delete</span></button>";
		param_edit_layer += "<button type='button' class='small cancel'><span title='Cancel'>Cancel</span></button> ";
		param_edit_layer += "<button type='button' class='yellow small save'><span title='Save'>Save</span></button></div></div>";
		
		$(this).closest("li").find(".real button.edit").addClass("hide");
		$(this).closest("li").append(param_edit_layer);
		
		$('#select_tag_edit').select2({ placeholder: 'Select Tag', minimumResultsForSearch: 20 });
	});
	
	/* 갤러리 수정 > Cancel 버튼 클릭시  */
	$(document).on('click', '.gallery .edit_layer button.cancel',function() { 
		$(this).closest('li').find('.real button.edit').removeClass('hide'); $(this).closest('.edit_layer').remove(); 
	});

	/* 갤러리 수정 > Save 버튼 클릭시  */
	$(document).on('click', '.gallery .edit_layer button.save',function() { 
		var param_tag_list_split = $(this).closest(".edit_layer").find(".form_table select[name='tag_type']").val();
		var param_tag_list = "";
		for(var i=0; i < param_tag_list_split.length; i++){ param_tag_list += (param_tag_list == "") ? param_tag_list_split[i] : ","+ param_tag_list_split[i]; }

		var param_obj = new Object();
		param_obj["param_content_seq"] = $(this).closest("div.edit_layer").attr("seq");
		param_obj["param_tag_list"] = param_tag_list;
		
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/content/tag/update", "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			alert("저장이 완료 되었습니다.");
			$.when(fn_content_list()).then(function(){ fn_table_sorter(); });
			$(".gallery .edit_layer").closest('li').find('.real button.edit').removeClass('hide'); $(".gallery .edit_layer").remove(); 
		}else{
			alert(obj_result.header.resultMessage);
		}
	});

	/* 갤러리 수정 > Delete 버튼 클릭시  */
	$(document).on('click', '.gallery .edit_layer button.delete',function() { 
		var param_rtn_value = $(this).closest("div.edit_layer").attr("seq");
		dialog.list_delete_confirm_btn($(this), "This item will be deleted. Are you sure?", fn_list_delete_yes, param_rtn_value); 
	});
	
	function fn_list_delete_yes(param_rtn_value){
		var obj_tag_result = JSON.parse(common_ajax.inter("/service/v2/abroad/content/del/"+ param_rtn_value, "json", false, "DELETE", ""));
		if(obj_tag_result.header.isSuccessful == true){ 
			$.when(fn_content_list()).then(function(){ fn_table_sorter(); });
			$(".gallery .edit_layer").closest('li').find('.real button.edit').removeClass('hide'); $(".gallery .edit_layer").remove(); 
		}
	}

	/* 페이지 리셋  */
	function fn_input_page_reset(){
		param_image_data = [];
		$("#detail_info .page input[type='text'], #detail_info .page input[type='hidden'], #detail_info .page textarea").val("");
		$("#detail_info .page select[name='tag_type']").val([]).trigger("change");
		
		var objDZ = Dropzone.forElement("div#dropzone");
		objDZ.removeAllFiles(true); 
	}
	
	function fn_default_set(){
		$("#container .search_box input[name='page_start_num']").val(param_page_num);
		$("#container .search_box input[name='page_size']").val(param_page_size);
	}
	
	/* 게시물 목록 */
	function fn_content_list(){
		fn_default_set();
		
		var checkbox_type = $("#detail_list").find(":checkbox[name='category_type']");
		var tag_type = "";
		for(var i=0; i < checkbox_type.length; i++){ 
			if(checkbox_type.eq(i).is(":checked")){ 
				tag_type += (tag_type == "")? checkbox_type.eq(i).val() : ","+ checkbox_type.eq(i).val() ; 
			}  
		}
		var param_obj = new Object();
		param_obj["search_context"] = $("#container .contents .search_box input[name='search_context']").val();
		param_obj["page_size"] = $("#container .contents .search_box input[name='page_size']").val();
		param_obj["page_start_num"] = $("#container .contents .search_box input[name='page_start_num']").val();
		param_obj["tag_type"] = tag_type;
		
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/content/"+ content_type, "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var insert_table_data = "";
			if(obj_data.length == 0){ 
				param_page_last = true; 
				if(param_page_num == 0){ $("#container #detail_list .list .gallery ul").empty(); }
				$("#container #detail_list .list .gallery ul").append(insert_table_data);
			}else{
				for(var i=0; i < obj_data.length; i++){
					insert_table_data += "<li seq="+ obj_data[i]["site_content_seq"] +" tag_arr="+ obj_data[i]["tag_select_list"] +"><div class='real'>";
					insert_table_data += "<img src='"+ obj_data[i]["thumbnail_path"] +"'>";
					
					var tag_arr = obj_data[i]["tag_select_list_nm"].split(",");
					var tag_list = "";
					for(var z=0; z < tag_arr.length; z++){ tag_list += (tag_list == "") ? "#"+ tag_arr[z] : " #"+ tag_arr[z]; }
					insert_table_data += "<div class='description'><h5>"+ tag_list +"</h5></div>";
					insert_table_data += "<div class='set'><button type='button' class='black xsmall edit'><span title='Edit'>Edit</span></button></div>";
					insert_table_data += "</div></li>"
				}
				if(param_page_num == 0){ $("#container #detail_list .list .gallery ul").empty(); }
				$("#container #detail_list .list .gallery ul").append(insert_table_data);
			}
		}else{
			$("#container #detail_list .list .gallery ul").empty().append(no_data);
		}
	}
	
	function fn_table_sorter(){
		// 스크롤했을때 param_page_num 추가해서 append 한다. 
		$("#detail_list .list").scroll(function(){ 
			//console.log($(this).scrollTop() +"/"+ Math.round($(this).find(".gallery").outerHeight()) +"/"+ $(this).height() +"/"+ param_page_last);
			if($(this).scrollTop() >= (Math.round($(this).find(".gallery").outerHeight()) - $(this).height())){
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
		var input_label_box = "<h5>Tag</h5>";
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/tag", "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			param_tag_data = obj_data;
			for(var i=0; i < obj_data.length; i++){ 
				if(obj_data[i]["view_yn"] == 1){ 
					input_select_box += "<option value='"+ obj_data[i]["site_tag_seq"] +"'>"+ obj_data[i]["tag_nm"] +"</option>";
					input_label_box += "<label><input type='checkbox' name='category_type' value='"+ obj_data[i]["site_tag_seq"] +"'><span>"+ obj_data[i]["tag_nm"] +"</span></label>";
				}
			}
		}
		$("#detail_info .page select[name='tag_type']").empty().append(input_select_box);
		$("#detail_list .sort").empty().append(input_label_box);
	}
	/* sort 조건 눌렀을때 */
	$(document).on("click", "#detail_list .sort input:checkbox", function(){
		param_page_last=false; param_page_num = 0; $.when(fn_content_list()).then(function(){ fn_table_sorter(); });
	});

</script>

	<link rel="stylesheet" type="text/css" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/FileScript/dropzone.css" />
	<script src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/FileScript/dropzone.js"></script>
	<div id="container">
		<div class="browser sidebar expand">
			<div class="burger_icon"><span></span></div>
			<h3>Study Abroad</h3>
			<div class="scroll"><jsp:include page="../layout/abroad_menu.jsp" flush="true" /></div>
		</div>
		<div class="contents gallery_edit">
			<div class="basic">
				<dl class="">
					<dd class="name">
						<h3>커뮤니티 <span class="depth_txt">></span> <b>갤러리</b></h3>
						<div class="search_box">
							<input type="hidden" name="page_start_num" />
							<input type="hidden" name="page_size" />
							<input type="hidden" name="search_context" placeholder="Title Name">
						</div>
					</dd>
					<dd class="new"><button type="button" class="small black"><span>Upload Image</span></button></dd>
				</dl>
			</div>
			<div id="detail_list">
				<div class="sort_option"><div class="inquiry group expand"><div class="sort first"></div></div></div>
				<div class="list"><div class="gallery"><ul></ul></div></div>
			</div>
			
			<div id="detail_info">
				<div class="viewbar"><h4><b></b></h4><div class="close_detail"></div></div>
				<div class="page gallery">
					<div class="contents">
						<div class="set_input">
							<ul class="form_table"><li><div class="cell tag"><select name="tag_type" style="width:100%;" multiple="multiple"></select></div></li></ul>
						</div>
						<div class="upload_gallery">
							<div id="dropzone" class="dropzone2" >
								<div class="dz-default dz-message"><span>Drop files here to upload</span></div>
							</div>
						</div>
					</div>
					<div class="create_btn">
						<button type="button" class="small cancel" ><span>Cancel</span></button>
						<button type="button" class="small blue create" ><span>Upload</span></button>
					</div>
				</div>
			</div>
			
		</div>
	</div>