<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>

<html>
<head>
    <title>注册页</title>
    <script src="js/jquery-3.4.1.min.js" type="text/javascript"></script>
    <link rel="stylesheet" type="text/css" href="css/login.css"/>
    <style type="text/css">
        body {
            background: url(img/register_bg.jpg);
            background-size: 100% 100%;
        }
    </style>
</head>

<body>
<div class="bg">
    <div class="boardLogin">
        <a href="#" class="logo">
            <img src="img/site_logo.png">
        </a>
        <form action="register_check.jsp" method="post">
            <div class="inpGroup">
                <span class="userIcon"></span>
                <input id="email" name="email" type="email" placeholder="Enter email">
            </div>
            <div class="inpGroup">
                <span class="passwordIcon"></span>
                <div>
                    <input id="password" name="password" type="password" placeholder="Password">
                </div>
            </div>
            <div class="inpGroup">

                <span class="passwordIcon"></span>
                <input id="ConfirmPassword" name="confirmpassword" type="password"
                       placeholder="Confirm password">
            </div>
            <input type="submit" class="submit" value="注册" onclick="isSame()"/>
        </form>
        <div>
            <a href="login.jsp">登陆页面</a>
        </div>

    </div>
</div>
<div id="particles-js"></div>
<script>
    function isSame() {
        var email = $("input[name=email]");
        var p1 = $("input[name=password]");
        var p2 = $("input[name=confirmpassword]");
        if (email.val() == '' || p1.val() == '' || p2.val() == '') {
            alert("邮箱或密码不能为空");
        } else if (p1.val() != p2.val()) {
            alert("两次密码不一致！");
        }
    }
</script>
</body>
<script src="js/particles.min.js"></script>
<script src="js/app.js"></script>
</html>
