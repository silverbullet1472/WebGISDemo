<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!doctype html>
<html>
<head>
    <title>Login</title>
    <script src="js/jquery-3.4.1.min.js" type="text/javascript"></script>
    <link rel="stylesheet" type="text/css" href="css/login.css"/>
    <style type="text/css">
        body{
            background: url(img/login_bg.jpg);
            background-size: 100% 100%;
        }
    </style>
</head>
<body>
<script type="text/javascript">
    var loginMsg = '<%=session.getAttribute("loginFailed")%>';
    if (loginMsg != "null") {
        function alertFun() {
            alert("Login Failed!");
        }
    }
    var registerMsg = '<%=session.getAttribute("justRegister")%>';
    if (registerMsg != "null") {
        function alertFun() {
            alert("Register Success!");
        }
    }
</script>
<div class="bg">
    <div class="boardLogin">
        <a href="#" class="logo">
            <img src="img/site_logo.png">
        </a>
        <form id="login" action="login_check.jsp" method="post">
            <div class="inpGroup">
                <span class="userIcon"></span>
                <input id="email" name="email" type="email" placeholder="Enter email">
            </div>
            <div class="inpGroup">
                <span class="passwordIcon"></span>
                <input id="password" name="password" type="password" placeholder="Password">
            </div>
            <input id="loginBtn" class="submit" type="submit" value="登陆" onclick="isEmpty()"/>
        </form>
        <div id="otherBtn">
            <a href="register.jsp">注册账户</a>
            <a href="index.jsp">游客登陆</a>
        </div>
    </div>
</div>
<div id="particles-js"></div>
<script>
    function isEmpty() {
        var u = $("input[name=email]");
        var p = $("input[name=password]");

        if (u.val() == '' || p.val() == '') {
            alert("邮箱或密码不能为空");
        }

    }
</script>
</body>
<script src="js/particles.min.js"></script>
<script src="js/app.js"></script>
<script type="text/javascript"> window.onload = alertFun; </script>
</html>