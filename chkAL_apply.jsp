<%@page import="ws.CrewMsgObj"%>
<%@page import="ws.crew.LoginAppBObj"%>
<%@page import="ws.off.CrewALFun"%>
<%@ page import="eg.off.*,eg.*, java.net.URLEncoder,java.io.*,java.util.*,java.text.*"%>
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
	} 
else
{
//	String offsdate = request.getParameter("validfrm");//yyyy/mm/dd
//	String offedate = request.getParameter("validto");//yyyy/mm/dd
//offsdate = offsdate.replaceAll("-", "/");//yyyy/mm/dd
//offedate = offedate.replaceAll("-", "/");//yyyy/mm/dd
	
	String off_type = request.getParameter("off_type");
	String sdateStr = request.getParameter("sdate");
	String edateStr = request.getParameter("sdate");
	String[] offsdate = sdateStr.split(",");
	String[] offedate = edateStr.split(",");
	int sheetNum = offsdate.length;
	String[] str = new String[sheetNum];
	String[] str2 = new String[sheetNum];
	String[] str3 = new String[sheetNum];
	String[] gdyear = new String[sheetNum];
	String errMsg = "";
	int flag = 0;//錯誤
	CrewALFun fun = new CrewALFun();
	CrewMsgObj obj = fun.sendAL(off_type, lObj.getFzCrewObj().getEmpno() , offsdate, offedate);
	out.println(obj.getErrorMsg());//:
	
}
}catch(ClassCastException e){
	out.println("請登入");
	//response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println("Error"+e.toString());	
}
%>