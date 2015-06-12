<%@page import="java.net.URLDecoder"%>
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
}else{  
	FZCrewObj uObj = lObj.getFzCrewObj();
	String aEmpno = uObj.getEmpno();
	String rEmpno = request.getParameter("rEmpno");
	String[] aChoSwapSkj = request.getParameterValues("chkA");
	String[] rChoSwapSkj = request.getParameterValues("chkR");
	String yymm = request.getParameter("myDate");
	String comment = request.getParameter("comment");
	String comment2 = request.getParameter("comment2");
	//out.println(comment);
	comment =  URLDecoder.decode(comment, "UTF-8") + URLDecoder.decode(comment2, "UTF-8");
	String apoint = request.getParameter("apoint");
	String rpoint = request.getParameter("r_point");
	String ack =  request.getParameter("ack");
	String rck =  request.getParameter("r_ck");
	String aTimes =  request.getParameter("aTimes");
	String rTimes =  request.getParameter("rTimes");
	String year = "";
	String month = "";
	String str = "";
	int totalTimes = 4;
	boolean flag = false;
	SendCrewSwapFormObj sendObj = new SendCrewSwapFormObj();
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
            
          //submit
            $("#sub").click(function(e){
              	var yymm = $("#myDate").val();
              	var aEmpno =  $("#aEmpno").val();
 				var rEmpno =  $("#rEmpno").val();
 				var ack =  $("#ack").val();
 				var apoint =  $("#apoint").val();
 				var rck =  $("#r_ck").val();
 				var rpoint =  $("#r_point").val();
 				console.log(ack);
 				console.log(apoint);
 				console.log(rck);
 				console.log(rpoint);
 				var type = 0;
              	if(!(yymm === undefined) && !(aEmpno === undefined) && !(rEmpno === undefined) && "" != yymm &&  "" != aEmpno&&  "" != rEmpno){
              		if(""!=ack && ""!=rck){
              			//TPE all 申請單
              			type = 1;
              		}else if(""!=apoint && ""!=rpoint){
              			// TPE aCrew&rCrew 皆用積點   
              			type = 3;
              		}else if(""!=apoint && ""!=rck){
              			//TPE aCrew用積點 & rCrew三次
              			type = 4;
              		}else{
              			type = 0;        			
              		}
              		if(type != 0){
              			$.ajax({
                            type: "POST",
                            url: "send_apply.jsp",
                    		data: {myDate:yymm,aEmpno:aEmpno,rEmpno:rEmpno,ack:ack,apoint:apoint,r_ck:rck,r_point:rpoint,type:type},
                            success:function(data){
                            	$("#strMsg").html(data);
                            	$("#backData").val(data);	
                				$("#alert-popup-apply").popup("open");                             
                            },
                            error:function(xhr, ajaxOptions, thrownError){
                                console.log(xhr.status);
                                console.log(thrownError);
                                $("#strMsg").html("Error");
                            	$("#backData").val("Error");	
                				$("#alert-popup-apply").popup("open"); 
                            }
                        });
                        e.preventDefault();
              		}else{
              			$("#strMsg").html("選班機會/積點選班資格錯誤");
        				$("#alert-popup-apply").popup("open");   
              		}              		 
              	}else{
              		$("#strMsg").html("請勾班次");
    				$("#alert-popup-apply").popup("open");
              	}
              });
            //confirm
			$("#popConf").click(function(e){
				var msg = $("#backData").val();
				//console.log(msg);
				//console.log(msg.indexOf("Successful"));
				//console.log(msg.match("Successful"));
				if(msg.indexOf("Successful") > -1){
					$("#popConf").attr("href","change_main.jsp");
				}else{
					$("#alert-popup-apply").popup("close");	
				}
				//$("#alert-popup-apply").popup("close");	         	
            });
			//back
			$("#naviBar_icon_Back").click(function(e){
            	var yymm = $("#myDate").val();
            	var rEmpno = $("#rEmpno").val();
            	if("" != yymm && ""!=rEmpno ){
	            	$("#swapSendform").attr("action", "change_apply_list.jsp");
					$("#swapSendform").submit();
            	}else{
            		//console.log(rEmpno+yymm);
            	}
        	});
			//back
			$("#cancel").click(function(e){
            	var yymm = $("#myDate").val();
            	var rEmpno = $("#rEmpno").val();
            	if("" != yymm && ""!=rEmpno ){
	            	$("#swapSendform").attr("action", "change_apply_list.jsp");
					$("#swapSendform").submit();
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
				<td id="header-bar-btnAppname">確認換班申請</td>
				<td id="header-bar-btnMenu">
					<a id="btn_menu" href="#navbar"><div id="navi_icon_menu"></div></a>
				</td>
			</tr>
		</table>
	</div>
<!-- Header bar End -->

<!-- 確認換班申請 Start-->
<div role="main" class="ui-content">
	<form id="swapSendform" method="POST" action="" data-ajax="false">
		<div data-role="navbar">
		<input type="hidden" id="rEmpno" name="rEmpno" value="<%=rEmpno%>">
		<!-- <input type="hidden" id="radiorEmpno" name="radiorEmpno" value="<%=rEmpno%>"> -->
		<input type="hidden" id="myDate" name="myDate" value="<%=yymm%>">
		<input type="hidden" name="rEmpno" id="rEmpno" value="<%=rEmpno%>">
		<input type="hidden" name="aEmpno" id="aEmpno" value="<%=uObj.getEmpno()%>">
		<input type="hidden" name="aTimes" id="aTimes" value="<%=aTimes%>">
		<input type="hidden" name="rTimes" id="rTimes" value="<%=rTimes%>">
		<input type="hidden" name="ack" id="ack" value="<%=ack%>">
		<input type="hidden" name="apoint" id="apoint" value="<%=apoint%>">
		<input type="hidden" name="r_ck" id="r_ck" value="<%=rck%>">
		<input type="hidden" name="r_point" id="r_point" value="<%=rpoint%>">
		<input type="hidden" name="type" id="type" >
		<%
		if(null!=yymm && !"".equals(yymm)){
			String date[] = yymm.split("/");
			year = date[0];
			month = date[1];
			if(month.length()<=1){
				month = "0"+month;
			}
			if("TPE".equals(uObj.getBase())){
				CrewSwapFunALL csf = new CrewSwapFunALL();
				
				csf.SwapDetail(aEmpno,uObj.getBase(), rEmpno, year, month, aChoSwapSkj, rChoSwapSkj);
				CrewSwapDetailRObj rObjAL = csf.getCrewSpDetailObjAL();
				
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
						<li>ResultMSG:<%=rObjAL.getErrorMsg() %></li>
					</ul>
					<%
				}else{
					if(null!=rObjAL){
						
						aCrewInfoObj= rObjAL.getaCrewInfoObj();
						//out.println(aCrewInfoObj);
						rCrewInfoObj= rObjAL.getrCrewInfoObj();
						//out.println(rCrewInfoObj);
						aSwapSkjAL = rObjAL.getaCrewSkjAL();
						//out.println(aSwapSkjAL.size());
						rSwapSkjAL = rObjAL.getrCrewSkjAL();
						//out.println(rSwapSkjAL.size());
		
		%>
			<ul id="result_title">
				<li>Applicant</li>
				<li>Substituent</li>
			</ul>
			
			<%if(null!=aCrewInfoObj  && null!=rCrewInfoObj){  
				sendObj.setMonth(month);
				sendObj.setYear(year);
				sendObj.setaApplyTimes((Integer.parseInt(aTimes)+1+""));
				sendObj.setaEmpno(aCrewInfoObj.getEmpno());
				sendObj.setaCname(aCrewInfoObj.getCname());
				sendObj.setaSern(aCrewInfoObj.getSern());
				sendObj.setaGrps(aCrewInfoObj.getGrps());
				sendObj.setaQual(aCrewInfoObj.getOccu());
				
				sendObj.setrApplyTimes((Integer.parseInt(rTimes)+1+""));
				sendObj.setrEmpno(rCrewInfoObj.getEmpno());
				sendObj.setrCname(rCrewInfoObj.getCname());
				sendObj.setrSern(rCrewInfoObj.getSern());				
				sendObj.setrGrps(rCrewInfoObj.getGrps());
				sendObj.setrQual(rCrewInfoObj.getOccu());
			
			
			%>
			<ul class="result_content">
				<li>
					<div>	<!--申請者第1欄-->
						<p style="font-size: 18px; font-weight: bold;"><%=aCrewInfoObj.getCname() %></p>
						<p style="font-size: 11px;">(FA)</p>
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
							<p><%=(Integer.parseInt(aTimes)+1+"") %></p>
							<br>
							<p>Qualification :</p>
							<p><%=aCrewInfoObj.getOccu() %></p>
						</span>
					</div>
				</li>
				<li>
					<div>	<!--被換者第1欄-->
						<p style="font-size: 18px; font-weight: bold;"><%=rCrewInfoObj.getCname() %></p>
						<p style="font-size: 11px;">(FA)</p>
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
							<p><%=(Integer.parseInt(rTimes)+1+"")%></p>
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
						String[] aTripno = new String[aSwapSkjAL.size()];
						String[] aFdate = new String[aSwapSkjAL.size()];
						String[] aFltno = new String[aSwapSkjAL.size()];
						String[] aFlyHrs = new String[aSwapSkjAL.size()];
						for(int i=0;i<aSwapSkjAL.size();i++){ 
							CrewSkjObj obj = (CrewSkjObj) aSwapSkjAL.get(i);
							aTripno[i] = obj.getTripno();
							aFdate[i] = obj.getFdate();
							aFltno[i] = obj.getDutycode();
							aFlyHrs[i] = obj.getCr() ;
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
						sendObj.setaTripno(aTripno);						
						sendObj.setaFdate(aFdate);					
						sendObj.setaFltno(aFltno);						
						sendObj.setaFlyHrs(aFlyHrs);
						
					}%>
				</li>
				<li>
					<%if(null!=rSwapSkjAL){
						String[] rTripno = new String[rSwapSkjAL.size()];
						String[] rFdate = new String[rSwapSkjAL.size()];
						String[] rFltno = new String[rSwapSkjAL.size()];
						String[] rFlyHrs = new String[rSwapSkjAL.size()];
						for(int i=0;i<rSwapSkjAL.size();i++){ 
							CrewSkjObj obj = (CrewSkjObj) rSwapSkjAL.get(i);
							rTripno[i] = obj.getTripno();
							rFdate[i] = obj.getFdate();
							rFltno[i] = obj.getDutycode();
							rFlyHrs[i] = obj.getCr() ;
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
						sendObj.setrTripno(rTripno);
						sendObj.setrFdate(rFdate);
						sendObj.setrFltno(rFltno);
						sendObj.setrFlyHrs(rFlyHrs);
					}%>
				</li>
			</ul>
			<ul class="result_content">
				<li>
						<%
						
						sendObj.setaSwapHr(rObjAL.getaSwapTotalCr());
						sendObj.setaSwapCr(rObjAL.getaCrAfterSwap());						
						sendObj.setaPrjcr(aCrewInfoObj.getPrjcr());						
						sendObj.setaSwapDiff(rObjAL.getaSwapDiffCr());	
						

						sendObj.setrSwapHr(rObjAL.getrSwapTotalCr());
						sendObj.setrSwapCr(rObjAL.getrCrAfterSwap());
						sendObj.setrPrjcr(rCrewInfoObj.getPrjcr());
						sendObj.setrSwapDiff(rObjAL.getrSwapDiffCr());
						sendObj.setComments(comment);
						%>
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
			<!-- <ul id="result_personinfo">
				<li><a href="personInfo.html" id="list_btn_profile" data-ajax="false"></a></li>
				<li><a href="personInfo.html" id="list_btn_profile" data-ajax="false"></a></li>
			</ul> -->
			<ul id="result_personinfo" style="border-top: none;">
				<li>
					<div>Comments: </div>
					<div><%=comment %></div>
				</li>
			</ul>
			<%
			}
		}
					session.setAttribute("sendSwapObj", sendObj);	
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
		<%
				}//if("0".equals(rObjAL.getResultMsg()))
			}else if("KHH".equals( uObj.getBase())){
				//導KHHpage
				//out.println("KHH");
				response.sendRedirect("KHHchange_apply_finalcheck.jsp");
			}
		}//month & year
		else{
		%><ul id="result_title"><li>缺少日期資訊,請重新選擇</li></ul>
		<%}%>
		<div id="btnOKCancel">
			<a id="cancel" href="#" class="ui-btn ui-corner-all"><div>取消</div></a>
			<a id="sub" href="#" class="ui-btn ui-corner-all" data-ajax="false"><div>確認</div></a>
		</div>
<%
	
	}
}catch(ClassCastException e){
	out.println("請登入");
	response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println("X"+e.toString());
}
%>
		</form>
	</div>
<!-- 確認換班申請 End-->


<!-- popup container start -->

<div data-role="popup" id="alert-popup-apply" class="ui-content popupDiv" data-overlay-theme="b" data-dismissible="false" data-position-to="window" data-shadow="true" data-corners="true">
    <div data-role="header" class="popup-header">
       <p>提出換班申請</p>
    </div>

    <div data-role="content" class="popup-content">
    	<input type="hidden" name="backData" id="backData">
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
