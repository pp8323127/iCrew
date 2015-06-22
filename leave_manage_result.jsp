<%@page import="eg.off.OffTypeObj"%>
<%@page import="eg.off.OffsObj"%>
<%@page import="eg.off.OffType"%>
<%@page import="eg.off.ALPeriodObj"%>
<%@page import="ws.crew.CrewBasicObj"%>
<%@page import="ws.off.CrewOffListRObj"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="eg.off.quota.*, eg.*,tool.*,java.util.*"%>
<%@page import="ws.off.CrewALQuotaRObj"%>
<%@page import="ws.off.CrewALFun"%>
<%@page import="ws.crew.LoginAppBObj"%>
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
} 
else
{
	String leave_type = request.getParameter("type");
	String year = request.getParameter("myDate");

	
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
	
	<!-- Mobiscroll JS and CSS Includes -->
	<script src="mobiscroll/mobiscroll.core.js"></script>
	<script src="mobiscroll/mobiscroll.frame.js"></script>
	<script src="mobiscroll/mobiscroll.scroller.js"></script>

	<script src="mobiscroll/mobiscroll.util.datetime.js"></script>
	<script src="mobiscroll/mobiscroll.datetimebase.js"></script>
	<script src="mobiscroll/mobiscroll.datetime.js"></script>

	<link href="mobiscroll/mobiscroll.frame.css" rel="stylesheet" type="text/css" />
	<!-- <link href="mobiscroll/mobiscroll.frame.jqm.css" rel="stylesheet" type="text/css" /> -->
	<!-- <link href="mobiscroll/mobiscroll.scroller.jqm.css" rel="stylesheet" type="text/css" /> -->
	<link href="mobiscroll/mobiscroll.scroller.css" rel="stylesheet" type="text/css" />
	
    <script type="text/javascript">
        $(document).ready(function () {
        	initDate();
        	scrollDate();
        	

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
            $("#delBtn").click(function(e){
            	var delAL = GetInputValue("delAL");
            	//console.log("delAL:"+delAL);
            	if("" != delAL && isNaN(delAL)){
            		$("#alMsg").html(delAL);
            		//var msg = $("#alMsg").val(); 
            		//console.log(msg);
                	$("#alert-popup-apply").popup("open");
                	//console.log("delBtn apply open");
            	}else{
            		$("#strMsg").html("請勾選欲刪除的假單");
    				$("#backData").val("1");
    				$("#alert-popup-info").popup("open");
    				console.log("delBtn info open");
            	}
            	
            });
            $("#sub").click(function(e){
				$("#alert-popup-apply").popup("close");	
            	var delAL = GetInputValue("delAL");
            	var offyear = GetInputValue("offyear");
           		$.ajax({
        			type: "POST",
        			url: "delAL.jsp",
        			data: {delAL:delAL,offyear:offyear},
        			success:function(data){	
						if(data.indexOf("請登入") > -1){
							window.location.href = "login.jsp";
						}else if(data.indexOf("失敗") > -1){
        					$("#strMsg").html(data);
	        				$("#backData").val("1");	 
							$("#strMsgHeader").html("提示:");
	        				$("#alert-popup-info").popup("open");
	        				//console.log("sub info open");
	        				//console.log(data);
	        			}else{
	        				$("#strMsg").html(data);
	        				$("#backData").val("0");	
	        				//$("#strMsgHeader").hide();
	        				$("#strMsgHeader").html(" ");
	        				$("#alert-popup-info").popup("open");
	        			}
        			},
        			error:function(xhr, ajaxOptions, thrownError){
        				console.log(xhr.status);
        				console.log(thrownError);
        				$("#strMsg").html("Error");
        				$("#backData").val("1");
        				$("#alert-popup-info").popup("open");
        			}
        		});
        		e.preventDefault();           	
            });
          	//confirm
			$("#popConf").click(function(e){
				var msg = $("#backData").val();
				if(0 == msg){
					$("#form1").attr("action", "leave_manage_result.jsp");
    				$("#form1").submit();
    				//導向查詢頁面
    				console.log(msg);
				}else{
					$("#alert-popup-info").popup("close");	
				}					         	
            });
            /* 休假查詢類型 選單 */
			$("#type1").onclick = function() {
				 $("#leave_type").innerHTML="扣薪假";
			};

			 $("#type2").onclick = function() {
				 $("#leave_type").innerHTML="不扣薪假";
			};

			 $("#type_other").onclick = function() {
				 $("#leave_type").innerHTML="其他";
			};

        });
        
        function initDate(){
			//今天的日期(yyyy-m)
			var today = new Date();
			thisYear = today.getFullYear();
			var thisMonth = ('0'+(today.getMonth()+1)).slice(-2);
//			thisMonth = today.getMonth();
			var myDate = thisYear;
			var showDate = $("#myDate").val();
			if(null ==  showDate || "" == showDate ){
				 $("#myDate").val(myDate) ;
			}
			// alert(myDate);
		};
		function scrollDate(){
 			$('.myDate').mobiscroll().date({
   				theme: '',
   				mode: 'mode',
   				display: 'modal',
   				lang: 'en',
   				dateFormat: 'yy',
   				dateOrder: 'yy',
   				setText: '選擇',
   				cancelText: '取消',
   				startYear: 2000
    		});
 		}
		function GetInputValue(InputName){                	
         	return $('input[name=' + InputName + ']:checked').map(function ()
         	{
         		return $(this).val();
         	}).get().join(',');
         }
    </script>

</head>
<body>

<div id="leave_manage_result" data-role="page">
<!-- Header bar Start -->
	<div data-role="header" data-position="fixed">
		<table id="header-bar">
			<tr>
				<td id="header-bar-btnBak">
					<a href="leave_manage.jsp" data-ajax="false" ><div id="naviBar_icon_Back"></div></a>
				</td>
				<td id="header-bar-btnAppname">假單查詢與刪除</td>
				<td id="header-bar-btnMenu">
					<a id="btn_menu" href="#navbar"><div id="navi_icon_menu"></div></a>
				</td>
			</tr>
		</table>
	</div>
<!-- Header bar End -->

<!-- 假單查詢與刪除 Start-->
	<div role="main" class="ui-content">
		<form id="form1" method="POST" action="" data-ajax="false">
<%
	if(null!=year && !"".equals(year)){
		CrewALFun fun = new CrewALFun();
		fun.OffsList(year, lObj.getFzCrewObj().getEmpno(), leave_type);
		 CrewOffListRObj rObjAL = fun.getCrewOffsAL();
		
		if(!"0".equals(rObjAL.getResultMsg()) && null != rObjAL){
			CrewBasicObj infoObj = rObjAL.getEgInfo();
			ArrayList ALObjAL = rObjAL.getALperiodAL();//ALPeriodObj
			ArrayList offObjAL = rObjAL.getOffsAL();
			OffType offtype = new OffType();
			offtype.offData();
			
%>
		<div class="leave_result_title">
		  	<input name="offyear" type="hidden" id="offyear" value="<%=year%>">
		  	<input name="type" type="hidden" id="type" value="<%=leave_type%>">
		  	<input name="myDate" type="hidden" id="myDate" value="<%=year%>">
			<p class="font_20_bold"><%=infoObj.getCname() %></p>
			<p class="font_16_bold" style="margin:0px 7px;"><%=infoObj.getDeptno() %></p>
			<p class="font_14"><%=infoObj.getEmpn() %></p>
			<p class="font_14"><%=infoObj.getSern() %></p>
			<%if("1".equals(leave_type)){ %>
			<br>
			<p class="font_16">AL effective Date :</p>
			<p class="font_16"><%=infoObj.getAldate() %></p>
			<p class="font_16">未扣除特休假總天數 :</p>
			<p class="font_18_a40000"><%=rObjAL.getUndeduct()%></p>
			<%} %>
		</div>

<%
		if(null!= ALObjAL && ALObjAL.size() > 0){
			for(int i=0; i<ALObjAL.size(); i++)
			{
				ALPeriodObj obj = (ALPeriodObj) ALObjAL.get(i);
%>
		<div class="leave_result_title">
			<p class="font_18">(<%=offtype.getOffDesc(obj.getOfftype()).offtype%>)<%=obj.getEff_dt()%> ~ <%=obj.getExp_dt()%></p>
			<br>
			<p class="font_16">進假天數 :</p>
			<p class="font_18_bold"><%=obj.getOffquota()%></p>
			<p class="font_16" style="margin-left:15px;">已使用天數 :</p>
			<p class="font_18_bold"><%=obj.getUseddays()%></p>
			<br>
		</div>
<%
			}
		}
%>
		<div class="leave_result_help">
			<div data-role="navbar">
				<ul>
					<li>
						<div id="list_icon_used_small">已扣除假單</div>
					</li>
					<li>
						<div id="list_icon_nonused_small">未扣除假單</div>
					</li>
					<li>
						<div id="list_icon_delete_small">已刪除假單</div>
					</li>
					
				</ul>
<%
		if(!"1".equals(leave_type)){
%>
				<ul><li></li></ul>
				<ul>
					<li>
						<div>A->Approved</div>
					</li>
					<li>
						<div>R->Rejected</div>
					</li>
					<li>
						<div >P->Processing</div>
					</li>
				</ul>
<%
		}
%>		</div>
	</div>


		<%
		String offClass = "";
		String icon = "";
		boolean delflag = false;
		int count = 0;
		String remark = "";
		if(null!=offObjAL && offObjAL.size()>0) {
			for(int i=0; i<offObjAL.size(); i++)
			{
				delflag = false;
				
				OffsObj obj = (OffsObj) offObjAL.get(i);
				if(null!=obj.getRemark() && !"".equals(obj.getRemark())){
					remark = obj.getRemark().trim();
					if ("N".equals(remark))
					{
						offClass = "leave_result_nonused";
						icon= "list_icon_nonused";
						if("1".equals(leave_type)){
							delflag = true;	
							count ++;
						}
					}	
					else if ("*".equals(remark))
					{
						icon= "list_icon_delete";
						offClass = "leave_result_delete";						
					}	
					else if ("Y".equals(remark))
					{
						icon = "list_icon_used";
						offClass = "leave_result_used";
					}else{
						offClass = "";
					}
				}
				OffTypeObj offtypeobj = offtype.getOffDesc(obj.getOfftype());
				
				%>	
				<div class="<%=offClass%>">
					<%
					if(delflag){
					%>	
						<span>
							<input type="checkbox" name="delAL" id= "delAL<%=i%>" value="<%=obj.getOffsdate()%><%=obj.getOffedate()%><%=obj.getOffno()%>"/>
						</span>					
					<% 	
					}
					%>				
					<div class="font_14 <%=icon%>">
						<p style="margin-right: 20px;"><%=obj.getForm_num() %></p>
						<p><%=obj.getOffdays()%>Day</p>
					</div>
					<!-- <div class="font_14">
						<p> -->
						<%
						if(null != obj.getOccur_date() || null != obj.getRelation()) { %>
							<div class="font_14"><p>
							<% if(null != obj.getOccur_date()) {
								out.println(" /EventDate:"+obj.getOccur_date()+"");	
							}else{
								out.println("");
							}
							if(null != obj.getRelation()) {
								out.println(" ("+ obj.getRelation()+")");	
							}else{
								out.println("");
							} %> </p> 
							</div> 
						<%}%>
						
						<input type="hidden" name="ALinfo" id="ALinfo<%=i%>" value="<%=obj.getForm_num() %><br><%=obj.getOffsdate()%>-<%=obj.getOffedate()%>">						
						<!-- </p>
						<input type="hidden" name="ALinfo" id="ALinfo<%=i%>" value="<%=obj.getForm_num() %><br><%=obj.getOffsdate()%>-<%=obj.getOffedate()%>">
					</div> -->
					<div class="font_18">
						<p>(<%=offtypeobj.offtype%>)</p>
						<p><%=obj.getOffsdate()%>-<%=obj.getOffedate()%></p>
					</div>
					<div class="font_16">
						<p>Apply Date :<%=obj.getNewdate()%>
						<%
						if(null != obj.getEf_judge_status() && !"1".equals(leave_type)) {
							out.println(" /Status:"+obj.getEf_judge_status());	
						}else{
							out.println("");
						}
						%>
						</p>
					</div>
				</div>
			<%
			}
		}
		%>


		<div id="leave_result_info">
			<div id="list_icon_info_20px" style="top:-100px;"></div>
			<span id="div_result_infoMsg">
				<p>• 特休假將於休假生效日當天扣除。</p>
				<p>• 欲取消每月1日至10日之特休假，</p>
				<p style="margin-left:10px;">需提前2個月10日(含10日)以前申請。</p>
				<p>• 欲取消每月11日以後之特休假，</p>
				<p style="margin-left:10px;">需提前1個月10日(含10日)以前申請。</p>
				<p>• 如有任何問題請洽空服行政。</p>
			</span>
		</div>
		<%if(count > 0){ %>
		<div id="btnApply" class="leave_apply_btnApply">
			<a id="delBtn" href="#" data-rel="popup" data-transition="pop" class="ui-btn ui-corner-all"><div>刪除假單</div></a>
		</div>
		<%} %>

		</form>
	</div>

	<!-- 定義popup顯示位置 -->
	<div id="popupSite"></div>
<!-- 假單查詢與刪除 End-->


<%
		}else{
			out.println(rObjAL.getErrorMsg());
		}
	}else{
		out.println("no date");
	}
}
}catch(ClassCastException e){
	out.println("請登入");
	response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println("Error"+e.toString());	
}
%>

<!-- 假單查詢與刪除 End-->

<!-- popup container start -->
<div data-role="popup" id="alert-popup-apply" class="ui-content popupDiv" data-overlay-theme="b" data-dismissible="false" data-position-to="#popupSite" data-shadow="true" data-corners="true">
    <div data-role="header" class="popup-header">
       <p style="margin-bottom: 22px;">確認刪除以下假單?</p>
    </div>

    <div data-role="content" class="popup-content" id="leave_manage_result_popup">
    	<div class="leave_manage_result_popup1">
    		<p id="alMsg"></p>
    	</div>
	    <!--  <div class="leave_manage_result_popup1">
			<p>001553_1 , 1 Day</p>
			<p>(AL)2014/05/22-2014/05/22</p>
		</div>
	    <div class="leave_manage_result_popup1">
			<p>001553_1 , 1 Day</p>
			<p>(AL)2014/05/22-2014/05/22</p>
		</div>-->

		<div data-role="navbar">
			<ul>
				<li>
					<a class="ui-btn btnPopOK" data-rel="back" data-ajax="false"><div>取 消</div></a>
				</li>
				<li>
		        	<a id="sub" class="ui-btn btnPopOK" href="#" data-ajax="false"><div>確 認</div></a>
		        </li>
	        </ul>
		</div>
    </div>
</div>
<div data-role="popup" id="alert-popup-info" class="ui-content popupDiv" data-overlay-theme="b" data-dismissible="false" data-position-to="#popupSite" data-shadow="true" data-corners="true">
    <div data-role="header" class="popup-header">
    	   <p style="margin-bottom: 22px;" id="strMsgHeader"></p>
    </div>
     <div data-role="content" class="popup-content" id="leave_manage_result_popup">
     	<div class="leave_manage_result_popup1">
	     	<input type="hidden" id="backData"> 
	        <p id="strMsg"></p>
        </div>
     </div>
     <a id="popConf" class="ui-btn btnPopOK" href="#" data-ajax="false"><div>確 認</div></a>
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