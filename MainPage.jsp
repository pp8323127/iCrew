<%@page import="fzAuthP.FZCrewObj"%>
<%@page import="ws.crew.LoginAppBObj"%>
<%@page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%
try{
	response.setHeader("Cache-Control","no-cache");
	response.setDateHeader ("Expires", 0);
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
<html>
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
<link rel="stylesheet" href="jQueryMob/mainpage-style.css" />	
<script src="jQueryMob/jquery.js" language="javascript"></script>	
<script src="jQueryMob/jquery.mobile.custom.js" language="javascript"></script>

<style type="text/css">
	
	/*.ui-page {
	    background: transparent;
	}
	
	.ui-page .ui-header {
	    background: transparent;
	}*/
	
	.ui-content {
	    /*background: transparent;*/
	    width: 100%;
	    padding: 0;
	}	
	
	div::-webkit-scrollbar { 
	    display: none;
    }	
	
	/*.ui-input-text
	{
	    width: 260px !important;
	    height: 38px !important;
	    margin-right: auto;
	    margin-left: auto;
	}
	
	form .placeholder {
		font-family: 'Microsoft JhengHei', Helvtica;
		font-size: 15px;
		color: #707070;
	}
    
    .ui-field-contain {
    	width: 100%;
	    padding: 0;
    }*/
	
</style>

<script type="text/javascript">
$(document).ready(function () {
	
	$("#btn_menu").click(function(e){
		$.ajax({
			type: "POST",
			url: "navbar.jsp",
			success:function(data){
				//alert(data);
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

<!-- MainPage Start -->
	<div id="MainPage" data-role="page" data-theme="a">
	  <div data-role="header" data-position="fixed" class="header-bd" style="height: 44px; border:none; padding:0;">
		<div class="main-navi">
		 <div data-role="navbar">
		   <ul>
		     <li class="navbar"></li>
		     <li class="navbar">iCrew</li>
		     <li class="navbar"><a id="btn_menu" class="ui-btn-right" href="#navbar"></a></li>
		   </ul>
		 </div>
		</div>
	  </div>
	   <%if("N".equals(uObj.getLocked()) && cabin ){%>
	  <div role="main" class="ui-content">
		<div>
		  <div class="div_change">
		    <a id="btn_change" class="ui-btn" href="change_main.jsp" data-ajax="false"></a>
		  </div>
		  <div class="div_choose">
		    <a id="btn_choose" class="ui-btn" href="choose_main.jsp" data-ajax="false"></a>
		  </div>
		  <div class="div_leave">
		    <a id="btn_leave" class="ui-btn" href="leave_main.jsp" data-ajax="false"></a>
		  </div>		  
		</div>
		<%}%>
		<div style="display: block; height:180px;">
		  <div class="div_cia_bus">
		    <div class="div_cia"><a id="btn_cia" class="ui-btn" href="http://tpeweb04.china-airlines.com/cia/" data-ajax="false"></a></div>
		    <div class="div_bus"><a id="btn_bus" class="ui-btn" href="http://ch.e-go.com.tw/" data-ajax="false"></a></div>	
		  </div>			
		
		  <div class="div_communicate_mail">
		      <!-- <div class="div_communicate"><a id="btn_communicate" class="ui-btn" href="#"></a></div>
		      <div class="div_mail"><a id="btn_mail" class="ui-btn" href="#"></a></div> -->

		      <div class="div_communicate"><a id="btn_mail" class="ui-btn" href="#"></a></div>
		      <div class="div_mail"></div>
		  </div>
		</div>    
	  </div>
	 
	  <div id="navbar" data-role="panel" data-position="right" data-position-fixed="false" data-display="overlay" data-theme="b">
        <ul id="right-list" data-role="listview" data-inset="true" data-icon="false">
        </ul>	    
	  </div> 	  
	  
	</div>	
<!-- MainPage End -->

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