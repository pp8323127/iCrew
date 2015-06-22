<%@page import="ws.CrewMsgObj"%>
<%@page import="ws.off.CrewALFun"%>
<%@page import="ws.crew.LoginAppBObj"%>
<%@page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
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
		
		
		String checkStr = request.getParameter("delAL");
		String offyear = request.getParameter("offyear");
		//out.println("失敗"+checkStr);
		String[] checkdel = checkStr.split(",");
		if(checkdel.length > 0){
			CrewALFun fun = new CrewALFun();
			CrewMsgObj obj = fun.DelAL(checkdel, lObj.getFzCrewObj().getEmpno(), offyear);
			if("1".equals(obj.getResultMsg())){
				out.println("您已成功刪除申請單");//:+obj.getErrorMsg()
			}else{
				out.println("失敗:"+obj.getErrorMsg());	
			}
			
		}else{
			out.println("失敗:請勾選欲刪除之假單.");			
		}
	}
}catch(ClassCastException e){
	out.println("請登入");
	//response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println("Error"+e.toString());	
}
%>