<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

	<script type="text/javascript">
	var now_year_date = "${serverDate}";
	
	var param_li_add = '<li class="new"><div class="real hide"><div class="thumb"><span><img src=""></span></div><h3></h3><p></p>';
	param_li_add += '<div class="set ui-sortable-handle"><button type="button" class="black xsmall edit"><span title="Edit">Edit</span></button></div></div>';
	param_li_add += '<div class="edit_layer"><div class="thumb"><span><img src=""></span><button type="button" class="select_img" onclick="fn_thumbnail_img_upload(\'manager\');"><span></span></button></div>';
	param_li_add += '<ol class="form_table"><li><div class="cell name"><input type="text" value="" placeholder="Please enter partner name" required></div></li>';
	param_li_add += '<li><div class="cell profile"><div class="profile" contenteditable="true" data-placeholder="Please enter profile"></div></div></li></ol>';
	param_li_add += '<div class="edit_btnarea">';
	param_li_add += '<button type="button" class="small cancel"><span title="Cancel">Cancel</span></button> ';
	param_li_add += '<button type="button" class="blue small create"><span title="Create">Create</span></button></div></div></li>';
	
	var param_li_mod = '<div class="edit_layer"><div class="thumb"><span><img src=""></span><button type="button" class="select_img" onclick="fn_thumbnail_img_upload(\'manager\');"><span></span></button>';
	param_li_mod += '</div><ol class="form_table"><input type="hidden" name="staff_seq"><li><div class="cell name"><input type="text" value="" placeholder="Please enter partner name" required></div></li>';
	param_li_mod += '<li><div class="cell profile"><div class="profile" contenteditable="true" data-placeholder="Please enter profile"></div></div></li></ol>';
	param_li_mod += '<div class="edit_btnarea"><button type="button" class="red small delete"><span title="Delete">Delete</span></button> ';
	param_li_mod += '<button type="button" class="small cancel"><span title="Cancel">Cancel</span></button> ';
	param_li_mod += '<button type="button" class="yellow small save"><span title="Save">Save</span></button></div></div>'
	
	$(document).ready(function() {
		$.when(fn_main_manager_list()).then(function(){ fn_table_sortable(); });
		
		$("div[contenteditable]").keydown(function(e){ if (e.keyCode === 13) { document.execCommand('insertHTML', false, '<br>'); return false; } }); // contenteditable 일때 꼭 넣어주기 
	});
	
	/* .edit_layer delete button */
	$(document).on('click', '#info_staff .edit_layer button.delete',function() { fn_main_manager_delete($(this).closest("li").find("input[name='staff_seq']").val()); });

	/* .edit_layer cancel button */
	$(document).on('click', '#info_staff .edit_layer button.cancel',function() { fn_all_layer_remove(); });
	
	/* 신규생성 */
	$(document).on('click', '#container .contents .new button.black', function(){
		fn_all_layer_remove();
		$("#info_staff ul").prepend(param_li_add);
	});
	
	/* 수정 */
	$(document).on('click', '#container .contents #info_staff .real button.edit', function(){
		fn_all_layer_remove();
		$(this).closest('li').find('.real').addClass('hide');
		$(this).closest('li').append(param_li_mod);
		
		var staff_seq = $(this).closest('li').attr("code");
		var name = $(this).closest('li').find('.real h3').text();
		var profile = $(this).closest('li').find('.real div.profile').html();
		var img_path = $(this).closest('li').find('.real .thumb img').attr('src');
		
		$(this).closest('li').find('.edit_layer input[name="staff_seq"]').val(staff_seq);
		$(this).closest('li').find('.edit_layer .name>input').val(name);
		$(this).closest('li').find('.edit_layer .profile>div.profile').html(profile);
		$(this).closest('li').find('.edit_layer .thumb img').attr('src', img_path);
	});

	function fn_all_layer_remove(){
		$("#info_staff").find("li div.real").removeClass('hide');
		$("#info_staff").find("li div.edit_layer").remove();
		$("#info_staff").find("li.new").remove();
	}
	
	/* .edit_layer save button */
	$(document).on('click', '#info_staff .edit_layer button.save, #info_staff .edit_layer button.create',function() {
		var img_path = $(this).closest("li").find(".edit_layer .thumb img").attr("src");
		var name = $(this).closest("li").find(".edit_layer .name input").val();
		var profile = $(this).closest("li").find(".edit_layer .profile div.profile").html();
		profile = profile.replace(/<[\/]{0,1}(p)[^><]*>/gi, "<br>");
		profile = profile.replace(/<br><br>/gi,"<br>");
		
		if(img_path == ""){ alert("운영진 사진을 등록해 주세요."); return; }
		if(name == ""){ alert("운영진 이름을 등록해 주세요."); return; }
		if(profile == ""){ alert("운영진 프로필을 등록해 주세요."); return; }

		var param_obj = new Object();
		param_obj["param_save_type"] = ($(this).closest("li").attr("class") == undefined)? "mod" : $(this).closest("li").attr("class");
		param_obj["param_seq"] = $(this).closest("li").find(".edit_layer input[name='staff_seq']").val();
		param_obj["param_img_path"] = img_path;
		param_obj["param_name"] = name;
		param_obj["param_desc"] = profile;

		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/manager", "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			alert("저장이 완료 되었습니다.");
			$.when(fn_main_manager_list()).then(function(){ fn_table_sortable(); });
		}else{
			alert(obj_result.header.resultMessage);
		}
	});	

	/* 썸네일 받기 */
	function fn_popup_thumb_image_return(thumb_image_path){ $("#info_staff .edit_layer .thumb img").attr("src", thumb_image_path); }
	
	function fn_main_manager_list(){
		var insert_table_data = "";
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/manager", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			if(obj_data.length > 0){ 
				for(var i=0; i < obj_data.length; i++){
					insert_table_data += "<li code='"+ obj_data[i]["staff_seq"] +"'>";
					insert_table_data += "<div class='real'><div class='thumb'><span><img src='"+ obj_data[i]["img_path"] +"' /></span></div>";
					insert_table_data += "<h3>"+ obj_data[i]["staff_nm"] +"</h3><div class='profile'>"+ obj_data[i]["staff_desc"] +"</div>";
					insert_table_data += "<div class='set'><button type='button' class='black xsmall edit'><span title='Edit'>Edit</span></button></div></div></li>";
				}
			}
		}
		$("#container .contents #info_staff .section ul").empty().append(insert_table_data);
	}
	
	function fn_table_sortable(){
		$("#info_staff ul").sortable({
			items: 'li:not(.ui-state-disabled)',
			handle: ".set",
			cancel: 'input, button',
			update: function(event, ui) {
				var start_pos = ui.item.data('start_pos');
		        var end_pos = ui.item.index();
		        
		        var sort_arr = new Array();
		        var li_list = $(this).closest("ul").find("li:not(.ui-state-disabled)");
		        for(var i=0; i < li_list.length; i++){ sort_arr.push(li_list.eq(i).attr("code")); }

		        var param_save_obj = new Object();
		        param_save_obj["data"] = sort_arr;

		    	var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/manager/sort", "json", false, "POST", param_save_obj));
		    	if(obj_result.header.isSuccessful == false){ alert(obj_result.header.resultMessage); }
			},
			placeholder: "ui-state-highlight",
			forcePlaceholderSize: true
		});
	}
	
	/* 운영진 삭제 기능 */
	function fn_main_manager_delete(staff_seq){
		if(staff_seq == ""){ alert("잘못된 접근입니다."); return; }
		
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/manager/"+ staff_seq, "json", false, "DELETE", ""));
		if(obj_result.header.isSuccessful == true){
			fn_main_manager_list();
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
		<div class="contents">
			<div class="basic">
				<dl class="">
					<dd class="name">
						<h3>소개 페이지 <span class="depth_txt">></span> <b>운영진 소개</b></h3>
					</dd>
					<dd class="new"><button type="button" class="black small"><span>New Staff</span></button></dd>
				</dl>
			</div>
			<div id="info_staff">
				<div class="section"><ul></ul></div>
			</div>
		</div>
	</div>
	