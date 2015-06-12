<%@page import="java.net.URLEncoder"%>
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
	String yymm = request.getParameter("myDate");
	int acnt = 0;
	int rcnt = 0;
	String apoint = request.getParameter("apoint");
	String rpoint = request.getParameter("r_point");
	String ack =  request.getParameter("ack");
	String rck =  request.getParameter("r_ck");
	String aTimes =  request.getParameter("aTimes");
	String rTimes =  request.getParameter("rTimes");
	
	//out.println(rEmpno+yymm+apoint+ack+aTimes+rTimes);
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
            	var aEmpnoArr = $('input:checkbox:checked[name="chkA"]').val();
            	var rEmpnoArr = $('input:checkbox:checked[name="chkR"]').val();
            	
            	if("" != yymm && !isNaN(aEmpnoArr) && !isNaN(rEmpnoArr) ){
            		
                	$("#swapDetailform").attr("action", "change_apply_finalcheck.jsp");
    				$("#swapDetailform").submit();
            	}else{
            		$("#strMsg").html("請勾選班次");
            		$("#backData").val("");
            		$("#alert-popup-apply").popup("open");
            	}
            });
        	//confirm
			$("#popConf").click(function(e){
				$("#alert-popup-apply").popup("close");	   
				//$("#strMsg2").html(data);
            });
        	//detail pop
			$("#popInfo").click(function(e){
				$("#alert-popup-info").popup("close");	         	
            });
			//back
			$("#naviBar_icon_Back").click(function(e){
            	var yymm = $("#myDate").val();
            	var rEmpno = $("#rEmpno").val();
            	if("" != yymm && ""!=rEmpno ){
	            	$("#swapDetailform").attr("action", "change_apply_substitle.jsp");
					$("#swapDetailform").submit();
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
    	//detail
        function danji(type,id,spCode,tripNo){
            id = parseInt(id);
            //$("#info"+type + id).click(function(e){
				var flag = false;
				$.ajax({
                    type: "POST",
                    url: "swapFltDetail.jsp",
                    data: {spCode:spCode, tripNo:tripNo},
                    success:function(data){
                    	//console.log(data);
                        flag = true;
                    	$("#tripno_show").html("tripNo : "+tripNo);
                    	$("#strMsg2").html(data);
                		//$("#backData").val("");
                		$("#alert-popup-info").popup("open");
                    },
                    error:function(xhr, ajaxOptions, thrownError){
                        console.log(xhr.status);
                        console.log(thrownError);
                        alert("Error");
                    }
                });
                //e.preventDefault();
            	if(!flag){
            		$("#strMsg2").html("無法取得資訊");
            		//$("#backData").val("");
            		$("#alert-popup-info").popup("open");
            	}
           //}); 
        };
    </script>

</head>
<body>

<div id="change_calc_table" data-role="page">
<!-- Header bar Start -->
	<div data-role="header" data-position="fixed">
		<table id="header-bar">
			<tr>
				<td id="header-bar-btnBak">
					<a href="#"><div id="naviBar_icon_Back"></div></a>
				</td>
				<td id="header-bar-btnAppname">換班申請</td>
				<td id="header-bar-btnMenu">
					<a id="btn_menu" href="#navbar"><div id="navi_icon_menu"></div></a>
				</td>
			</tr>
		</table>
	</div>
<!-- Header bar End -->

<!-- 換班班表 Start-->
<div role="main" class="ui-content">	
<form id="swapDetailform" method="POST" action="" data-ajax="false">
<div data-role="navbar" id="calc_navbar">
<%
if(null!=yymm && !"".equals(yymm)){
	String date[] = yymm.split("/");
	year = date[0];
	month = date[1];
	if(month.length()<=1){
		month = "0"+month;
	}
	CrewSwapFunALL csf = new CrewSwapFunALL();
//取得班表
if("TPE".equals(uObj.getBase())){
csf.SwapSkjTPE(aEmpno, rEmpno, year, month);
CrewSwapRObj rObjAL = csf.getCrewSpObjAL();
	if("0".equals(rObjAL.getResultMsg())){
	%>
	<ul><li><div id="calc_datetime"><%=rObjAL.getErrorMsg() %></div></li></ul>
	<%
	}else{

		CrewInfoObj aCrewInfoObj = rObjAL.getaCrewInfoObj();
		CrewInfoObj rCrewInfoObj = rObjAL.getrCrewInfoObj();
		
		ArrayList aEmpnoAL = rObjAL.getaCrewSkjAL();
		ArrayList rEmpnoAL = rObjAL.getrCrewSkjAL();
		CrewCrossCrMuti ccm = new CrewCrossCrMuti();
		ArrayList dayofmonthAL = new ArrayList();
		dayofmonthAL=ccm.getEachDayOfMonth(year,month);
//out.println(ccm.getStr());
%>

<ul>
<li>
	<div id="calc_datetime">
		<table>
			<tr class="tr_yearmonth">
				<th rowspan="3">
					<p><%=year %></p>
					<p><%=month %></p>
					<input type="hidden" id="myDate" name="myDate" value="<%=yymm%>">
					<input type="hidden" name="rEmpno" id="rEmpno" value="<%=rEmpno%>">
					<input type="hidden" name="aEmpno" id="aEmpno" value="<%=uObj.getEmpno()%>">
					<input type="hidden" name="aTimes" id="aTimes" value="<%=aTimes%>">
					<input type="hidden" name="rTimes" id="rTimes" value="<%=rTimes%>">
					<input type="hidden" name="ack" id="ack" value="<%=ack%>">
					<input type="hidden" name="apoint" id="apoint" value="<%=apoint%>">
					<input type="hidden" name="r_ck" id="r_ck" value="<%=rck%>">
					<input type="hidden" name="r_point" id="r_point" value="<%=rpoint%>">
				</th>
			</tr>

			<tr></tr>
			<tr></tr>
<%
String bcolor = "";
for(int o=0; o<dayofmonthAL.size(); o++)
{
	if(((String)dayofmonthAL.get(o)).indexOf("SAT")>=0 || ((String)dayofmonthAL.get(o)).indexOf("SUN")>=0)
	{
		//週末
		bcolor="#ffff00";
	}else{
		bcolor="";
	}
%>
			
			<tr class="tr_date" bgcolor="<%=bcolor%>">
				<td><%=((String) dayofmonthAL.get(o)).substring(8,10)%></td>
			</tr>
<%
}//for(int o=0; o<dayofmonthAL.size(); o++)
%>
		</table>
	</div>
</li>
<li>
	<div id="compare_applicant1">
		<table>
			<tr class="tr_applicant">
				<th colspan="4">Applicant /</th>
			</tr>
			<tr class="tr_name_table">
				<td colspan="4">
					<p><%=aCrewInfoObj.getCname()%></p>
					<p><%=aCrewInfoObj.getEmpno()%></p>
					<p><%=aCrewInfoObj.getSern()%></p>			
				</td>
			</tr>
			<tr class="tr_fltno_cr_resthr_select">
				<td>Fltno</td>
				<td>CR</td>
				<td>RestHr</td>
				<td>Select</td>
			</tr>

			<%
		if(null!= aEmpnoAL && aEmpnoAL.size() > 0){
			for(int o=0; o<dayofmonthAL.size(); o++)
			{
				if(((String)dayofmonthAL.get(o)).indexOf("SAT")>=0 || ((String)dayofmonthAL.get(o)).indexOf("SUN")>=0)
				{
					//週末
					bcolor="#ffff00";
				}else{
					bcolor="";
				}					
				for(int i=0 ;i<aEmpnoAL.size();i++){
					
					CrewSkjObj sobj = (CrewSkjObj)aEmpnoAL.get(i);
					if(((String)dayofmonthAL.get(o)).equals(sobj.getFdate()+" ("+sobj.getDayOfWeek()+")"))
					{
						acnt++;		
				%>
					<tr class="tr_content_table">
						<td>
						<%if("FLY".equals(sobj.getCd()) | "TVL".equals(sobj.getCd())){%>					    
							<a id="infoA<%=i%>" href="#" data-rel="popup" data-transition="pop" onclick="danji('A',<%=i%>,'<%=sobj.getSpCode()%>','<%=sobj.getTripno()%>');"><%=sobj.getDutycode() %></a>
						<%}else{%>
					   		<%=sobj.getDutycode() %>  
					 	<%}%>
						</td>
						<td><%=sobj.getCr() %></td>
						<td class="fontgray"><%=sobj.getResthr() %></td>
						<td>
						<%if(csf.isCheckBox(sobj.getDutycode(), sobj.getTripno())){ %>
						<input type="checkbox" name="chkA" value="<%=i%>"> 
						<%} %>
						</td>
					</tr>
				<%
					}//if(((String)dayofmonthAL.get(o))
				}//for(int i=0 ;i<aEmpnoAL.size();i++)
				if(acnt<=0)
				{
				%>
					<tr class="tr_content_table"><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
				<%
				}//if(acnt<=0)
				acnt = 0;
			}//A 	for(int o=0; o<dayofmonthAL.size(); o++)
		}//if(null!= aEmpnoAL && aEmpnoAL.size() > 0)
		%>	
			<!-- <tr class="tr_content_table">
				<td>0000</td>
				<td>1111</td>
				<td >20</td>
				<td class="tr_chk">
					<div id="list_btn_square"></div>
				</td>
			</tr> -->
		</table>
	</div>
</li>


<li>
	<div id="compare_substitle1">
		<table>
			<tr class="tr_substitle">
				<th colspan="4">Substituent /</th>
			</tr>
			<tr class="tr_name_table">
				<td colspan="4">
					<p><%=rCrewInfoObj.getCname() %></p>
					<p><%=rCrewInfoObj.getEmpno() %></p>
					<p><%=rCrewInfoObj.getSern() %></p>
				</td>
			</tr>
			<tr class="tr_fltno_cr_resthr_select">
				<td>Fltno</td>
				<td>CR</td>
				<td>RestHr</td>
				<td>Select</td>
			</tr>

<%
			if(null!= rEmpnoAL && rEmpnoAL.size() > 0){
			for(int o=0; o<dayofmonthAL.size(); o++)
			{
				if(((String)dayofmonthAL.get(o)).indexOf("SAT")>=0 || ((String)dayofmonthAL.get(o)).indexOf("SUN")>=0)
				{
					//週末
					bcolor="#ffff00";
				}else{
					bcolor="";
				}					
				for(int i=0 ;i<rEmpnoAL.size();i++){
					
					CrewSkjObj sobj = (CrewSkjObj)rEmpnoAL.get(i);
					if(((String)dayofmonthAL.get(o)).equals(sobj.getFdate()+" ("+sobj.getDayOfWeek()+")"))
					{
						rcnt++;		
				%>
					<tr class="tr_content_table">
						<td>
						<%if("FLY".equals(sobj.getCd()) | "TVL".equals(sobj.getCd())){%>					    
							<a id="infoR<%=i%>" href="#" data-rel="popup" data-transition="pop" onclick="danji('R',<%=i%>,'<%=sobj.getSpCode()%>','<%=sobj.getTripno()%>');"><%=sobj.getDutycode() %></a>
						<%}else{%>
					   		<%=sobj.getDutycode() %>  
					 	<%}%>
						</td>
						<td><%=sobj.getCr() %></td>
						<td class="fontgray"><%=sobj.getResthr() %></td>
						<td>
						<%if(csf.isCheckBox(sobj.getDutycode(), sobj.getTripno())){ %>
						<input type="checkbox" name="chkR" value="<%=i%>"> 
						<%} %>
						</td>
					</tr>
				<%
					}//if(((String)dayofmonthAL.get(o))
				}//for(int i=0 ;i<rEmpnoAL.size();i++)
				if(rcnt<=0)
				{
				%>
					<tr class="tr_content_table"><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
				<%
				}//if(acnt<=0)
				rcnt = 0;
			}//A 	for(int o=0; o<dayofmonthAL.size(); o++)
		}//if(null!= rEmpnoAL && rEmpnoAL.size() > 0)
		%>	
			<!-- <tr class="tr_content_table">
				<td>0000</td>
				<td>1111</td>
				<td class="fontgray">20</td>
				<td class="tr_chk">
					<div id="list_btn_square"></div>
				</td>
			</tr> -->
		</table>
	</div>
</li>

</ul>

		<div id="div_select_comments">
			<label>Comments</label>
			<select id="comment" name= "comment">
		 	<option value="<%out.println(URLEncoder.encode("已自行查詢，責任自負", "UTF-8"));%>">已自行查詢，責任自負</option>
			<%
			if(null!=rObjAL.getCommItemAL()){
				for(int i=0;i<rObjAL.getCommItemAL().size();i++){ %>
			<option value="<%out.println(URLEncoder.encode((String) rObjAL.getCommItemAL().get(i), "UTF-8"));%>"><%=(String) rObjAL.getCommItemAL().get(i) %></option>
			
			
			<%
				}
			}
			%>
			</select>
			<input id="comment2" name="comment2" type="text" placeholder="放棄特休假請輸入申請者(A)或被換者(R)+日期">
		</div>

		<div id="btnApply" class="btn_calc_table">
			<a id="sub" href="#" data-rel="popup" data-transition="pop" class="ui-btn ui-corner-all"><div>送出任務互換資訊</div></a>
		</div>

	</div>
<%				

			}
		}else{
		%>
		    <!-- <script type="text/javascript">
		       	$("#swapDetailform").attr("action", "KHHchange_apply_list.jsp");
				$("#swapDetailform").submit();
		    </script>	 -->
		<%
		}
	}//	if(null!=yymm && !"".equals(yymm))
}
}catch(ClassCastException e){
	out.println("請登入");
	response.sendRedirect("login.jsp");
}catch(Exception e){
	out.println(e.toString());
	response.sendRedirect("login.jsp");
}
%>
</form>
</div>
<!-- 換班班表 End-->

<!-- popup container start -->

<div data-role="popup" id="alert-popup-info" class="ui-content popupDiv" data-overlay-theme="b" data-dismissible="false" data-position-to="window" data-shadow="true" data-corners="true" style="text-align: center;">
    <div data-role="header" class="popup-header" id="change_apply_list_header">
       <p id="tripno_show"></p>
    </div>

    <div data-role="content" class="popup-content" id="change_apply_list_popup">
		<p id="strMsg2"></p>
        <a id="popInfo" class="ui-btn btnPopOK" href="#" data-ajax="false"><div>確 認</div></a>
    </div>
</div>
<div data-role="popup" id="alert-popup-apply" class="ui-content popupDiv" data-overlay-theme="b" data-dismissible="false" data-position-to="window" data-shadow="true" data-corners="true">
    <div data-role="header" class="popup-header">
       <p >選班資格申請</p>
    </div>

    <div data-role="content" class="popup-content">    
    	<input type="hidden" id="backData" >	
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


