<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
	<meta charset="UTF-8">
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

	/*	动态生成的元素使用传统的事件添加方式无法生效，需要使用父子选择器
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
	*/

		$("#clueRemarkDiv").on("mouseover",".remarkDiv",function (){
			$(this).children("div").children("div").show();
		})

		/*
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		 */
		$("#clueRemarkDiv").on("mouseout",".remarkDiv",function (){
			$(this).children("div").children("div").hide();
		})

		/*
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		*/

		$("#clueRemarkDiv").on("mouseover",".myHref",function (){
			$(this).children("span").css("color","red");
		})
		
		/*
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});
		*/

		$("#clueRemarkDiv").on("mouseout",".myHref",function (){
			$(this).children("span").css("color","#E6E6E6");
		})

        //为“解除市场活动”按钮添加单击事件
        $("#associatedActivity-table").on("click","a",function (){
            var clueId ="${requestScope.clue.id}"
            var activityId = $(this).attr("activityId")
            console.log("56行--clueId="+clueId)
            console.log("57行--activityId="+activityId)
			//发送ajax请求解除关联
			$.ajax({
				url:"workbench/clue/removeACRelationByClueIdAndActivityId.do",
				data:{
					clueId:clueId,
					activityId:activityId
				},
				type:"post",
				dataType:"json",
				success:function(data){
					if (data.code=='1'){
						//解除成功后，刷新关联页面
						$("#associated_"+activityId).remove()
					}else if (data.code=='0'){
						alert(data.msg)
					}
				}
			})
        })

		//为“关联市场活动”按钮，添加单击事件
		$("#toAssociateActivity").click(function (){
			//初始化工作
			//清空搜索框
			$("#activityNameForAssociate").val("")
			//清空列表
			$("#disassociated-body").html("")
			//重置全选和取消全选按钮
			$("#contrlAllCheckBox").prop("checked",false)
			//发送ajax请求，查询可供关联的市场活动信息,要求已关联的不显示在关联页面上
			$("#bundModal").modal("show")
		})

		//为添加备注的“保存”按钮 添加单击事件
		$("#saveCreateRemark").click(function (){
			var clueId = "${requestScope.clue.id}"
			var noteContent = $("#remark").val().trim()
			if (remark==''){
				alert("备注不能为空")
				return
			}
			//发送ajax请求，添加备注
			$.ajax({
				url:"workbench/clue/saveCreateClueRemark.do",
				data:{
					clueId:clueId,
					noteContent:noteContent
				},
				type:"post",
				dataType:"json",
				success:function(data){
					if (data.code=="1"){
						var clueRemark = data.retData
						//将新添加的备注加到所有备注的最后
						var clueRemarkHtml = ''
							clueRemarkHtml+="<div id=\"div_"+clueRemark.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">"
							clueRemarkHtml+="<img title=\"zhangsan\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">"
							clueRemarkHtml+="<div style=\"position: relative; top: -40px; left: 40px;\" >"
							clueRemarkHtml+="<h5>"+clueRemark.noteContent+"</h5>"
							clueRemarkHtml+="<font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b>${requestScope.clue.fullname}${requestScope.clue.appellation}"+"-${requestScope.clue.company}"+"</b> <small style=\"color: gray;\"> "+clueRemark.createTime+" 由${sessionScope.sessionUser.name}创建</small>"
							clueRemarkHtml+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">"
							clueRemarkHtml+="<a class=\"myHref\" name='editA' remarkId=\""+clueRemark.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>"
							clueRemarkHtml+="&nbsp;&nbsp;&nbsp;&nbsp;"
							clueRemarkHtml+="<a class=\"myHref\" name='deleteA' remarkId=\""+clueRemark.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>"
							clueRemarkHtml+="</div>"
							clueRemarkHtml+="</div>"
							clueRemarkHtml+="</div>"
							$("#remarkDiv").before(clueRemarkHtml)
							//清空添加备注的输入框
						    $("#remark").val("")
					}else if(data.code=="0"){
							alert(data.msg)
					}
				}
			})
		})

		//键盘弹起，自动动态搜索
		$("#activityNameForAssociate").keyup(function (){
			//重置全选和取消全选按钮
			$("#contrlAllCheckBox").prop("checked",false)
			//动态搜索市场活动
			queryDisassociatedActivity()
		})

		//为"关联"按钮绑定单击事件，关联市场活动信息
		$("#associateBtn").click(function (){
			var activities = $("#disassociated-body input[type=checkbox]:checked")
			var clueId = "${requestScope.clue.id}"
			var parm = 'clueId='+clueId
			if (activities.size()==0){
				alert("至少关联一个市场活动")
				return
			}
			$.each(activities,function (i,e){
				parm+="&activityIds="+e.value
			})
			//发送ajax请求，关联市场活动信息
			$.ajax({
				url:"workbench/clue/saveCreateACRelationByList.do",
				data:parm,
				type:"post",
				dataType:"json",
				success:function(data){
					//判断是否关联成功
					//关联成功，retData存储了关联成功的市场活动信息，映射到市场活动信息的div当中
					//关闭关联市场活动的模态窗口
					if (data.code=='1'){
						var activityList =  data.retData
						var activitiesHtml=''
						$.each(activityList,function (i,e){
						activitiesHtml+="<tr id=\"associated_"+e.id+"\">"
						activitiesHtml+="<td>"+e.name+"</td>"
						activitiesHtml+="<td>"+e.startDate+"</td>"
						activitiesHtml+="<td>"+e.endDate+"</td>"
						activitiesHtml+="<td>"+e.owner+"</td>"
						activitiesHtml+="<td><a href=\"javascript:void(0);\" activityId=\""+e.id+"\"  style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>"
						activitiesHtml+="</tr>"
						})
						$("#associated-activityFtr").after(activitiesHtml)
						$("#bundModal").modal("hide")
					}else if (data.code=='0'){
						alert(data.msg)
					}
				}
			})
		})
		$("#contrlAllCheckBox").click(function (){
			//所有checkbox的checked属性跟着全选的属性走
			$("#disassociated-body input[type=checkbox]").prop("checked",this.checked)
		})
		$("#disassociated-body").on("click","input[type=checkbox]",function (){
			if ($("#disassociated-body input[type=checkbox]:checked").size()==$("#disassociated-body input[type=checkbox]").size()){
				$("#contrlAllCheckBox").prop("checked",true)
			}else {
				$("#contrlAllCheckBox").prop("checked",false)
			}
		})
	});

	function queryDisassociatedActivity(){
		var activityName = $("#activityNameForAssociate").val()
		var clueId = "${requestScope.clue.id}"
		if (activityName==""){
			return
		}
		$.ajax({
			url:"workbench/clue/queryActivityForAssociation.do",
			data:{
				activityName:activityName,
				clueId:clueId
			},
			type:"get",
			dataType:"json",
			success:function(data){
				if (data.code=="1"){
					var htmlBody = ''
					var dissociatedActivityList = data.retData
					$.each(dissociatedActivityList,function (i,e){
						htmlBody+="<tr id=\""+e.id+"\">"
						htmlBody+="<td><input type=\"checkbox\"value=\""+e.id+"\" /></td>"
						htmlBody+="<td>"+e.name+"</td>"
						htmlBody+="<td>"+e.startDate+"</td>"
						htmlBody+="<td>"+e.endDate+"</td>"
						htmlBody+="<td>"+e.owner+"</td>"
						htmlBody+="</tr>"
					})
					$("#disassociated-body").html(htmlBody)
				}else if(data.code=="0"){
					alert(data.msg)
				}
			}
		})
	}
</script>

</head>
<body>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="activityNameForAssociate" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;" >
								<td><input type="checkbox" id="contrlAllCheckBox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="disassociated-body">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="associateBtn" type="button" class="btn btn-primary">关联</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${requestScope.clue.fullname}${requestScope.clue.appellation} <small>${requestScope.clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='convert.html';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.fullname}${requestScope.clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${requestScope.clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="clueRemarkDiv" style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${requestScope.clueRemarkList}" var="clueRemark">
			<div id="div_${clueRemark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${clueRemark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${clueRemark.noteContent}</h5>
					<font color="gray">线索</font> <font color="gray">-</font> <b>${requestScope.clue.fullname}${requestScope.clue.appellation}-${requestScope.clue.company}</b> <small style="color: gray;"> ${clueRemark.editFlag==0?clueRemark.createTime:clueRemark.editTime} 由${clueRemark.editFlag==0?clueRemark.createBy:clueRemark.editBy}${clueRemark.editFlag==0?"创建":"修改"}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" name="eidtA" remarkid="${clueRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" name="deleteA" remarkid="${clueRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveCreateRemark" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;" id="associatedActivity-table">
					<thead>
						<tr style="color: #B3B3B3;" id="associated-activityFtr">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody>
                        <c:forEach items="${requestScope.associatedActivityList}" var="activity">
                            <tr id="associated_${activity.id}">
                                <td>${activity.name}</td>
                                <td>${activity.startDate}</td>
                                <td>${activity.endDate}</td>
                                <td>${activity.owner}</td>
                                <td><a href="javascript:void(0);" activityId="${activity.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                            </tr>
                        </c:forEach>
					</tbody>
				</table>
			</div>
			
			<div><%--data-toggle="modal" data-target="#bundModal"--%>
				<a href="javascript:void(0);" id="toAssociateActivity" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>