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
	String jobtype = GetJobType.getEmpJobType(lObj.getFzCrewObj().getEmpno()) ;
	String yymm = request.getParameter("myDate");

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
            	$("#form_quota").attr("action", "leave_apply.jsp");
				$("#form_quota").submit();
            });
            		
            
        });
        function changeColor(para){
        	$(".link").removeClass("today_circle");
        	$("#link"+para).addClass("today_circle");        
        }
    </script>

</head>
<body>

<div id="leave_quota" data-role="page" class="bg_f8">
<!-- Header bar Start -->
	<div data-role="header" data-position="fixed">
		<table id="header-bar">
			<tr>
				<td id="header-bar-btnBak">
					<a  href="leave_quota.jsp" data-ajax="false"><div id="naviBar_icon_Back"></div></a>
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
<%
if(null!=yymm && !"".equals(yymm)){
	String date[] = yymm.split("/");
	String year = date[0];
	String month = date[1];
	if(month.length()<=1){
		month = "0"+month;
	}	
%>
		<div class="quota_result_title">
			<p><%=jobtype%></p>
			<p class="font_16_bold_a40000" style="margin: 0px 5px 0px 5px;"><%=year%>-<%=month%></p>
			<p>AL Quota</p>
			<br>
			<p>Total/Left(Release)</p>
		</div>
<%
	CrewALFun fun = new CrewALFun();	
	fun.ListALquota(jobtype, year, month);
	CrewALQuotaRObj rObjAL = fun.getCrewQuotaAL();
	ALQuotaObj[]  objArr = rObjAL.getQuotaArr();
	Date todate = new Date();
	SimpleDateFormat dateFormat = new SimpleDateFormat("MM");
	
	if(null!=objArr && objArr.length>0){
%>
		<div class="quota_result_calendar">
			<!-- 放星期幾 -->
			<ul class="calendar_week">
				<li>日</li>
				<li>一</li>
				<li>二</li>
				<li>三</li>
				<li>四</li>
				<li>五</li>
				<li>六</li>
			</ul>
			
<%
			int tempday = DateTool.getDay3(year+"/"+month+"/01");
			String a = "";
			
			for (int j=0; j<tempday-1 ; j++)
			{
				a +="<li><p></p></li>";
			}

			//out.println("a="+a);
%>
			<!-- 
			放日期 1個ul是一週 
			today_circle的class是藍色圈圈
			font_14_a40000是剩0的時候要變成的紅字
			-->
<%

		int count = 0;
		for(int i=0; i<objArr.length; i++ )
		{
			String tempdate = "";
			if((i+1)<10)
			{
				tempdate = year+"/"+month+"/0"+(i+1);
			}
			else
			{
				tempdate = year+"/"+month+"/"+(i+1);
			}
			ALQuotaObj obj = (ALQuotaObj) objArr[i];
			if(DateTool.getDay3(tempdate)==1){
				//out.println("other"+i);
				out.print("<ul class=\"calendar_day\">");
				count++;
			}
			if(count == 0 ){
				out.print("<ul class=\"calendar_day\">"+a);
				count++;
			}//第一週處理
%>
				<li>
				<p id="link<%=count+1%><%=i%>"  class="link"  onClick="changeColor(<%=count+1%><%=i%>);"><%=i+1%></p><!--   -->
<%
				 if (Integer.parseInt(obj.getQuota_left())<=0)
				 {
%>	
					<p class="font_14_a40000"><%=obj.getQuota()%>/0</p>
					<p class="font_14_a40000">(<%=obj.getQuota_release()%>)</p>
<%
				 }
				 else
				 {
%>
					<p class=""><%=obj.getQuota()%>/<%=obj.getQuota_left()%></p>
<%
				 }
%>		
				</li>
<%
			
			if(DateTool.getDay3(tempdate)==7)
			{	
				out.print("</ul>");
			}
		}//for(int i=0; i<objArr.length; i++ )


%>			
		</div>
		<form id="form_quota" method="POST" action="" data-ajax="false">
		</form>
		<div id="leave_result_info"  style="margin-right:25px">
			<span id="div_result_infoMsg">
			<p>• 此表僅供查詢，以實際遞單為準</p>
        	<p>• 當AL Quota為零，每月遞單截止為前五天22:00至遞單截止日23:59期間，禁止上網取消退回已申請之AL其餘時段正常作業。</p>
       		<p>• 每月遞單截止日前五天23:00，可自行上網申請是放出額度之AL</p>
       		</span>
       	</div>
		
		<div id="btnApply" class="leave_apply_btnApply">
			<a id="sub" href="#" class="ui-btn ui-corner-all" ><div>申請</div></a>			
		</div>			
<%
		}//if(objAL.length>0)
		else{
			out.print("<div class=\"quota_result_title\">No Data</div>");
		}
	}//if(null!=yymm && !"".equals(yymm)
}
}catch(ClassCastException e){
	out.println("請登入");
	response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println("Error"+e.toString());	
}
%>
	</div>
<!-- 特休假配額查詢 End-->

<!-- navbar Slide Panel -->
    <div id="navbar" data-role="panel" data-position="right" data-position-fixed="false" data-display="overlay" data-theme="b">
        <ul id="right-list" data-role="listview" data-inset="true" data-icon="false">
        </ul>
    </div>
<!-- navbar Slide Panel -->

</div>


</body>
</html>