<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

	<link rel="stylesheet" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/toast_editor/css/tui-editor.css">
	<link rel="stylesheet" href="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/toast_editor/css/tui-editor-contents.css">
	<script src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/toast_editor/js/tui-editor-Editor.js"></script>
	<script src="<spring:eval expression="@globalContext['IMG_SERVER']" />/common/toast_editor/js/tui-editor-extTable.js"></script>

	<script type="text/javascript">
	var now_year_date = "${serverDate}";
	var guide_editor, schedule_editor;
	var editor_toolbar = [ 'heading', 'bold', 'italic', 'strike', 'divider', 'hr', 'quote', 'divider', 'ul', 'ol', 'task', 'indent', 'outdent', 'divider', 'table', 'link', 'divider', 'code', 'codeblock' ]; //'image' 제거 
	
	$(document).ready(function() {
		$.when(fn_main_program_list()).then(function(){ fn_table_sortable(); });
	});
	
	function fn_main_program_list(){
		var no_data = "<tr><td colspan='4' class='nodata' data-guide='No data available!'></td></tr>";
		
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/program", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			var insert_table_data = "";
			if(obj_data.length > 0){ 
				for(var i=0; i < obj_data.length; i++){
					insert_table_data += "<tr code='"+ obj_data[i]["menu_seq"] +"'>";
					insert_table_data += "<td class='type_record left'>"+ obj_data[i]["parent_menu_nm"] +"</td>";
					insert_table_data += "<td class='title_record left'>"+ obj_data[i]["menu_nm"] +"</td>";
					insert_table_data += "<td class='author_record'>"+ obj_data[i]["reg_user_nm"] +"</td>";
					var param_reg_ts = (obj_data[i]["reg_ts"] == undefined) ? "" : common_date.convertType(obj_data[i]["reg_ts"],8);
					insert_table_data += "<td class='date_record'>"+ param_reg_ts +"</td>";
					insert_table_data += "</tr>";
				}
				$("#container #detail_list .tablesorter tbody").empty().append(insert_table_data);
			}else{
				$("#container #detail_list .tablesorter tbody").empty().append(no_data);
			}
		}else{
			$("#container #detail_list .tablesorter tbody").empty().append(no_data);
		}
	}
	
	function fn_table_sortable(){
		var table_height = $('#detail_list .list').height()-34;
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
	}
	
	$(document).on('click','#detail_list .hms_table tbody tr',function() {
		$('#detail_info').removeClass('new');
		if($(this).hasClass('selected')){
			fn_layer_cancel();
		} else{
			$(this).closest('tbody').find('tr').removeClass('selected');
			$(this).addClass('selected');
			$('#container').addClass('expand');
			$('.browser.sidebar').removeClass('expand');
			
			var param_menu_seq = $(this).attr("code");
			var param_menu_nm = $(this).find("td.title_record").text();
			$.when(fn_input_page_reset()).then(function(){
				fn_program_info(param_menu_seq, param_menu_nm); // 첫번째로 로딩시에 프로그램 소개 Event 작동 
			});
		}
	});

	/* #program_info delete button */
	$(document).on('click', '#detail_info .create_btn button.delete',function() {
		var sel_css_name = $(this).closest('div').parent('div').find('#ptype').val();
		//console.log("sel_css_name::"+sel_css_name);
		fn_program_content_remove(sel_css_name); 
	});
	
	/* #detail_info cancel button */
	$(document).on('click', '#detail_info .create_btn button.cancel, #detail_info .close_detail',function() { fn_layer_cancel(); });

	$(document).on('click', '#detail_info .create_btn button.save',function() { 
		var param_now_class = common_trims.trim($(this).closest("div.page").attr("class").replace("page", ""));
		var param_menu_seq = $("#detail_info input[name='param_menu_seq']").val();
		
		if(param_menu_seq == ""){ alert("잘못된 경로로 접근하셨습니다. 다시 시도해주세요."); return; }
		
		var param_obj = new Object();
		param_obj["param_menu_seq"] = param_menu_seq;
		param_obj["param_content_menu_seq"] = $("#detail_info ."+ param_now_class +" input[name='param_content_menu_seq']").val();

		if(param_now_class == "program_info"){
			var param_video_url = $("#detail_info ."+ param_now_class +" input[name='video_url']").val();
			if(param_video_url == ""){ alert("유튜브 URL을 입력해 주세요."); return; }
			
			var param_url_sp = param_video_url.split("/");
			var param_youtube_code = param_url_sp[param_url_sp.length -1];
			
			param_obj["param_content_type"] = "INFO";
			param_obj["param_video_url"] = param_youtube_code;
			param_obj["param_title"] = "";
			param_obj["param_contents"] = "";
			param_obj["param_thumbnail_path"] = "";
		}else{
			var param_title = $("#detail_info ."+ param_now_class +" input[type='text']").val();
			if(param_title == ""){ alert("제목을 입력해 주세요."); return; }

			param_obj["param_content_type"] = (param_now_class == "guidelines")? "GUIDE" : "SCHEDULE";
			param_obj["param_video_url"] = "";
			param_obj["param_title"] = param_title;
			param_obj["param_contents"] = (param_now_class == "guidelines")? guide_editor.data().tuiEditor.getHtml() : schedule_editor.data().tuiEditor.getHtml();
			param_obj["param_thumbnail_path"] = "";
		}

		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/program", "json", false, "POST", param_obj));
		if(obj_result.header.isSuccessful == true){
			alert("저장이 완료 되었습니다.");
			$.when(fn_main_program_list()).then(function(){ fn_layer_cancel(); });
		}else{
			alert(obj_result.header.resultMessage);
		}
		
	});

	function fn_layer_cancel(){
		$("#detail_list .hms_table tbody tr").removeClass('selected');
		$('#container').toggleClass('expand');
		$('.browser.sidebar').toggleClass('expand');
		fn_input_page_reset();
	}
	
	function fn_input_page_reset(){
		$("#detail_info input[name='param_menu_seq']").val("");
		$("#detail_info .subtit h4").text("");
		$("#detail_info .page input[type='text'], #detail_info .page input[name='param_content_menu_seq']").val("");
		$("#detail_info .program_info #youtube_frm").attr("src", "");
		$("#detail_info .tabnav ul li").removeClass("selected");
		$("#detail_info .tabnav ul li:eq(0)").addClass("selected");
		guide_editor.tuiEditor('setValue', '');
		schedule_editor.tuiEditor('setValue', '');
	}
	
	/* 프로그램 소개 */
	function fn_program_info(param_menu_seq, param_menu_nm){
		
		$("#detail_info input[name='param_menu_seq']").val(param_menu_seq);
		$("#detail_info .subtit h4").text(param_menu_nm);
		$('#detail_info').find('.page').addClass('hide');
		$('#detail_info').find('.program_info').removeClass('hide'); //첫번째것만 오픈 
		$("#detail_info .program_info .create_btn button.delete").addClass("hide"); //프로그램소개 삭제버튼 숨기기	
		$("#detail_info .guidelines .create_btn button.delete").addClass("hide"); //모집안내 삭제버튼 숨기기	
		$("#detail_info .schedule .create_btn button.delete").addClass("hide"); //현지일정 삭제버튼 숨기기		
		
		var param_create_mode = true;
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/program/"+ param_menu_seq, "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			if(obj_data.length > 0){
				param_create_mode = false;
				
				for(var i=0; i < obj_data.length; i++){
					console.log(obj_data[i]["content_type"]+"|menu_content_seq::"+obj_data[i]["menu_content_seq"]);
					if(obj_data[i]["content_type"] == "INFO"){
						var youtube_url = "https://youtu.be/"+ obj_data[i]["video_url"];
						$("#detail_info .program_info .youtube_url input[name='video_url']").val(youtube_url);
						$("#detail_info .program_info #youtube_frm").attr("src", "https://www.youtube.com/embed/"+ obj_data[i]["video_url"]);
						$("#detail_info .program_info input[name='param_content_menu_seq']").val(obj_data[i]["menu_content_seq"]);
						if(obj_data[i]["menu_content_seq"] != ""){						
							$("#detail_info .program_info .create_btn button.delete").removeClass("hide");							
						}else{						
							$("#detail_info .program_info .create_btn button.delete").addClass("hide");							
						}
					}else if(obj_data[i]["content_type"] == "GUIDE"){
						$("#detail_info .guidelines input[type='text']").val(obj_data[i]["title"]);
						guide_editor.data().tuiEditor.setHtml(obj_data[i]["contents"]);
						$("#detail_info .guidelines input[name='param_content_menu_seq']").val(obj_data[i]["menu_content_seq"]);
						if(obj_data[i]["menu_content_seq"] != ""){						
							$("#detail_info .guidelines .create_btn button.delete").removeClass("hide");							
						}else{						
							$("#detail_info .guidelines .create_btn button.delete").addClass("hide");							
						}
					}else if(obj_data[i]["content_type"] == "SCHEDULE"){
						$("#detail_info .schedule input[type='text']").val(obj_data[i]["title"]);
						schedule_editor.data().tuiEditor.setHtml(obj_data[i]["contents"]);
						$("#detail_info .schedule input[name='param_content_menu_seq']").val(obj_data[i]["menu_content_seq"]);
						if(obj_data[i]["menu_content_seq"] != ""){						
							$("#detail_info .schedule .create_btn button.delete").removeClass("hide");							
						}else{						
							$("#detail_info .schedule .create_btn button.delete").addClass("hide");							
						}
					}
				}
			}
		}
	}
	
	/* 상세화면 > 메뉴클릭  */
	$(document).on('click','#detail_info .tabnav ul>li',function() {
		$(this).closest('#detail_info').find('.page').addClass('hide');
		$(this).closest('ul').find('li').removeClass('selected');
		$(this).addClass('selected');
		
		var type = $(this).attr('data-type')
		if(type == 'program_info'){ $('#detail_info .program_info').removeClass('hide')
		} else if(type == 'guidelines'){ $('#detail_info .guidelines').removeClass('hide')
		} else if(type == 'schedule'){ $('#detail_info .schedule').removeClass('hide')
		}
	});
	
	/* 유튜브 URL 입력후 */
	$(document).on("keyup", "#detail_info .program_info input[name='video_url']", function(){
		var param_url_sp = $(this).val().split("/");
		var param_video_url = param_url_sp[param_url_sp.length -1];
		$("#detail_info .program_info #youtube_frm").attr("src", "https://www.youtube.com/embed/"+ param_video_url);
	});
	

	/* 프로그램 하위 컨텐츠 삭제 */
	function fn_program_content_remove(css_name){		
		//var param_menu_seq = $("#detail_info input[name='param_menu_seq']").val();
		var param_menu_content_seq = $("#detail_info ."+css_name+" input[name='param_content_menu_seq']").val();
		//var param_menu_nm = $("#detail_info .subtit h4").text();
		
		//console.log(css_name+"|"+param_menu_content_seq);

		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/program/"+ param_menu_content_seq, "json", false, "DELETE", ""));
		if(obj_result.header.isSuccessful == true){
			//$("#detail_info input[name='param_menu_seq']").val(param_menu_seq);
			//$("#detail_info .subtit h4").text(param_menu_nm);			
			//$.when(fn_input_page_reset()).then(function(){
			//	fn_program_info(param_menu_seq, param_menu_nm);   
			//});
			alert("해당 서브 컨텐츠가 삭제 되었습니다.");
			$.when(fn_main_program_list()).then(function(){ fn_layer_cancel(); });
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
		<div class="contents page_edit">
			<div class="basic">
				<dl class=""><dd class="name"><h3>프로그램 <span class="depth_txt">></span> <b>프로그램 소개/모집요강/스케줄</b></h3></dd></dl>
			</div>
			<div id="detail_list">
				<div class="list">
					<div class="hms_table">
						<table class="tablesorter">
							<colgroup>
								<col style="width:15%;">
								<col style="width:55%;">
								<col style="width:15%;">
								<col style="width:15%;">
							</colgroup>
							<thead>
								<tr>
									<th class="type_record">Type</th>
									<th class="title_record">Program Name</th>
									<th class="author_record">Author</th>
									<th class="date_record">Issue Date</th>
								</tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
			</div>
			<div id="detail_info">
				<input type="hidden" name="param_menu_seq" />
				<div class="tabnav">
					<ul>
						<li data-type="program_info" class="selected"><span>프로그램 소개</span></li>
						<li data-type="guidelines"><span>모집안내</span></li>
						<li data-type="schedule"><span>현지일정</span></li>
					</ul>
					<div class="close_detail"></div>
				</div>
				<div class="page program_info">
					<input type="hidden" name="param_content_menu_seq" />
					<input type="hidden" id="ptype" value="program_info" />
					<div class="contents sa_info">
						<div class="edit_banner">
							<div class="subtit"><h4></h4></div>
							<hr/>
							<div class="section">
								<div class="top_info">
									<h5></h5>
									<div class="use_info"><span class="icon_pc" title="PC"></span><span class="icon_mobile" title="Mobile"></span></div>
								</div>
								<div class="bsize"><iframe id="youtube_frm" width="1180" height="340" src="" frameborder="0" allowfullscreen=""></iframe></div>
								<div class="youtube_url"><input type="text" name="video_url" value="" placeholder="Ex) https://youtu.be/mJte6MY1qjA" /></div>
								<div class="tip_info"><p class="alert">유튜브 동영상에서 동영상URL 복사후 넣어주세요.</p></div>
							</div>
						</div>
					</div>
					<div class="create_btn">
						<button type="button" class="small delete hide"><span>Delete</span></button>
						<button type="button" class="small cancel"><span>Cancel</span></button>
						<button type="button" class="small yellow save"><span>Save</span></button>
					</div>
				</div>
				<div class="page guidelines">
					<input type="hidden" name="param_content_menu_seq" />
					<input type="hidden" id="ptype" value="guidelines" />
					<div class="contents">
						<div class="set_input">
							<ul class="form_table"><li><div class="cell title large"><input type="text" value="" placeholder="Please enter title" /></div></li></ul>
							<div class="tip"><p><b>How to use editor</b> : 표 영역을 선택한 후 마우스 우클릭을 하면 표의 셀 합치기, 표안의 텍스트 정렬을 하실 수 있습니다.</p></div>
						</div>
						<div class="edit_news"><div id="guide_paper_editor"></div></div>
						<script class="code-js">
						guide_editor = $('#guide_paper_editor').tuiEditor({ initialEditType: 'wysiwyg', previewStyle: 'vertical', height: '100%' ,exts: ['table'], toolbarItems: editor_toolbar });
						</script>
					</div>
					<div class="create_btn">
						<button type="button" class="small delete hide"><span>Delete</span></button>
						<button type="button" class="small cancel"><span>Cancel</span></button>
						<button type="button" class="small yellow save"><span>Save</span></button>
					</div>
				</div>
				<div class="page schedule">
					<input type="hidden" name="param_content_menu_seq" />
					<input type="hidden" id="ptype" value="schedule" />
					<div class="contents">
						<div class="set_input">
							<ul class="form_table"><li><div class="cell title large"><input type="text" value="" placeholder="Please enter title" /></div></li></ul>
							<div class="tip"><p><b>How to use editor</b> : 표 영역을 선택한 후 마우스 우클릭을 하면 표의 셀 합치기, 표안의 텍스트 정렬을 하실 수 있습니다.</p></div>
						</div>
						<div class="edit_news"><div id="schedule_paper_editor"></div></div>
						<script class="code-js">
						schedule_editor = $('#schedule_paper_editor').tuiEditor({ initialEditType: 'wysiwyg', previewStyle: 'vertical', height: '100%' ,exts: ['table'], toolbarItems: editor_toolbar });
						</script>
					</div>
					<div class="create_btn">
						<button type="button" class="small delete hide"><span>Delete</span></button>
						<button type="button" class="small cancel"><span>Cancel</span></button>
						<button type="button" class="small yellow save"><span>Save</span></button>
					</div>
				</div>			
			</div>
		</div>
	</div>
