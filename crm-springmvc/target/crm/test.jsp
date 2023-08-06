<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
    <meta charset="UTF-8">
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
    <title>文件上传</title>
</head>
<body>
    <form action="workbench/activity/fileUpload.do" method="post" enctype="multipart/form-data">
        <input type="text" name="username"/>
        <input type="file" name="myfile"/>
        <input type="submit" value="提交">
    </form>
</body>
</html>
