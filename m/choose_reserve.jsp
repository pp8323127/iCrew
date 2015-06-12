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
            $("#btn_menu").click(function(e){
                $.ajax({
                    type: "POST",
                    url: "navbar.jsp",
                    success:function(data){
                        //alert(data);
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
            	var formNo = $('input:radio:checked[name="unList"]').val();
            	$.ajax({
        			type: "POST",
        			url: "chkChoose_reserve.jsp",
        			data: {unList:formNo},
        			success:function(data){
        				$("#strMsg").html(data);
        				$("#alert-popup-apply").popup("open");
        			},
        			error:function(xhr, ajaxOptions, thrownError){
        				console.log(xhr.status);
        				console.log(thrownError);
        				$("#strMsg").html("Error");
        			}
        		});
        		e.preventDefault();
        	});
            /*$("#sub").click(function(e){
            	var formNo = $('input:radio:checked[name="unList"]').val();
            	alert(formNo);
            	if("" != formNo){
	            	$("#form1").attr("action", "chkChoose_reserve.jsp");
					$("#form1").submit();
            	}
            });*/
        });
        function PopFunction(reason,sno,sdate,edate,comment,time){
        	$("#info1").html(reason+','+sno);
        	$("#info2").html(sdate+'~'+edate+','+comment);
        	$("#info3").html(time);
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
		<table id="choose-serv-t">
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
			%>
			<tr>
				<td style="padding-top: 15px; padding-left:23px; width: 30%;"><%=obj.getReason()%></td>
				<td><%=obj.getSno()%></td>
				<td>處理序號<%=(String) objAL2.get(i)%></td>
				<td><a href="#alert-popup-info" data-rel="popup" data-transition="pop" onclick="PopFunction('<%=obj.getReason()%>','<%=obj.getSno()%>','<%=obj.getSdate()%>','<%=obj.getEdate()%>','<%=obj.getComments()%>','<%=obj.getNew_tmst()%>');"><div id="list_icon_info_gray_20px"></div></a></td>
			</tr>
			<%
				}
				
			}
			%>
		</table>
		<%if(!flag){%>
			<div  style="padding-top: 15px; padding-left:23px; width: 30%;">No data.</div>
		<%}%>
		
		<table id="choose-serv-t" style="margin-top: 15px;">
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
			%>
			<tr>
				<td><input type="radio" name="unList" id="unList<%=i%>" value="<%=obj.getEmpno()%><%=obj.getSno()%>"></td>
				<td><%=obj.getReason()%></td>
				<td><%=obj.getSno()%></td>
				<td><a href="#alert-popup-info" data-rel="popup" data-transition="pop" onclick="PopFunction('<%=obj.getReason()%>','<%=obj.getSno()%>','<%=obj.getSdate()%>','<%=obj.getEdate()%>','','<%=obj.getNew_tmst()%>');"><div id="list_icon_info_gray_20px"></div></a></td>
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
        <a class="ui-btn btnPopOK" data-rel="back"><div>確 認</div></a>
    </div>

</div>

<div data-role="popup" id="alert-popup-apply" class="ui-content popupDiv" data-overlay-theme="b" data-dismissible="false" data-position-to="window" data-shadow="true" data-corners="true">
    <div data-role="header" class="popup-header">
       <p>你已提出選班預約申請</p>
    </div>

    <div data-role="content" class="popup-content">
        <p id="strMsg"></p>
        <a class="ui-btn btnPopOK" href="choose_main.jsp" data-ajax="false"><div>確 認</div></a>
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
