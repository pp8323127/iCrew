<%@page import="eg.off.OffType"%>
<%@page import="eg.off.OffTypeObj"%>
<%@page import="eg.off.ALPeriodObj"%>
<%@page import="ws.crew.CrewBasicObj"%>
<%@page import="ws.off.CrewALRObj"%>
<%@page import="java.util.ArrayList"%>
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
		response.sendRedirect("login.jsp");
	} 
	else
	{		
		String offyear = request.getParameter("offyear");
%>
<!DOCTYPE html>
<html lang="en">
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

<div id="leave_search" data-role="page">
<!-- Header bar Start -->
    <div data-role="header" data-position="fixed">
        <table id="header-bar">
            <tr>
                <td id="header-bar-btnBak">
                    <a href="leave_main.jsp" data-ajax="false"><div id="naviBar_icon_Back"></div></a>
                </td>
                <td id="header-bar-btnAppname">特休假查詢</td>
                <td id="header-bar-btnMenu">
                    <a id="btn_menu" href="#navbar"><div id="navi_icon_menu"></div></a>
                </td>
            </tr>
        </table>
    </div>
<!-- Header bar End -->
<%
CrewALFun fun = new CrewALFun();
fun.ListOfAL(lObj.getFzCrewObj().getEmpno());
CrewALRObj rObjAL = fun.getCrewALAL();

%>
<!-- 特休假查詢 Start-->
    <div role="main" class="ui-content">
        <div class="search_title">
        <%
        if(null != rObjAL && null!= rObjAL.getEgInfo()){ 
        	CrewBasicObj obj = rObjAL.getEgInfo();
        %>
            <p class="font_20_bold"><%=obj.getCname()%></p>
            <p class="font_16_bold"><%=obj.getDeptno() %></p>
            <br>
            <p><%=obj.getEmpn() %></p>
            <p>(<%=obj.getSern() %>)</p>
            <br>
            <p>AL effective Date :</p>
            <p><%=obj.getAldate() %></p>
            <br>   
            
            <p>未扣休假總天數 :</p>
            <p class="font_bold"><%=rObjAL.getUndeduct() %></p>
        <%   	
        }
        %> 
        </div>

        <%
        OffType offtype = new OffType();
        offtype.offData();
        if(null!=rObjAL.getALperiodAL()){
        	ArrayList objAL = rObjAL.getALperiodAL();
        	for(int i=0;i<objAL.size();i++){
        		ALPeriodObj obj = (ALPeriodObj) objAL.get(i);
        //一個search_content的div，是一筆的紀錄 
        %>
        <div class="search_content">
        	<p class="font_14_707070">AL/XL valid period</p>
        	<br>
            <p class="font_18_a40000">(<%=offtype.getOffDesc(obj.getOfftype()).offtype%>)<%=obj.getEff_dt() %>~<%=obj.getExp_dt() %></p>
            <br>
            <p>進假天數 :</p>
            <p class="font_18_bold">
            <%
            if(null!=obj.getOrigdays() && !"".equals(obj.getOrigdays())) {
				out.println(obj.getOrigdays());
			} else {
				out.println(obj.getOffquota());
			} 
			%>
			</p>
            <p style="margin-left: 20px;">可用天數 :</p>
            <p class="font_18_bold"><%=obj.getOffquota()%></p>
            <br>
            <p>已使用天數 :</p>
            <p class="font_18_bold"><%=obj.getUseddays() %></p>
        </div>
        <% 		
        	}
        }else{
        %>
        <div class="search_content"><p class="font_18_a40000">No Data</p></div>
        
        <%        	
        }        
        %>
    </div>
<!-- 特休假查詢 End-->
<%
	}
}catch(ClassCastException e){
	out.println("請登入");
	response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println("Error"+e.toString());	
}
%>
<!-- navbar Slide Panel -->
    <div id="navbar" data-role="panel" data-position="right" data-position-fixed="false" data-display="overlay" data-theme="b">
        <ul id="right-list" data-role="listview" data-inset="true" data-icon="false">
        </ul>
    </div>
<!-- navbar Slide Panel -->

</div>


</body>
</html>
		
		
