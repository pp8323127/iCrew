<%@page import="credit.CreditObj"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="swap3ac.CrewSkjObj"%>
<%@page import="swap3ac.CrewInfoObj"%>
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
	String yymm = request.getParameter("myDate");
	String apoint = request.getParameter("apoint");
	String ack =  request.getParameter("ack");
	String aTimes =  request.getParameter("aTimes");
	String rTimesStr =  request.getParameter("rTimes");
	int rTimes = 4;
	if(null != rTimesStr && !"".equals(rTimesStr)){
		rTimes = Integer.parseInt(rTimesStr);	
	}
	//out.println(rEmpno+yymm+apoint+ack+aTimes+rTimes);
	String year = "";
	String month = "";
	String str = "";
	int totalTimes = 4;
	boolean flagN = false;
	boolean flagC = false;

		
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
            
          //submit
            $("#sub").click(function(e){
              	var yymm = $("#myDate").val();
              	var rEmpno =  $("#rEmpno").val();
              	var ck = GetCheckedValue("r_ck");
              	var ck1 = GetCheckedValue("r_point");
              	console.log(ck);
              	console.log(ck1);
              	/*console.log(yymm);
              	console.log(aEmpno);
              	
				console.log("" != yymm &&  "" != aEmpno );
				console.log(""==ck); 
				console.log(""==ck1);				
				console.log(""!=ck1);
				console.log(""!=ck);*/				
              	if(!(yymm === undefined) && !(rEmpno === undefined) && "" != yymm &&  "" != rEmpno 
				&& ((""==ck && ck1==1) || (""==ck1 && ck == 1)) ){
              			$("#strMsg").html("班表僅供參考，請向組員派遣部門確認正式班表任務。"+
            		          "<br><br>放棄特休假，請在Comments輸入申請者(A)或被換者(B)+日期，如 : "+
            		          "<br>A12/17表示申請者放棄12/17特休"+
            		          "<br>R12/25表示被換者放棄12/25特休"+
            		          "<br><br>跨月班次之飛時，僅計算至當月底"+
            		          "<br><br>顯示之休時僅供參考，正確休時請以派遣部回覆為準。");	
              			$("#status").val("1");
              			$("#alert-popup-apply").popup("open");
      	            	
              	}else{
              		$("#status").val("0");
              		$("#strMsg").html("請勾1個選換班機會or1個積點換班");
    				$("#alert-popup-apply").popup("open");
              	}
              });
            //confirm
			$("#popConf").click(function(e){
				var status = $("#status").val();
				if(status == 1){
					$("#swap3").attr("action", "KHHchange_apply_list.jsp");
  					$("#swap3").submit();	
				}else{
					$("#alert-popup-apply").popup("close");
				}
            });
            //back
			$("#naviBar_icon_Back").click(function(e){
            	var yymm = $("#myDate").val();
            	var rEmpno = $("#rEmpno").val();
            	if("" != yymm && ""!=rEmpno ){
	            	$("#swap3").attr("action", "KHHchange_apply_applicant.jsp");
					$("#swap3").submit();
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

<div id="change_apply_substitle" data-role="page">
<!-- Header bar Start -->
	<div data-role="header" data-position="fixed">
		<table id="header-bar">
			<tr>
				<td id="header-bar-btnBak">
					<a href="#"><div id="naviBar_icon_Back"></div></a>
				</td>
				<td id="header-bar-btnAppname">換班申請-被換者</td>
				<td id="header-bar-btnMenu">
					<a id="btn_menu" href="#navbar"><div id="navi_icon_menu"></div></a>
				</td>
			</tr>
		</table>
	</div>
<!-- Header bar End -->

<!-- 換班申請-被換者 Start-->
	<div role="main" class="ui-content">
		<form id="swap3" method="POST" action="" data-ajax="false">
		<%
		if(null!=yymm && !"".equals(yymm)){
			String date[] = yymm.split("/");
			year = date[0];
			month = date[1];
			if(month.length()<=1){
				month = "0"+month;
			}
			CrewSwapFunALL cst = new CrewSwapFunALL();
			cst.CreditAvlforR(rEmpno, year, month);
			CrewSwapCreditRObj rObjAL = cst.getCrewCtObjAL(); 
			fzac.CrewInfo c = new fzac.CrewInfo(rEmpno);
		%>
		<div id="div_change_apply_title">
		<%if(null!=c && null!=c.getCrewInfo()){ %>
			<p><%=c.getCrewInfo().getCname()%></p>
			<p><%=rEmpno%></p>
			<p>(<%=c.getCrewInfo().getSern()%>)</p>
		<%} %>
		</div>
		<input type="hidden" id="myDate" name="myDate" value="<%=yymm%>">
		<input type="hidden" name="rEmpno" id="rEmpno" value="<%=rEmpno%>">
		<input type="hidden" name="aEmpno" id="aEmpno" value="<%=uObj.getEmpno()%>">
		<input type="hidden" name="aTimes" id="aTimes" value="<%=aTimes%>">
		<input type="hidden" name="rTimes" id="rTimes" value="<%=rTimes%>">
		<input type="hidden" name="ack" id="ack" value="<%=ack%>">
		<input type="hidden" name="apoint" id="apoint" value="<%=apoint%>">
		<div data-role="collapsible" data-iconpos="right" data-collapsed-icon="list_btn_arrow_right_gray" data-expanded-icon="list_btn_arrow_down_gray" class="apply_col ui-nodisc-icon">
		<%if(null != rObjAL && rObjAL.getrEmpnoAvb() == 2 && rTimes < totalTimes && null!=ack &&  !"".equals(ack)) {//&& null!=apoint && !"".equals(apoint)
			//A用積點可與B申請單 or B積點換. 
			flagN =true;
		%>	<h3>四次換班權利</h3>
			<table class="choose-serv-t" style="margin-bottom: 15px;">
			<%for(int i=rTimes;i<totalTimes;i++){ %>			
				<tr>
					<td><input type="checkbox" name="r_ck" id="r_ck<%=i%>" value="1"></td>
					<td><%=year%>年<%=month%>月-<%=(i+1)%></td>
					<td></td>
				</tr>					
			<%}%>
			</table>
		<%}else if(null != rObjAL && null != cst.getObjAL() && cst.getObjAL().size()>0){
			ArrayList objAL = cst.getObjAL();
			flagC =true;
		%>		
			<h3>積點換班權利</h3>
			<table class="choose-serv-t">
				<%
				for(int i=0;i<objAL.size();i++){
					CreditObj obj =  (CreditObj) objAL.get(i);
					if(!"其它選班單".equals(obj.getReason())){
				%>
				<tr>
					<td><input type="checkbox" name="r_point" id="r_pck<%=i%>" value="<%=obj.getSno()%>"></td>
					<td><%=obj.getReason()%></td>
					<td><%=obj.getSno() %></td>
					<td><a href="#alert-popup-info" data-rel="popup" data-transition="pop" onClick="PopFunction('<%=obj.getSno()%>','<%=obj.getReason()%>');"><div class="list_icon_info_gray_20px"></div></a></td>
				</tr>
				<%
					}
				}
				%>
			</table>
		
		<%
		}else{
			if(!flagN && (null != cst.getObjAL() && cst.getObjAL().size()>0)){
		%>
			<h5>被換者:無申請單機會!</h5>
		<%
			}else{
		%>
			<h5>被換者:無申請單機會或無積點 </h5>
		<%		
			}
		}%>
		</div>
		<%if(flagN || flagC){ %>
		<div id="btnApply" class="change_btnApply">
		 	<a id="sub" href="#" data-rel="popup" data-transition="pop" class="ui-btn ui-corner-all"><div>申請換班</div></a>
			<!--  <a href="#alert-popup-apply" data-rel="popup" data-transition="pop" class="ui-btn ui-corner-all"><div>申請換班</div></a>-->
		</div>
		<%} 
	}//	if(null!=yymm && !"".equals(yymm))
}%>
		</form>		
	</div>

	<!-- 定義popup顯示位置 -->
	<div id="popupSite"></div>
<!-- 換班申請-被換者 End-->
<%				

}catch(ClassCastException e){
	out.println("請登入");
	response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println(e.toString());
}
%>
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
       <p>換班注意事項</p>
    </div>

    <div data-role="content" class="popup-content" id="change_apply_popup">
    	<input type="hidden" id="status" value=<%=0%>>	
        <p id="strMsg"></p>
        <a id="popConf" class="ui-btn btnPopOK" href="#" data-ajax="false"><div>確 認</div></a>
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
