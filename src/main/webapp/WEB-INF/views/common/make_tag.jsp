<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>

	<script type="text/javascript">
	var param_tag_seq = "${param_seq}";
	var param_tag_view = "${param_tag_view}";
	var param_main_view = "${param_main_view}";
	
	$(document).ready(function() {
		$(".create_area .basic input[name='param_tag_view']").eq(0).prop('checked', true);

		var obj_result = JSON.parse(common_ajax.inter("/service/tag/mainview", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){
			var obj_data = JSON.parse(obj_result.data);
			for(var i=0; i < obj_data.length; i++){
				if(param_main_view == "" || param_main_view == "0"){
					$(".create_area .basic select[name='param_main_view'] option[value='"+ obj_data[i]["mainViewYn"] +"']").remove();
				}else{
					if(param_main_view != obj_data[i]["mainViewYn"]){
						$(".create_area .basic select[name='param_main_view'] option[value='"+ obj_data[i]["mainViewYn"] +"']").remove();
					}
				}
			}
		}
		
		if(param_tag_seq == ""){
			$(".header h1").text("태그등록");
		}else{
			$(".header h1").text("태그수정");
			var param_tag_nm = $("[data-record-key='"+ param_tag_seq +"']").find("td:eq(2)").text();
			console.log(param_tag_nm +">>>>>");
			
			$(".create_area .basic input[name='param_tag_seq']").val(param_tag_seq);
			$(".create_area .basic input[name='param_tag_nm']").val(param_tag_nm);
			$(".create_area .basic select[name='param_main_view'] option[value='"+ param_main_view +"']").prop("selected","selected");
			if(param_tag_view == '1'){ 
				$(".create_area .basic input[name='param_tag_view']").eq(0).prop('checked', true);
			} else {
				$(".create_area .basic input[name='param_tag_view']").eq(1).prop('checked', true);
			}
		}
		
		fnUniform();
		
		// 저장버튼 클릭시 
		$(".footer .ok").click(function(){
			if($(".create_area .basic input[name='param_tag_nm']").val() == ""){ common_alert.big('warning','태그를 입력해 주세요.'); return; }
			if( $(".create_area .basic input[name='param_tag_view']:checked").val() == "0" && $(".create_area .basic select[name='param_main_view'] option:selected").val() != "0" ){
				common_alert.big('warning','상태값이 Hidden일때 메인노출을 할수 없습니다.'); return;
			}

			$.ajax({
				data : $('#tagMngForm').find("select, textarea, input").serialize(),
				type : "POST",
				url : "/service/tag/mng",
				success : function(data){
					var obj_result = JSON.parse(data);
					if(obj_result.header.isSuccessful == true){
						var message = "";					
						if($("input[name='param_tag_seq']").val == ""){
							message = "태그가 생성되었습니다.";
						}else{
							message = "태그가 수정되었습니다.";
						}
						common_alert.big_func('success', message, fnSaveOk);
					}else{
						common_alert.big('warning', obj_result.header.resultMessage);
					}
				},
				error : function(xhr, ajaxOpts, thrownErr){
					console.log(xhr +"/"+ ajaxOpts +"/"+ thrownErr );
				}
			});
		});
	});
	
	function fnSaveOk(){
		$('.footer .cancel').click();
		fnListDetail();
	}
	</script>
	<div class="header"><h1></h1></div>
	<div class="create_area">
		<div class='basic'>
			<form id="tagMngForm" name="tagMngForm" >
			<input type='hidden' name='param_tag_seq' value=''>
			<input type='hidden' name='param_user_seq' value='${cookieEmpSeq}'>
			<input type='hidden' name='param_user_nm' value='${cookieEmpNm}'>
			<dl>
				<dt>태그</dt>
				<dd><input type="text" name="param_tag_nm" /></dd>
			</dl>
			<dl>
				<dt>메인노출</dt>
				<dd>
					<select name='param_main_view'>
						<option value='0'>없음</option>
						<option value='1'>1번째</option>
						<option value='2'>2번째</option>
						<option value='3'>3번째</option>
						<option value='4'>4번째</option>
						<option value='5'>5번째</option>
					</select>
				</dd>
			</dl>
			<dl>
				<dt>상태</dt>
				<dd>
					<input type="radio" name="param_tag_view" id="viewYn1" value="1" > <label for="viewYn1" style="margin-right:5px !important;"> Visible</label>
					<input type="radio" name="param_tag_view" id="viewYn2" value="0" > <label for="viewYn2" style="margin-right:5px !important;"> Hidden</label>
				</dd>
			</dl>
			</form>
		</div>
	</div>
	<div class="footer">
		<button type="button" class="cancel"><span>취소</span></button>
		<button type="button" class="ok yellow"><span>확인</span></button>
	</div>
