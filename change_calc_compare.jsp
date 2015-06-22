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
	String[] rEmpno = request.getParameterValues("rEmpno");
	String yymm = request.getParameter("myDate");
	String year = "";
	String month = "";
	String str = "";
		
		//out.println(year +"/"+month);
		/*CrewSwapTPE csf = new CrewSwapTPE();
		//試算資格
		if("TPE".equals(uObj.getBase())){			
			str = csf.CorssCrTPE(aEmpno, rEmpno, year, month);
		}else if("KHH".equals(uObj.getBase())){
			//str = csf.CorssCrKHH(aEmpno, rEmpno, year, month);
		}else{
			
		}*/
		
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
            	var yymm = $("#myDate").val();
            	var rEmpno = $('input:radio:checked[name="radiorEmpno"]').val();
            	//console.log(yymm+rEmpno);
            	if("" != yymm && !isNaN(rEmpno) && "" != rEmpno){
	            	$("#Crossform").attr("action", "change_calc_table.jsp");
					$("#Crossform").submit();
            	}else{
            		$("#strMsg2").html("請勾選欲試算的組員");
                	//$("#backData").val("");
                	$("#alert-popup-info").popup("open");
            	}
            });
			$("#naviBar_icon_Back").click(function(e){            	
				$("#Crossform").attr("action", "change_calc.jsp");
				$("#Crossform").submit();            	
        	});
			//detail pop
			$("#popInfo").click(function(e){
				$("#alert-popup-info").popup("close");	         	
            });
        });
        
    </script>

</head>
<body>

<div id="change_calc_compare" data-role="page">
<!-- Header bar Start -->
	<div data-role="header" data-position="fixed">
		<table id="header-bar">
			<tr>
				<td id="header-bar-btnBak">
					<a href="#"><div id="naviBar_icon_Back"></div></a>
				</td>
				<td id="header-bar-btnAppname">換班飛時試算</td>
				<td id="header-bar-btnMenu">
					<a id="btn_menu" href="#navbar"><div id="navi_icon_menu"></div></a>
				</td>
			</tr>
		</table>
	</div>
<!-- Header bar End -->

<!-- 換班飛時試算-對照 Start-->
<div role="main" class="ui-content">
<form id="Crossform" method="POST" action="" data-ajax="false">
<div data-role="navbar" id="calc_navbar">
	
<%
if(null!=yymm && !"".equals(yymm)){
	String date[] = yymm.split("/");
	year = date[0];
	month = date[1];
	if(month.length()<=1){
		month = "0"+month;
	}
	CrewCrossCrMuti ccm = new CrewCrossCrMuti(aEmpno, rEmpno, year, month);
	ccm.SelectData();
	ArrayList aEmpnoAL = ccm.getACrewSkjAL();
	ArrayList rEmpnoAL = ccm.getRCrewSkjAL();
	CrewInfoObj aCrewInfoObj = ccm.getACrewInfoObj();
	CrewInfoObj[] rCrewInfoObj = ccm.getrCrewInfoObj();
	int acnt = 0;
	int rcnt = 0;
	/*每天*/
	ArrayList dayofmonthAL = new ArrayList();
	dayofmonthAL=ccm.getEachDayOfMonth(year,month);
	//out.println(ccm.getStr());
%>
<ul>
<li>
	<div id="calc_datetime">
		<table>
			<tr class="tr_yearmonth">
				<th rowspan="3">
					<p><%=year %></p>
					<p><%=month %></p>
				</th>
				<input type="hidden" name="myDate"  id="myDate" value="<%=yymm%>">
			</tr>
			<tr></tr>
			<tr></tr>
<%
String bcolor = "";
for(int o=0; o<dayofmonthAL.size(); o++)
{
	if(((String)dayofmonthAL.get(o)).indexOf("SAT")>=0 || ((String)dayofmonthAL.get(o)).indexOf("SUN")>=0)
	{
		//週末
		bcolor="#FFCDDF";
	}else{
		bcolor="f8f8f8";
	}
%>
			
			<tr class="tr_date" bgcolor="<%=bcolor%>">
				<td><%=((String) dayofmonthAL.get(o)).substring(8,10)%></td>
			</tr>
<%
}//for(int o=0; o<dayofmonthAL.size(); o++)
%>
			<tr class="tr_select_title">
				<td>
				<p>選</p>
				<p>擇</p>
				<p>試</p>
				<p>算</p>
				<p>者</p>
				</td>
			</tr>
		</table>
	</div>
</li>
<li>
	<div id="compare_applicant1">		
		<table>
			<tr class="tr_applicant">
				<th colspan="2">Applicant</th>
			</tr>
			<tr class="tr_name">
				<td colspan="2">
					<p><%=aCrewInfoObj.getEmpno()%></p>
					<p><%=aCrewInfoObj.getCname()%></p>
				</td>
			</tr>
			<tr class="tr_fltno_cr">
				<td>Fltno</td>
				<td>CR</td>
			</tr>
		<%
		if(null!= aEmpnoAL && aEmpnoAL.size() > 0){
			for(int o=0; o<dayofmonthAL.size(); o++)
			{
				if(((String)dayofmonthAL.get(o)).indexOf("SAT")>=0 || ((String)dayofmonthAL.get(o)).indexOf("SUN")>=0)
				{
					//週末
					bcolor="#FFCDDF";
				}else{
					bcolor="#f8f8f8";
				}					
				for(int i=0 ;i<aEmpnoAL.size();i++){
					
					CrewSkjObj sobj = (CrewSkjObj)aEmpnoAL.get(i);
					if(((String)dayofmonthAL.get(o)).equals(sobj.getFdate()+" ("+sobj.getDayOfWeek()+")"))
					{
						acnt++;		
				%>
					<tr class="tr_content">
						<td><%=sobj.getDutycode() %></td>
						<td><%=sobj.getCr() %></td>
					</tr>
				<%
					}//if(((String)dayofmonthAL.get(o))
				}//for(int i=0 ;i<aEmpnoAL.size();i++)
				if(acnt<=0)
				{
				%>
					<tr class="tr_content"><td>&nbsp;</td><td>&nbsp;</td></tr>
				<%
				}//if(acnt<=0)
				acnt = 0;
			}//A 	for(int o=0; o<dayofmonthAL.size(); o++)
		}//if(null!= aEmpnoAL && aEmpnoAL.size() > 0)
		%>	
			<!-- 表格尾 -->
			<tr class="tr_applicant">
				<th colspan="2">Applicant</th>
			</tr>
			<tr class="tr_name">
				<td colspan="2">
					<p><%=aCrewInfoObj.getEmpno()%></p>
					<p><%=aCrewInfoObj.getCname()%></p>
				</td>
			</tr>
			<tr class="tr_chk">
				<td colspan="2">
					
				</td>
			</tr>
		</table>
		
	</div>
</li>

<%
if(null!=rCrewInfoObj && rCrewInfoObj.length>0){
	for(int i=0;i<rCrewInfoObj.length;i++) {
%>
<li>	
	<div id="compare_substitle<%=i%>">
		<table>
			<tr class="tr_substitle">
				<th colspan="2">Substituent</th>
			</tr>
			<tr class="tr_name">
				<td colspan="2">
					<p><%=rCrewInfoObj[i].getEmpno() %></p>
					<p><%=rCrewInfoObj[i].getCname() %></p>
				</td>
			</tr>
			<tr class="tr_fltno_cr">
				<td>Fltno</td>
				<td>CR</td>
			</tr>
		<%
		rcnt = 0;		
		ArrayList rEmpnoSkj = (ArrayList) rEmpnoAL.get(i);//第i位被換者
		if(null != rEmpnoSkj && rEmpnoSkj.size() > 0){
			for(int o=0; o<dayofmonthAL.size(); o++)
			{
				if(((String)dayofmonthAL.get(o)).indexOf("SAT")>=0 || ((String)dayofmonthAL.get(o)).indexOf("SUN")>=0)
				{
					//週末
					bcolor="#ffcddf";
				}else{
					bcolor="#f8f8f8";
				}									
				for(int k=0;k<rEmpnoSkj.size();k++){
					
					CrewSkjObj sobj = (CrewSkjObj)rEmpnoSkj.get(k);
					if(((String)dayofmonthAL.get(o)).equals(sobj.getFdate()+" ("+sobj.getDayOfWeek()+")"))
					{
						rcnt++;
				%>
					<tr class="tr_content">
						<td><%=sobj.getDutycode() %></td>
						<td><%=sobj.getCr() %></td>
					</tr>
					
				<%
					}//if(((String)dayofmonthAL.get(o))
						
				}//for(int k=0;k<rEmpnoSkj.size();k++)
				if(rcnt<=0)
				{
				%>
					<tr class="tr_content"><td>&nbsp;</td><td>&nbsp;</td></tr>
				<%
				}//if(rcnt<=0)					
				rcnt = 0;
			}//R	for(int o=0; o<dayofmonthAL.size(); o++)
		}//if(null != rEmpnoSkj && rEmpnoSkj.size() > 0)
		%>	
			<!-- 表格尾 -->
			<tr class="tr_substitle">
				<th colspan="2">Substituent</th>
			</tr>
			<tr class="tr_name">
				<td colspan="2">
					<p><%=rCrewInfoObj[i].getEmpno() %></p>
					<p><%=rCrewInfoObj[i].getCname() %></p>
				</td>
			</tr>
			<tr class="tr_chk">
				<td colspan="2">
					<!--  <div id="list_btn_square"></div>-->
					<input type="radio" name="radiorEmpno" value="<%=rCrewInfoObj[i].getEmpno()%>">
				</td>
			</tr>
		</table>
	</div>	
</li>
<%
		}//for(int i=0;i<rCrewInfoObj.length;i++) 
	%>


	</ul>
	</div>
			<div id="btnOKCancel" class="btn_calc_compare">
				<a data-rel="back" class="ui-btn ui-corner-all"  data-ajax="false"><div>取消</div></a>
				<a id="sub" href="#" class="ui-btn ui-corner-all" data-ajax="false"><div>確認</div></a>
			</div>
	<%
	}//if(null!=rCrewInfoObj && rCrewInfoObj.length>0)
}//	if(null!=yymm && !"".equals(yymm))			
}
}catch(ClassCastException e){
	out.println("請登入");
	response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println(e.toString());
}
%>
</form>

</div>
<!-- 換班飛時試算-對照 End-->
<!-- popup container start -->

<div data-role="popup" id="alert-popup-info" class="ui-content popupDiv" data-overlay-theme="b" data-dismissible="false" data-position-to="window" data-shadow="true" data-corners="true" style="text-align: center;">
    <div data-role="header" class="popup-header" id="change_apply_list_header">
       <p id="tripno_show"></p>
    </div>
    <div data-role="content" class="popup-content" id="change_apply_list_popup">
		<p id="strMsg2"></p>
        <a id="popInfo" class="ui-btn btnPopOK" href="#" data-ajax="false"><div>確 認</div></a>
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
