<%@page import="java.text.SimpleDateFormat"%>
<%@page import="eg.off.quota.*, eg.*,tool.*,java.util.*"%>
<%@page import="ws.off.CrewALQuotaRObj"%>
<%@page import="ws.off.CrewALFun"%>
<%@page import="ws.crew.LoginAppBObj"%>
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
} 
else
{
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
	
	<!-- Mobiscroll JS and CSS Includes -->
	<script src="mobiscroll/mobiscroll.core.js"></script>
	<script src="mobiscroll/mobiscroll.frame.js"></script>
	<script src="mobiscroll/mobiscroll.scroller.js"></script>

	<script src="mobiscroll/mobiscroll.util.datetime.js"></script>
	<script src="mobiscroll/mobiscroll.datetimebase.js"></script>
	<script src="mobiscroll/mobiscroll.datetime.js"></script>

	<link href="mobiscroll/mobiscroll.frame.css" rel="stylesheet" type="text/css" />
	<link href="mobiscroll/mobiscroll.scroller.css" rel="stylesheet" type="text/css" />
	
    <script type="text/javascript">
        $(document).ready(function () {
        	initDate();
        	scrollDate();
        	$("#leave_type").html("不扣薪假");
			$("#type").val("1");

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
            $("#sub").click(function(e){
            	var yymm = $("#myDate").val();
            	var type = $("#type").val();
            	if(""!=yymm && ""!=type){
	            	$("#form_leave").attr("action", "leave_manage_result.jsp");
					$("#form_leave").submit();
            	}else{
            		$("#strMsg").html("查詢類別不可為空");
            		$("#type1").attr("style", "visibility: hidden");
            		$("#type2").attr("style", "visibility: hidden");
            		$("#type_other").attr("style", "visibility: hidden");
    				$("#alert-popup-info").popup("open");
            	}
            });
            //confirm
			$("#popConf").click(function(e){
				$("#alert-popup-info").popup("close");										         	
            });	
			$("#leave_type").click(function(e){
				$("#type1").attr("style", "visibility: true");
        		$("#type2").attr("style", "visibility: true");
        		$("#type_other").attr("style", "visibility: true");
        		$("#alert-popup-info").popup("open");
			});
            /* 休假查詢類型 選單 */
			$("#type1").click(function(e){
				 $("#leave_type").html("不扣薪假");
				 $("#type").val("1");
				 console.log("1");
				 $("#alert-popup-info").popup("close");
			});

			$("#type2").click(function(e){
			 	$("#leave_type").html("扣薪假");
			 	$("#type").val("2");
			 	console.log("2");
			 	$("#alert-popup-info").popup("close");
			});

			$("#type_other").click(function(e){
			 	$("#leave_type").html("其他");
			 	$("#type").val("3");
			 	$("#alert-popup-info").popup("close");
			});

        });
        
        function initDate(){
			//今天的日期(yyyy-m)
			var today = new Date();
			thisYear = today.getFullYear();
			//var thisMonth = ('0'+(today.getMonth()+1)).slice(-2);
//			thisMonth = today.getMonth();
			var myDate = thisYear;
			var showDate = $("#myDate").val();
			if(null ==  showDate || "" == showDate ){
				 $("#myDate").val(myDate) ;
			}
			// alert(myDate);
		};
		function scrollDate(){
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
 		}
    </script>

</head>
<body>

<div id="leave_manage" data-role="page">
<!-- Header bar Start -->
	<div data-role="header" data-position="fixed">
		<table id="header-bar">
			<tr>
				<td id="header-bar-btnBak">
					<a href="leave_main.jsp" data-ajax="false"><div id="naviBar_icon_Back"></div></a>
				</td>
				<td id="header-bar-btnAppname">假單查詢與刪除</td>
				<td id="header-bar-btnMenu">
					<a id="btn_menu" href="#navbar"><div id="navi_icon_menu"></div></a>
				</td>
			</tr>
		</table>
	</div>
<!-- Header bar End -->

<!-- 假單查詢與刪除 Start-->
	<div role="main" class="ui-content">
		<form id="form_leave" method="POST" action="" data-ajax="false">
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
	
				<tr>
					<th colspan="1">查詢類型</th>
				</tr>
				<tr>
					<td>
					<!--<select id="leave_type" name="leave_type"  class="ui-btn btnCate"  >-->
				    	<!-- <option value="1" selected>不扣薪假</option>AL/XL/LVE/LSW/OL -->
						<!-- <option value="2" >扣薪假</option><!-- SL/PL/CL/EL/FCL/HNSL/HNEL/HNCL/HNI/CNSL/CNCL -->
						<!-- <option value="3" >其他</option>	 <!-- Others -->
				    <!--  </select>-->
						<a href="#" id="leave_type" name="leave_type" class="ui-btn ui-corner-all" data-rel="popup" data-transition="pop"></a>
						<input type="hidden" id="type" name="type">
					</td>
				</tr>
			</table>
			
			<div id="btnOKCancel">
				<a href="leave_main.jsp" data-ajax="false" class="ui-btn ui-corner-all"><div>取消</div></a>
				<a id="sub" href="#" class="ui-btn ui-corner-all" data-ajax="false"><div>確認</div></a>
			</div>
		</form>
	</div>

	<!-- 定義popup顯示位置 -->
	<div id="popupSite"></div>



<%
}
}catch(ClassCastException e){
	out.println("請登入");
	response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println("Error"+e.toString());	
}
%>

<!-- 假單查詢與刪除 End-->

<!-- popup container start -->
<div data-role="popup" id="alert-popup-info" class="ui-content popupDiv" data-overlay-theme="b" data-dismissible="false" data-position-to="#popupSite" data-shadow="true" data-corners="true">
    <div data-role="header" class="popup-header">
       <p style="margin-bottom: 22px;">請選擇查詢類別</p>
    </div>

     <div data-role="content" class="popup-content">	
    	<p id="strMsg"></p>
    	<!-- 這裡面的ID沒有寫CSS，只是用來跑JS而已 -->
		<a class="ui-btn btnCate" href="#" id="type1"><div>不扣薪假</div></a>
		<a class="ui-btn btnCate" href="#" id="type2"><div>扣薪假</div></a>
		<a class="ui-btn btnCate" href="#" id="type_other"><div>其他</div></a>

        <a id="popConf" class="ui-btn btnPopOK" href="#" data-rel="back" data-ajax="false"><div>確認</div></a>
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