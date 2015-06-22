<%@page import="fzAuthP.FZCrewObj"%>
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
		FZCrewObj uObj = lObj.getFzCrewObj();
		boolean cabin = ("FA,FS,ZC,PR,PU,CM".indexOf(uObj.getOccu())) > 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
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
<body class="main">
<div id="change_main" class="main" data-role="page">
<!-- Header bar Start -->
	<div data-role="header" data-position="fixed">
		<table id="header-bar">
			<tr>
				<td id="header-bar-btnBak">
					<a href="MainPage.jsp" data-ajax="false"><div id="naviBar_icon_Back"></div></a>
				</td>
				<td id="header-bar-btnAppname">iCrew</td>
				<td id="header-bar-btnMenu">
					<a id="btn_menu" href="#navbar"><div id="navi_icon_menu"></div></a>
				</td>
			</tr>
		</table>
	</div>
<!-- Header bar End -->

<!-- 換班 主選單 Start-->
    <div role="main" class="ui-content">
        <div id="main-content">
            <div>
                <p>換班</p>
            </div>
            <div>
             <%if("N".equals(uObj.getLocked()) && cabin ){%>
                <a href="change_calc.jsp" class="ui-btn ui-nodisc-icon ui-btn-icon-right ui-icon-menu_btn_arrow_right_white" data-ajax="false">換班飛時試算</a>
                <hr/>
                <a href="change_apply.jsp" class="ui-btn ui-nodisc-icon ui-btn-icon-right ui-icon-menu_btn_arrow_right_white" data-ajax="false">換班申請</a>
                <hr/>
                <a href="change_log.jsp" class="ui-btn ui-nodisc-icon ui-btn-icon-right ui-icon-menu_btn_arrow_right_white" data-ajax="false">換班紀錄查詢</a>
                <hr/>
             <%}else{%> 
            	<p>未授權:資格不符合(非後艙組員 或 自行班表鎖定者)</p> 
             <%}%>
            </div>
        </div>
    </div>
<!-- 換班 主選單 End-->

<!-- navbar Slide Panel -->
    <div id="navbar" data-role="panel" data-position="right" data-position-fixed="false" data-display="overlay" data-theme="b">
        <ul id="right-list" data-role="listview" data-inset="true" data-icon="false">
        </ul>
    </div>
<!-- navbar Slide Panel -->
</div>
</body>

</html>
<%
	}
}catch(ClassCastException e){
	out.println("請登入");
	response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println("Error"+e.toString());	
}
%>