<%@page import="ws.crew.CrewSwapFunALL"%>
<%@page import="ws.crew.StatusObj"%>
<%@page import="fzAuthP.FZCrewObj"%>
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
	} else{  
	FZCrewObj uObj = lObj.getFzCrewObj();
	String aEmpno = uObj.getEmpno();
	String rEmpno = request.getParameter("rEmpno");
	String yymm = request.getParameter("myDate");
	String year = "";
	String month = "";
	String str = "";
	int temp = 9;
	if(null!=yymm && !"".equals(yymm)){
		String date[] = yymm.split("/");
		year = date[0];
		month = date[1];
		if(month.length()<=1){
			month = "0"+month;
		}	
		//out.println(year +"/"+month);
		CrewSwapFunALL csf = new CrewSwapFunALL();
		if(null!=rEmpno){
			String[] rEmpnoArr = rEmpno.split(",");
			if(rEmpnoArr.length > 0 ){
				StatusObj obj = csf.ChkCrewBase(aEmpno, rEmpnoArr);	
				//out.println(obj.getErrMsg());
				//試算資格
				if(obj.getStatus() == 1 || obj.getStatus() == 2){			
					str = csf.CorssCr(aEmpno, rEmpnoArr, year, month);
					if("Y".equals(str)){
						out.println(obj.getErrMsg() +":"+ str);
					}else{
						out.println("錯誤:"+ str);
					}
						
				}else{
					out.println("錯誤:"+obj.getErrMsg());
				}
			}
		}else{
			out.println("無被換者");
		}		
	}else{
		out.println("無試算日期");
	}	
}
}catch(ClassCastException e){
	out.println("請登入");
	response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println(e.toString());
}
%>