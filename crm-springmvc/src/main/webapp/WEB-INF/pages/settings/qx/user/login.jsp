<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<meta charset="UTF-8">
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
</head>
<body>
<script type="text/javascript">
	$(()=>{
		//如果cookie中有值，则默认选中记住密码
		if ($("#loginPwd").val()!=""&&$("#loginAct").val()!=""){
			$("#isRemPwd").prop("checked",true)
		}else{
			$("#isRemPwd").prop("checked",false)
		}
		function longin(){
			var flag = true
			var loginAct = $("#loginAct").val().trim()
			var loginPwd = $("#loginPwd").val().trim()
			if (loginAct==""||loginPwd==""){
				flag=false
			}
			if(flag){
				/*验证登录，发生ajax函数，验证账户是否合格*/
				$.ajax({
					url:"settings/qx/user/login.do",// http://127.0.0.1:8080/crm/+
					data:{
						loginAct:loginAct,
						loginPwd:loginPwd,
						isRemPwd:$("#isRemPwd").prop("checked"),
					},
					type:"post",
					dataType:"json",
					success:function (returnObject){
						if(returnObject.code==='0'){
							$("#msg").html(returnObject.msg)
						}else if(returnObject.code==='1'){
							//成功了，跳转到页面：workbench/index.jsp页面
							window.location.href="workbench/index.do"
						}
					},
					beforeSend:function (){
						$("#msg").html("正在努力验证...")
					}
				})
			}else {
				$("#msg").html("用户名和密码不能为空！")
			}
		}
		$("#btn").click(()=>{
			longin()
		})
		/*窗口绑定事件，按回车键提交表单*/
		$(window).keydown((event)=>{
			if (event.keyCode===13){
				if ($("#loginAct").val()==''){
					$("#loginAct").focus()
				}else if($("#loginPwd").val()==''){
					$("#loginPwd").focus()
				}else{
					longin()
				}
			}
		})
		/*文本框获得焦点，清空错误提示信息*/
		$(".form-control").focus(()=>{
			$("#msg").html("")
		})


	})
</script>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2019&nbsp;动力节点</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form id ='form' action="workbench/index.html" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input id="loginAct" class="form-control" type="text" value="${cookie.loginAct.value}" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input id="loginPwd" class="form-control" type="password" value="${cookie.loginPwd.value}" placeholder="密码">
					</div>
					<div class="checkbox" style="position: relative;top: 30px; left: 10px;">
						<label>
							<input id="isRemPwd" type="checkbox"> 十天内免登录
						</label>
						&nbsp;&nbsp;
						<span id="msg" style="color: red"></span>
					</div>
				</div>
			</form>
			<button id="btn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
		</div>
	</div>
</body>
</html>