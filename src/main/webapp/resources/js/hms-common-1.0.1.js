var lib = {
	google_code : function(param_dept, param_type, param_sort){
		var param_google_code = "";
		param_google_code += (param_dept == 120) ? "F" : (param_dept == 130) ? "MF" : "AF";
		param_google_code += (param_type == "BN1004") ? "TOP" : (param_type == "BN1001") ? "BR"+ param_sort : (param_type == "BN1002") ? "BF"+ param_sort : "SF"+ param_sort ;
		return param_google_code;
	}
	,
	gt_code : function(param_type, param_sort){
		param_sort = (param_sort == "" )? "1" : param_sort ;
		return "BN20"+ param_type.substr(-1) + param_sort;
	}
}

var search = {
	get_parameter : function(param_id){
		var param_key = $("#"+ param_id);

		var param_page_num = param_key.find("input[name='page_start_num']").val();
		var param_page_size = param_key.find("input[name='page_size']").val();
		
		var search_dept_1 = param_key.find("select[name='search_dept_1'] option:selected").val();
		var search_dept_2 = param_key.find("select[name='search_dept_2'] option:selected").val();
		search_dept_1 = (search_dept_1 == undefined) ? "" : search_dept_1;
		search_dept_2 = (search_dept_2 == undefined) ? "" : search_dept_2;
		var search_dept = (search_dept_2 == "")? search_dept_1 : search_dept_2;
		
		var search_dept_arr = "";
		if(param_emp_type == "B"){ //분원직원일때 
			if(search_dept == ""){
				var param_emp_dept_list_sp = param_emp_dept_list.split(",");
				var param_emp_dept_seq = "";
				for(var i=0; i < param_emp_dept_list_sp.length; i++){
					param_emp_dept_seq += (param_emp_dept_seq == "")? param_emp_dept_list_sp[i].split(":")[0] : ","+ param_emp_dept_list_sp[i].split(":")[0];
				}
				search_dept_arr = param_emp_dept_seq; 
			}else{
				search_dept_arr = search_dept; 
			}
		}
		
		var checkbox_type = param_key.find(":checkbox[name='search_type']");
		var search_type = "";
		var search_all_type = "";
		for(var i=0; i < checkbox_type.length; i++){ 
			if(checkbox_type.eq(i).is(":checked")){ 
				search_type += (search_type == "")? checkbox_type.eq(i).val() : ","+ checkbox_type.eq(i).val() ; 
			} 
			search_all_type += (search_all_type == "")? checkbox_type.eq(i).val() : ","+ checkbox_type.eq(i).val(); 
		}
		
		var checkbox_status = param_key.find(":checkbox[name='search_status']");
		var search_status = "";
		var search_all_status = "";
		for(var i=0; i < checkbox_status.length; i++){ 
			if(checkbox_status.eq(i).is(":checked")){ 
				search_status += (search_status == "")? checkbox_status.eq(i).val() : ","+ checkbox_status.eq(i).val(); 
			} 
			search_all_status += (search_all_status == "")? checkbox_status.eq(i).val() : ","+ checkbox_status.eq(i).val(); 
		}

		search_type = (search_type == "") ?  search_all_type : search_type;
		search_status = (search_status == "") ?  search_all_status : search_status;
		
		var checkbox_tag = param_key.find(":checkbox[name='search_tag']");
		var search_tag = "";
		for(var i=0; i < checkbox_status.length; i++){ 
			if(checkbox_tag.eq(i).is(":checked")){ search_tag += (search_tag == "")? checkbox_tag.eq(i).val() : ","+ checkbox_tag.eq(i).val(); } 
		}
		
		var search_start_dt = "";
		var search_end_dt = "";
		if(param_key.find("input[name='search_date']").val() != undefined){
			var search_date = param_key.find("input[name='search_date']").val().replace(/ /gi, '').replace(/\./g, '').split("-");
			search_start_dt = search_date[0];
			search_end_dt = search_date[1];
		}
		
		var param_obj = new Object();
		param_obj["search_emp_type"] = param_emp_type;
		param_obj["search_dept"] = search_dept;
		param_obj["search_dept_arr"] = search_dept_arr;
		param_obj["search_context"] = param_key.find("input[name='search_context']").val();
		param_obj["search_type"] = search_type;
		param_obj["search_status"] = search_status;
		param_obj["search_tag"] = search_tag;
		param_obj["search_start_dt"] = search_start_dt;
		param_obj["search_end_dt"] = search_end_dt;
		param_obj["page_start_num"] = param_page_num;
		param_obj["page_size"] = param_page_size;
		return param_obj;
	}
	,
	get_ir_parameter : function(param_id){
		var param_key = $("#"+ param_id);
	
		var param_page_num = param_key.find("input[name='page_start_num']").val();
		var param_page_size = param_key.find("input[name='page_size']").val();
		
		var search_start_dt = "";
		var search_end_dt = "";
		if(param_key.find("input[name='search_date']").val() != undefined){
			var search_date = param_key.find("input[name='search_date']").val().replace(/ /gi, '').replace(/\./g, '').split("-");
			search_start_dt = search_date[0];
			search_end_dt = search_date[1];
		}
		search_type = (search_type == "") ?  search_all_type : search_type;

		var checkbox_type = param_key.find(":checkbox[name='search_type']");
		var search_type = "";
		var search_all_type = "";
		for(var i=0; i < checkbox_type.length; i++){ 
			if(checkbox_type.eq(i).is(":checked")){ 
				search_type += (search_type == "")? checkbox_type.eq(i).val() : ","+ checkbox_type.eq(i).val() ; 
			} 
			search_all_type += (search_all_type == "")? checkbox_type.eq(i).val() : ","+ checkbox_type.eq(i).val(); 
		}
		
		var param_obj = new Object();
		param_obj["search_context"] = param_key.find("input[name='search_context']").val();
		param_obj["search_type"] = search_type;
		param_obj["search_start_dt"] = search_start_dt;
		param_obj["search_end_dt"] = search_end_dt;
		param_obj["page_start_num"] = param_page_num;
		param_obj["page_size"] = param_page_size;
		return param_obj;
	}
	,
	get_abroad_parameter : function(param_id){
		var param_key = $("#"+ param_id);

		var param_page_num = param_key.find("input[name='page_start_num']").val();
		var param_page_size = param_key.find("input[name='page_size']").val();
		
		var search_dept_arr = "";
		var checkbox_type = param_key.find(":checkbox[name='search_dept']");
		for(var i=0; i < checkbox_type.length; i++){ 
			if(checkbox_type.eq(i).is(":checked")){ search_dept_arr += (search_dept_arr == "")? checkbox_type.eq(i).val() : ","+ checkbox_type.eq(i).val() ; }
		}
		if(search_dept_arr == ""){ for(var i=0; i < checkbox_type.length; i++){ search_dept_arr += (search_dept_arr == "")? checkbox_type.eq(i).val() : ","+ checkbox_type.eq(i).val() ; } }
		
		var search_start_dt = "";
		var search_end_dt = "";
		if(param_key.find("input[name='search_date']").val() != undefined){
			var search_date = param_key.find("input[name='search_date']").val().replace(/ /gi, '').replace(/\./g, '').split("-");
			search_start_dt = search_date[0];
			search_end_dt = search_date[1];
		}
		
		var param_obj = new Object();
		param_obj["search_dept_arr"] = search_dept_arr;
		param_obj["search_context"] = param_key.find("input[name='search_context']").val();
		param_obj["search_start_dt"] = search_start_dt;
		param_obj["search_end_dt"] = search_end_dt;
		param_obj["page_start_num"] = param_page_num;
		param_obj["page_size"] = param_page_size;
		return param_obj;
	}
	,
	get_report_parameter : function(param_id){
		var param_key = $("#"+ param_id);

		var param_page_num = param_key.find("input[name='page_start_num']").val();
		var param_page_size = param_key.find("input[name='page_size']").val();
		
		var param_dept_arr = param_key.find("input[name='search_dept']").val();

		var search_type_arr = "";
		var checkbox_type = param_key.find(":checkbox[name='content_type']");
		for(var i=0; i < checkbox_type.length; i++){ 
			if(checkbox_type.eq(i).is(":checked")){ search_type_arr += (search_type_arr == "")? checkbox_type.eq(i).val() : ","+ checkbox_type.eq(i).val() ; }
		}
		if(search_type_arr == ""){ for(var i=0; i < checkbox_type.length; i++){ search_type_arr += (search_type_arr == "")? checkbox_type.eq(i).val() : ","+ checkbox_type.eq(i).val() ; } }
		
		var search_start_dt = "";
		var search_end_dt = "";
		if(param_key.find("input[name='search_date']").val() != undefined){
			var search_date = param_key.find("input[name='search_date']").val().replace(/ /gi, '').replace(/\./g, '').split("-");
			search_start_dt = search_date[0];
			search_end_dt = search_date[1];
		}
		
		var param_obj = new Object();
		param_obj["search_dept_arr"] = param_dept_arr;
		param_obj["search_type_arr"] = search_type_arr;
		param_obj["search_context"] = param_key.find("input[name='search_context']").val();
		param_obj["search_start_dt"] = search_start_dt;
		param_obj["search_end_dt"] = search_end_dt;
		param_obj["page_start_num"] = param_page_num;
		param_obj["page_size"] = param_page_size;
		return param_obj;
	}
	,
	get_dept_list : function(param_id){
		var param_key = $("#"+ param_id);
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/dept/top", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var select_dept_top_list = "<option value='' selected>전체분원</option>";
			for(var i=0; i < obj_data.length; i++){
				select_dept_top_list += "<option value='"+ obj_data[i]["dlt_dept_seq"] +"'>"+ obj_data[i]["dlt_dept_nm"] +"</option>";
			}
			param_key.find("select[name='search_dept_1']").empty().append(select_dept_top_list);
		}
		param_key.find("select[name='search_dept_1']").select2({ minimumResultsForSearch: 20, width:'100px', dropdownAutoWidth: 'true' });
	}
	,
	get_dept_sub_list : function(param_id, param_parent_dept_seq, param_emp_type){
		var param_key = $("#"+ param_id);
		var select_dept_sub_list = "";
		console.log(param_parent_dept_seq);
		if(param_emp_type == 'B'){ // 분원관리자가 접속했을때 
			
			var arr_dept = param_parent_dept_seq.split(",");
			select_dept_sub_list += "<option value='' selected>전체분원</option>";
			for(var i=0; i < arr_dept.length; i++){
				var split_arr_dept = arr_dept[i].split(":");
				select_dept_sub_list += "<option value='"+ split_arr_dept[0] +"'>"+ split_arr_dept[1] +"</option>";
			}
		}else{
			if(param_parent_dept_seq == "" || param_parent_dept_seq == "150" || param_parent_dept_seq == "140"){
				select_dept_sub_list = "";
			}else{
				var obj_result = JSON.parse(common_ajax.inter("/service/v2/dept/"+ param_parent_dept_seq, "json", false, "GET", ""));
				if(obj_result.header.isSuccessful == true){
					var obj_data = JSON.parse(obj_result.data);
					select_dept_sub_list += "<option value='' selected>전체분원</option>";
					for(var i=0; i < obj_data.length; i++){
						select_dept_sub_list += "<option value='"+ obj_data[i]["dlt_dept_seq"] +"'>"+ obj_data[i]["dlt_dept_nm"] +"</option>";
					}
				}
			}
		}
		param_key.find("select[name='search_dept_2']").empty().append(select_dept_sub_list);
		param_key.find("select[name='search_dept_2']").select2({ minimumResultsForSearch: 20, width:'146px', dropdownAutoWidth: 'true' });
		if(select_dept_sub_list == ""){
			param_key.find("select[name='search_dept_2']").select2('destroy');
		}
	}
	,
	get_course_list : function(param_id){
		var param_key = $("#"+ param_id);
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/dept/course", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var select_dept_course_list = "<h5>Branch Type</h5>";
			for(var i=0; i < obj_data.length; i++){
				select_dept_course_list += "<label><input type='checkbox' name='search_type' value='"+ obj_data[i]["course_seq"] +"'/> <span>"+ obj_data[i]["course_nm"] +"</span></label>";
			}
			param_key.find(".sort_option .sort").empty().append(select_dept_course_list);
		}
	}
	,
	get_tag_list : function(param_id){
		var param_key = $("#"+ param_id);
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/tag/main", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var select_tag_main_list = "<h5>Tag</h5>";
			for(var i=0; i < obj_data.length; i++){
				select_tag_main_list += "<label><input type='checkbox' name='search_tag' value='"+ obj_data[i]["tag_code"] +"'/> <span>"+ obj_data[i]["tag_nm"] +"</span></label>";
			}
			param_key.find(".sort_option #tag_list").empty().append(select_tag_main_list);
		}
	}
	,
	get_tag_box_list : function(param_id, selected_value){
		var param_key = $("#"+ param_id);
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/tag/box", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var param_option_select = "";
			var select_tag_list = "<option value=''></option>";
			for(var i=0; i < obj_data.length; i++){
				param_option_select = "";
				if(selected_value != "") { $.each(JSON.parse(selected_value), function(index, value){ if(value == obj_data[i]["tag_code"]){ param_option_select = "selected"; } }); }
				select_tag_list += "<option value='"+ obj_data[i]["tag_code"] +"' "+ param_option_select +">"+ obj_data[i]["tag_nm"] +"</option>";
			}
			param_key.find(".contents .tag select").empty().append(select_tag_list).select2({ minimumResultsForSearch: 20, placeholder: "Select Tag", width:'100%', dropdownAutoWidth: 'true' });
		}
	}
}

var layer = {
	get_dept_list : function(param_id){
		var param_key = $("#"+ param_id);
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/dept/top", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var select_dept_top_list = "";
			for(var i=0; i < obj_data.length; i++){
				select_dept_top_list += "<option value='"+ obj_data[i]["dlt_dept_seq"] +"'>"+ obj_data[i]["dlt_dept_nm"] +"</option>";
			}
			param_key.find("select[name='inup_dept_1']").empty().append(select_dept_top_list);
		}
		param_key.find("select[name='inup_dept_1']").select2({ minimumResultsForSearch: 20, width:'100px', dropdownAutoWidth: 'true' });
	}
	,
	get_dept_news_list : function(param_id){
		var param_key = $("#"+ param_id);
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/dept/top", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var select_dept_top_list = "";
			for(var i=0; i < obj_data.length; i++){
				if ( obj_data[i]["dlt_dept_seq"] == 150 ){
					select_dept_top_list += "<option value='140'>학교</option>";
				}
				select_dept_top_list += "<option value='"+ obj_data[i]["dlt_dept_seq"] +"'>"+ obj_data[i]["dlt_dept_nm"] +"</option>";
			}
			param_key.find("select[name='inup_dept_1']").empty().append(select_dept_top_list);
		}
		param_key.find("select[name='inup_dept_1']").select2({ minimumResultsForSearch: 20, width:'100px', dropdownAutoWidth: 'true' });
	},
	
//	get_dept_news_list : function(param_id){
//		var param_key = $("#"+ param_id);
//		var obj_result = JSON.parse(common_ajax.inter("/service/v2/dept/news", "json", false, "GET", ""));
//		if(obj_result.header.isSuccessful == true){
//			var obj_data = JSON.parse(obj_result.data);
//			var select_dept_top_list = "";
//			if ( obj_data.length == 4){
//				select_dept_top_list += "<option value='' selected>전체분원</option>";
//			}
//			for(var i=0; i < obj_data.length; i++){
//				select_dept_top_list += "<option value='"+ obj_data[i]["DLT_DEPT_SEQ"] +"'>"+ obj_data[i]["DLT_DEPT_NM"] +"</option>";
//			}
//			param_key.find("select[name='inup_dept_1']").empty().append(select_dept_top_list);
//		}
//		param_key.find("select[name='inup_dept_1']").select2({ minimumResultsForSearch: 20, width:'100px', dropdownAutoWidth: 'true' });
//	}
//	,
	get_dept_sub_list : function(param_id, param_parent_dept_seq){
		var param_key = $("#"+ param_id);
		var select_dept_sub_list = "";
		if(param_parent_dept_seq.indexOf(",") > -1){ // 분원관리자가 접속했을때 
			var arr_dept = param_parent_dept_seq.split(",");
			for(var i=0; i < arr_dept.length; i++){
				var split_arr_dept = arr_dept[i].split(":");
				select_dept_sub_list += "<option value='"+ split_arr_dept[0] +"'>"+ split_arr_dept[1] +"</option>";
			}
		}else{
			if(param_parent_dept_seq == "" || param_parent_dept_seq == "150" || param_parent_dept_seq == "140" ){
				select_dept_sub_list = "";
			}else{
				var obj_result = JSON.parse(common_ajax.inter("/service/v2/dept/"+ param_parent_dept_seq, "json", false, "GET", ""));
				if(obj_result.header.isSuccessful == true){
					var obj_data = JSON.parse(obj_result.data);
					select_dept_sub_list += "<option value='' selected>전체분원</option>";
					for(var i=0; i < obj_data.length; i++){
						select_dept_sub_list += "<option value='"+ obj_data[i]["dlt_dept_seq"] +"'>"+ obj_data[i]["dlt_dept_nm"] +"</option>";
					}
				}
			}
		}
		param_key.find("select[name='inup_dept_2']").empty().append(select_dept_sub_list);
		param_key.find("select[name='inup_dept_2']").select2({ minimumResultsForSearch: 20, width:'146px', dropdownAutoWidth: 'true' });
		if(select_dept_sub_list == ""){
			param_key.find("select[name='inup_dept_2']").select2('destroy').hide();
		}
	}
}

var dialog = {
	list_delete_confirm_btn : function(param_obj, param_text, param_rtn_func, param_rtn_value){
		$('.red_bg').fadeIn();
		$('#alert_box').dialog({
			resizable: false,
			height: "auto",
			width: 400,
			modal: true,
			show: { duration: 500 },
			buttons: {
				Cancel: function() {
					$('.red_bg').fadeOut();
					$(this).dialog('close');
				},
				Confirm: function() {
					$('.red_bg').fadeOut();
					$(this).dialog('close');
					param_rtn_func(param_rtn_value);
				}
			}
		});
		$('#alert_box p').text(param_text);
		$('#alert_box').next().find('button:nth-child(2)').addClass('yellow');
	},

	faq_type_delete_alert_btn : function(param_obj, param_text, param_rtn_func, param_rtn_value){
		$('.red_bg').fadeIn();
		$('#alert_box').dialog({
			resizable: false,
			height: "auto",
			width: 400,
			modal: true,
			show: { duration: 500 },
			buttons: {
				Close: function() {
					$('.red_bg').fadeOut();
					$(this).dialog('close');
				},
			}
		});
		$('#alert_box p').text(param_text);
		$('#alert_box').next().find('button:nth-child(2)').addClass('yellow');
	}
}

function fn_edit_table_convert(param_content_html){
	if(window.CSSBS_ie){
		if(window.CSSBS_ie11){ //11버전 이상
			param_content_html = param_content_html.replace(/<p><br><\/p>/g,'<br>');
			param_content_html = param_content_html.replace(/<p>&nbsp;/g,'<br>').replace(/<\/p>/g,'');
		}else{
			param_content_html = param_content_html.replace(/<p>&nbsp;/g,'<br>').replace(/<\/p>/g,'');
		}
	}else if(window.CSSBS_webkit){
		param_content_html = param_content_html.replace(/<div><br><\/div>/g, '<br>');
		param_content_html = param_content_html.replace(/<div>/g, '<br>').replace(/<\/div>/g, '');
	}

	param_content_html = param_content_html.replace(/<(\/span|span)([^>]*)>/gi,"");
	param_content_html = param_content_html.replace(/<(\/div|div)([^>]*)>/gi,"");
	param_content_html = param_content_html.replace(/<(\/p|p)([^>]*)>/gi,"");

	param_content_html = fn_trim_br(fn_trim(param_content_html));
	param_content_html = fn_trim_nbsp(fn_trim(param_content_html));
	param_content_html = fn_trim_br(fn_trim(param_content_html));
	param_content_html = fn_trim_nbsp(fn_trim(param_content_html));
	return param_content_html;
}

function fn_trim(str) { return fn_trim_left(fn_trim_right(str)); }
function fn_trim_left(str) { while (str.substring(0,1) == ' ') { str = str.substring(1, str.length); } return str; }
function fn_trim_right(str){ while (str.substring(str.length - 1, str.length) == ' ') { str = str.substring(0, str.length - 1); } return str; }
function fn_trim_br(str){ return fn_trim_br_left(fn_trim_br_right(str)); }
function fn_trim_br_left(str) { while (str.substring(0,4) == '<br>') { str = str.substring(4, str.length); } return str; }
function fn_trim_br_right(str){ while (str.substring(str.length-4, str.length) == '<br>') {str = str.substring(0, str.length-4); } return str; }
function fn_trim_nbsp(str){ return fn_trim_nbsp_left(fn_trim_nbsp_right(str)); }
function fn_trim_nbsp_left(str) { while (str.substring(0,6) == '&nbsp;') { str = str.substring(6, str.length); } return str; }
function fn_trim_nbsp_right(str){ while (str.substring(str.length-6, str.length) == '&nbsp;') { str = str.substring(0, str.length-6); } return str; }
