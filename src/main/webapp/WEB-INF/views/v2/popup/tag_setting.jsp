<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script type="text/javascript">
/* search button */
$(document).on("click", "#pop_tag_setting .create_area .new_tag input[type='button']", function(){ fn_tag_list(); });

/* edit record */
$(document).on('click','#pop_tag_setting .hms_table tbody button.edit',function() {
	var parent = $(this).closest('tr')
	parent.addClass('edit');
	parent.find('select, input[type=text], label.onoff>input').prop('disabled', false);
	parent.find('button.edit, button.delete').addClass('hide');
	parent.find('button.save, button.cancel').removeClass('hide');
	parent.find('td.tagname_record>input').focus();
});

/* cancel action */
$(document).on('click','#pop_tag_setting .hms_table tbody button.cancel', function() { fn_tag_list(); });

/* save(create, edit) action */
$(document).on('click','#pop_tag_setting .hms_table tbody button.save', function() {
	var parent = $(this).closest('tr')
	var param_obj = new Object();
	param_obj["tag_code"] = parent.attr("code");
	param_obj["tag_nm"] = parent.find(".tagname_record input[type=text]").val();
	param_obj["main_view_yn"] = (parent.find(".mainview_record select[name='mainview'] option:selected").val() == "") ? 0 : parent.find(".mainview_record select[name='mainview'] option:selected").val();
	param_obj["view_yn"] = (parent.find(":checkbox[name='status_yn']").is(":checked")) ? 1 : 0;
	
	var obj_result = JSON.parse(common_ajax.inter("/service/v2/tag/save", "json", false, "POST", param_obj));
	if(obj_result.header.isSuccessful == false){ alert("데이터 저장에 실패 했습니다. "); }
	fn_tag_list();
	search.get_tag_list("container");
});

/* delete action */
$(document).on('click','#pop_tag_setting .hms_table tbody button.delete', function() {
	var param_rtn_value = $(this).closest("tr").attr("code");
	dialog.list_delete_confirm_btn($(this), "This item will be deleted. Are you sure?", fn_tag_list_delete_yes, param_rtn_value); 
});

function fn_tag_list_delete_yes(param_rtn_value){
	if(param_rtn_value != ""){
		var param_obj = new Object();
		param_obj["tag_code"] = param_rtn_value;
		
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/tag/remove", "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == false){ alert("데이터 삭제에 실패 했습니다. "); }
		fn_tag_list();
		search.get_tag_list("container");
	}
}

function add_tag(){
	var insert_row = '<tr code="" class="edit new">';
	insert_row += '<td class="tagname_record left"><input type="text" value="" /></td>';
	insert_row += '<td class="mainview_record"><select name="mainview" class="mainview"><option value=""></option><option value="1">1st</option><option value="2">2nd</option><option value="3">3rd</option><option value="4">4th</option><option value="5">5th</option></select></td>';
	insert_row += '<td class="status_record"><label class="onoff"><input type="checkbox" name="status_yn" checked /><span></span></label></td>';
	insert_row += '<td class="postnum_record">0</td><td class="author_record"></td><td class="date_record"></td>';
	insert_row += '<td class="edit_record"><button title="Save" class="icon save"><span></span></button></td><td class="delete_record"><button title="Delete" class="icon cancel"><span></span></button></td></tr>';
	
	$('#pop_tag_setting .hms_table table>tbody').prepend(insert_row);
	$('tr.edit.new td.tagname_record>input').focus();
	$("#pop_tag_setting .list .hms_table select.mainview").select2({ placeholder: "None", minimumResultsForSearch: 20 }); 
}

function fn_tag_list(){
	var no_data = "<tr><td colspan='8' class='nodata' data-guide='No data available!'></td></tr>";
	
	var param_obj = new Object();
	param_obj["search_context"] = $("#pop_tag_setting input[name='search_context']").val();
	
	var obj_result = JSON.parse(common_ajax.inter("/service/v2/tag/list", "json", false, "POST", param_obj));
	if(obj_result.header.isSuccessful == true){
		var obj_data = JSON.parse(obj_result.data);
		var insert_table_data = "";
		if(obj_data.length == 0){ 
			$("#pop_tag_setting .list .hms_table .tablesorter tbody").empty().append(no_data);
		}else{
			for(var i=0; i < obj_data.length; i++){
				insert_table_data += "<tr code='"+ obj_data[i]["tag_code"] +"'>";
				insert_table_data += "<td class='tagname_record left'><input type='text' value='"+ obj_data[i]["tag_nm"] +"' disabled /></td>";
				insert_table_data += "<td class='mainview_record'>";
				insert_table_data += "<select name='mainview' class='mainview' disabled>";
				for(var a=0; a < 6; a++){
					var tag_main_sort = (a == 0)? "" : (a == 1)? a +"st" : (a == 2)? a +"nd" : (a == 3)? a +"rd" : a +"th" ; 
					var tag_main_sort_val = (a == 0)? "" : a ; 
					var tag_main_sort_select = (obj_data[i]["main_view_yn"] == a)? "selected" : "";
					insert_table_data += "<option value='"+ tag_main_sort_val +"' "+ tag_main_sort_select +">"+ tag_main_sort +"</option>";
				}
				insert_table_data += "</select>";
				insert_table_data += "</td>";
				var tag_status_yn = (obj_data[i]["view_yn"] == 1)? "checked" : "";
				insert_table_data += "<td class='status_record'><label class='onoff'><input type='checkbox' name='status_yn' "+ tag_status_yn +" disabled /><span></span></label></td>";
				insert_table_data += "<td class='postnum_record'>"+ obj_data[i]["tag_content_cnt"] +"</td>";
				insert_table_data += "<td class='author_record'>"+ obj_data[i]["reg_user_nm"] +"</td>";
				insert_table_data += "<td class='date_record'>"+ common_date.convertType(obj_data[i]["reg_ts"],8) +"</td>";
				insert_table_data += "<td class='edit_record'>";
				insert_table_data += "<button title='Edit' class='icon edit'><span>Edit</span></button>";
				insert_table_data += "<button title='Save' class='icon save hide'><span>Save</span></button>";
				insert_table_data += "</td>";
				insert_table_data += "<td class='delete_record'>";
				var tag_del_view = (obj_data[i]["tag_content_cnt"] == 0)? "" : "disabled";
				insert_table_data += "<button title='Delete' class='icon delete' "+ tag_del_view +"><span>Delete</span></button>";
				insert_table_data += "<button title='Cancel' class='icon cancel hide'><span>Cancel</span></button>";
				insert_table_data += "</td></tr>"
			}
			$("#pop_tag_setting .list .hms_table .tablesorter tbody").empty().append(insert_table_data);
			fn_list_view_after();
		}
	}else{
		$("#pop_tag_setting .list .hms_table .tablesorter tbody").empty().append(no_data);
	}
}

function fn_list_view_after(){ 
	$("#pop_tag_setting .list .hms_table select.mainview").select2({ placeholder: "None", minimumResultsForSearch: 20 }); 
}
</script>

<div id="pop_tag_setting" class="pop full large blue">
	<div class="header">
		<h1>Tag Setting</h1>
		<div class="func">
			<div class="close">Close</div>
		</div>
	</div>
	<div class="create_area">
		<div class="new_tag">
			<div class="search_box">
				<input type="text" name="search_context" placeholder="Tag name">
				<input type="button" class="search_btn">
			</div>
			<button type="button" class="small blue" onclick="add_tag();"><span>Add Tag</span></button>
		</div>
		<div class="list">
			<div class="scroll">
				<div class="hms_table">
					<table class="tablesorter">
						<colgroup>
							<col style="width:30%">
							<col style="width:10%;">
							<col style="width:15%;">
							<col style="width:10%;">
							<col style="width:15%;">
							<col style="width:20%;">
							<col style="width:35px;">
							<col style="width:35px;">
						</colgroup>
						<thead>
							<tr>
								<th class="tagname_record">Tag Name</th>
								<th class="mainview_record">Main View</th>
								<th class="status_record">Status</th>
								<th class="postnum_record">Post Num.</th>
								<th class="author_record">Author</th>
								<th class="date_record">Issue Date</th>
								<th class="edit_record" colspan="2">Edit</th>
							</tr>
						</thead>
						<tbody></tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
