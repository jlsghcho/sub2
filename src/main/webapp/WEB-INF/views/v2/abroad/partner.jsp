<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<script type="text/javascript">
var now_year_date = "${serverDate}";

var param_li_edit = "<div class='edit_layer'>";
param_li_edit += "<div class='thumb'>";
param_li_edit += "<img src=''><button type='button' class='select_img' onclick='fn_thumbnail_img_upload(\"partner\");'><span></span></button></div>";
param_li_edit += "<ol class='form_table'>";
param_li_edit += "<input type='hidden' name='partner_seq'>";
param_li_edit += "<li><div class='cell name'><input type='text' value='' placeholder='Please enter partner name'></div></li>";
param_li_edit += "<li><div class='cell url'><input type='text' value='' placeholder='Please enter URL'></div></li>";
param_li_edit += "</ol>";
param_li_edit += "<div class='edit_btnarea'>";
param_li_edit += "<button type='button' class='red small delete'><span title='Delete'>Delete</span></button> ";
param_li_edit += "<button type='button' class='small cancel'><span title='Cancel'>Cancel</span></button> ";
param_li_edit += "<button type='button' class='yellow small save'><span title='Save'>Save</span></button> ";
param_li_edit += "</div></div>";

var param_li_add = "<li class='new'>";
param_li_add += "<a href='' target='_blank'><img src=''></a>";
param_li_add += "<div class='set'><button type='button' class='black xsmall edit'><span title='Edit'>Edit</span></button></div>";
param_li_add += "<div class='edit_layer'>";
param_li_add += "<div class='thumb'>";
param_li_add += "<img src=''><button type='button' class='select_img' onclick='fn_thumbnail_img_upload(\"partner\");'><span></span></button></div>";
param_li_add += "<ol class='form_table'>";
param_li_add += "<li><div class='cell name'><input type='text' value='' placeholder='Please enter partner name'></div></li>";
param_li_add += "<li><div class='cell url'><input type='text' value='' placeholder='Please enter URL'></div></li>";
param_li_add += "</ol>";
param_li_add += "<div class='edit_btnarea'>";
param_li_add += "<button type='button' class='small cancel'><span title='Cancel'>Cancel</span></button> ";
param_li_add += "<button type='button' class='blue small create'><span title='Create'>Create</span></button> ";
param_li_add += "</div></div></li>";

$(document).ready(function() {
	$.when(fn_main_partner_list()).then(function(){ fn_table_sortable(); });
});

$(document).on('click', '#container .contents #info_partner .add', function(){
	fn_all_layer_remove();
	$(this).before(param_li_add);
});

/* edit partner */
$(document).on('click', '#container .contents #info_partner .set button.edit',function() {
	fn_all_layer_remove();
	$(this).closest('li').append(param_li_edit);

	var imgsrc = $(this).closest('li').find('a img').attr('src');
	var title = $(this).closest('li').find('a').attr('title');
	var link_url = $(this).closest('li').find('a').attr('href');
	var partner_seq = $(this).closest('li').attr('code');
	
	$(this).closest('li').find('.edit_layer input[name="partner_seq"]').val(partner_seq);
	$(this).closest('li').find('.edit_layer .thumb img').attr('src', imgsrc);
	$(this).closest('li').find('.edit_layer .name input').val(title);
	$(this).closest('li').find('.edit_layer .url input').val(link_url);
});

/* .edit_layer delete button */
$(document).on('click', '#info_partner .edit_layer button.delete',function() { fn_main_partner_delete($(this).closest("li").find("input[name='partner_seq']").val()); });

/* .edit_layer cancel button */
$(document).on('click', '#info_partner .edit_layer button.cancel',function() { fn_all_layer_remove(); });

/* .edit_layer save button */
$(document).on('click', '#info_partner .edit_layer button.save, #info_partner .edit_layer button.create',function() {
	var img_path = $(this).closest("li").find(".thumb img").attr("src");
	var name = $(this).closest("li").find(".name input").val();
	var link = $(this).closest("li").find(".url input").val();
	
	if(img_path == ""){ alert("파트너 로고를 등록해 주세요."); return; }
	if(name == ""){ alert("파트너 명을 등록해 주세요."); return; }
	if(link == ""){ alert("파트너 사이트를 등록해 주세요."); return; }

	var param_obj = new Object();
	param_obj["param_save_type"] = ($(this).closest("li").attr("class") == undefined)? "mod" : $(this).closest("li").attr("class");
	param_obj["param_seq"] = $(this).closest("li").find("input[name='partner_seq']").val();
	param_obj["param_type"] = $(this).closest(".section").find(".subtit h4").text();
	param_obj["param_img_path"] = img_path;
	param_obj["param_title"] = name;
	param_obj["param_link_url"] = link;

	var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/partner", "json", false, "POST", param_obj));
	if(obj_result.header.isSuccessful == true){
		alert("저장이 완료 되었습니다.");
		$.when(fn_main_partner_list()).then(function(){ fn_table_sortable(); });
	}else{
		alert(obj_result.header.resultMessage);
	}
});

function fn_all_layer_remove(){
	$("#info_partner").find("li div.edit_layer").remove();
	$("#info_partner").find("li.new").remove();
}

/* 파트너 삭제 기능 */
function fn_main_partner_delete(partner_seq){
	if(partner_seq == ""){ alert("잘못된 접근입니다."); return; }
	
	var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/partner/"+ partner_seq, "json", false, "DELETE", ""));
	if(obj_result.header.isSuccessful == true){
		fn_main_partner_list();
	}else{
		alert(obj_result.header.resultMessage);
	}
}

/* 썸네일 받기 */
function fn_popup_thumb_image_return(thumb_image_path){ $("#info_partner .edit_layer .thumb img").attr("src", thumb_image_path); }

function fn_main_partner_list(){
	var partner_type_arr = ['USA','CANADA'];
	$("#container .contents #info_partner").empty();
	for(var z=0; z < partner_type_arr.length; z++){ 
		$("#container .contents #info_partner").append("<div class='section'><div class='subtit'><h4>"+ partner_type_arr[z] +"</h4></div><ul><li class='add ui-state-disabled'><span>Add Partner</span></li></ul></div>"); }

	var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/partner", "json", false, "GET", ""));
	if(obj_result.header.isSuccessful == true){
		var obj_data = JSON.parse(obj_result.data);
		
		var param_pre_partner_type = "";
		var insert_table_data = "";
		var param_partnet_type_loc = 0;
		if(obj_data.length > 0){ 
			for(var i=0; i < obj_data.length; i++){
				if(param_pre_partner_type != obj_data[i]["partner_type"] && param_pre_partner_type != ""){
					param_partnet_type_loc = fn_find_section("#container .contents #info_partner .section .subtit h4", param_pre_partner_type);
					$("#container .contents #info_partner .section:eq("+ param_partnet_type_loc +") ul li.add").before(insert_table_data);
					insert_table_data = "";
				}
				
				insert_table_data += "<li code='"+ obj_data[i]["partner_seq"] +"'>";
				insert_table_data += "<a href='"+ obj_data[i]["link_url"] +"' target='_blank' title='"+ obj_data[i]["partner_nm"] +"'><img src='"+ obj_data[i]["img_path"] +"'></a>";
				insert_table_data += "<div class='set'><button type='button' class='black xsmall edit'><span title='Edit'>Edit</span></button></div>";
				insert_table_data += "</li>";
				
				param_pre_partner_type = obj_data[i]["partner_type"];
				if(i == (obj_data.length -1)){ 
					param_partnet_type_loc = fn_find_section("#container .contents #info_partner .section .subtit h4", param_pre_partner_type);
					$("#container .contents #info_partner .section:eq("+ param_partnet_type_loc +") ul li.add").before(insert_table_data);
					insert_table_data = "";
				}
			}
		}
	}
}

function fn_find_section(param_id, param_text){ var rtn_value = 0; for( var a = 0; a < $(param_id).length; a++){ if($(param_id).eq(a).text() == param_text){ rtn_value = a; }} return rtn_value; }

function fn_table_sortable(){
	$("#info_partner ul").sortable({
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

	    	var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/partner/sort", "json", false, "POST", param_save_obj));
	    	if(obj_result.header.isSuccessful == false){ alert(obj_result.header.resultMessage); }
		},
		placeholder: "ui-state-highlight",
		forcePlaceholderSize: true
	});
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
						<h3>소개 페이지 <span class="depth_txt">></span> <b>파트너</b></h3>
					</dd>
				</dl>
			</div>
			<div id="info_partner"></div>
		</div>
	</div>

