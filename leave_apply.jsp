<%@page import="credit.CreditObj"%>
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
	FZCrewObj uObj = lObj.getFzCrewObj();
	String aEmpno = uObj.getEmpno();
	//String rEmpno = request.getParameter("rEmpno");
	//String yymm = request.getParameter("myDate");
	//String apoint = request.getParameter("apoint");
	//String ack =  request.getParameter("ack");
	//String aTimes =  request.getParameter("aTimes");
	//String rTimesStr =  request.getParameter("rTimes");
	//int rTimes = 4;
	//if(null != rTimesStr && !"".equals(rTimesStr)){
	//	rTimes = Integer.parseInt(rTimesStr);	
	//}
	//out.println(rEmpno+yymm+apoint+ack+aTimes+rTimes);
	String year = "";
	String month = "";
	String str = "";
	int totalTimes = 4;
	boolean flag = false;

		
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
	<!-- <link href="mobiscroll/mobiscroll.frame.jqm.css" rel="stylesheet" type="text/css" /> -->
	<!-- <link href="mobiscroll/mobiscroll.scroller.jqm.css" rel="stylesheet" type="text/css" /> -->
	<link href="mobiscroll/mobiscroll.scroller.css" rel="stylesheet" type="text/css" />

	<script>
		/*$(function () {
			$('.myDate').mobiscroll().date({
				theme: '',
				mode: 'mode',
				display: 'modal',
				lang: 'en',
				dateFormat: 'yy/mm/dd',
				dateOrder: 'yymmdd',
				setText: '選擇',
				cancelText: '取消',
				startYear: 2000
			});
		});*/
	</script>

<!-- Mobiscroll JS and CSS Includes -->

    <script type="text/javascript">
        $(document).ready(function () {
        	addNewAL();    
        	scrollDate();
        	$("#addAL").click(function(e){
			    addNewAL();
			    scrollDate();
            });	   	
    		
    	
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
				 	//$('#loadingmessage').show();
	            	var sdate = GetInputValue("sdate");
	            	var edate = GetInputValue("edate");
					var off_type = $("#off_type").val();
					//console.log(sdate);
					//console.log(edate);
					//console.log(rEmpnoArr2[0]);
	            	if("" != sdate && ""!= edate && isNaN(sdate) && isNaN(edate)){	            		
	            		$.ajax({
		        			type: "POST",
		        			url: "chkAL_apply.jsp",
		        			data: {sdate:sdate,edate:edate,off_type:off_type},
		        			success:function(data){
		        				//$('#loadingmessage').hide();
		        				if(data.indexOf("失敗") > -1){
		        					$("#strMsg").html(data);
			        				$("#backData").val("0");
			        				$("#alert-popup-apply").popup("open");
			        			}else{
			        				$("#strMsg").html(data);
			        				$("#backData").val("1");	
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
	            		$("#strMsg").html("日期不可為空");
	    				$("#backData").val("0");
	    				$("#alert-popup-apply").popup("open");
	            	}
	          });
			//confirm
			$("#popConf").click(function(e){
				var msg = $("#strMsg").val();
				if(msg == 1){
					$("#form_sendAL").attr("action", "leave_main.html");
					$("#form_sendAL").submit();
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
		};
        function addNewAL(){
  	  		var sdate =  document.getElementsByName("sdate");
  	  		console.log(sdate.length);
  	  		//var countR = $("#countR").val();
  	  		var countR = sdate.length;
  	  		if(countR == 0){
  				$("#AL_div:last").append(
    	  				"<tr>"+
    	  				"<td colspan='3' style='text-align:left; font-weight:bold;'>第"+(countR+1)+"筆</td>"+
    	  				"</tr>"+
    	  				"<tr>"+
    					"<td class='leave_td_label'>From</td>"+
    					"<td><input type='text' class='myDate' id='sdate"+countR+"' name='sdate'></td>"+
    					"<td><div class='list_btn_sckedule'></div></td>"+
    					"</tr>"+
    					"<tr>"+
    					"<td class='leave_td_label'>To</td>"+
    					"<td><input type='text' class='myDate' id='edate"+countR+"' name='edate'></td>"+
    					"<td><div class='list_btn_sckedule'></div></td>"+
    					"</tr>"+
    					"<tr>"+
    					"<td class='leave_td_label'>Off Days</td>"+
    					"<td><input type='text' id='countOff"+countR+"'  onFocus ='getDays("+countR+");'></td>"+
    					"</tr>");
  				$("#AL_div:last").trigger('create');
  	  		}else if(countR > 0 && countR < 6){
  	  			$("#AL_div:last").append(
  	  				"<tr>"+//id='tr1"+countR+"'
	  				"<td colspan='3' style='border-top-width:1px; border-top-style:solid; border-top-color:#9c9c9c; text-align:left; font-weight:bold; padding-top:10px;'>第"+(countR+1)+"筆</td>"+
	  				"</tr>"+
  	  				"<tr>"+
  					"<td class='leave_td_label'>From</td>"+
  					"<td><input type='text' class='myDate' id='sdate"+countR+"' name='sdate'></td>"+
  					"<td><div class='list_btn_sckedule'></div></td>"+
  					"</tr>"+
  					"<tr>"+
  					"<td class='leave_td_label'>To</td>"+
  					"<td><input type='text' class='myDate' id='edate"+countR+"' name='edate'></td>"+
  					"<td><div class='list_btn_sckedule'></div></td>"+
  					"</tr>"+
  					"<tr>"+
  					"<td class='leave_td_label'>Off Days</td>"+
  					"<td><input type='text' id='countOff"+countR+"'  onFocus ='getDays("+countR+");'></td>"+
  					//"<td><div id='del"+countR+"' class='delEmpno' onClick='delAL(\"tr1"+countR+"\",\"tr2"+countR+"\",\"tr3"+countR+"\",\"tr4"+countR+"\",\"del"+countR+"\");'>X</div></td>"+
  					"<td><div id='rst"+countR+"' class='list_btn_close' onClick='resetDate(\""+countR+"\");'></div></td>"+
  					"</tr>");
  	  			/*$("sdate"+countR).collapsibleset();
				$("edate"+countR).collapsibleset();
		 		$("countOff"+countR).collapsibleset();
		 		console.log("refresh");*/
		 		$("#AL_div:last").trigger('create');
		 		//$("tr4"+countR).collapsibleset();
		 		//$("del"+countR).collapsibleset();
        	}else{
        		$("#strMsg").html("最多6張申請單");
				$("#backData").val("");
				$("#alert-popup-apply").popup("open");
        	}
        	//$("#countR").val(++countR);
    	};
    	function resetDate(para){
    		$("#sdate"+para).val("");
    		$("#edate"+para).val("");
    		$("#countOff"+para).val("");
    	}
        function delAL(Idname1,Idname2,Idname3,Idname4,Idname5){
        	//console.log(Idname1+","+Idname2+","+Idname3+","+Idname4+","+Idname5);
 			$("#"+Idname1).remove();
 			$("#"+Idname2).remove();
 			$("#"+Idname3).remove();
 			$("#"+Idname4).remove();
 			$("#"+Idname5).remove();
 		};
 		function scrollDate(){
 			$('.myDate').mobiscroll().date({
   				theme: '',
   				mode: 'mode',
   				display: 'modal',
   				lang: 'en',
   				dateFormat: 'yy/mm/dd',
   				dateOrder: 'yymmdd',
   				setText: '選擇',
   				cancelText: '取消',
   				startYear: 2000
    		});
 		}
 		function GetInputValue(InputName){                	
         	return $('input[name=' + InputName + ']').map(function ()
         	{
         		return $(this).val();
         	}).get().join(',');
         }
        function getDays(para){
        	var sDate1 = $("#sdate"+para).val();// sDate1 format"2002/01/10"
        	var sDate2 = $("#edate"+para).val();
        	var iDays;
        	var msg = "Y";
        	if(sDate1 == "" || sDate2 == "")//至少要填一張單
        	{
        		msg ="請選擇休假區間!";
        		//alert(msg);
        		$("#strMsg").html(msg);
				$("#backData").val("0");
				$("#alert-popup-apply").popup("open");
        		return msg;
        	}else if(sDate1 > sDate2 )
        	{
        		msg ="起訖區間錯誤!";
        		//alert(msg);
        		$("#strMsg").html(msg);
				$("#backData").val("0");
				$("#alert-popup-apply").popup("open");
        		return msg;
        	}
        	
        	fday = new Date(Number(sDate1.substring(0,4)),Number(sDate1.substring(5,7))-1,Number(sDate1.substring(8,10)));//Date(2011,9,1)
        	tday = new Date(Number(sDate2.substring(0,4)),Number(sDate2.substring(5,7))-1,Number(sDate2.substring(8,10)));
        	dayms = 24*60*60*1000;
        	if(sDate1 != "" && sDate2 != "") {
        		iDays = Math.floor((tday.getTime()-fday.getTime())/dayms)+1;
        	}else{
        		iDays = 0;
        	}
        	
        	//把相差的毫秒轉換為天數 
        	$("#countOff"+para).val(iDays);
        	//document.form1.elements["tdays_"+para].value =  iDays;
        	//document.form1.tdays.value = iDays;
        	//document.form1.totdays.value = iDays;
        	
        	if(iDays > 6){
        		msg ="請AL不可超過連續六天!!";
        		$("#strMsg").html(msg);
				$("#backData").val("");
				$("#alert-popup-apply").popup("open");
        		return msg;
        	}      	
        	
        	if(sDate1.substr(0,4)!= sDate2.substr(0,4))
        	{
        		msg ="跨年假單請分開申請!!";
        		$("#strMsg").html(msg);
				$("#backData").val("0");
				$("#alert-popup-apply").popup("open");
        		return msg;
        	}

        	var off_type = $("#off_type").val();

        	if(off_type=="16" && sDate2>"2011/12/31")
        	{
        		msg = "XL額外慰勞假使用期限僅至2011/12/31!!";
        		return msg;
        	}
        	
        	var temp_tdays = $("#countOff"+para).val();
        	if(off_type=="16" &&  temp_tdays != "3")
        	{
        		msg = "XL額外慰勞假需一次使用完畢!!";
        		return msg;
        	}
        	
        };
    </script>


	
</head>
<body>

<div id="leave_quota_result" data-role="page">
<!-- Header bar Start -->
	<div data-role="header" data-position="fixed">
		<table id="header-bar">
			<tr>
				<td id="header-bar-btnBak">
					<a  href="leave_main.jsp" data-ajax="false"><div id="naviBar_icon_Back"></div></a>
				</td>
				<td id="header-bar-btnAppname">特休假申請</td>
				<td id="header-bar-btnMenu">
					<a id="btn_menu" href="#navbar"><div id="navi_icon_menu"></div></a>
				</td>
			</tr>
		</table>
	</div>
<!-- Header bar End -->

<!-- 特休假申請 Start-->
<div role="main" class="ui-content">
<form id="form_sendAL" method="POST" action="" data-ajax="false">
<!-- 一整個AL_form的div，是一張休假單的表格 -->
<div class="AL_form">
	<div>
		<!--<select name="off_type" id="off_type"  class="title_al">
		<option value="0">AL 特休假</option>
		</select> -->
		<p class="title_al">AL特休假</p>
		<input type="hidden"  name="off_type" id="off_type"  value="0">
	</div>
	<div>
		<table class="leave_apply_table"  id="AL_div">
			<!-- <tr>
				<td class="leave_td_label">From</td>
				<td><input type="text" class="myDate" id="sdate"></td>
				<td><div class="list_btn_sckedule"></div></td>
			</tr>
			<tr>
				<td class="leave_td_label">To</td>
				<td><input type="text" class="myDate" id="edate"></td>
				<td><div class="list_btn_sckedule"></div></td>
			</tr>
			<tr>
				<td class="leave_td_label">Off Days</td>
				<td><input type="text" id="countOff"></td>
			</tr> -->
		</table>
	</div>
</div>
</form>
	<div class="leave_apply_add" >
		<p id="addAL">+ 新增</p>
	</div>

	<div id="result_info">
		<div id="list_icon_info_20px" style="top:-35px;"></div>
		<span id="div_result_infoMsg">
			<p>未扣假天數+預請假天數，不得大於30日</p>
			<p>AL每筆連續不得超過六日，</p>
			<p>兩筆之間至少間隔一日。</p>
		</span>
	</div>
	
	<div id="btnApply" class="leave_apply_btnApply">
		<a id="sub" href="#" data-rel="popup" data-transition="pop" class="ui-btn ui-corner-all"><div>確認</div></a>
	</div>
		
	
<!-- 特休假申請 End-->

<!-- popup container start 
<div data-role="popup" id="alert-popup-apply" class="ui-content popupDiv" data-overlay-theme="b" data-dismissible="false" data-position-to="window" data-shadow="true" data-corners="true">
    <div data-role="header" class="popup-header">
       <p>您已提出特休假申請</p>
    </div>

    <div data-role="content" class="popup-content" id="leave_apply_popup">
		<div id="leave_apply_popup_content">
	        <p>AL特休假</p>
	        <p>2015/01/15-2015/01/16</p>
	        <p>申請成功</p>
	        <p id="backData"></p>
	        <p id="strMsg"></p>
		</div>

        <a 　class="ui-btn btnPopOK" href="#" data-ajax="false"><div>確 認</div></a>
    </div>
</div>-->
<!-- popup container end -->

<!-- popup container start -->
<div data-role="popup" id="alert-popup-apply" class="ui-content popupDiv" data-overlay-theme="b" data-dismissible="false" data-position-to="window" data-shadow="true" data-corners="true">
    <div data-role="header" class="popup-header">
       <p>提示:</p>
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