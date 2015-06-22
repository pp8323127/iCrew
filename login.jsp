<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,fzAuthP.*" %>

<% 
    
	session.removeAttribute("loginAppBobj");
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
<link rel="stylesheet" href="jQueryMob/login-style.css" />	
<script src="jQueryMob/jquery.js" language="javascript"></script>

<script type="text/javascript">
$( document ).bind( 'mobileinit', function(){
	$.mobile.loader.prototype.options.text = "Loading";
	$.mobile.loader.prototype.options.textVisible = false;
	$.mobile.loader.prototype.options.theme = "#";
	$.mobile.loader.prototype.options.html = "<div> </div>";
});
</script>
	
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
	
	.ui-input-text
	{
	    width: 260px !important;
	    height: 38px !important;
	    margin-right: auto;
	    margin-left: auto;
	}
	
	form .placeholder {
		font-family: 'Microsoft JhengHei', helvetica;
		font-size: 15px;
		color: #707070;
	}
	
	div::-webkit-scrollbar { 
	    display: none;
    }
    
    .ui-field-contain {
    	width: 100%;
	    padding: 0;
    }		
		
</style>
	
<script type="text/javascript">
$(document).ready(function () {

    $('body').append("<div class='ui-loader-background'><div class='custom-spinner'></div></div>");
	
	$("#sub").click(function(e){
		var userid = $("#txt_userid").val();
		var pwd = $("#txt_password").val();
		$.ajax({
		    /*beforeSend: function() { showLoader(); },
			complete: function(){ hideLoader(); },*/
			type: "POST",
			url: "checkUser.jsp",
			data: {UserID:userid, Password:pwd},
			success:function(data){
				//alert(data);
				if(data.indexOf("請登入") > -1){
					window.location.href = "login.jsp"
				}else if ($.trim(data) == "true"){
					//alert("true");
					$("#loginForm").attr("action", "MainPage.jsp");
					$("#loginForm").submit();
					
				}else{
					//alert("false");
					$("#myPopupDialog").popup("open");
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

$(document).on({
	ajaxSend: function () { $.mobile.loading('show'); },
	ajaxStart: function () { $.mobile.loading('show'); },
	ajaxStop: function () { $.mobile.loading('hide'); },
	ajaxError: function () { $.mobile.loading('hide'); }
});

/*function showLoader() {
    window.setTimeout(function(){
        $.mobile.loading('show');
    }, 1);
};
 
function hideLoader() {
    window.setTimeout(function(){
        $.mobile.loading('hide');
    }, 100000);
};*/

// $(document).ready(init);
// function init(){
// 	console.log("0");
//  	$("#sub").click(clickFun);
// }		
// function clickFun() {
// 		$.ajax({
// 			type : "POST",
// 			url : "swap1.jsp",
// 			data :{Name:loginForm.Name.value, Pwd:loginForm.Pwd.value},
// 			//contentType: "text/html",
// 			//dataType: "text/html",
// 			async: true,
// 			success: function (data) {
// 				//console.log(data); 
// 				//$("#errorMsg").html(data);
// 				alert(data);
// 			},
// 			error:function(xhr, ajaxOptions, thrownError){ 
// 				console.log(xhr.status); 
// 				console.log(thrownError); 
// 				alert("Error");
// 			}
// 		})
// }

</script>

</head>
<body>

<!--login page-->
	<div id="loginPage" data-role="page" data-theme="a">
	  <div data-role="header" data-position="fixed" class="header-bd" style="min-height: 44px;">
		<div class="logo-img"></div>
	  </div>
	  <div role="main" class="ui-content">
	 
	   <div class="iCrew-logo"></div>
	   
	   <form id="loginForm" method="POST" action="" data-ajax="false">
			 <div id="div_uid" class="uid">
				 <input type="text" id="txt_userid" placeholder="帳號">
			 </div>
			 <div id="div_pwd" class="pwd">
				 <input type="password" id="txt_password" data-mini="false" placeholder="密碼" >
			 </div>
			 <div id="div_btn_login" class="login-btn">
			     <button id="sub" class="ui-btn ui-corner-all" >登 入</button>
			 </div>
	    </form>
	    
	   <div data-role="popup" id="myPopupDialog" data-overlay-theme="b" data-dismissible="false">
	
	     <div data-role="main" class="ui-content" align="center">
	       <div class="ui-field-contain">
	         <div class="alert-title">登入錯誤</div>
	         <div class="alert-content">員工號或密碼不正確</div>
	       </div>
	       <div class="alert-btn">
	         <a href="#" id="btn_confirm" class="ui-btn" data-rel="back">確 認</a>
	       </div>
	     </div>
	     
	   </div>
	   	    
	  </div>
	  
	</div>

</body>
</html>