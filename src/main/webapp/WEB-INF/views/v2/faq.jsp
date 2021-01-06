<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>



<jsp:include page="popup/type_setting.jsp" flush="true" />

<script type="text/javascript">

	var now_year_date = "${serverDate}";
	var param_emp_type = "${cookieEmpType}";
	var param_emp_dept_list = "${cookieDeptList}";

	var param_empSeq = "${cookieEmpSeq}";
	var param_empNm = "${cookieEmpNm}";
	
	var param_page_num ,param_page_size, param_page_last;
	
	var quill = '';
	var editorType = '';
	var editorChangeTs = '20201127';
	
	$(document).ready(function() {
		param_page_num = 0;
		param_page_size = 30;
		param_page_last = false;
		
		get_faq_dept_list()
		
		/* get_site_list("container"); */
		typeActiveSetting();
		
		/* search.get_tag_list("container"); */
		
		//fn_popup_editor();
		/* $.when(typeActiveSetting()).then(function(){ fn_faq_list(); }); */
		$.when(fn_faq_list()).then(function(){ fn_table_sorter(); });
		
		$("#container .search_box input[type='button']").click(function(){ param_page_last=false; param_page_num = 0; $.when(fn_faq_list()).then(function(){ fn_table_sorter(); });  }); // 검색 > 버튼 클릭시
		
	});
	
	
	/* 사이트 세팅 */
	/*function get_site_list(param_id){
		// 상단
		 var param_key = $("#"+param_id);
		var select_dept_top_list = "<option value='ALL' selected>전체 사이트</option>";
		select_dept_top_list += "<option value='9'>정상어학원</option>";
		select_dept_top_list += "<option value='10'>정상수학학원</option>";
		param_key.find("select[name='search_dept_1']").empty().append(select_dept_top_list);
		param_key.find("select[name='search_dept_1']").select2({ minimumResultsForSearch: 20, width:'150px', dropdownAutoWidth: 'true' });
		
		
		// 우측탭
		$('#fn_site_type').append('<option value="9" >정상어학원</option>');
		$('#fn_site_type').append('<option value="10" >정상수학학원</option>');
		$("#fn_site_type").select2({ minimumResultsForSearch: 20, width:'150px', dropdownAutoWidth: 'true' }); 
	}*/
	
	function get_faq_dept_list(){
		var param_key = $("#container");
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/dept/faq", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var select_dept_top_list = '';
			var select_dept_side_list = '';
			if ( obj_data.length == 2){
				select_dept_top_list += "<option value='ALL' selected>전체분원</option>";
			}
			for(var i=0; i < obj_data.length; i++){
				select_dept_top_list += "<option value='"+ obj_data[i]["DLT_DEPT_SEQ"] +"'>"+ obj_data[i]["DLT_DEPT_NM"] +"</option>";
				select_dept_side_list += "<option value='"+ obj_data[i]["DLT_DEPT_SEQ"] +"'>"+ obj_data[i]["DLT_DEPT_NM"] +"</option>";
			}
			param_key.find("select[name='search_dept_1']").empty().append(select_dept_top_list);
			$('#fn_site_type').empty().append(select_dept_side_list);
			$("#fn_site_type").select2({ minimumResultsForSearch: 20, width:'150px', dropdownAutoWidth: 'true' });
		}
		param_key.find("select[name='search_dept_1']").select2({ minimumResultsForSearch: 20, width:'150px', dropdownAutoWidth: 'true' });
	}
	
	/*Type, Active세팅*/
	function typeActiveSetting(){
		var obj_result = JSON.parse(common_ajax.inter("/faq/getTypeList", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			$('#typeDiv').empty();
			$('#fn_qust_type').empty();
			var obj_data = JSON.parse(obj_result.data);
			$('#typeDiv').append('<h5>Category</h5>');
			for(var i=0; i < obj_data.length; i++){
				$('#typeDiv').append('<label><input type="checkbox" name="search_type" value="'+obj_data[i].CATE_ID+'" /> <span>'+ obj_data[i].CATE_NAME +'</span></label>');
				$('#fn_qust_type').append('<option value="'+obj_data[i].CATE_ID+'">'+ obj_data[i].CATE_NAME +'</option>');
			}
			$("#fn_qust_type").select2({ minimumResultsForSearch: 20, width:'150px', dropdownAutoWidth: 'true' });
			$('#typeDiv').append('<h5>Active</h5>');
			$('#typeDiv').append('<label><input type="checkbox" name="search_status" value="Y" checked/> <span>ON</span></label>');
			$('#typeDiv').append('<label><input type="checkbox" name="search_status" value="N" /> <span>OFF</span></label>');
		}
		
	}
	
	/* 검색박스에서 엔터시 조회되게끔 변경 */
	$(document).on("keypress", "#container .search_box input[name='search_context']", function(){
		param_page_last=false; param_page_num = 0; $.when(fn_faq_list()).then(function(){ fn_table_sorter(); }); 
	});

	function fn_faq_Del(param){
		var param_value_seq = $(param).closest("tr").attr("seq");
		var param_value_site = $(param).closest("tr").attr("site");
		var param_delete_value = {'seq': param_value_seq, 'site': param_value_site};
		dialog.list_delete_confirm_btn($(this), "This item will be deleted. Are you sure?", fn_list_delete_yes, param_delete_value); 
	}
	
	/* Tag Setting open */ 
	function fn_type_setting_open(){
		$('body').addClass('noscroll');
		$('#type_head_pop #pop_tag_setting, .black_bg').fadeIn();
		/* set_scroll(); */
		fn_type_list();
	}
	
	function fn_default_set(){
		$("#container .search input[name='page_start_num']").val(param_page_num);
		$("#container .search input[name='page_size']").val(param_page_size);
	}

	$(window).on('resize', function() {
		/* resize height for sort */
		var option_height = $('.sort_option').height();
		if($('#detail_list .inquiry').hasClass('expand')){
			$('#detail_list .list').css('top', option_height+'px');
		}else{
			$('#detail_list .list').removeAttr('style');
		}
		/* resize height for scroller */
		var table_height = $('#detail_list .list').height()-34;
		$('#detail_list .tablesorter-scroller-table').css('maxHeight',table_height);
		$("#detail_list .hms_table").css("width", $("#container").width());
	});
	
	$(document).on('mouseenter','#detail_list .hms_table td',function() { $(this).closest('tr').addClass('hover'); });
	$(document).on('mouseleave','#detail_list .hms_table td',function() { $(this).closest('tr').removeClass('hover'); });
	$(document).on('mouseenter', 'td.delete_record',function(e){ $(this).closest('tr').removeClass('hover'); e.stopPropagation(); });
	$(document).on('click', 'td.delete_record',function(e){ e.stopPropagation(); });
	
	/* sort 조건 눌렀을때 */
	$(document).on("click", "#detail_list .sort input:checkbox", function(){
		param_page_last=false; param_page_num = 0; $.when(fn_faq_list()).then(function(){ fn_table_sorter(); });
	});
	
	function fn_table_sorter(){
		var table_height = $('#detail_list .list').height()-34;
		
		$('#detail_list .tablesorter').trigger('sortReset');
		$("#detail_list .tablesorter").tablesorter({
			headers : { 
				'.delete_record, .edit_record' : {sorter:false}
			},
			widgets: [ 'scroller' ],
			widgetOptions : {
				scroller_height : table_height,
				scroller_upAfterSort: true,
				scroller_jumpToHeader: true,
				scroller_rowHighlight : 'hover',
				scroller_barWidth : null
			}
		});

		var option_height = $('.sort_option').height();
		if($('#detail_list .inquiry').hasClass('expand')){
			$('#detail_list .list').css('top', option_height+'px');
		}else{
			$('#detail_list .list').removeAttr('style');
		}
		$("#detail_list .hms_table").css("width", $("#container").width());
		
		// 스크롤했을때 param_page_num 추가해서 append 한다. 
		$("#detail_list .hms_table .tablesorter-scroller-table").scroll(function(){ 
			if($(this).scrollTop() >= ($(this).find(".tablesorter").height() - $(this).height())){
				if(param_page_last == false){
					++param_page_num; 
					$.when(fn_faq_list()).then(function(){ fn_table_sorter(); });
				}
			}
		});
		
	}
	
	function fn_faq_list(){
		var no_data = "<tr><td colspan='8' class='nodata' data-guide='No data available!'></td></tr>";
		fn_default_set();
		console.log(search.get_parameter("container"));
		var obj_result = JSON.parse(common_ajax.inter("/faq/list", "json", false, "POST", search.get_parameter("container")));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var insert_table_data = "";
			if(obj_data.length == 0){ 
				param_page_last = true; 
				if(param_page_num == 0){ $("#container #detail_list .list .hms_table .tablesorter tbody").empty().append(no_data); }
				$("#container #detail_list .list .hms_table .tablesorter tbody").append(insert_table_data);
			}else{
				for(var i=0; i < obj_data.length; i++){

					/* var delete_btn_status = (obj_data[i]["USE_YN"] == 'Y' ) ? "" : "disabled"; */
					
					insert_table_data += "<tr seq='"+ obj_data[i]["SEQ_NO"] +"'site='"+ obj_data[i]["SITE_ID"] +" ' orgRegTs='"+ obj_data[i]["REG_DT_ORG"] +" '>";
					insert_table_data += "<td class='newstype_record'>"+ obj_data[i]["SITE_NM"] +"</td>";
					insert_table_data += "<td class='branch_record left'>"+ obj_data[i]["CATE_NAME"] +"</td>";
					insert_table_data += "<td class='title_record left'>"+ obj_data[i]["SUBJECT"] +"</td>";
					insert_table_data += "<td class='status_record'>"+ obj_data[i]["ACTIVE"] +"</span></td>";
					insert_table_data += "<td class='author_record'>"+ obj_data[i]["REG_NAME"] +"</td>";
					insert_table_data += "<td class='date_record'>"+ common_date.convertType(obj_data[i]["REG_DT"],8) +"</td>";
					insert_table_data += "<td class='count_record'>"+ obj_data[i]["COUNT"] +"</td>";
					insert_table_data += "<td class='delete_record'><button title='Delete' onclick='fn_faq_Del(this)' class='icon delete'><span>Delete</span></button></td>";
					insert_table_data += "</tr>";
				}
				if(param_page_num == 0){ $("#container #detail_list .list .hms_table .tablesorter tbody").empty(); }
				$("#container #detail_list .list .hms_table .tablesorter tbody").append(insert_table_data);
				if(obj_data.length < param_page_size){ param_page_last = true; }
			}
		}else{
			$("#container #detail_list .list .hms_table .tablesorter tbody").empty().append(no_data);
		}
		$("#container #detail_list .list .hms_table .tablesorter").trigger("update");

	}
	
	function fn_list_delete_yes(param_rtn_value){
		var site = param_rtn_value.site
		var seq = param_rtn_value.seq
		var obj_tag_result = JSON.parse(common_ajax.inter("/faq/del/"+ site+ "/"+ seq, "json", false, "DELETE", ""));
		if(obj_tag_result.header.isSuccessful == true){ fn_faq_list(); }
	}
	
	/* 게시물 추가 > 레이어 오픈  */ 
	function fn_new_post_open(){
		
		$('.edit_news').children().remove();
		$('.edit_news').append('<div id="paper_editor"></div>');
		
		fn_popup_editor_quill();
		editorType = 'quill';
		
		$('#tabTitle').empty().append("<b>New FAQ</b>");
		$("#container .tit_area button").prop("disabled", true);
		$('#detail_list tbody tr').removeClass('selected');
		$('#container').addClass('expand');
		$('#detail_info').addClass('new');
		
		$("#detail_info input[name='faq_seq']").val("");
		$("#detail_info input[name='title']").val("");
		$("#active_use_yn").prop("checked", true);
		
		
		
		$("#fn_site_type option:eq(0)").prop("selected", true).change();
		$("#fn_qust_type option:eq(0)").prop("selected", true).change();
		$('#fn_site_type').prop('disabled', false);
		$("#fn_qust_type").prop('disabled', false);
		
		$("#detail_info .contents .thumb img").attr("src", "");
		
		$('#paper_editor .ql-editor').empty();		
		
		/* button */
		$("#detail_info .page .create_btn button.save").hide();
		$("#detail_info .page .create_btn button.create").show();
		/* fn_popup_editor_modi(); */
	}

	$(document).on("change", "#detail_info .viewbar select[name='inup_dept_1']", function(){ /* 레이어 오픈 > 분원선택 */ 
		if(param_emp_type == 'S'){
			$("#detail_info .viewbar select[name='notice_type']").attr("disabled", true);
			layer.get_dept_sub_list("detail_info", $(this).find(":selected").val());
			$("#detail_info .viewbar select[name='notice_type']").select2("val", "1");
		}else{
			console.log(">>>> event");
			$("#detail_info .viewbar select[name='notice_type']").attr("disabled", true);
			$("#detail_info .viewbar select[name='notice_type']").select2("val", "2");
		}
	});

	$(document).on('click','#detail_info button.cancel, #detail_info .close_detail',function() {
		$("#container .tit_area button").prop("disabled", false);
		$('#detail_list .hms_table tr').removeClass('selected');
		$('#detail_info').removeClass('new');
		$('#container').removeClass('expand');
		
		resize_sorth();
		//resize_tablesorter();
	});
	
	/* 게시물 수정 > 레이어 오픈 */ 
	$(document).on('click','#detail_list .hms_table tbody tr', function() {
		$('.edit_news').children().remove();
		$('.edit_news').append('<div id="paper_editor"></div>');
		
		var orgRegTs = $(this).attr("orgRegTs");
		$('#tabTitle').empty().append("<b>FAQ Setting</b");
		if($(this).find("td.nodata").length == 0){
			$("#container .tit_area button").prop("disabled", true);
			$("#detail_info .viewbar select[name='notice_type']").prop('disabled', false);
			$('#detail_info').removeClass('new');
			
			if($(this).hasClass('selected')){
				$(this).toggleClass('selected');
				$('#container').toggleClass('expand');
				$("#container .tit_area button").prop("disabled", false);
			} else{
				$(this).closest('tbody').find('tr').removeClass('selected');
				$(this).addClass('selected');
				$('#container').addClass('expand');
				
				$('#detail_info .page .form_table input, #detail_info .page .form_table textarea').not(":radio, :checkbox").val("");
				$('#paper_editor .ql-editor').empty();
				$("#detail_info .contents .thumb img").attr("src", "");
				$("#detail_info .page .create_btn button.save").show();
				$("#detail_info .page .create_btn button.create").hide();
				
				/* 타입 입력하고 내용/링크 등등 가지고 온다. */
				$("#detail_info .viewbar input[name='faq_seq']").val($(this).attr("seq"));
				$("#detail_info .viewbar input[name='faq_site']").val($(this).attr("site"));
				
				var obj_result = JSON.parse(common_ajax.inter("/faq/view/"+ $(this).attr("seq") +"/"+ $(this).attr("site"), "json", false, "GET", ""));
				if(obj_result.header.isSuccessful == true){
					var obj_data = JSON.parse(obj_result.data);
					$("#fn_site_type").val(obj_data[0]["SITE_ID"]);
					$("#fn_site_type").val(obj_data[0]["SITE_ID"]).change();
					$("#fn_site_type").prop('disabled', true);
					$("#fn_qust_type").val(obj_data[0]["CATE_ID"]);
					$("#fn_qust_type").val(obj_data[0]["CATE_ID"]).change();
					$("#fn_qust_type").prop('disabled', true);
					
					var useFlag = true; 
					if ( obj_data[0]["USE_YN"] == "N" ){
						useFlag= false;
					} 
					$("#active_use_yn").prop("checked", useFlag);
					$("#detail_info input[name='title']").val(obj_data[0]["SUBJECT"]);
					
					// quill
					if ( orgRegTs >= editorChangeTs){
						editorType = 'quill';
						fn_popup_editor_quill();
						var editorData = obj_data[0]["CONTENTS"];
						editorData = editorData.replace("<div style='width:100%;text-align:left;'>", "");
						editorData = editorData.replace('<div style="width:100%;text-align:left;">', '');
						editorData = editorData.replace('</div>', '');
						var editorJson = JSON.parse(editorData)
		    			quill.setContents(editorJson, 'silent');						
					}else{
						editorType = 'summernote';
						$('#paper_editor').summernote('code', "");
						fn_popup_editor_summernote();
						$('#paper_editor').summernote('code', obj_data[0]["CONTENTS"]);
					}
        			
				}
				
				/* fn_popup_editor_modi(); */
			}
		}
	});	
</script>

<div id="container" class="main">
	<div class="tit_area">
		<h3>FAQ Setting</h3>
		<div class="search">
			<div class="items">
				<input type="hidden" name="page_start_num" />
				<input type="hidden" name="page_size" />
				
				<select name="search_dept_1" style="width:150px"></select>
				<!-- <select name="search_dept_2"></select> -->
			</div >
			<div class="search_box">
				<input type="text" name="search_context" placeholder="Title text" />
				<input type="button" class="search_btn" />
			</div>
		</div>
		<button type="button" class="black new" onclick="fn_new_post_open()"><span>New FAQ</span></button>
		<%-- <c:if test="${cookieEmpType == 'S'}">
		<button type="button" class="setting" onclick="fn_type_setting_open()"><span>Type Setting</span></button>
		</c:if> --%>
	</div>
	<div id="detail_list">
		<div class="sort_option">
			<div class="inquiry">
				<div class="sort first" id="typeDiv">
				</div>
				<div class="sort" id="tag_list"></div>
			</div>
		</div>
		<div class="list">
			<div class="hms_table">
				<table class="tablesorter">
					<colgroup>
						<col style="width:10%;">
						<col style="width:10%;">
						<col style="width:35%">
						<col style="width:10%;">
						<col style="width:10%;">
						<col style="width:15%;">
						<col style="width:10%;">
						<col style="width:35px;">
					</colgroup>
					<thead>
						<tr>
							<th class="branch_record">Site</th>
							<th class="btype_record">Category</th>
							<th class="title_record">Title</th>
							<th class="status_record">Active</th>
							<th class="author_record">Author</th>
							<th class="date_record">Issue Date</th>
							<th class="period_record">Count</th>
							<th class="delete_record"></th>
						</tr>
					</thead>
					<tbody></tbody>
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
		/* var Font = Quill.import('attributors/class/font'); */
		var Font = Quill.import('formats/font'); 
		Font.whitelist = ['nanumgothic', 'malgungothic', 'gulim', 'dotum']; 
	    Quill.register({
	    	'modules/better-table': quillBetterTable
	    	}, true)
		Quill.register( Font, true)
		quill = new Quill('#paper_editor', {
			theme: 'snow',
		    modules: {
		    	 toolbar: [
		    		  [{ 'font': ['nanumgothic', 'malgungothic', 'gulim', 'dotum'] }, { 'size': [] }],
				      ['bold', 'italic', 'underline', 'strike'],
				      [{ 'script': 'sub'}, { 'script': 'super' }], 
				      [{ 'color': []}, { 'background': []}],   
				      [{ 'list': 'bullet' }, { 'list': 'ordered'},{ 'align': [] } ],
				      [ 'link', 'image', 'video', 'formula'],
				      ['table'] 
				    ],  
				    //toolbar: false,
		      table: false,  // disable table module
		         'better-table': {
			        operationMenu: {
			          items: {
			            unmergeCells: {
			              text: 'Another unmerge cells name'
			            }
			          }
			        }
			      }
		      // keyboard: {
		      //  bindings: QuillBetterTable.keyboardBindings
		      //}
		    }
		  })
		
		quill.getModule('toolbar').addHandler('image',function(){
			fn_editor_image_upload_quill(quill);
		});
	    /* quill.getModule('toolbar').addHandler('video',function(){
			console.log('aaaaaaaaaaaa');
		}); */
		quill.getModule('toolbar').addHandler('table',function(){
			Quill.register({
				  'modules/better-table': quillBetterTable,
				}, true) 
			var focus_bf = quill.focus();
			tableModule = quill.getModule('better-table')
			tableModule.insertTable(3, 3)
			var focus_af = quill.focus();
		});  
	
		if ( $('.qlbt-col-tool').length > 0 ) {
			$('.qlbt-col-tool').remove();
		}
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
			//imageCheck($(this))
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
	
	
	/* function imageCheck(el){
		if(!/\.(jpeg|jpg|png|gif|bmp)$/i.test(el.value)){
			alert('이지미 파일만 등록 가능합니다');
			el.value = '';
			el.focus();
		}
	} */
	
	function fn_popup_editor_modi(){
		$("#paper_editor .dropdown-fontname li a").removeClass("checked");
		$("#paper_editor .dropdown-fontname li:eq(0) a").addClass("checked");
		$("#paper_editor .note-current-fontname").text($(".dropdown-fontname li:eq(0) a").attr('data-value'));
	}
	
	/* 추가 및 수정 버튼 클릭시 */
	$(document).on("click", "#detail_info .create_btn .create, #detail_info .create_btn .save", function(){

		var param_inup_type = ($("#detail_info").attr("class") == "new") ? "insert" : "update";
		var param_site_type = $("#fn_site_type").val();
		var param_qust_type = $("#fn_qust_type").val();
		var param_title = $("#detail_info .contents .form_table input[name='title']").val();
		
		//var param_editor_text = quill.root.innerHTML;
		//var param_editor_text = $('.ql-editor').html()
		var param_editor_text = '';
		// quill
		if ( editorType == 'quill'){
      		param_editor_text = JSON.stringify(quill.getContents())
		}else{
			param_editor_text = $('#paper_editor').summernote('code');
			if(param_editor_text.substring(0,4) != "<div"){ param_editor_text = "<div style='width:100%;text-align:left;'>"+ param_editor_text +"</div>"; }
		}
		
		if(param_title == ""){ alert("제목을 입력해 주세요."); return; } 
		if(param_editor_text == ""){ alert("내용을 입력해 주세요."); return; }
		
				
		var param_obj = new Object();
		param_obj["param_inup_type"] = param_inup_type;
		param_obj["param_site_type"] = param_site_type;
		param_obj["param_qust_type"] = param_qust_type;
		param_obj["param_title"] = param_title;
		param_obj["param_editor_text"] = param_editor_text;
		param_obj["param_empNm"] = param_empNm;
		param_obj["param_empSeq"] = param_empSeq;
		param_obj["param_seq_no"] = $("#detail_info .viewbar input[name='faq_seq']").val()
		
		var param_use_yn = "N";
		if($("#active_use_yn").is(":checked")){
			param_use_yn = "Y";
		}
		param_obj["param_use_yn"] = param_use_yn;
		

		console.log(param_obj);
		var obj_result = JSON.parse(common_ajax.inter("/faq/save", "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			alert("저장이 완료 되었습니다.");
			$("#detail_info button.cancel").trigger("click");
			fn_faq_list();
		}else{
			alert(obj_result.header.resultMessage);
		}
	});
	
	

		
	
	/* 썸네일 받기 */
	function fn_popup_thumb_image_return(thumb_image_path){ $("#detail_info .contents .thumb img").attr("src", thumb_image_path); }
	
	</script>
	<input type="file" accept="image/*" id="getImage" onchange="imagecheck(this);">
	<div id="detail_info">
		<div class="viewbar">
			<input type="hidden" name="faq_seq" />
			<h4 id="tabTitle"><b>FAQ</b></h4>
			<div class="items " >
				<select id="fn_site_type">
				</select>
			</div>
			<div class="items">
				<select id="fn_qust_type"></select>
			</div>
			<label class="onoff"><input id="active_use_yn" type="checkbox" checked><span>Active</span></label>
			<div class="close_detail"></div>
		</div>
		<div class="page faq">
			<div class="contents">
				<div class="set_input" >
					<ul class="form_table">
						<li>
							<div class="cell title" >
							<input type="text" name="title" value="" placeholder="Please enter title" />
							</div>
						</li>
					</ul>
				</div>
				<div class="edit_news"><div id="paper_editor"></div>
			</div>
			</div>
		<div class="create_btn">
			<button type="button" class="small cancel"><span>Cancel</span></button>
			<button type="button" class="small yellow save"><span>Save</span></button>
			<button type="button" class="small blue create"><span>Create</span></button>
			
			
		</div>
	</div>
	
</div>