<%@page import="ws.crew.LoginAppBObj"%>
<%@page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%
try{
	LoginAppBObj lObj= null;
	if(null != session.getAttribute("loginAppBobj")){
		lObj= (LoginAppBObj) session.getAttribute("loginAppBobj");
	}
	if(lObj == null ) {
		out.println("請登入");
		response.sendRedirect("login.jsp");
	} 
	else
	{
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<title>iCrew</title>
	<link rel="stylesheet" href="jQueryMob/jquery.mobile.custom.structure.css" />	
	<link rel="stylesheet" href="jQueryMob/jquery.mobile.custom.theme.css" />	
	<link rel="stylesheet" href="jQueryMob/CSS.css">
	<script src="jQueryMob/jquery.js" language="javascript"></script>	
	<script src="jQueryMob/jquery.mobile.custom.js" language="javascript"></script>

    <script type="text/javascript">
        $(document).ready(function () {

        	//今天的日期(yyyy)
			var today = new Date();
			thisYear = today.getFullYear();

			var myDate = thisYear;
			document.getElementById("myDate").value = myDate;
			// alert(myDate);

            $("#btn_menu").click(function(e){
                $.ajax({
                    type: "POST",
                    url: "navbar.jsp",
                    success:function(data){
                        // alert(data);
                        if(data.indexOf("請登入") > -1){
							window.location.href = "login.jsp";
						}else{
                        	$("#right-list li").remove();
                        	$("#right-list").append(data).listview("refresh");
						}
                    },
                    error:function(xhr, ajaxOptions, thrownError){
                        console.log(xhr.status);
                        console.log(thrownError);
                        alert("Error");
                    }
                });
                e.preventDefault();
            });
            $("#sub").click(function(e){
            	var year = $("#myDate").val();
            	//alert(year);
            	if("" != year){
	            	$("#SwapQueryform").attr("action", "change_log_list.jsp?year="+year);
					$("#SwapQueryform").submit();
            	}
            });
        });
    </script>


	<!-- Mobiscroll JS and CSS Includes -->
	<script src="mobiscroll/mobiscroll.core.js"></script>
	<script src="mobiscroll/mobiscroll.frame.js"></script>
	<script src="mobiscroll/mobiscroll.scroller.js"></script>

	<script src="mobiscroll/mobiscroll.util.datetime.js"></script>
	<script src="mobiscroll/mobiscroll.datetimebase.js"></script>
	<script src="mobiscroll/mobiscroll.datetime.js"></script>

	<link href="mobiscroll/mobiscroll.frame.css" rel="stylesheet" type="text/css" />
	<!-- <link href="mobiscroll/mobiscroll.frame.jqm.css" rel="stylesheet" type="text/css" /> -->
	<!-- <link href="mobiscroll/mobiscroll.scroller.jqm.css" rel="stylesheet" type="text/css" /> -->
	<link href="mobiscroll/mobiscroll.scroller.css" rel="stylesheet" type="text/css" />

	<script>
		$(function () {
			$('#myDate').mobiscroll().date({
				theme: '',
				mode: 'mode',
				display: 'modal',
				lang: 'en',
				dateFormat: 'yy',
				dateOrder: 'yy',
				setText: '選擇',
				cancelText: '取消',
				startYear: 2000
			});
		});
	</script>

</head>
<body>

<div id="change_log" data-role="page">
<!-- Header bar Start -->
	<div data-role="header" data-position="fixed">
		<table id="header-bar">
			<tr>
				<td id="header-bar-btnBak">
					<a href="change_main.jsp" data-ajax="false"><div id="naviBar_icon_Back"></div></a>
				</td>
				<td id="header-bar-btnAppname">換班紀錄查詢</td>
				<td id="header-bar-btnMenu">
					<a id="btn_menu" href="#navbar"><div id="navi_icon_menu"></div></a>
				</td>
			</tr>
		</table>
	</div>
<!-- Header bar End -->

<!-- 換班紀錄查詢 Start-->
	<div role="main" class="ui-content">
	<form id="SwapQueryform" method="POST" action="" data-ajax="false">
		<table id="change_table">
			<tr>
				<th colspan="1">查詢年份</th>
			</tr>
			<tr>
				<td>
					<div id="inputMon">
						<input type="text" id="myDate" name="myDate">
					</div>
				</td>
			</tr>
		</table>
		<!-- <div id="btnApply" class="change_btnApply">
			<a href="change_log_list.jsp" class="ui-btn ui-corner-all" data-ajax="false"><div>查詢</div></a>
		</div> -->
		<div id="btnApply" class="change_btnApply">
			<a href="#" id="sub" class="ui-btn ui-corner-all" ><div>查詢</div></a>
		</div>
	</form>	
	</div>

<!-- 換班紀錄查詢 End-->

<!-- navbar Slide Panel -->

    <div id="navbar" data-role="panel" data-position="right" data-position-fixed="false" data-display="overlay" data-theme="b">
        <ul id="right-list" data-role="listview" data-inset="true" data-icon="false">
        </ul>
    </div>
<!-- navbar Slide Panel -->

</div>


</body>
</html>
<%
	}
}catch(ClassCastException e){
	out.println("請登入");
	response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println("Error"+e.toString());	
}
%>