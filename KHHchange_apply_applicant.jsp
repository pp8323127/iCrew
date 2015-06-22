<%@page import="credit.CreditObj"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="swap3ackhh.CrewSkjObj"%>
<%@page import="swap3ackhh.CrewInfoObj"%>
<%@page import="java.sql.SQLException"%>
<%@page import="credit.SkjPickObj"%>
<%@page import="credit.SkjPickList"%>
<%@page import="java.util.ArrayList"%>
<%@page import="fzAuthP.FZCrewObj"%>
<%@page import="ws.crew.*"%>
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
	String rCname = "";
	String rSern = "";
	String yymm = request.getParameter("myDate");
	//out.println(rEmpno+yymm);
	String year = "";
	String month = "";
	String str = "";
	int totalTimes = 4;
	boolean flag = false;

				
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
            
          //submit
            $("#sub").click(function(e){
              	var yymm = $("#myDate").val();
              	var aEmpno =  $("#aEmpno").val();
              	var ck = GetCheckedValue("ack");
              	var ck1 = GetCheckedValue("apoint");
              	/*console.log(yymm);
              	console.log(aEmpno);
              	console.log(ck);
              	console.log(ck1);
				console.log("" != yymm &&  "" != aEmpno );
				console.log(""==ck); 
				console.log(""==ck1);				
				console.log(""!=ck1);
				console.log(""!=ck);*/				
              	if(!(yymm === undefined) && !(aEmpno === undefined) && "" != yymm &&  "" != aEmpno 
              			&& ((""==ck && ck1>1 && ",".indexOf(ck1)) == -1 || (""==ck1 && ck == 1)) ){
      	            	$("#swap2").attr("action", "KHHchange_apply_substitle.jsp");
      					$("#swap2").submit();	
              	}else{
              		$("#strMsg").html("請勾1個選換班機會or1個積點換班");
    				$("#alert-popup-apply").popup("open");
              	}
              });
            //confirm
			$("#popConf").click(function(e){
				$("#alert-popup-apply").popup("close");	         	
            });
			//back
			$("#naviBar_icon_Back").click(function(e){
            	var yymm = $("#myDate").val();
            	var rEmpno = $("#radiorEmpno").val();
            	if("" != yymm && ""!=rEmpno ){
	            	$("#swap2").attr("action", "change_apply.jsp");
					$("#swap2").submit();
            	}else{
            		//console.log(rEmpno+yymm);
            	}
        	});
        });
        
        function GetCheckedValue(checkBoxName){                	
        	return $('input:checkbox:checked[name=' + checkBoxName + ']').map(function ()
        	{
        		return $(this).val();
        	}).get().join(',');
        };
        function PopFunction(sno,reason){
        	$("#info1").html(sno);
        	$("#info2").html(reason);
    	};
    </script>

</head>
<body>

<div id="change_apply_applicant" data-role="page">
<!-- Header bar Start -->
	<div data-role="header" data-position="fixed">
		<table id="header-bar">
			<tr>
				<td id="header-bar-btnBak">
					<a href="#"><div id="naviBar_icon_Back"></div></a>
				</td>
				<td id="header-bar-btnAppname">換班申請-申請者</td>
				<td id="header-bar-btnMenu">
					<a id="btn_menu" href="#navbar"><div id="navi_icon_menu"></div></a>
				</td>
			</tr>
		</table>
	</div>
<!-- Header bar End -->

<!-- 換班申請-申請者 Start-->
	<div role="main" class="ui-content">
		<form id="swap2" method="POST" action="" data-ajax="false">
<%
	if(null!=yymm && !"".equals(yymm)){
		String date[] = yymm.split("/");
		year = date[0];
		month = date[1];
		if(month.length()<=1){
			month = "0"+month;
		}
		CrewSwapFunALL csf = new CrewSwapFunALL();
		//同base才可以互換
		StatusObj baseObj = csf.ChkCrewBase(aEmpno, rEmpno);
		if(null!= baseObj && baseObj.getStatus() == 0){%>		
			<div id="div_change_apply_title">
			<p><%=baseObj.getErrMsg()%></p>
			</div>		
		<%
		}else if( null!= baseObj && baseObj.getStatus() == 2){//KHH
			//上班日確認
	        str = csf.ChkSwapWorkday(baseObj.getErrMsg(),year,month);
	        if("Y".equals(str)){  
	        	//雙方換班資格
		    	str = csf.ChkSwapInfoKHH(aEmpno,rEmpno,year,month);
		    	if("Y".equals(str)){
	    %>
		<div id="div_change_apply_title">
			<p><%=uObj.getCname() %></p>
			<p><%=uObj.getEmpno() %></p>
			<p>(<%=uObj.getSern() %>)</p>
		</div>
		<input type="hidden" id="myDate" name="myDate" value="<%=yymm%>">
		<input type="hidden" name="rEmpno" id="rEmpno" value="<%=rEmpno%>">
		<input type="hidden" name="radiorEmpno" id="radiorEmpno" value="<%=rEmpno%>">
		<input type="hidden" name="rCame" id="rCame" value="<%=rCname%>">
		<input type="hidden" name="rSern" id="rSern" value="<%=rSern%>">
		<input type="hidden" name="aEmpno" id="aEmpno" value="<%=uObj.getEmpno()%>">
		<input type="hidden" name="aTimes" id="aTimes" value="<%=csf.getaTimes()%>">
		<input type="hidden" name="rTimes" id="rTimes" value="<%=csf.getrTimes()%>">
		<!-- 申請單 -->
		<div data-role="collapsible" data-iconpos="right" data-collapsed-icon="list_btn_arrow_right_gray" data-expanded-icon="list_btn_arrow_down_gray" class="apply_col ui-nodisc-icon">
    		<h3>四次換班權利</h3>
			<table id="choose-serv-t" style="margin-bottom: 15px;">
		<%		//是否A全勤
				str = csf.FullAttforA(aEmpno, year, month, csf.getaTimes());
				if("Y".equals(str) && csf.getaTimes() < totalTimes) {		
					flag = true;
					for(int i=csf.getaTimes();i<totalTimes;i++){ 
		%>
				<tr>
					<td><input type="checkbox" name="ack" id="ack<%=i %>" value="1"></td>
					<td><%=year%>年<%=month%>月-<%=(i+1)%></td>
					<td></td>
				</tr>	
		<%			} 
				}else{
		%>
				<tr><td><%=str%></td></tr>	
		<%	
				}
		%>			
			</table>
		</div>		
		<!-- 積點 -->
		<div data-role="collapsible" data-iconpos="right" data-collapsed-icon="list_btn_arrow_right_gray" data-expanded-icon="list_btn_arrow_down_gray" class="apply_col ui-nodisc-icon">
			<h3>積點換班權利</h3>
			<table id="choose-serv-t">
		<% //是否A有積點
				str = csf.CreditAvlforA(aEmpno, year, month);
				if("Y".equals(str) && null != csf.getObjAL() &&  csf.getObjAL().size() > 0){		
					flag = true;
					ArrayList objAL = csf.getObjAL();
					for(int i=0;i<objAL.size();i++){
						CreditObj obj =  (CreditObj) objAL.get(i);
						if(!"其它選班單".equals(obj.getReason())){
		%>
				<tr>
					<td><input type="checkbox" name="apoint" id="apck<%=i %>" value="<%=obj.getSno()%>"></td>
					<td><%=obj.getReason()%></td>
					<td><%=obj.getSno() %></td>
					<td><a href="#alert-popup-info" data-rel="popup" data-transition="pop" onClick="PopFunction('<%=obj.getSno()%>','<%=obj.getReason()%>');"><div id="list_icon_info_gray_20px"></div></a></td>
				</tr>
					
		<%			
						}
					} 
				}else{
		%>
				<tr><td><%=str%></td></tr>	
		<%	
				}
		%>	
			</table>
		</div>
		<%			if(flag){ %>
		<div id="btnApply" class="change_btnApply">
			<a id="sub" href="#" class="ui-btn ui-corner-all" data-ajax="false"><div>下一步</div></a>
		</div>
		<%			}
				}//if("Y".equals(str)) 雙方換班資格  
				else{
					%>
			        <div id="div_change_apply_substitle_noauthority">
			        	<p><%=str%></p>
			        </div>
			        <div id="btnApply" class="change_btnApply2">
						<a href="change_apply.jsp?myDate=<%=yymm%>" class="ui-btn ui-corner-all" data-ajax="false"><div>重新選擇</div></a>
					</div>
			        <% 						
				}
				%>
			<%}//if("Y".equals(str)) 上班日確認
			else{
		        %>
		        <div id="div_change_apply_substitle_noauthority">
		        	<p><%=str%></p>
		        </div>
		        <div id="btnApply" class="change_btnApply2">
						<a href="change_apply.jsp?myDate=<%=yymm%>"class="ui-btn ui-corner-all" data-ajax="false"><div>重新選擇</div></a>
				</div>
		        <% 	
	        }
			%>
		<%}//if(baseObj.getStatus() == 0) 同base才可以互換
		else{
	        //導TPEpage
			//out.println("TPE");
			response.sendRedirect("change_apply_applicant.jsp?myDate="+yymm+"&radiorEmpno="+rEmpno);	       
		}
		%>
		</form>

	</div>

	<!-- 定義popup顯示位置 -->
	<div id="popupSite"></div>
<!-- 換班申請-申請者 End-->

<!-- popup container start -->
<div data-role="popup" id="alert-popup-info" class="ui-content popupDiv" data-overlay-theme="b" data-dismissible="false" data-position-to="#popupSite" data-shadow="true" data-corners="true">
    <div data-role="header" class="popup-header">
       <p id="info1"></p>
    </div>
	<hr style="margin-top: 17px;">
    <div data-role="content" class="popup-content">
        <p id="info2"></p>
        <a class="ui-btn btnPopOK" data-rel="back"><div>確 認</div></a>
    </div>
</div>

<div data-role="popup" id="alert-popup-apply" class="ui-content popupDiv" data-overlay-theme="b" data-dismissible="false" data-position-to="window" data-shadow="true" data-corners="true">
    <div data-role="header" class="popup-header">
       <p>提示:</p>
    </div>
    <div data-role="content" class="popup-content">
        <p id="strMsg"></p>
        <a id="popConf" class="ui-btn btnPopOK" href="#" data-ajax="false"><div>確 認</div></a><!--  -->
    </div>
</div>
<!-- popup container end -->

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
	}//	if(null!=yymm && !"".equals(yymm))
}
}catch(ClassCastException e){
	out.println("請登入");
	response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println(e.toString());
}
%>