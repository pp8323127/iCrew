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
	}else{  
	FZCrewObj uObj = lObj.getFzCrewObj();
	String aEmpno = uObj.getEmpno();
	String rEmpno = request.getParameter("rEmpno");
	String[] aChoSwapSkj = request.getParameterValues("chkA");
	String[] rChoSwapSkj = request.getParameterValues("chkR");
	String yymm = request.getParameter("myDate");
	String year = "";
	String month = "";
	
				
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
                        $("#right-list li").remove();
                        $("#right-list").append(data).listview("refresh");
                    },
                    error:function(xhr, ajaxOptions, thrownError){
                        console.log(xhr.status);
                        console.log(thrownError);
                        alert("Error");
                    }
                });
                e.preventDefault();
            });
            
            $("#sub").click(function(e){
            	var yymm = $("#myDate").val();
            	var rEmpno = $("#rEmpno").val();
            	//var aEmpnoArr = $('input:checkbox:checked[name="chkA"]').val();
            	//var rEmpnoArr = $('input:checkbox:checked[name="chkR"]').val();
            	//console.log(aEmpnoArr.length+rEmpnoArr.length);
            	if("" != yymm && "" != rEmpno ){
	            	$("#CrossToApplyform").attr("action", "change_apply.jsp");
					$("#CrossToApplyform").submit();
            	}else{
            		
            	}
            });
			
			 $("#naviBar_icon_Back").click(function(e){
            	var yymm = $("#myDate").val();
            	var rEmpno = $("#radiorEmpno").val();
            	if("" != yymm && ""!=rEmpno ){
	            	$("#CrossToApplyform").attr("action", "change_calc_table.jsp");
					$("#CrossToApplyform").submit();
					//console.log("yes:"+$("#myDate").val()+$("#rEmpno").val());
            	}else{
            		//console.log("error:"+$("#myDate").val()+$("#rEmpno").val());
            	}
        	});
			//confirm
			$("#popConf").click(function(e){
				$("#alert-popup-info").popup("close");	
	        });
			//info
			$("#infoA").click(function(e){
				var aEmpno = $("#aEmpno").val();
            	var rEmpno = $("#rEmpno").val();
            	var yymm = $("#myDate").val();   
        		$("#empno").val(aEmpno);
        		console.log($("#empno").val());
        		/*$("#CrossToApplyform").attr("action", "change_personInfo.jsp");
				$("#CrossToApplyform").submit();
            	*/
            	if("" != yymm && "" != aEmpno && null != aEmpno){
	            	
            		$.ajax({
	        			type: "POST",
	        			url: "change_personInfo.jsp",
	        			data: {empno:aEmpno,rEmpno:rEmpno,myDate:yymm},
	        			success:function(data){	       
	        				$("#strMsg").html(data);
	        				$("#backData").val(1);
		        			$("#alert-popup-info").popup("open");		        				
	        				console.log(data);
	        			},
	        			error:function(xhr, ajaxOptions, thrownError){
	        				console.log(xhr.status);
	        				console.log(thrownError);
	        				$("#strMsg").html("Error");
	        				$("#backData").val("");
	        				$("#alert-popup-info").popup("open");
	        			}
	        		});
	        		e.preventDefault();
            	}else{
            		console.log("空值");
            	}
        	});
			$("#infoR").click(function(e){
				var aEmpno = $("#aEmpno").val();
            	var rEmpno = $("#rEmpno").val();
            	var yymm = $("#myDate").val(); 
            	$("#empno").val(rEmpno);
        		//console.log($("#empno").val());
        		/*$("#CrossToApplyform").attr("action", "change_personInfo.jsp");
				$("#CrossToApplyform").submit();
				
				*/
            	if("" != yymm && "" != rEmpno && null != rEmpno){
            		$.ajax({
	        			type: "POST",
	        			url: "change_personInfo.jsp",
	        			data: {empno:rEmpno,rEmpno:rEmpno,myDate:yymm},
	        			success:function(data){	       
	        				$("#strMsg").html(data);
	        				$("#backData").val(1);
		        			$("#alert-popup-info").popup("open");		        				
	        				//console.log(data);
	        			},
	        			error:function(xhr, ajaxOptions, thrownError){
	        				console.log(xhr.status);
	        				console.log(thrownError);
	        				$("#strMsg").html("Error");
	        				$("#backData").val("");
	        				$("#alert-popup-info").popup("open");
	        			}
	        		});
	        		e.preventDefault();
            	}else{
            		console.log("空值");
            	}
        	});
        });
    </script>

</head>
<body>

<div id="change_calc_result" data-role="page">
<!-- Header bar Start -->

	<div data-role="header" data-position="fixed">
		<table id="header-bar">
			<tr>
				<td id="header-bar-btnBak">
					<a href="#"><div id="naviBar_icon_Back"></div></a>
				</td>
				<td id="header-bar-btnAppname">換班飛時試算</td>
				<td id="header-bar-btnMenu">
					<a id="btn_menu" href="#navbar"><div id="navi_icon_menu"></div></a>
				</td>
			</tr>
		</table>
	</div>
<!-- Header bar End -->

<!-- 換班飛時試算結果 Start-->
	<form id="CrossToApplyform" method="POST" action="" data-ajax="false">
	<div role="main" class="ui-content">
		<div data-role="navbar">
		<input type="hidden" id="aEmpno" name="aEmpno" value="<%=aEmpno%>">
		<input type="hidden" id="rEmpno" name="rEmpno" value="<%=rEmpno%>">
		<input type="hidden" id="radiorEmpno" name="radiorEmpno" value="<%=rEmpno%>">
		<input type="hidden" id="myDate" name="myDate"  value="<%=yymm%>">
		<input type="hidden" id="empno" name="empno" value="">
		<%
		if(null!=yymm && !"".equals(yymm)){
			String date[] = yymm.split("/");
			year = date[0];
			month = date[1];
			if(month.length()<=1){
				month = "0"+month;
			}	
			//out.println(aChoSwapSkj.length +",r:"+ rChoSwapSkj.length);
			if("TPE".equals(uObj.getBase())){
				CrewSwapFunALL csf = new CrewSwapFunALL();
				csf.CorssCrDetail(aEmpno,uObj.getBase(), rEmpno, year, month, aChoSwapSkj, rChoSwapSkj);
				CrewCorssDetailRObj rObjAL = csf.getCrewCrossDetailObjAL();
				CrewInfoObj aCrewInfoObj = null;
				CrewInfoObj rCrewInfoObj = null;
				ArrayList aSwapSkjAL = null;
				ArrayList rSwapSkjAL = null;
				int aALtimes = 0;
				int rALtimes = 0;
				DecimalFormat df = new DecimalFormat("0000");
		if("0".equals(rObjAL.getResultMsg())){
			%>
			<ul id="result_title">
				<li><%=rObjAL.getErrorMsg() %></li>
			</ul>
			<%
		}else{
			if(null!=rObjAL){
				aCrewInfoObj= rObjAL.getaCrewInfoObj();
				rCrewInfoObj= rObjAL.getrCrewInfoObj();
				
				aSwapSkjAL = rObjAL.getaCrewSkjAL();
				rSwapSkjAL = rObjAL.getrCrewSkjAL();	
				//取得被查詢者已換次數
				swap3ac.ApplyCheck ac = new swap3ac.ApplyCheck(aEmpno,rEmpno,year,month);
		
		%>
		
			<ul id="result_title">
				<li>Applicant</li>
				<li>Substituent</li>				
			</ul>

			<%if(null!=aCrewInfoObj  && null!=rCrewInfoObj){  %>
			<ul class="result_content">
				<li>
					<div>	<!--申請者第1欄-->
						<p style="font-size: 18px; font-weight: bold;"><%=aCrewInfoObj.getCname() %></p>
						<!--<p style="font-size: 11px;">(FA)</p> -->
						<br>
						<span class="span_font11px">
							<p><%=aCrewInfoObj.getEmpno() %></p>
							<p><%=aCrewInfoObj.getSern() %></p>
							<br>
							<p>Section</p>
							<p><%=aCrewInfoObj.getGrps() %></p>
						</span>
						<span class="span_Exchange_Qualification">
							<p>Exchange Count :</p>
							<p><%=ac.getAApplyTimes() %></p>
							<br>
							<p>Qualification :</p>
							<p><%=aCrewInfoObj.getOccu() %></p>
						</span>
					</div>
				</li>
				<li>
					<div>	<!--被換者第1欄-->
						<p style="font-size: 18px; font-weight: bold;"><%=rCrewInfoObj.getCname() %></p>
						<!-- <p style="font-size: 11px;">(FA)</p> -->
						<br>
						<span class="span_font11px">
							<p><%=rCrewInfoObj.getEmpno() %></p>
							<p><%=rCrewInfoObj.getSern() %></p>
							<br>
							<p>Section</p>
							<p><%=rCrewInfoObj.getGrps() %></p>
						</span>
						<span class="span_Exchange_Qualification">
							<p>Exchange Count :</p>
							<p><%=ac.getRApplyTimes() %></p>
							<br>
							<p>Qualification :</p>
							<p><%=rCrewInfoObj.getOccu() %></p>
						</span>
					</div>
				</li>
			</ul>
	
			<ul class="result_content">
				<li>
					<%
					if(null!=aSwapSkjAL){
						for(int i=0;i<aSwapSkjAL.size();i++){ 
							CrewSkjObj obj = (CrewSkjObj) aSwapSkjAL.get(i);
					%>
					<div>	<!--申請者第2欄-->
						<p style="font-size: 11px;">Trip No.</p>
						<p style="font-size: 18px;"><%=obj.getTripno() %></p>
						<br>
						<p style="font-size: 18px; font-weight: bold; color: #c22727;"><%=obj.getFdate() %></p>
						<br>
						<p style="font-size: 20px; font-weight: bold;"><%=obj.getDutycode() %></p>
						<br>
						<span class="span_Flying">
							<p>Flying Time :</p>
							<%if("AL".equals(obj.getDutycode()))	
							{
								aALtimes++;  
							%>
								<p>0000</p>
							<%}else{ %>
								<p><%=obj.getCr() %></p>
							<%} %>
							
						</span>
					</div>
					<%}
					}%>
				</li>
				<li>
					<%if(null!=rSwapSkjAL){
						for(int i=0;i<rSwapSkjAL.size();i++){ 
							CrewSkjObj obj = (CrewSkjObj) rSwapSkjAL.get(i);
					%>
					<div>	<!--被換者第2欄-->
						<p style="font-size: 11px;">Trip No.</p>
						<p style="font-size: 18px;"><%=obj.getTripno() %></p>
						<br>
						<p style="font-size: 18px; font-weight: bold; color: #c22727;"><%=obj.getFdate() %></p>
						<br>
						<p style="font-size: 20px; font-weight: bold;"><%=obj.getDutycode() %></p>
						<br>
						<span class="span_Flying">
							<p>Flying Time :</p>
							<%if("AL".equals(obj.getDutycode()))	
							{
								rALtimes++;  
							%>
								<p>0000</p>
							<%}else{ %>
								<p><%=obj.getCr() %></p>
							<%} %>
						</span>
					</div>
					<%
						} 
					}%>
				</li>
			</ul>
			<ul class="result_content">
				<li>
					<div class="noborder">	<!--申請者第3欄-->
						<p>互換班飛時 :</p>
						<p class="pbold"><%=rObjAL.getaSwapTotalCr() %></p>
						<br>
						<p>飛時差額 :</p>
						<p class="pbold"><%=rObjAL.getaSwapDiffCr() %></p>
						<br>
						<p>換班前時數 :</p>
						<p class="pbold"><%=aCrewInfoObj.getPrjcr() %></p>
						<br>
						<p>放棄AL時數 :</p>
						<p class="pbold"><%=df.format(200 * aALtimes) %></p>
						<br>
						<p>換班後時數 :</p>
						<p class="pbold"><%=rObjAL.getaCrAfterSwap() %></p>
					</div>
				</li>
				<li>
					<div class="noborder">	<!--被換者第3欄-->
						<p>互換班飛時 :</p>
						<p class="pbold"><%=rObjAL.getrSwapTotalCr() %></p>
						<br>
						<p>飛時差額 :</p>
						<p class="pbold"><%=rObjAL.getrSwapDiffCr() %></p>
						<br>
						<p>換班前時數 :</p>
						<p class="pbold"><%=rCrewInfoObj.getPrjcr() %></p>
						<br>
						<p>放棄AL時數 :</p>
						<p class="pbold"><%=df.format(200 * rALtimes) %></p>
						<br>
						<p>換班後時數 :</p>
						<p class="pbold"><%=rObjAL.getrCrAfterSwap() %></p>
					</div>
				</li>
			</ul>
			<ul id="result_personinfo">
				<li><a href="#" class="list_btn_profile" data-ajax="false" id="infoA"></a></li>
				<li><a href="#" class="list_btn_profile" data-ajax="false" id="infoR"></a></li>
			</ul>
		<%
			}
		}
		%>	
		</div>
		<div id="result_info">
			<div id="list_icon_info_20px"></div>
			<span id="div_result_infoMsg">
				<p>換班者互換班飛時=A</p>
				<p>被換者互換班飛時=B</p>
				<p>飛時差額=A-B=X</p>
				<p>換班後時數=換班前時數±X+AL</p>
			</span>
		</div>

		<div id="btnApply" class="result_btnApply">
			<a id="sub" href="#" class="ui-btn ui-corner-all" data-ajax="false"><div>換班申請</div></a>
		</div>
	
	</div>
<%			
			}//if("0".equals(rObjAL.getResultMsg()))
		}else if("KHH".equals( uObj.getBase())){
			//導KHHpage
			//out.println("KHH");
			response.sendRedirect("KHHchange_calc_result.jsp");
		}
	}//month & year
}
}catch(ClassCastException e){
	out.println("請登入");
	response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println(e.toString());
}
%>
</form>
<!-- 換班飛時試算結果 End-->

<!-- popup container start -->
<div data-role="popup" id="alert-popup-info" class="ui-content popupDiv" data-overlay-theme="b" data-dismissible="false" data-position-to="#popupSite" data-shadow="true" data-corners="true">
    
	<input type="hidden" id="backData" >	
    <p id="strMsg"></p>
       <a id="popConf" class="ui-btn btnPopOK" href="#" data-ajax="false"><div>確 認</div></a><!--  -->

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
