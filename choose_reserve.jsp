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
	
	SkjPickList spl = new SkjPickList();
	/*spl.getSkjPickList("ALL",uObj.getEmpno());
	ArrayList objAL = spl.getObjAL();*///列表
	
	CrewPickFun cpf = new CrewPickFun();
	cpf.PickApplyList(uObj.getEmpno());
	CrewPickApplyListRObj objRAL = cpf.getPickListObjAL();
	ArrayList objAL = objRAL.getListObjAL();
	String ifY = objRAL.getFlag();
	
	ArrayList objAL2 = new ArrayList();//處理序號
	String str = "";
	boolean flag = false;
	String comment = "";
%>
<!DOCTYPE html>
<html>
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
        	var count = 0;
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
            
            //submit
            $("#sub").click(function(e){
            	//var formNo1 = $('input:radio:checked[name="unList"]').val();
            	//var formNo2 = $('input:radio:checked[name="unList1"]').val();
            	var formNo1 = GetCheckedValue('unList'); 
            	var formNo2 = GetCheckedValue('unList1');
            	/*console.log(!isNaN(formNo1));
            	console.log(!isNaN(formNo2));
            	console.log(count);*/
            	var formNo = "";
            	if(count == 1 && "" != formNo1){
            		formNo = formNo1;
            	}else if(count == 1 && "" != formNo2){
            		formNo = formNo2;
            	}else{
            		formNo = "";
            	}
            	if(""!=formNo){
	            	$.ajax({
	        			type: "POST",
	        			url: "chkChoose_reserve.jsp",
	        			data: {unList:formNo},
	        			success:function(data){
	        				$("#strMsg1").html("你已提出選班預約申請");
	        				$("#strMsg").html(data);
	        				$("#msgValue").val("0");
	        				$("#alert-popup-apply").popup("open");
	        			},
	        			error:function(xhr, ajaxOptions, thrownError){
	        				console.log(xhr.status);
	        				console.log(thrownError);
	        				$("#msgValue").val("1");
	        				$("#strMsg").html("Error");
	        				$("#alert-popup-apply").popup("open");
	        			}
	        		});
	        		e.preventDefault();
            	}else{
            		$("#strMsg1").html("");
            		$("#strMsg").html("請選擇一張申請單");
            		$("#msgValue").val("1");
    				$("#alert-popup-apply").popup("open");
            	}
        	});
            $("#popConf").click(function(e){
            	if(0 == $("#msgValue").val()){
            		$("#popConf").attr("href","choose_main.jsp");
            	}else{
            		$("#alert-popup-apply").popup("close");
            	}
            	count = 0;
            });
            $("#popConf1").click(function(e){
            	$("#info1").html("");
        		$("#info2").html("");
                $("#info3").html("");
                $("#alert-popup-info").popup("close");
            });
            function GetCheckedValue(checkBoxName){                	
            	return $('input:checkbox:checked[name=' + checkBoxName + ']').map(function ()
            	{
	            	count ++;
            		return $(this).val();
            	}).get().join(',');
            };
        });
        function PopFunction(reason,sno,sdate,edate,comment,time){
        	$("#info1").html(reason+','+sno);
        	var temp = "";
        	if(""!=sdate && ""!=edate){
        		temp = "全勤區間"+sdate+'~'+edate;
        	}
        	
        	if("" != comment){
        		temp +='<br>'+comment;
        	}
        	$("#info2").html(temp);
        	$("#info3").html("新增時間:"+time);
        	
    	};
    </script>

</head>
<body>

<div id="choose_reserve" data-role="page">
<!-- Header bar Start -->
	<div data-role="header" data-position="fixed">
		<table id="header-bar">
			<tr>
				<td id="header-bar-btnBak">
					<a href="choose_main.jsp" data-ajax="false"><div id="naviBar_icon_Back"></div></a>
				</td>
				<td id="header-bar-btnAppname">選班預約申請</td>
				<td id="header-bar-btnMenu">
					<a id="btn_menu" href="#navbar"><div id="navi_icon_menu"></div></a>
				</td>
			</tr>
		</table>
	</div>
<!-- Header bar End -->
<form id="form1">
<!-- 選班預約申請 Start-->
	<div role="main" class="ui-content">
		<%if(null!= objAL && objAL.size()>0){ %>
		<table class="choose-serv-t">
			<tr>
				<th colspan="4">已掛號申請單</th>
			</tr>
			<%
			for(int i=0;i<objAL.size();i++){ 
				SkjPickObj obj = (SkjPickObj) objAL.get(i);					
				String pickNum = spl.getPick_Num(Integer.toString(obj.getSno()));
				objAL2.add(pickNum);
				//out.println(i+","+pickNum+"<br>");
				if(null != objAL2.get(i) && !"".equals((String)objAL2.get(i))){
				flag = true;
				comment = obj.getComments();
			 	if(comment != null)
			 	{
					comment = obj.getComments().replaceAll("\r\n","<br>");
					comment = comment.replaceAll("'"," ");
					comment = comment.replaceAll("\""," ");
			 	}
			%>
			<tr>
				<td style="padding-top: 15px; padding-left:23px; width: 30%;"><%=obj.getReason()%></td>
				<td><%=obj.getSno()%></td>
				<td>處理序號<%=(String) objAL2.get(i)%></td>
				<td><a href="#alert-popup-info" data-rel="popup" data-transition="pop" onClick="PopFunction('<%=obj.getReason()%>','<%=obj.getSno()%>','<%=obj.getSdate()%>','<%=obj.getEdate()%>','<%=comment%>','<%=obj.getNew_tmst()%>');"><div class="list_icon_info_gray_20px"></div></a></td>
			</tr>
			<%
				}
				
			}
			%>
		</table>
		<%if(!flag){%>
			<div  style="padding-top: 15px; padding-left:23px; width: 30%;">No data.</div>
		<%}%>
		
		<table class="choose-serv-t" style="margin-top: 15px;">
			<tr>
				<th colspan="4">未掛號申請單</th>
			</tr>
			<%
			int idx = 0;
			boolean ifshow = false;
			for(int i=0;i<objAL.size();i++){ 
				ifshow = false;
				SkjPickObj obj = (SkjPickObj) objAL.get(i);
				if((null == objAL2.get(i) || "".equals((String)objAL2.get(i)) ) && (("".equals(obj.getEd_user()) | obj.getEd_user() ==null) && "Y".equals(obj.getValid_ind()) )){
					if("Y".equals(ifY))
					{
						if("全勤選班".equals(obj.getReason()))
						{
							idx ++;
							ifshow = true;	
						}
					}
					else
					{
						idx ++;
						ifshow = true;	
					}
				    if(ifshow){ 
				    	comment = obj.getComments();
					 	if(comment != null)
					 	{
							comment = obj.getComments().replaceAll("\r\n","<br>");
							comment = comment.replaceAll("'"," ");
							comment = comment.replaceAll("\""," ");
					 	}
			%>
			<tr>
				<td><input type="checkbox" name="unList" id="unList<%=i%>" value="<%=obj.getEmpno()%><%=obj.getSno()%>"></td>
				<td><%=obj.getReason()%></td>
				<td><%=obj.getSno()%></td>
				<td><a href="#alert-popup-info" data-rel="popup" data-transition="pop" onClick="PopFunction('<%=obj.getReason()%>','<%=obj.getSno()%>','<%=obj.getSdate()%>','<%=obj.getEdate()%>','<%=comment%>','<%=obj.getNew_tmst()%>');"><div class="list_icon_info_gray_20px"></div></a></td>
			</tr>
			<%
				    }
				} 
			}
			%>
		</table>
		
		<table class="choose-serv-t" style="margin-top: 15px;">
			<tr>
				<th colspan="4">退/改選申請單</th>
			</tr>
			<%
			int idx1 = 0;
			boolean ifshow1 = false;
			for(int i=0;i<objAL.size();i++){ 
				ifshow1 = false;
				SkjPickObj obj = (SkjPickObj) objAL.get(i);
				if((null == objAL2.get(i) || "".equals((String)objAL2.get(i)) ) && ((!"".equals(obj.getEd_user()) && obj.getEd_user() !=null) && "Y".equals(obj.getValid_ind()) )){
					if("Y".equals(ifY))
					{
						if("全勤選班".equals(obj.getReason()))
						{
							idx1 ++;
							ifshow1 = true;	
						}
					}
					else
					{
						idx1 ++;
						ifshow1 = true;	
					}
				    if(ifshow1){
			    	  comment = obj.getComments();
					  if(comment != null)
					  {
						comment = obj.getComments().replaceAll("\r\n","<br>");
						comment = comment.replaceAll("'"," ");
						comment = comment.replaceAll("\""," ");
					  }
			%>
			<tr>
				<td><input type="checkbox" name="unList1" id="unList1<%=i%>" value="<%=obj.getEmpno()%><%=obj.getSno()%>"></td>
				<td><%=obj.getReason()%></td>
				<td><%=obj.getSno()%></td>
				<td><a href="#alert-popup-info" data-rel="popup" data-transition="pop" onClick="PopFunction('<%=obj.getReason()%>','<%=obj.getSno()%>','<%=obj.getSdate()%>','<%=obj.getEdate()%>','<%=comment%>','<%=obj.getNew_tmst()%>');"><div class="list_icon_info_gray_20px"></div></a></td>
			</tr>
			<%
				    }
				} 
			}
			%>
		</table>
		
		<div id="btnApply" class="choose_btnApply">

			<a id="sub" href="#" data-rel="popup" data-transition="pop" class="ui-btn ui-corner-all"><div>預約申請</div></a> 
		</div>
<%}else{%>
		<div id="btnApply" class="choose_btnApply">
			<div>No data.<%=cpf.getPickListObjAL().getErrorMsg() %></div>
		</div>
	
<%}%>
	</div>
	<!-- 定義popup顯示位置 -->
	<div id="popupSite"></div>
</form>
<!-- 選班預約申請 End-->
<%
}
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
        <hr>
        <p id="info3"></p>
        <a class="ui-btn btnPopOK" id="popConf1" href="#" data-ajax="false"><div>確 認</div></a>
    </div>

</div>

<div data-role="popup" id="alert-popup-apply" class="ui-content popupDiv" data-overlay-theme="b" data-dismissible="false" data-position-to="window" data-shadow="true" data-corners="true">
    <div data-role="header" class="popup-header">
       <p id="strMsg1"></p>
    </div>

    <div data-role="content" class="popup-content">
    	<input type="hidden" id="msgValue">
        <p id="strMsg"></p>
        <a class="ui-btn btnPopOK" id="popConf" href="#" data-ajax="false"><div>確 認</div></a>
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
