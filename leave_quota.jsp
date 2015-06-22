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
        	initDate();     	
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
          	//submit
            $("#sub").click(function(e){
            	var yymm = $("#myDate").val();
            	//console.log(yymm);
            	if("" != yymm){    
            		/*$("#strMsg").html(
            		"<p>• 此表僅供查詢，以實際遞單為準</p>"+
                    "<p>• 當AL Quota為零，每月遞單截止為前五天22:00至遞單截止日23:59期間，禁止上網取消退回已申請之AL其餘時段正常作業。</p>"+
                    "<p>• 每月遞單截止日前五天23:00，可自行上網申請是放出額度之AL</p>"
                    );            		
            		$("#alert-popup-apply").popup("open");  */      
            		$("#backData").val("0");
            		$("#form1").attr("action", "leave_quota_result.jsp");
    				$("#form1").submit();
            	}else{
            		$("#strMsg").html("請選擇日期");
            		$("#backData").val("1");
            		$("#alert-popup-apply").popup("close");
            	}
            });
          	//confirm
			$("#popConf").click(function(e){
				var msg = $("#strMsg").val();
				if(0== msg){
					$("#form1").attr("action", "leave_quota_result.jsp");
    				$("#form1").submit();
				}else{
					$("#alert-popup-apply").popup("close");	
				}					         	
            });
        });
        function initDate(){
			//今天的日期(yyyy-m)
			var today = new Date();
			thisYear = today.getFullYear();
			var thisMonth = ('0'+(today.getMonth()+1)).slice(-2);
//			thisMonth = today.getMonth();
			var myDate = thisYear + "/" + thisMonth;
			var showDate = $("#myDate").val();
			if(null ==  showDate || "" == showDate ){
				 $("#myDate").val(myDate) ;
			}
			// alert(myDate);
		}
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
				dateFormat: 'yy/m',
				dateOrder: 'yym',
				setText: '選擇',
				cancelText: '取消',
				startYear: 2000
			});
		});
	</script>

</head>
<body>

<div id="leave_quota" data-role="page">
<!-- Header bar Start -->
	<div data-role="header" data-position="fixed">
		<table id="header-bar">
			<tr>
				<td id="header-bar-btnBak">
					<a  href="leave_main.jsp" data-ajax="false"><div  id="naviBar_icon_Back"></div></a>
				</td>
				<td id="header-bar-btnAppname">特休假配額查詢</td>
				<td id="header-bar-btnMenu">
					<a id="btn_menu" href="#navbar"><div id="navi_icon_menu"></div></a>
				</td>
			</tr>
		</table>
	</div>
<!-- Header bar End -->

<!-- 特休假配額查詢 Start-->
	<div role="main" class="ui-content">
	<form id="form1" method="POST" action="" data-ajax="false">
		<table id="change_table">
			<tr>
				<th colspan="1">查詢月份</th>
			</tr>
			<tr>
				<td>
					<div id="inputMon">
						<input type="text" id="myDate" name="myDate">
					</div>
				</td>
			</tr>
		</table>
		
		<div id="btnApply" class="change_btnApply">
			<a id="sub" href="#" data-rel="popup" data-transition="pop" class="ui-btn ui-corner-all"><div>確認</div></a>
		</div>
	</form>
	</div>
<!-- 特休假配額查詢 End-->

<!-- popup container start -->
<!-- <div data-role="popup" id="alert-popup-apply" class="ui-content popupDiv" data-overlay-theme="b" data-dismissible="false" data-position-to="window" data-shadow="true" data-corners="true">
    <div data-role="header" class="popup-header">
       <p>年假配額查詢注意事項</p>
    </div>

    <div data-role="content" class="popup-content" id="leave_quota_popup">
    	<p id="strMsg"></p>
        <a id="popConf" class="ui-btn btnPopOK" href="#" data-ajax="false"><div>確 認</div></a>
    </div>
</div> -->
<!-- popup container end -->

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