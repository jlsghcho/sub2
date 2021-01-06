<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script type="text/javascript">
$(document).on("click", "#pop_banner_select_type .footer button.yellow", function(){
	$(this).closest('.pop').fadeOut();
	$('.white_bg, .black_bg, .layer_bg').fadeOut();
	$('#detail_info>.page>.contents').addClass('hide');

	fn_layer_select_banner_type($("#pop_banner_select_type .create_area .uniform :radio[name='select_banner']:checked").val());
});
</script>

		<div id="pop_banner_select_type" class="pop small fit blue">
			<div class="header">
				<h1>Select Banner Type</h1>
				<div class="func">
					<div class="close">Close</div>
				</div>
			</div>
			<div class="create_area">
				<div class="scroll">
					<div class="uniform banner">
						<c:if test="${cookieEmpType == 'S'}">
						<label>
							<input type="radio" name="select_banner" id="top_fixed" value="BN1004" checked>
							<span>탑배너고정</span>
						</label>
						<label>
							<input type="radio" name="select_banner" id="main_rolling" value="BN1001">
							<span>상단배너롤링</span>
						</label>
						<label>
							<input type="radio" name="select_banner" id="main_fixed" value="BN1002">
							<span>상단배너고정</span>
						</label>
						</c:if>
						<label>
							<input type="radio" name="select_banner" id="go_link" value="BN1005">
							<span>바로가기배너</span>
						</label>
					</div>
				</div>
			</div>
			<div class="footer">
				<button type="button" class="cancel"><span>Cancel</span></button>
				<button type="button" class="select yellow"><span>Select</span></button>
			</div>
		</div>