<%@page import="ws.CrewMsgObj"%>
<%@page import="ws.crew.CrewSwapFunALL"%>
<%@page import="ws.crew.LoginAppBObj"%>
<%@page import="fzAuthP.FZCrewObj"%>
<%@page import="ws.crew.SendCrewSwapFormObj"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%
try{
//LoginAppBObj lObj= (LoginAppBObj) session.getAttribute("loginAppBobj");
SendCrewSwapFormObj swapFormAr = null;
LoginAppBObj lObj= null;
if(null != session.getAttribute("loginAppBobj")){
	lObj= (LoginAppBObj) session.getAttribute("loginAppBobj");
	swapFormAr = (SendCrewSwapFormObj) session.getAttribute("sendSwapObj");
}
if(lObj == null ) {
	out.println("請登入");
	//response.sendRedirect("login.jsp");
} 
else{  
	FZCrewObj uObj = lObj.getFzCrewObj();
	String aEmpno = uObj.getEmpno();
	String rEmpno = request.getParameter("rEmpno");
	//String[] aChoSwapSkj = request.getParameterValues("chkA");
	//String[] rChoSwapSkj = request.getParameterValues("chkR");
	String yymm = request.getParameter("myDate");
	String apoint = request.getParameter("apoint");
	/*if(null == apoint || "".equals(apoint)){
		apoint = "0";
	}*/
	String rpoint = request.getParameter("r_point");
	/*if(null == rpoint || "".equals(rpoint)){
		rpoint = "0";
	}*/
	String ack =  request.getParameter("ack");
	String rck =  request.getParameter("r_ck");
	/*String aTimes =  request.getParameter("aTimes");
	String rTimes =  request.getParameter("rTimes");*/
	String type =  request.getParameter("type");
	String str = "";
	int totalTimes = 4;

	if(null!=swapFormAr.getMonth() && !"".equals(swapFormAr.getMonth())){
		/*String date[] = yymm.split("/");
		year = date[0];
		month = date[1];
		if(month.length()<=1){
			month = "0"+month;
		}*/
		//out.println(swapFormAr.getYear()+swapFormAr.getMonth()+apoint+rpoint+ack+rck+aTimes+rTimes+type);
		/*out.println(swapFormAr.getaCname());
		out.println(swapFormAr.getrCname());
		out.println(swapFormAr.getaGrps());
		out.println(swapFormAr.getrGrps());*/
		
		CrewSwapFunALL csf = new CrewSwapFunALL();
		CrewMsgObj obj = csf.SendSwapForm(swapFormAr, type, apoint, rpoint);
		if("1".equals(obj.getResultMsg())){
			out.println("您已成功提出申請");//obj.getErrorMsg()
			session.removeAttribute("sendSwapObj");
		}else{
			//out.println(type);
			out.println("失敗:"+obj.getErrorMsg());//+"ack:"+ack+"rck:"+rck+"apoint:"+apoint+"rpoint:"+rpoint
		}		
	}else{
		out.println("錯誤 :無月份資料");
	}
	
}
}catch(ClassCastException e){
	out.println("請登入");
	//response.sendRedirect("login.jsp");
}catch(Exception e){
out.println("X"+e.toString());
}


%>