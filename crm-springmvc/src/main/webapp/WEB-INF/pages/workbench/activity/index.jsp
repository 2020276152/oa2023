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
		//当市场活动主页面加载完毕，查询所有数据的第一页以及所有数据的总条数，默认每页显示10条记录
		queryActivityByConditionForPage(1,10)

		//为创建市场活动“创建”按钮绑定单击事件
		$("#createActivityBtn").click(function (){
			//在显示创建市场活动的模态进行初始化工作，重置表单
			$("#createActivityForm").get(0).reset()
			$("#createActivityModal").modal("show")
		})
		//为创建市场活动“关闭”按钮绑定单击事件
		$("#closeCreateActivityBtn").click(function (){
			$("#createActivityModal").modal("hide")
		})
		//为创建市场活动“保存”按钮绑定单击事件
		$("#savaCreateActivityBtn").click(function (){
			//获取参数,只要是用户手动输入的参数，都需要前后去空
			var owner = $("#create-marketActivityOwner option:selected").val() //用户的id
			var name = $("#create-marketActivityName").val().trim() //市场活动的名称
			var startDate = $("#create-startTime").val()
			var endDate = $("#create-endTime").val()
			var cost = $("#create-cost").val().trim()
			var description = $("#create-describe").val().trim()
			//表单验证
			isParamCorrect(owner,name,startDate,endDate,cost)
			//发送ajax函数，创建市场活动
			$.ajax({
				url:"workbench/activity/savaCreateActivity.do",
				data:{
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description
				},
				type:"post",
				dataType:"json",
				success:function(returnObject){
					if (returnObject.code==1){
						//关闭模态窗口
						$("#createActivityModal").modal("hide")
						//刷新市场活动列，显示第一页数据
						queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'))
					}else if(returnObject.code==0){
						//不关闭模态窗口，提示信息
						$("#createActivityModal").modal("show")
						console.log(returnObject.msg)
						alert(returnObject.msg)
					}
				},
			})
		})
		//为查询按钮绑定单击事件
		$("#queryActivityBtn").click(function (){
			queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage') )
		})
		//为删除按钮绑定单击事件
		$("#deleteActivityBtn").click(function (){
			//定义一个数组，存储checkbox的value值
			var ids= ''
			$("input[type='checkbox']:checked").each(function(i,e){
				ids+="ids="+e.value+"&"
			})
			ids=ids.substr(0,ids.length-1)

			if (ids.length==0){
				alert("请选择要删除的市场活动")
				return
			}
			var flag = window.confirm("亲，确定要删除吗？")
			if (!flag){
				return
			}
			console.log(ids)
			//发送ajax异步请求删除市场活动
			$.ajax({
				url:"workbench/activity/removeActivity.do",
				data:ids,
				type:"post",
				dataType:"json",
				success:function(returnObject){
					if (returnObject.code==1){
						//删除成功之后，显示市场活动列表，显示第一页数据，保存每页显示条数不变
						queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'))
					}else {
						alert(returnObject.msg)
					}
				}
			})

		})
		//为取消全选和全选checkbox绑定单击事件
		$("#checkboxSwitch").click(function (){
            $("#activity-body input[type='checkbox']").prop('checked',this.checked)
		})

        //为所有动态生成的checkbox元素绑定单击事件
		$("#activity-body").on("click","input[type=checkbox]",function (){
			//做好判断两个数量是否相等，相等则勾选全选按钮，不相等则取消勾选全选按钮
			if($("#activity-body input[type=checkbox]:checked").size()==$("#activity-body input[type=checkbox]").size()){
				$("#checkboxSwitch").prop("checked",true)
			}else {
				$("#checkboxSwitch").prop("checked",false)
			}
		})
		//为修改市场活动按钮创建单击事件
		$("#editActivityBtn").click(function (){
			if($("#activity-body input[type=checkbox]:checked").size()!=1){
				alert("请选择一项市场活动信息")
				return
			}
			$.ajax({
				url:"workbench/activity/queryActivityById.do",
				data:{
					id:$("#activity-body input[type=checkbox]:checked").val(),
				},
				type:"get",
				dataType:"json",
				success:function(data){
					//将要修改的市场活动回显到修改市场活动信息的模态窗口中
					$("#edit-id").val(data.id)
					$("#edit-marketActivityOwner").val(data.owner)
					$("#edit-marketActivityName").val(data.name)
					$("#edit-startTime").val(data.startDate)
					$("#edit-endTime").val(data.endDate)
					$("#edit-describe").val(data.description)
					$("#edit-cost").val(data.cost)
					//显示模态窗口
					$("#editActivityModal").modal("show")
				}
			})
		})
		//为修改市场活动的更新按钮添加单击事件
		$("#updateActivityBtn").click(function (){
			//获取参数
			var id = $("#edit-id").val()
			var owner = $("#edit-marketActivityOwner").val()
			var name = $("#edit-marketActivityName").val().trim()
			var startDate = $("#edit-startTime").val()
			var endDate = $("#edit-endTime").val()
			var description = $("#edit-describe").val().trim()
			var cost= $("#edit-cost").val().trim()
			//表单验证
			isParamCorrect(owner,name,startDate,endDate,cost)
			$.ajax({
				url:"workbench/activity/modifyActivity.do",
				data:{
					id:id,
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					description:description,
					cost:cost
				},
				type:"post",
				dataType:"json",
				success:function(data){
					if (data.code=="1"){
						//关闭模态窗口
						//刷新市场活动列表，保持当前页数不变，保持每页显示记录条数不变
						$("#editActivityModal").modal("hide")
						queryActivityByConditionForPage($("#demo_pag1").bs_pagination('getOption', 'currentPage'),$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'))
					}else {
						alert(data.msg)
					}
				}
			})
		})

		//为"批量导出市场活动按钮"绑定单击事件
		$("#exportActivityAllBtn").click(function (){
			window.location.href="workbench/activity/exportAllActivities.do"
		})
		$("#exportActivityXzBtn").click(function (){
			var checkedActivity = $("#activity-body input[type=checkbox]:checked")
			if (checkedActivity.size()<=0){
				alert("请选择将要导出的市场活动")
				return
			}
			var ids = ''
			$.each(checkedActivity,function (i,e){
				ids+="ids="+e.value+"&"
			})
			ids = ids.substr(0,ids.length-1)
			window.location.href='workbench/activity/exportActivities.do?'+ids
		})
		//为市场活动“导入”按钮添加单击事件
		$("#importActivityBtn").click(function (){
			//表单验证，只允许上传后缀为xsl的文件
			var activityFileName = $("#activityFile").val()	//获取文件原始名称（包括后缀名）
			var suffix = activityFileName.substr(activityFileName.lastIndexOf(".")+1).toLowerCase();
			if (suffix!=="xsl"){
				alert("只支持xsl文件")
				return
			}
			var activityFile = $("#activityFile")[0].files[0];
			//excel文件文件大小不能超过5M
			if (activityFile.size>1024*1024*5){
				alert("文件大小不能超过5MB")
				return
			}
			//发送ajax异步请求
			var formData = new FormData()
			//FormData对象模拟键值对提交数据，可以提交二进制数据
			formData.append("activityFile",activityFile)
			formData.append("username","lisi-formData")
			$.ajax({
				url:"workbench/activity/importActivity.do",
				type:"post",
				data:formData,
				processData:false,
				contentType:false,
				dataType:"json",
				success:function (data){
					if (data.code=="1"){
						//提示成功导入多少条记录
						alert("成功导入"+data.retData+"条数据")
						//刷新市场活动列表
						queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'))
						//关闭模态窗口
						$("#importActivityModal").modal("hide")
					}else if(data.code=="0"){
						//导入失败，模态窗口不关闭，show一下
						$("#importActivityModal").modal("show")
						//提示信息
						alert("系统繁忙，请稍后再试")
					}
				}
			})

		})
	});

	function isParamCorrect(owner,name,startDate,endDate,cost){
		//表单验证
		if (owner=='create-defaulte-selected'){
			alert("所有者不能为空！")
			return;
		}
		if(name==''){
			alert("用户名不能为空")
			return;
		}
		if(startDate!=''||endDate!=''){
			if (new Date(endDate.replace(/-/g, "/"))<new Date(startDate.replace(/-/g, "/"))){
				alert("结束时间不能小于开始时间")
				return;
			}
		}
		var regExp = /^([1-9][0-9]*|0)$/
		if (!regExp.test(cost)){
			alert("成本只能是非负整数")
			return;
		}
	}
	function queryActivityByConditionForPage (pageNum,pageSize){
		//收集参数
		var name =$("#query-name").val()
		var owner=$("#query-owner").val()
		var startDate=$("#query-startDate").val()
		var endDate = $("#query-endDate").val()
		//发送ajax异步请求，局部刷新页码
		$.ajax({
			url:"workbench/activity/queryActivityByConditionForPage.do",
			data:{
				name:name,
				owner:owner,
				startDate:startDate,
				endDate:endDate,
				pageNum:pageNum,
				pageSize:pageSize
			},
			type:"post",
			dataType:"json",
			success:function(returnObject){
				var activityList =  returnObject.activityList
				var totalRows = returnObject.totalRows
				var htmlBody = ''
				$.each(activityList,function (i,e){
					htmlBody+="<tr class='active'>"
					htmlBody+="<td><input type='checkbox' value='"+e.id+"'/></td>"
					htmlBody+="<td><a style='text-decoration: none; cursor: pointer;' onclick='queryActivityDetailByActivityId(&quot;"+e.id+"&quot;)'>"+e.name+ "</a></td>"
					htmlBody+="<td>"+e.owner+"</td>"
					htmlBody+="<td>"+e.startDate+"</td>"
					htmlBody+="<td>"+e.endDate+"</td>"
					htmlBody+="</tr>"
				})
				//回显市场活动
				$("#activity-body").html(htmlBody)
				//需要总记录条数，因此在success中肯定拿到了总记录条数
				//使用bs_pagination维护翻页,显示翻页信息
				$("#demo_pag1").bs_pagination({
					currentPage: pageNum, // 当前页码
					rowsPerPage:pageSize, //每页显示条数
					totalPages: Math.ceil(totalRows/pageSize), //总页数（这个一定要写，自己根据“总记录条数”和”每页显示条数“计算，，切记，框架问题）
					totalRows: totalRows, //数据总条数
					visiblePageLinks: 5,// 可视化的页码小卡片，大于5时显示5个，小于5时，显示小于5的个数

					showGoToPage: true,//是否显示“跳转到”的部分，默认显示true
					showRowsPerPage:true,//是否显示“每页显示条数”的部分，默认显示true
					showRowsInfo:true,//是否显示记录的信息，默认true
					onChangePage:function(event,pageObj){  //当前页码或者显示数据总条数发生变动，触发此函数，发送ajax请求，根据页码和显示记录条数查询
						//event是事件对象
						//pageObj存储了当页码发生变动后的currentPage和rowsPerPage
						queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage)
						$("#checkboxSwitch").prop('checked',false)
					}
				});
			}
		})
	}
	function queryActivityDetailByActivityId(id){
		window.location.href="workbench/activity/activityDetail.do?id="+id
	}


</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="createActivityForm">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
									<option value="create-defaulte-selected">--请选择--</option>
									<c:forEach items="${requestScope.userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="date" class="form-control" id="create-startTime">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="date" class="form-control" id="create-endTime">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" id="closeCreateActivityBtn">关闭</button>
					<button type="button" class="btn btn-primary" id="savaCreateActivityBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
									<option id="edit-owner"></option>
									<c:forEach items="${requestScope.userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="date" class="form-control" id="edit-startTime" value="">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="date" class="form-control"  id="edit-endTime" value="">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateActivityBtn" >更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile" >
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
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
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="date" id="query-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="date" id="query-endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryActivityBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createActivityBtn" data-target="#createActivityModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editActivityBtn" data-target="#editActivityModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
					<button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
					<button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkboxSwitch" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activity-body">
					</tbody>
				</table>
				<div id="demo_pag1"></div>
			</div>
			<%--
			<div style="height: 50px; position: relative;top: 30px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="activity-totalRows">50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>
			</div>
			--%>
			
		</div>
		
	</div>
</body>
</html>