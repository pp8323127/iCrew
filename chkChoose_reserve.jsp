<%@page import="ws.crew.CrewPickApplyNumRObj"%>
<%@page import="fzAuthP.FZCrewObj"%>
<%@page import="ws.crew.CrewPickFun"%>
<%@page import="ws.crew.LoginAppBObj"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>

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
	FZCrewObj uObj = lObj.getFzCrewObj();
	String str = (String)request.getParameter("unList");
	String returnmsg = "";
	String sno = str.substring(6) ;
	String empno = str.substring(0,6) ;
	//out.println(str+"empno"+empno+"sno"+sno);
	CrewPickFun cpf = new CrewPickFun();
	cpf.PickApplyNum(empno, uObj.getBase(), sno);
	//cpf.getPickNumObjAL();
	CrewPickApplyNumRObj rObjAL = cpf.getPickNumObjAL();
	if("1".equals(rObjAL.getResultMsg())){
		out.println(rObjAL.getErrorMsg());
		//out.println(rObjAL.getNum());	
	}else{
		out.println(rObjAL.getErrorMsg());
	}
	
}	
}
catch(ClassCastException e){
	out.println("請登入");
	//response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println(e.toString());
}
%>