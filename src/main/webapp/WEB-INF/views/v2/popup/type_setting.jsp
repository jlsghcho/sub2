<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script type="text/javascript">

var param_empSeq = "${cookieEmpSeq}";


$(document).on("click", ".close", function(){ 
	typeActiveSetting();
	$.when(fn_faq_list()).then(function(){ fn_table_sorter(); });
});

/* search button */
$(document).on("click", "#type_head_pop #pop_tag_setting .create_area .new_tag input[type='button']", function(){ fn_type_list(); });

/* edit record */
$(document).on('click','#type_head_pop #pop_tag_setting .hms_table tbody button.edit',function() {
	var parent = $(this).closest('tr')
	parent.addClass('edit');
	parent.find('input[name="cate_name"], input[name="cate_sort"]').prop('disabled', false);
	parent.find('button.edit, button.delete').addClass('hide');
	parent.find('button.save, button.cancel').removeClass('hide');
	parent.find('input[name="cate_name"]').focus();
});

/* cancel action */
$(document).on('click','#type_head_pop #pop_tag_setting .hms_table tbody button.cancel', function() {
	fn_type_list(); 
});


/* save(create, edit) action */
$(document).on('click','#type_head_pop #pop_tag_setting .hms_table tbody button.save', function() {
	var parent = $(this).closest('tr')
	var param_obj = new Object();
	param_obj["param_cate_id"] = parent.attr("cate_id");
	param_obj["param_cate_name"] = parent.find('input[name="cate_name"]').val();
	param_obj["param_cate_sort"] = parent.find('input[name="cate_sort"]').val();
	param_obj["param_reg_seq"] = param_empSeq;
	
	if(param_obj["param_cate_name"] == ""){ alert(" 'Type Name'을 입력해 주세요."); return; } 
	if(param_obj["param_cate_sort"] == ""){ alert(" 'sort Order'를 입력해 주세요."); return; }
	
	var obj_result = JSON.parse(common_ajax.inter("/type/save", "json", false, "POST", param_obj));
	if(obj_result.header.isSuccessful == false){ alert("데이터 저장에 실패 했습니다. "); }
	fn_type_list();
	/* get_tag_list("container"); */
});

function set_type_cnt(param){
	$("#fn_type_cnt").html(param+" results found.");	
}


/* delete action */
function fn_type_Del(param){
	if ( $(param).closest("tr").find('input[name="used"]').val() != "0"  ){
		dialog.faq_type_delete_alert_btn($(this), "This item is in use. Cannot be deleted", fn_type_list_delete_yes, param_rtn_value);
		
	}else{
		var param_rtn_value = $(param).closest("tr").attr("cate_id");
		dialog.list_delete_confirm_btn($(this), "This item will be deleted. Are you sure?", fn_type_list_delete_yes, param_rtn_value); 
	}
}


function fn_type_list_delete_yes(param_rtn_value){
	console.log(param_rtn_value);
	if(param_rtn_value != ""){
		var param_obj = new Object();
		param_obj["cate_id"] = param_rtn_value;
		
		var obj_result = JSON.parse(common_ajax.inter("/type/remove", "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == false){ alert("데이터 삭제에 실패 했습니다. "); }
		fn_type_list();
	}
}

function inNumber(){
    if(event.keyCode<48 || event.keyCode>57){
       event.returnValue=false;
    }
}

function add_type(){
	var insert_row = '<tr cate_id="" class="edit">';
	insert_row += '<td class="tagname_record left"><input type="text" name="cate_name" value="" /></td>';
	insert_row += '<td class="mainview_record"><input type="text" name="cate_sort" value="" onkeypress="inNumber()"/></td>';
	insert_row += '<td class="mainview_record"><input type="text" name="used" value="0" style="background-color: #e2e2e2;" readonly /></td>';
	insert_row += '<td class="edit_record"><button title="Save" class="icon save"><span></span></button></td><td class="delete_record"><button class="icon cancel" ><span></span></button></td></tr>';
	
	$('#type_head_pop #pop_tag_setting .hms_table table>tbody').prepend(insert_row);
	$('#type_head_pop #pop_tag_setting tr.edit td.tagname_record>input').focus();
	$("#type_head_pop #pop_tag_setting .list .hms_table select.mainview").select2({ placeholder: "None", minimumResultsForSearch: 20 }); 
}

function fn_type_list(){
	var no_data = "<tr><td colspan='5' class='nodata' data-guide='No data available!'></td></tr>";
	
	var param_obj = new Object();
	param_obj["search_context"] = $("#type_head_pop #pop_tag_setting input[name='search_context']").val();
	
	var obj_result = JSON.parse(common_ajax.inter("/faq/getTypeList", "json", false, "GET", ""));
	if(obj_result.header.isSuccessful == true){
		var obj_data = JSON.parse(obj_result.data);
		var insert_table_data = "";
		if(obj_data.length == 0){ 
			$("#type_head_pop #pop_tag_setting .list .hms_table .tablesorter tbody").empty().append(no_data);
		}else{
			for(var i=0; i < obj_data.length; i++){
				insert_table_data += "<tr cate_id='"+obj_data[i]["CATE_ID"]+"'>";
				insert_table_data += "<td class='tagname_record left' ><input type='text' name='cate_name' value='"+ obj_data[i]["CATE_NAME"] +"' disabled /></td>";
				insert_table_data += "<td class='mainview_record  left'><input type='text' name='cate_sort' value='"+ obj_data[i]["CATE_SORT"] +"' disabled /></td>";
				insert_table_data += "<td class='mainview_record  left'><input type='text' name='used' value='"+ obj_data[i]["USED"] +"' disabled /></td>";
				insert_table_data += "<td class='edit_record'>";
				insert_table_data += "<button title='Edit' class='icon edit'><span>Edit</span></button>";
				insert_table_data += "<button title='Save' class='icon save hide'><span>Save</span></button>";
				insert_table_data += "</td>";
				insert_table_data += "<td class='delete_record'>";
				insert_table_data += "<button title='Delete' onclick='fn_type_Del(this)' class='icon delete' ><span>Delete</span></button>";
				insert_table_data += "<button title='Cancel' class='icon cancel hide'><span>Cancel</span></button>";
				insert_table_data += "</td></tr>"
			}
			$("#type_head_pop #pop_tag_setting .list .hms_table .tablesorter tbody").empty().append(insert_table_data);
			set_type_cnt(obj_data.length);
			fn_list_view_after();
		}
	}else{
		$("#type_head_pop #pop_tag_setting .list .hms_table .tablesorter tbody").empty().append(no_data);
	}
	$("#type_head_pop #pop_tag_setting").css("width","700px");
	$("#type_head_pop #pop_tag_setting").css("height","500px");
	
}

function fn_list_view_after(){ 
	$("#pop_tag_setting .list .hms_table select.mainview").select2({ placeholder: "None", minimumResultsForSearch: 20 }); 
}
</script>

<div id="type_head_pop" style="position: absolute; left: 1100px; top:100px;">
	<div class="pop full large blue type" id="pop_tag_setting">
		<div class="header">
			<h1>Type Setting</h1>
			<div class="func">
				<div class="close">Close</div>
			</div>
		</div>
		<div class="create_area">
			<div class="new_tag" style="height: 53px;">
				<button type="button" class="small blue" onclick="add_type();"><span>New Type</span></button>
			</div> 
			<div class="list" style="height:350px;">
				<div class="scroll">
					<div class="hms_table">
						<table class="tablesorter">
							<colgroup>
								<col style="width:30%">
								<col style="width:30%;">
								<col style="width:30%;">
								<col style="width:35px;">
								<col style="width:35px;">
							</colgroup>
							<thead>
								<tr>
									<th class="tagname_record">Type Name</th>
									<th class="mainview_record">Sort Order</th>
									<th class="mainview_record">Used</th>
									<th class="edit_record" colspan="2">Edit</th>
								</tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
			</div>
			<div style="position: absolute; left:10px; top:410px;">
				<h5 id="fn_type_cnt"> 0 Result</h5>
			</div>
		</div>
	</div>
</div>
