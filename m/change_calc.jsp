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
	
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
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
        	addEmpno();
        	$("#addEmployee").click(addEmpno);
        	
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
            	var rEmpno =  GetInputValue("rEmpno");//document.getElementsByName("rEmpno").value;
				//var rEmpnoArr2 = document.getElementsByName("rEmpno");
				console.log(rEmpno);
				//console.log(rEmpnoArr2[0]);
            	if("" != yymm && ""!= rEmpno){
            		
            		$.ajax({
	        			type: "POST",
	        			url: "chkChange_calc.jsp",
	        			data: {rEmpno:rEmpno,myDate:yymm},
	        			success:function(data){	
	        				if(data.indexOf("Y") > -1){
				            	$("#CrossMutiform").attr("action", "change_calc_compare.jsp");
								$("#CrossMutiform").submit();
		        			}else{
		        				$("#strMsg").html(data);
		        				$("#backData").val("");
		        				$("#alert-popup-apply").popup("open");
		        			}
	        			},
	        			error:function(xhr, ajaxOptions, thrownError){
	        				console.log(xhr.status);
	        				console.log(thrownError);
	        				$("#strMsg").html("Error");
	        				$("#backData").val("");
	        				$("#alert-popup-apply").popup("open");
	        			}
	        		});
	        		e.preventDefault();
	        		
            	}else{
            		$("#strMsg").html("請輸入被換者");
    				$("#backData").val("");
    				$("#alert-popup-apply").popup("open");
            	}
            });      
          //confirm
			$("#popConf").click(function(e){
				$("#alert-popup-apply").popup("close");
         	});       

        });
		

        function addEmpno(){
  	  		var rEmpnoArr =  document.getElementsByName("rEmpno");
  	  		//console.log(rEmpnoArr.length);
  	  		//var countR = $("#countR").val();
  	  		var countR = rEmpnoArr.length;
  	  		if(countR == 0){
  	  			$("#divEmpno:last").append("<div class='inputEMP'><input type='text' name ='rEmpno' id='employee"+countR+"'  maxlength='6'>");
  	  			//$("#employee"+countR).collapsibleset();
				$("#divEmpno:last").trigger('create');
  	  		}else if(countR > 0 && countR < 3){
       			$("#divEmpno:last").append("<div class='inputEMP2'><input type='text' name ='rEmpno' id='employee"+countR+"' maxlength='6'><div id='del"+countR+"' class='delEmpno' onClick='delEmpno(\"employee"+countR+"\",\"del"+countR+"\")'></div></div>");
       			//$("#employee"+countR).collapsibleset();
				$("#divEmpno:last").trigger('create');
        	}else{
        		$("#strMsg").html("試算者至多三位");
				$("#backData").val("");
				$("#alert-popup-apply").popup("open");
        	}
        	//$("#countR").val(++countR);
    	}
		function initDate(){
			//今天的日期(yyyy-m)
			var today = new Date();
			thisYear = today.getFullYear();
			var thisMonth = ('0'+(today.getMonth()+1)).slice(-2);
//			thisMonth = today.getMonth();
			var myDate = thisYear + "/" + thisMonth;
			document.getElementById("myDate").value = myDate;
			// alert(myDate);
		}
		function GetInputValue(InputName){                	
         	return $('input[name=' + InputName + ']').map(function ()
         	{
         		return $(this).val();
         	}).get().join(',');
         }
         function delEmpno(Idname,Idname2){
 			$("#"+Idname+"").remove();
 			$("#"+Idname2+"").remove();
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
				dateFormat: 'yy/mm',
				dateOrder: 'yymm',
				setText: '選擇',
				cancelText: '取消',
				startYear: 2000
			});
		});
	</script>
</head>
<body>

<div id="change_calc" data-role="page">
<!-- Header bar Start -->
	<div data-role="header" data-position="fixed">
		<table id="header-bar">
			<tr>
				<td id="header-bar-btnBak">
					<a href="change_main.jsp"><div id="naviBar_icon_Back"></div></a>
				</td>
				<td id="header-bar-btnAppname">換班飛時試算</td>
				<td id="header-bar-btnMenu">
					<a id="btn_menu" href="#navbar"><div id="navi_icon_menu"></div></a>
				</td>
			</tr>
		</table>
	</div>
<!-- Header bar End -->

<!-- 換班飛時試算 Start-->
	<div role="main" class="ui-content">
	 <form id="CrossMutiform" method="POST" action="" data-ajax="false">
		<table id="change_table">
			<tr>
				<th colspan="1">申請月份</th>
			</tr>
			<tr>
				<td>
					<div id="inputMon">
						<input type="text" id="myDate" name="myDate">
					</div>
				</td>
			</tr>

			<tr>
				<th colspan="1">被換者之員工號</th>
			</tr>
			<tr>
				<td id="divEmpno">
					<!-- <a href="" id="employee1" value="" class="ui-btn ui-corner-all">被換員工</a> 
					<input type="hidden" id= "countR" value= "1">
					<div class="inputEMP"><input type="text" name = "rEmpno" id="employee0" value="635863"><div  id="del0"  onClick="delEmpno('employee0','del0')">X</div></div>-->
				</td>
			</tr>
			<tr>
				<td><p id="addEmployee">+ 新增試算人員</p></td>
			</tr>
		</table>
		
		<div id="btnOKCancel">
			<a href="change_main.jsp" class="ui-btn ui-corner-all"  data-ajax="false"><div>取消</div></a>
			<a id ="sub" href="#" class="ui-btn ui-corner-all" data-ajax="false"><div>確認</div></a>
		</div>
	  </form>
	</div>
<!-- 換班飛時試算 End-->

<!-- popup container start -->
<div data-role="popup" id="alert-popup-apply" class="ui-content popupDiv" data-overlay-theme="b" data-dismissible="false" data-position-to="window" data-shadow="true" data-corners="true">
    <div data-role="header" class="popup-header">
       <p >換班飛時試算</p>
    </div>

    <div data-role="content" class="popup-content">    
    	<input type="hidden" id="backData" >	
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
<%
}
}catch(ClassCastException e){
	out.println("請登入");
	response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println(e.toString());
}
%>