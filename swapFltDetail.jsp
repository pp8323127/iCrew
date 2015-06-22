<%@page import="java.util.ArrayList"%>
<%@page import="swap3ac.TripInfo"%>
<%@page import="swap3ac.TripInfoObj"%>
<%@page import="ws.crew.CrewSwapFun"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%
String tripNo = request.getParameter("tripNo");
String spCode = request.getParameter("spCode");
TripInfo ti = new TripInfo(tripNo);
ArrayList objAL = null;
try{
	ti.SelectData();
	objAL = ti.getTripnoAL();

if(null!=objAL){ 
	for(int i=0;i<objAL.size();i++){
		 TripInfoObj obj = (TripInfoObj)objAL.get(i);
%>
	<hr>
	<%=obj.getFdate()%>　Fltno: <%=obj.getDuty() %></br>
	Dpt: <%=obj.getDpt()%>　Arv: <%=obj.getArv()%></br>
	Btime: <%=obj.getBtime()%></br>
	Etime: <%=obj.getEtime()%></br>
	Cr(HHMM): <%=obj.getCrInHHMM()%></br>
	Sp Code:<%=spCode%></br><!-- Rest Hour: 10 -->		
<%}
	}else{ %>
	No Data.</br>
<%}
}catch(ClassCastException e){
	out.println("請登入");
	//response.sendRedirect("login.jsp");
}catch(Exception e){
	out.print(e.toString());
}

%>