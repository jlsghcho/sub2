<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<script type="text/javascript">
	var now_year_date = "${serverDate}";
	var param_save_arr;
	var param_sub_menu_arr;

	
	
	$(document).ready(function() {
		param_save_arr = new Array();
		fn_sub_menu_list();
		
		$.when(fn_menu_list()).then(function(){ fn_ui_sortable(); });
	});

	/*  한번만 서브 메뉴 가지고 오기 */
	function fn_sub_menu_list(){
		
		/* var abroad_sub_menu = "${cookieSubMenuList}";
		var abroad_sub_menu_list =  abroad_sub_menu.split("abroad=")[1].split(" ")[0].split(',');
		$('#'+abroad_sub_menu_list[0]).trigger("click"); */
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/menu/sub", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){ param_sub_menu_arr = JSON.parse(obj_result.data); }
		
		
		
	} 
	
	/* 메뉴 가지고 오기 */
	function fn_menu_list(){
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/menu", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var insert_table_data = "";
			var parent_menu_code = 0;
			var param_selected = "";
			if(obj_data.length > 0){ 
				for(var i=0; i < obj_data.length; i++){
					if(obj_data[i]["tree_lev"] == 1){
						if(parent_menu_code != 0 && parent_menu_code != obj_data[i]["menu_seq"]){ insert_table_data += "</ol></li>"; }
						insert_table_data += "<li class='top' code='"+ obj_data[i]["menu_seq"] +"'>";
						insert_table_data += "<div class='tit'><h4><span>"+ obj_data[i]["menu_nm"] +"</span></h4>";
						insert_table_data += "<div class='create'><button type='button' class='xsmall black' title='Create Menu' onclick='fn_add_menu("+ obj_data[i]["menu_seq"] +")'><span>Create Menu</span></button></div>";
						insert_table_data += "</div><ol>";
						parent_menu_code = obj_data[i]["menu_seq"];
					}else{
						insert_table_data += "<li class='sub' sub_code='"+ obj_data[i]["menu_seq"] +"' sub_sort='"+ obj_data[i]["sort_num"] +"'>";
						insert_table_data += "<div class='info'><h6 class='faketxt'>"+ obj_data[i]["menu_nm"] +"</h6><input type='text' class='fakeinput hide' value='"+ obj_data[i]["menu_nm"] +"'></div>";
						
						insert_table_data += "<div class='set_tag'>";
						insert_table_data += "<select class='tag_select' style='width:100%;' multiple='multiple' disabled>";
						for(var z=0; z < param_sub_menu_arr.length; z++){
							param_selected = (obj_data[i]["sub_menu_codes"].indexOf(param_sub_menu_arr[z]["sub_menu_code"]) > -1) ? "selected" : "";
							insert_table_data += "<option value='"+ param_sub_menu_arr[z]["sub_menu_code"] +"' "+ param_selected +">"+ param_sub_menu_arr[z]["sub_menu_nm"] +"</option>";
						}
						insert_table_data += "</select></div>";

						var menu_checked = (obj_data[i]["use_yn"] == 'Y')? "checked" : "";
						insert_table_data += "<div class='setting'><label class='active'><input type='checkbox' name='view' "+ menu_checked +" disabled><span>Active</span></label><button type='button' class='xsmall edit'><span>Edit</span></button><button type='button' class='xsmall yellow save hide'><span>Save</span></button></div>";
						insert_table_data += "</li>";
					}
					if(i == (obj_data.length -1)){ insert_table_data += "</ol></li>"; } //맨 마지막에 닫아준다. 
				}
				$("#container .contents #program_menu ul").empty().append(insert_table_data);
			}
		}else{
			$("#container .contents #program_menu ul").empty();
		}
		$('#program_menu~ .create_btn button').attr('disabled', true); 
	}
	
	function fn_ui_sortable(){
		$('#program_menu li ol').sortable({
			axis: 'y',
			cancel: '.setting, input',
			update : function(event, ui){
				var start_pos = ui.item.data('start_pos');
		        var end_pos = ui.item.index();
		        
		        var param_save_obj = new Object();
		        param_save_obj["type"] = "sort";
		        param_save_obj["seq"] = $(this).closest("li").find(".top").attr("code");
				
		        var sort_arr = new Array();
		        var li_list = $(this).closest("ol").find("li.sub");
		        for(var i=0; i < li_list.length; i++){
		        	console.log(li_list.eq(i));
		        	sort_arr.push(li_list.eq(i).attr("sub_code")); 
		        }
		        param_save_obj["data"] = sort_arr;
		        
		        var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/menu/save", "json", false, "POST", param_save_obj));
				if(obj_result.header.isSuccessful == false){ alert(obj_result.header.resultMessage); }
			},
			placeholder: "ui-state-highlight",
			forcePlaceholderSize: true
		}).disableSelection();
		
		/* tag for submenu */
		$('.tag_select').select2({ placeholder: 'Select tag for submenu', minimumResultsForSearch: 20 });
	}
	
	/* 메뉴 추가 */
	function fn_add_menu(param_menu_seq){
		var insert_table_data = "<li class='sub' sub_code='0' sub_sort='"+ ($('#program_menu').find("li[code='"+ param_menu_seq +"'] ol li").length +1) +"'>";
		insert_table_data += "<div class='info'><h6 class='faketxt hide'></h6><input type='text' class='fakeinput' value='' placeholder='Please enter menu name'></div>";
		insert_table_data += "<div class='set_tag'>";
		insert_table_data += "<select class='tag_select' style='width:100%;' multiple='multiple'>";
		for(var z=0; z < param_sub_menu_arr.length; z++){ insert_table_data += "<option value='"+ param_sub_menu_arr[z]["sub_menu_code"] +"' >"+ param_sub_menu_arr[z]["sub_menu_nm"] +"</option>"; }
		insert_table_data += "</select></div>";
		insert_table_data += "<div class='setting'><label class='active'><input type='checkbox' name='view'><span>Active</span></label><button type='button' class='xsmall delete'><span>Del</span></button><button type='button' class='xsmall yellow save'><span>Save</span></button></div>";
		insert_table_data += "</li>";
		
		$('#program_menu').find("li[code='"+ param_menu_seq +"'] ol").append(insert_table_data);
		//$('#program_menu~ .create_btn button').attr('disabled', false); 
		$('.tag_select').select2({ placeholder: 'Select tag for submenu', minimumResultsForSearch: 20 });
	}
	
	/* 저장버튼 클릭시 */
	$(document).on('click', '#program_menu .setting button.save', function(){
		var code = $(this).closest("li").attr("sub_code");
		var codes_split = $(this).closest("li").find(".tag_select").val();
		var codes = "";
		for(var i=0; i < codes_split.length; i++){ codes += (codes == "") ? codes_split[i] : ","+ codes_split[i]; }
		
		if($(this).closest("li").find(".fakeinput").val() == ""){ alert("메뉴 제목을 입력해 주세요."); return; }
		
        var param_save_obj = new Object();
        param_save_obj["type"] = (code == '0')? "create" : "update";
        param_save_obj["seq"] = (code == '0')? $(this).closest('.top').attr("code") : code;
        param_save_obj["text"] = $(this).closest("li").find(".fakeinput").val();
        param_save_obj["codes"] = codes;
        param_save_obj["view"] = $(this).closest('li').find('input:checkbox[name="view"]').is(":checked");

        var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/menu/save", "json", false, "POST", param_save_obj));
		if(obj_result.header.isSuccessful == true){
			alert("저장이 완료 되었습니다.");
		}else{
			alert(obj_result.header.resultMessage);
		}
		$.when(fn_menu_list()).then(function(){ fn_ui_sortable(); });
	});
	
	/* 취소 버튼 클릭시 */
	$(document).on('click', '#program_menu .setting button.delete', function(){
		$(this).closest("li").remove();
	});	
	
	/* 수정버튼 클릭시 */
	$(document).on('click', '#program_menu button.edit',function() {;
		var txt = $(this).closest('li').find('.faketxt').text();
		$(this).addClass('hide').closest('li').find('.faketxt').addClass('hide');
		$(this).closest('li').find('.fakeinput').removeClass('hide').focus().val(txt);
		
		$(this).closest(".setting").find(".save").removeClass("hide");
		$(this).closest("li").find(".tag_select").attr("disabled", false);
		$(this).closest(".setting").find(":checkbox[name='view']").attr("disabled", false);
	});
</script>

	<div id="container">
		<div class="browser sidebar expand">
			<div class="burger_icon"><span></span></div>
			<h3>Study Abroad</h3>
			<div class="scroll"><jsp:include page="../layout/abroad_menu.jsp" flush="true" /></div>
		</div>
		<div class="contents">
			<div class="basic">
				<dl class=""><dd class="name"><h3>기본설정 <span class="depth_txt">></span> <b>프로그램 메뉴 관리</b></h3></dd></dl>
			</div>
			<div id="program_menu"><ul></ul></div>
			<!-- 
			<div class="create_btn">
				<button type="button" class="small cancel" disabled><span>Cancel</span></button>
				<button type="button" class="small yellow" disabled><span>Save</span></button>
			</div>
			 -->
		</div>
	</div>