<%@page import="ws.CrewMsgObj"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ws.crew.CrewPickApplyNumRObj"%>
<%@page import="fzAuthP.FZCrewObj"%>
<%@page import="ws.crew.CrewPickFun"%>
<%@page import="ws.crew.LoginAppBObj"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>

<%try{	
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
	
		FZCrewObj uObj = lObj.getFzCrewObj();
		String type = (String)request.getParameter("type");
		
		String att = "";
		String pointList =  "";
		CrewPickFun cpf = null;
		if("1".equals(type)){
			att = (String)request.getParameter("att");
			String sdate = (String)request.getParameter("sdate");
			String edate = (String)request.getParameter("edate");
			String comment = (String)request.getParameter("comment");
			if(null!=sdate &&  !"".equals(sdate) && null!=edate && !"".equals(edate)){
				cpf = new CrewPickFun();		
				CrewMsgObj msg = cpf.SendPickAttForm( uObj.getEmpno(), uObj.getBase(), sdate, edate, comment);
				if("1".equals(msg.getResultMsg())){
					out.println("您已成功提出申請:"+msg.getErrorMsg());//+sdate+edate
				}else{
					out.println(msg.getErrorMsg());
				}
			}else{
				out.println("缺少起訖日期資訊");
			}
			//out.println("您已成功提出申請:"+att+ "/" +sdate+ "/" +edate+ "/"+comment);
		}else if("2".equals(type)){
			pointList = (String)request.getParameter("pointList");
			if(null != pointList && !"".equals(pointList)){
				String[] chkItem = pointList.split(",");
				cpf = new CrewPickFun();	
				CrewMsgObj msg = cpf.SendPickCtForm(chkItem, uObj.getEmpno(), uObj.getBase());
				if("1".equals(msg.getResultMsg())){
					out.println("您已成功提出申請");//+msg.getErrorMsg()
				}else{
					out.println("失敗:"+msg.getErrorMsg());
				}
				//out.println("您已成功提出申請:"+pointList);
			}else{
				out.println("失敗:請勾選3個積點或選班單");
			}
		}
	
}	
}
catch(ClassCastException e){
	out.println("請登入");
	response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println(e.toString());
}
%>