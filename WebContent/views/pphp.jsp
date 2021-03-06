<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
boolean flag = false;
String userName = "";
if(session.getAttribute("userName") == null){
	flag = false;
	response.sendRedirect("/");
}else if(session.getAttribute("userName").toString().equals("")){
	flag = false;
	response.sendRedirect("/");
}
else{
	flag = true;
	userName = session.getAttribute("userName").toString();
	//System.out.println(userName);
}
%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>APPLE STORE 在线商店官网</title>
    
    	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    	<link rel="stylesheet" type="text/css" href="assets/css/bootstrap-combined.min.css"/>
    	<link rel="stylesheet" type="text/css" href="assets/css/layoutit.css"/>
	</head>
    <body>     
       <div id="colorBar"></div>
       <div class="container wrapper wrapperWhite">
<div class="container">

    <div class="row" id="row-logo">
    	<div class="span12 navbar bufferBottom">
    		<a href="index.jsp"><img src="assets/img/logo.png" class="imgLogo" /></a>
    
    		    		<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            	<span class="icon-bar"></span>
            	<span class="icon-bar"></span>
            	<span class="icon-bar"></span>
            </a>
            <%
            	if(flag == false){
            %>
            <div id="navList" class="nav-collapse collapse">
            	<div><a href="#logInModal" data-toggle="modal">登录</a></div>
                <div>|</div>
                <div><a href="#signUpModal" data-toggle="modal">注册</a></div>
            </div>
            <%
            	}else{
            %>
            <div id="userInfo" class="nav-collapse collapse">
            	<div>
                	<a id="dropInfo" href="#" data-toggle="dropdown">
                    	<i class="icon-user"></i> &nbsp;<%=session.getAttribute("userName") %>
                    </a>
                    <ul class="dropdown-menu" role="menu" aria-labelledby="drop1">
                    	<li role="presentation"><a role="menuitem" tabindex="-1" href="toOrder">购买记录</a></li>
                        <li role="presentation"><a role="menuitem" tabindex="-1" href="UserLogout">退出登录</a></li>
                	</ul>
                </div>
            </div>
            <%
            	}
            %>
        </div>
	</div>

	<div class="row"><div class="span12 topBorder bufferBottom20"></div></div>
    <div class="row text-center orderTitle orderContent">
    	<div class="span12">
			<h2>我的订单</h2>
        </div>
	</div>
    <div class="row orderContent">
    	<div class="span12" id="orderList">
    	
        </div>
    </div>
</div>
</div>

<div class="container wrapper wrapperBrown">
	<div class="container">
    	<div class="span12">
        </div>
    </div>
</div>

<div class="container wrapper" id="wrapperFooter">
	<div class="container" id="footerContent">
		<div class="row">
			<div class="span12" id="footerCopyright">Copyright 2014 汪洋 &amp; 郭坦 &amp; 张茜 &amp;姜帅</div>
		</div>
    </div>
</div>

<!-- Modal -->
<div id="logInModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="logInModalLabel" aria-hidden="true">
	<div class="modal-header">
    	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    	<h3 id="logInModalLabel">登录</h3>
	</div>
	<form class="form-horizontal loginDialog" action="/User/Signin/" method="post" acceptcharset="UTF-8">
		<div class="modal-body">
			<div class="control-group">
    			<label class="control-label" for="inputEmail">邮箱</label>
    			<div class="controls">
					<input type="text" id="inputEmail" placeholder="Email">
				</div>
			</div>
  			<div class="control-group">
    			<label class="control-label" for="inputPassword">密码</label>
    			<div class="controls">
      				<input type="password" id="inputPassword" placeholder="Password">
    			</div>
			</div>
	</div>
		<div class="modal-footer">
    	<button class="btn btn-info" data-dismiss="modal" aria-hidden="true">登录</button>
    	<button class="btn" data-dismiss="modal" aria-hidden="true">取消</button>
	</div>
	</form>
</div>

<div id="signUpModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="signUpModalLabel" aria-hidden="true">
	<div class="modal-header">
    	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    	<h3 id="signUpModalLabel">注册</h3>
	</div>
    <form class="form-horizontal loginDialog" action="/User/Signin/" method="post" acceptcharset="UTF-8">
		<div class="modal-body">
			<div class="control-group">
    			<label class="control-label" for="inputEmail">邮箱</label>
    			<div class="controls">
					<input type="text" id="inputEmail" placeholder="Email">
				</div>
			</div>
  			<div class="control-group">
    			<label class="control-label" for="inputPassword">密码</label>
    			<div class="controls">
      				<input type="password" id="inputPassword" placeholder="Password">
    			</div>
			</div>
            <div class="control-group">
    			<label class="control-label" for="inputPassword">确认</label>
    			<div class="controls">
      				<input type="password" id="inputPassword" placeholder="Confirm">
    			</div>
			</div>
	</div>
		<div class="modal-footer">
    	<button class="btn btn-info" data-dismiss="modal" aria-hidden="true">注册</button>
    	<button class="btn" data-dismiss="modal" aria-hidden="true">取消</button>
	</div>
	</form>
</div>

<script src="assets/js/jquery.js"></script>
<script src="assets/js/bootstrap.min.js"></script>
<script type="text/javascript">
$(document).ready(
		function(){
		$.post('getOrders',{"userId":"<%=userName%>"}).success(function(data){
			console.log(data);
			var obj = eval ("(" + data + ")");
			var i = 0;
			var strHtml = '<table class="table table-hover"><tr><th>商店</th><th>商品</th><th>订购数量</th><th>单价</th><th>地址</th><th>时间</th><th>订单状态</th></tr>';
			while(i < obj.total){
				strHtml += "<tr><td>";
				strHtml += obj.rows[i].restaurantName;
				strHtml += "</td><td>";
				strHtml += obj.rows[i].foodName;
				strHtml += "</td><td>";
				strHtml += obj.rows[i].number;
				strHtml += "</td><td>";
				strHtml += obj.rows[i].price;
				strHtml += "</td><td>";
				strHtml += obj.rows[i].location;
				strHtml += "</td><td>";
				strHtml += obj.rows[i].date;
				strHtml += "</td><td>";
				strHtml += obj.rows[i].state;
				strHtml += "</td></tr>";
				i ++;
			}
			strHtml += "</table>";
			var $foodList = $("#orderList"); 
			$foodList.html(strHtml);
			}).error(function(data){
			alert("系统出错");
		});
		}
		);
</script>
</body>
</html>