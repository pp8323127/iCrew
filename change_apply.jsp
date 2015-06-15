<%@page import="java.text.DecimalFormat"%>
<%@page import="swap3ac.CrewSkjObj"%>
<%@page import="swap3ac.CrewInfoObj"%>
<%@page import="java.sql.SQLException"%>
<%@page import="credit.SkjPickObj"%>
<%@page import="credit.SkjPickList"%>
<%@page import="java.util.ArrayList"%>
<%@page import="fzAuthP.FZCrewObj"%>
<%@page import="ws.crew.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%
try{
	LoginAppBObj lObj= null;
	if(null != session.getAttribute("loginAppBobj")){
		lObj= (LoginAppBObj) session.getAttribute("loginAppBobj");
	}
	if(lObj == null ) {
		out.println("請登入");
		response.sendRedirect("login.jsp");
	}else{  
	String rEmpno = request.getParameter("radiorEmpno");
	String yymm = request.getParameter("myDate");
	String year = "";
	String month = "";

				
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
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
                        $("#right-list li").remove();
                        $("#right-list").append(data).listview("refresh");
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
              	var rEmpno =  $("#rEmpno").val();
				//console.log(yymm+rEmpno );
              	if("" != yymm && "" != rEmpno){
  	            	$("#swap1").attr("action", "change_apply_applicant.jsp");
  					$("#swap1").submit();
              	}else{
              		$("#strMsg").html("請輸入被換者員工號");
    				$("#alert-popup-apply").popup("open");
              	}
              }); 
         	 //confirm
			$("#popConf").click(function(e){
				$("#alert-popup-apply").popup("close");	         	
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

<div id="change_apply" data-role="page">
<!-- Header bar Start -->
	<div data-role="header" data-position="fixed">
		<table id="header-bar">
			<tr>
				<td id="header-bar-btnBak">
					<a href="change_main.jsp" data-ajax="false"><div id="naviBar_icon_Back"></div></a>
				</td>
				<td id="header-bar-btnAppname">換班申請</td>
				<td id="header-bar-btnMenu">
					<a id="btn_menu" href="#navbar"><div id="navi_icon_menu"></div></a>
				</td>
			</tr>
		</table>
	</div>
<!-- Header bar End -->

<!-- 換班申請 Start-->
	<div role="main" class="ui-content">
<%
if(null!=yymm && !"".equals(yymm)){
	String date[] = yymm.split("/");
	year = date[0];
	month = date[1];
	if(month.length()<=1){
		month = "0"+month;
	}
}
%>
		<form id="swap1" method="POST" action="" data-ajax="false">
		<table id="change_table">
			<tr>
				<th colspan="1">申請月份</th>
			</tr>
			<tr>
				<td>
					<div id="inputMon">
						<input type="text" id="myDate" name="myDate" value="<%=yymm%>">
					</div>
				</td>
			</tr>

			<tr>
				<th colspan="1">被換者之員工號</th>
			</tr>
			<tr>
				<td id="divEmpno">
					<div class="inputEMP"><input type="text" name="rEmpno" id="rEmpno" value="<%=rEmpno%>" maxlength="6"></div>
				</td>
			</tr>
		</table>
		
		<div id="btnOKCancel">
			<a href="MainPage.jsp" class="ui-btn ui-corner-all" data-ajax="false"><div>取消</div></a>
			<a id="sub" href="#" class="ui-btn ui-corner-all" data-ajax="false"><div>確認</div></a>
		</div>
		</form>
<%			
}
}catch(ClassCastException e){
	out.println("請登入");
	response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println(e.toString());
}
%>
	</div>
<!-- 換班申請 End-->

<!-- popup container start -->
<div data-role="popup" id="alert-popup-apply" class="ui-content popupDiv" data-overlay-theme="b" data-dismissible="false" data-position-to="window" data-shadow="true" data-corners="true">
    <div data-role="header" class="popup-header">
       <p>提示:</p>
    </div>
    <div data-role="content" class="popup-content">
        <p id="strMsg"></p>
        <a id="popConf" class="ui-btn btnPopOK" href="#" data-ajax="false"><div>確 認</div></a><!--  -->
    </div>
</div>
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
