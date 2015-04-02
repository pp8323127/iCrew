<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,fzAuthP.*" %>

<%
	String UserID = request.getParameter("UserID");
	String Password = request.getParameter("Password");
	Boolean check = true;

	//EIP帳號密碼登入
    if (UserID != null && Password != null) {
		CheckEIP eip = new CheckEIP(UserID, Password);
		if (eip.isPassEIP()) {
			out.println(check);
		}
		else {
			check = false;
			out.println(check);
		}
    }
    else{
    	check = false;
		out.println(check);
    }
    
%>