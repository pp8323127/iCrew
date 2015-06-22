<%@page import="java.net.URLEncoder"%>
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
		//response.sendRedirect("login.jsp");
	}else{  
	FZCrewObj uObj = lObj.getFzCrewObj();
	String aEmpno = uObj.getEmpno();
	String rEmpno = request.getParameter("rEmpno");
	String yymm = request.getParameter("myDate");
	String empno = request.getParameter("empno");//查詢用
	//out.println(empno);
	/*yymm="2015/06";
	rEmpno = "630304";*/

CrewEGinfo info = new CrewEGinfo();
ArrayList objAL = info.CrewContInfo(empno);
if(objAL.size()>0){
	for(int i=0;i<objAL.size();i++){
	CrewContObj obj = (CrewContObj) objAL.get(i);
%>
	<div data-role="header" class="popup-header" id="profile">
		<div id="personinfo">
			<p><%=obj.getCname()%></p>
			<p><%=obj.getSess() %></p>
			<p><%=obj.getBase() %></p>
			<br>
			<p class="personinfo_p2"><%=rEmpno %></p>
			<p class="personinfo_p2">(<%=obj.getBox() %>)</p>
		</div>
	</div>

	<div data-role="content" class="popup-content">
		<div id="personinfoDetail">
			<!--<p>E-mail：</p>
			<p><%=obj.getEmail() %></p>
			<br>
			<p>Moblie：</p>
			<p><%=obj.getMphone() %></p>
			<br>
			<p>Home：</p>
			<p><%=obj.getHphone() %></p>
			<br>-->
			<p>Message：</p>
			<p><%=obj.getIcq() %></p>
			<br>
		</div>
	</div>

	<div class="profile_btn">
		<% if(obj.getMphone() != null) { %>
			<div class="profile_btn_phone" onclick="location.href='tel:<%=obj.getMphone() %>'"></div>
		<%}%>
		<% if(obj.getHphone() != null) { %>
			<div class="profile_btn_call_home" onclick="location.href='tel:<%=obj.getHphone() %>'"></div>
		<%}%>

		<% if(obj.getEmail() != null) { %>
			<div class="profile_btn_mail" onclick="location.href='mailto:<%=obj.getEmail() %>'"></div>
		<%}%>
		
		<!-- <div class="profile_btn_msg" onclick="location.href='#'"></div> -->
	</div>


<!-- 	<div class="div_communicate_mail">
		<div class="div_communicate"><a id="btn_communicate" class="ui-btn" href="#"></a></div>
		<div class="div_mail"><a id="btn_mail" class="ui-btn" href="https://webmail.cal.aero/login/default.aspx" data-ajax="false"></a></div>	
	</div> -->
<%}
}else{ %>
	<div>
		<p>No data<%=info.getReturnStr()%></p>
	</div>
<%}
	}
}catch(ClassCastException e){
	out.println("請登入");
	//response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println("Error"+e.toString());	
}
%>

