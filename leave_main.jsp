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
<body class="main">
<div id="leave_main" class="main" data-role="page">
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

<!-- 請假 主選單 Start-->
    <div role="main" class="ui-content">
        <div id="main-content">
            <div>
                <p>請假</p>
            </div>
            <div>
            <%if(cabin && ("TPE".equals(uObj.getBase()) || "KHH".equals(uObj.getBase()))  ){//&& "1".equals(uObj.getstatus)%>
                <a href="leave_search.jsp" class="ui-btn ui-nodisc-icon ui-btn-icon-right ui-icon-menu_btn_arrow_right_white" data-ajax="false">特休假查詢</a>
                <hr/>
                <a href="leave_quota.jsp" class="ui-btn ui-nodisc-icon ui-btn-icon-right ui-icon-menu_btn_arrow_right_white" data-ajax="false">特休假配額查詢</a>
                <hr/>
                <a href="leave_apply.jsp" class="ui-btn ui-nodisc-icon ui-btn-icon-right ui-icon-menu_btn_arrow_right_white" data-ajax="false">特休假申請</a>
                <hr/>
                <a href="leave_manage.jsp" class="ui-btn ui-nodisc-icon ui-btn-icon-right ui-icon-menu_btn_arrow_right_white" data-ajax="false">假單查詢與刪除</a>
                <hr/>
             <%}else{%> 
            	<p>未授權:資格不符合(非後艙組員 或 Base不符)</p> 
             <%}%>
            </div>
        </div>
    </div>
<!-- 請假 主選單 End-->

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