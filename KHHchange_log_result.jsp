<%@page import="java.text.DecimalFormat"%>
<%@page import="swap3ackhh.*"%>
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
	} else{  
	FZCrewObj uObj = lObj.getFzCrewObj();
	String type = (String) request.getParameter("type");	
	String formno = "";

		  
%>
<!DOCTYPE html>
<html>
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
        });
    </script>

</head>
<body>

<div id="change_log_result" data-role="page">
<!-- Header bar Start -->
	<div data-role="header" data-position="fixed">
		<table id="header-bar">
			<tr>
				<td id="header-bar-btnBak">
					<a data-rel="back"><div id="naviBar_icon_Back"></div></a>
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
		<div id="log_result_title">
<%

	formno =  (String) request.getParameter("formno");
	swap3ackhh.ShowSwapForm aform = null;
	swap3ackhh.ShowSwapBForm bform = null;
	swap3ackhh.SwapFormObj obj = null;
	ArrayList aSwapSkjAL = null;
	ArrayList rSwapSkjAL = null;
	DecimalFormat df = new DecimalFormat("0000");
	int aALtimes = 0;
	int rALtimes = 0;
	if("KHH".equals(uObj.getBase()) && null != formno && !"".equals(formno)){
		if("A".equals(type)){
			aform = new swap3ackhh.ShowSwapForm(formno);
			obj= aform.getSwapFormObj();
		}else if("B".equals(type)){
			bform = new swap3ackhh.ShowSwapBForm(formno);
			obj = bform.getSwapFormObj();
		}
		aform = new swap3ackhh.ShowSwapForm(formno);
		obj= aform.getSwapFormObj();
		if(null != obj && !"".equals(obj)){
		aSwapSkjAL = obj.getASwapSkjAL();
		rSwapSkjAL = obj.getRSwapSkjAL();
		 
%>		
			<div>
			<span><p>Form No :</p>
			<p><%=type%><%=formno%></p></span>
			<br>
			<p>Apply Date :</p>
			<p><%=obj.getNewdate()%></p>
			<br>
			<p>Confirem Date :</p>
			<p><%=obj.getCheckdate()%></p>
			</div>
		</div>

		<div data-role="navbar">
			<ul id="result_title">
				<li>Applicant</li>
				<li>Substitle</li>
			</ul>
			
			<ul class="result_content">
				<li>
					<div>	<!--申請者第1欄-->
						<p style="font-size: 18px; font-weight: bold;"><%=obj.getACname() %></p>
						<p style="font-size: 11px;">&nbsp;</p>
						<br>
						<span class="span_font11px">
							<p><%=obj.getAEmpno() %></p>
							<p>(<%=obj.getASern()%>)</p>
							<br>
							<p>Section</p>
							<p><%=obj.getAGrps()%></p>
						</span>
						<span class="span_Exchange_Qualification">
							<p>Exchange Count :</p>
							<p><%=obj.getAApplyTimes() %></p>
							<br>
							<p>Qualification :</p>
							<p><%=obj.getAQual()%></p>
						</span>
					</div>
				</li>
				<li>
					<div>	<!--被換者第1欄-->
						<p style="font-size: 18px; font-weight: bold;"><%=obj.getRCname() %></p>
						<p style="font-size: 11px;"></p>
						<br>
						<span class="span_font11px">
							<p><%=obj.getREmpno() %></p>
							<p>(<%=obj.getRSern()%>)</p>
							<br>
							<p>Section</p>
							<p><%=obj.getRGrps()%></p>
						</span>
						<span class="span_Exchange_Qualification">
							<p>Exchange Count :</p>
							<p><%=obj.getRApplyTimes() %></p>
							<br>
							<p>Qualification :</p>
							<p><%=obj.getRQual()%></p>
						</span>
					</div>
				</li>
			</ul>
			<ul class="result_content">
				<li>
				
					<div>	<!--申請者第2欄-->
					<%
					if(aSwapSkjAL != null){
						for(int i=0;i<aSwapSkjAL.size();i++){
							CrewSkjObj2 skjObj = (CrewSkjObj2)aSwapSkjAL.get(i);							
					%>
						<p style="font-size: 11px;">Trip No.</p>
						<p style="font-size: 18px;"><%=skjObj.getTripno() %></p>
						<br>
						<p style="font-size: 18px; font-weight: bold; color: #c22727;"><%=skjObj.getFdate() %></p>
						<br>
						<p style="font-size: 20px; font-weight: bold;"><%=skjObj.getDutycode() %></p>
						<br>
						<span class="span_Flying">
							<p>Flying Time :</p>
						<%if("AL".equals(skjObj.getDutycode())){
							aALtimes++; 
						%>
							<p>0000</p>
						<%}else{ %>
							<p><%=skjObj.getCr() %></p>
						<%} %>
						</span>
						<%
						}
					}
					%>
					</div>
				</li>
				<li>
					<div>	<!--被換者第2欄-->
					<%
					if(rSwapSkjAL != null){
						for(int i=0;i<rSwapSkjAL.size();i++){
							CrewSkjObj2 skjObj = (CrewSkjObj2)rSwapSkjAL.get(i);						
					%>
						<p style="font-size: 11px;">Trip No.</p>
						<p style="font-size: 18px;"><%=skjObj.getTripno() %></p>
						<br>
						<p style="font-size: 18px; font-weight: bold; color: #c22727;"><%=skjObj.getFdate() %></p>
						<br>
						<p style="font-size: 20px; font-weight: bold;"><%=skjObj.getDutycode() %></p>
						<br>
						<span class="span_Flying">
							<p>Flying Time :</p>
						<%if("AL".equals(skjObj.getDutycode())){
							aALtimes++; 
						%>
							<p>0000</p>
						<%}else{ %>
							<p><%=skjObj.getCr() %></p>
						<%} %>
						</span>
						<%
						}
					}
					%>
					</div>
				</li>
			</ul>
			<ul class="result_content">
				<li>
					<div class="noborder">	<!--申請者第3欄-->
						<p>互換班飛時 :</p>
						<p class="pbold"><%=obj.getASwapHr()%></p>
						<br>
						<p>飛時差額 :</p>
						<p class="pbold"><%=obj.getASwapDiff()%></p>
						<br>
						<p>換班前時數 :</p>
						<p class="pbold"><%= obj.getAPrjcr()%></p>
						<br>
						<p>放棄AL時數 :</p>
						<p class="pbold">-<%=df.format(200 * aALtimes)%></p>
						<br>
						<p>換班後時數 :</p>
						<p class="pbold"><%=obj.getASwapCr()%> </p>
					</div>
				</li>
				<li>
					<div class="noborder">	<!--被換者第3欄-->
						<p>互換班飛時 :</p>
						<p class="pbold"><%=obj.getRSwapHr()%></p>
						<br>
						<p>飛時差額 :</p>
						<p class="pbold"><%=obj.getRSwapDiff()%></p>
						<br>
						<p>換班前時數 :</p>
						<p class="pbold"><%= obj.getRPrjcr()%></p>
						<br>
						<p>放棄AL時數 :</p>
						<p class="pbold">-<%=df.format(200 * rALtimes)%></p>
						<br>
						<p>換班後時數 :</p>
						<p class="pbold"><%=obj.getRSwapCr()%> </p>
					</div>
				</li>
			</ul>
			<ul id="result_personinfo">
				<li><a href="personInfo.jsp" id="list_btn_profile" data-ajax="false"></a></li>
				<li><a href="personInfo.jsp" id="list_btn_profile" data-ajax="false"></a></li>
			</ul>
			<ul id="result_personinfo" style="border-top: none;">
				<li>
					<div>Comments :<%=obj.getCrew_comm() %></div>
				</li>
			</ul>
			<ul id="log_result_info">
				<li>
					<span>
					<p>ED Confirm :</p>
					<p><%=obj.getEd_check() %></p>
					<br>
					<p>Comments :</p>
					<p><%=obj.getComments() %></p>
					</span>
				</li>
			</ul>
		</div>
		<div id="result_info" class="result_info_marginleft5">
			<!-- <span id="div_result_infoMsg">
				<p>本人及互換者相互同意換班並保證 :</p>
				<p>1.本申請日前兩個曆月內全勤。</p>
				<p>2.本申請單內填寫內容符合申請規定無誤。</p>
			</span> -->
		</div>
		
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
			}//obj
			else{
				%>
				<div id="log_result_title">No data</div>
				<%
			}
		}
		else{
			out.println("No formno");
		}
	
}
}catch(ClassCastException e){
	out.println("請登入");
	response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println(e.toString());
}
%>