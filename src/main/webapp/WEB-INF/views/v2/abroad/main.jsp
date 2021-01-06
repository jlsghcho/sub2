<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<script type="text/javascript">
	var now_year_date = "${serverDate}";
	var param_save_arr;
	var param_sub_menu_arr;


	/*  한번만 서브 메뉴 가지고 오기 */
	
	/*
	function fn_sub_menu_list(){
		
		var abroad_sub_menu = "${cookieSubMenuList}";
		var abroad_sub_menu_list =  abroad_sub_menu.split("abroad=")[1].split(" ")[0].split(',');
		$('#'+abroad_sub_menu_list[0]).trigger("click");
		var obj_result = JSON.parse(common_ajax.inter("/service/v2/abroad/menu/sub", "json", false, "GET", ""));
		if(obj_result.header.isSuccessful == true){ param_sub_menu_arr = JSON.parse(obj_result.data); }
		
	}
	*/
	
	$(document).ready(function() {
		var abroad_sub_menu = "${cookieSubMenuList}";
		var abroad_sub_menu_list =  abroad_sub_menu.split("abroad=")[1].split(" ")[0].split(',');
		$('#'+abroad_sub_menu_list[0]).trigger("click");
		
	});
	
</script>
	<div id="container">
		<div class="browser sidebar expand">
			<div class="burger_icon"><span></span></div>
			<h3></h3>
			<div class="scroll"><jsp:include page="../layout/abroad_menu.jsp" flush="true" /></div>
		</div>
	</div>
