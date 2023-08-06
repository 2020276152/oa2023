<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
	<meta charset="UTF-8">
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<!--  PAGINATION plugin -->
	<link rel="stylesheet" charset="UTF-8" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
	<script type="text/javascript" charset="UTF-8" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" charset="UTF-8" src="jquery/bs_pagination-master/localization/en.js"></script>
<script type="text/javascript">


	$(function(){

		console.log(11111111)

		//入口函数加载完毕
		queryAllClueByConditionForPage(1,10)

		//为创建线索"创建"按钮添加单击事件
		$("#creteClueBtn").click(function (){
			//弹出创建线索模态窗口
			$("#createClueModal").modal("show")
		})

		//为创建线索的"创建"按钮添加单击事件
		$("#saveCreateClueBtn").click(function (){
			//收集参数
			var owner = $("#create-clueOwner option:selected").val()
			var company = $("#create-company").val().trim() //必填
			var appellation = $("#create-call option:selected").val()
			var fullname = $("#create-surname").val().trim() //必填
			var job = $("#create-job").val().trim()
			var email = $("#create-email").val().trim()//正则验证
			var phone = $("#create-phone").val().trim()//正则验证
			var website = $("#create-website").val().trim()
			var mphone = $("#create-mphone").val().trim()//正则验证
			var state = $("#create-status option:selected").val()
			var description =$("#create-describe").val().trim()
			var contactSummary = $("#create-contactSummary").val().trim()
			var nextContactTime = $("#create-nextContactTime").val().trim()
			var address = $("#create-address").val().trim()
			var source =$("#create-source option:selected").val()

			//表单验证
			var regExpForEmail = /^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/
			var regExpForPhone = /^0\d{2}(?:-?\d{8}|-?\d{7})$/
			var regExpForMphone = /^((13[0-9])|(14[579])|(15[0-35-9])|(16[6])|(17[0135678])|(18[0-9])|(19[89]))\d{8}$/
			if(owner==""){
				alert("所有者不能为空")
				return
			}else if(company==""){
				alert("公司不能为空")
				return
			}else if (fullname==""){
				alert("姓名不能为空")
				return
			}
			if (email!=""){
				if (!regExpForEmail.test(email)){
					alert("邮箱格式错误，请重新输入")
					return
				}
			}
			if (phone!=""){
				if (!regExpForPhone.test(phone)){
					alert("电话号格式错误，请重新输入")
					return
				}
			}
			if (mphone!=""){
				if (!regExpForMphone.test(mphone)){
					alert("手机号格式错误，请重新输入")
					return
				}
			}

			//发送ajax请求创建线索，创建成功关闭模态窗口，跳转到第一页，保存每页显示记录条数不变
			$.ajax({
				url:"workbench/clue/saveCreateClue.do",
				data:{
					owner:owner,
					company:company,
					appellation:appellation,
					fullname:fullname,
					job:job,
					email:email,
					phone:phone,
					website:website,
					mphone:mphone,
					state:state,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address,
					source:source
				},
				type:"post",
				dataType:"json",
				success:function(data){
					if (data.code=="1"){
						//关闭创建线索的模态窗口
						$("#createClueModal").modal("hide")
						//清空创建线索的表单
						$("#createClueForm")[0].reset()
						//刷新线索，线索第一页，保存每页显示记录条数不变
						queryAllClueByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'))
					}else if(data.code=="0"){
						//提示信息
						alert(data.msg)
						//不关闭模态窗口,不清空表单信息
						$("#createClueModal").modal("show")
					}
				}
			})
		})

		//为模糊查询"按钮"添加单击按钮
		$("#query-btn").click(function (){
			queryAllClueByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'))
		})

	});

	function queryAllClueByConditionForPage(pageNum,pageSize){
		//获取参数
		var fullname = $("#query-fullname").val()
		var company = $("#query-company").val()
		var phone = $("#query-phone").val()
		var source = $("#query-source option:selected").text()
		var owner = $("#query-owner").val()
		var mphone = $("#query-mphone").val()
		var state = $("#query-state option:selected").text()
		//发送ajax请求，显示所有线索数据的10条数据
		$.ajax({
			url:"workbench/clue/queryAllClueByConditionForPage.do",
			data:{
				fullname:fullname,
				company:company,
				phone:phone,
				source:source,
				owner:owner,
				mphone:mphone,
				state:state,
				pageNum:pageNum,
				pageSize:pageSize
			},
			type:"get",
			dataType:"json",
			success:function(data){
				//解析数据
				var clueList = data.clueList
				var rows = data.rows
				//渲染页面
				var tbodyHtml = ''
				$.each(clueList,function (i,e){
					tbodyHtml+="<tr>"
					tbodyHtml+="<td><input type=\"checkbox\" value=\""+e.id+"\" /></td>"
					tbodyHtml+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"queryClueForDetailById(&quot;"+e.id+"&quot;)\">"+e.fullname+e.appellation+"</a></td>"
					tbodyHtml+="<td>"+e.company+"</td>"
					tbodyHtml+="<td>"+e.phone+"</td>"
					tbodyHtml+="<td>"+e.mphone+"</td>"
					tbodyHtml+="<td>"+e.source+"</td>"
					tbodyHtml+="<td>"+e.owner+"</td>"
					tbodyHtml+="<td>"+e.state+"</td>"
					tbodyHtml+="</tr>"
				})
				$("#tbody-clue").html(tbodyHtml)
				$("#demo_pag1").bs_pagination({
					currentPage: pageNum, // 当前页码
					rowsPerPage:pageSize, //每页显示条数
					totalPages:Math.ceil(rows/pageSize), //总页数（这个一定要写，自己根据“总记录条数”和”每页显示条数“计算，，切记，框架问题）
					totalRows:rows, //数据总条数
					visiblePageLinks: 5,// 可视化的页码小卡片，大于5时显示5个，小于5时，显示小于5的个数

					showGoToPage:true,//是否显示“跳转到”的部分，默认显示true
					showRowsPerPage:true,//是否显示“每页显示条数”的部分，默认显示true
					showRowsInfo:true,//是否显示记录的信息，默认true
					onChangePage:function(event,pageObj){  //当前页码发生变动，触发此函数
						//event是事件对象
						//pageObj存储了当页码发生变动后的currentPage和rowsPerPage
						//在此可以发送ajax异步请求，发送“页码”和“每页显示记录条数”到服务器，返回数据
						queryAllClueByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage)
					}
				});
			}
		})

	}

	//根据线索id查询线索明细
	function queryClueForDetailById(id){
		window.location.href="workbench/clue/queryClueDetailById.do?id="+id
	}

	
</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createClueForm">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">
									<option value="">--请选择--</option>
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
									<option value="">---请选择---</option>
									<c:forEach items="${requestScope.appellationList}" var="appellation">
										<%--每一个数据字典值对应一个id，用户选择的实际是数据字典值的value，向后台提交的实际是数据字典值的id--%>
										<option value="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-status">
									<option value="">---请选择---</option>
									<c:forEach items="${requestScope.clueStateList}" var="clueState">
										<option value="${clueState.id}">${clueState.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option value=" ">---请选择---</option>
									<c:forEach items="${requestScope.sourceList}" var="source"  >
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateClueBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
									<option value=" ">--请选择--</option>
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
									<!--
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								  -->
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
									<option value=" ">---请选择---</option>
									<c:forEach items="${requestScope.appellationList}" var="appellation">
										<%--每一个数据字典值对应一个id，用户选择的实际是数据字典值的value，向后台提交的实际是数据字典值的id--%>
										<option value="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
									<option value=" ">---请选择---</option>
									<c:forEach items="${requestScope.clueStateList}" var="clueState">
										<option value="${clueState.id}">${clueState.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
									<option value="">---请选择---</option>
									<c:forEach items="${requestScope.sourceList}" var="source"  >
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="query-fullname" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input id="query-company" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input id="query-phone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select id="query-source" class="form-control">
						  <option value=""></option>
						  <c:forEach items="${requestScope.sourceList}" var="source"  >
							  <option value="${source.id}">${source.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="query-owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input id="query-mphone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select id="query-state" class="form-control">
						  <option value=""></option>
						  <c:forEach items="${requestScope.clueStateList}" var="clueState">
							  <option value="${clueState.id}">${clueState.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button  type="button" id="query-btn" class="btn btn-default">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createClueModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editClueModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="tbody-clue">
						<!--
						<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
							<td>动力节点</td>
							<td>010-84846003</td>
							<td>12345678901</td>
							<td>广告</td>
							<td>zhangsan</td>
							<td>已联系</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
                            <td>动力节点</td>
                            <td>010-84846003</td>
                            <td>12345678901</td>
                            <td>广告</td>
                            <td>zhangsan</td>
                            <td>已联系</td>
                        </tr>
						-->
					</tbody>
				</table>
				<div id="demo_pag1"></div>
			</div>


			
		</div>

		
	</div>
</body>
</html>