<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.DJQWeb.JDBCOperation"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ page language="java" import="java.sql.Connection" %>

<%
    String email = request.getParameter("email");
    String password1 = request.getParameter("password");
    String password2 = request.getParameter("confirmpassword");
    JDBCOperation JDBC=new JDBCOperation();
    boolean isValid = false;
    Connection conn = null;// 创建一个数据库连接
    PreparedStatement pstmt = null;// 创建预编译语句对象，一般都是用这个而不用Statement
    ResultSet result = null;// 创建一个结果集对象
    try
    {
        JDBC=new JDBCOperation();
        conn = JDBC.getConn();
        String sql = "select * from account where email=?";// 预编译语句，“？”代表参数
        pstmt = conn.prepareStatement(sql);// 实例化预编译语句
        pstmt.setString(1, email);// 设置参数，前面的1表示参数的索引，而不是表中列名的索引
        result = pstmt.executeQuery();// 执行查询，注意括号中不需要再加参数
        if (!result.next()){
            System.out.println("开始写入！");
            sql = "insert into account(email,password) values(?,?)";// 预编译语句，“？”代表参数
            pstmt = (PreparedStatement)conn.prepareStatement(sql);// 实例化预编译语句
            pstmt.setString(1, email);// 设置参数，前面的1表示参数的索引，而不是表中列名的索引
            pstmt.setString(2, password1);// 设置参数，前面的1表示参数的索引，而不是表中列名的索引
            pstmt.executeUpdate();// 执行
            isValid = true;
        }
    }
    catch (Exception e)
    {
        e.printStackTrace();
    }
    finally
    {
        try
        {
            // 逐一将上面的几个对象关闭，因为不关闭的话会影响性能、并且占用资源
            // 注意关闭的顺序，最后使用的最先关闭
            if (result != null)
                result.close();
            if (pstmt != null)
                pstmt.close();
            if (conn != null)
                conn.close();
            //System.out.println("数据库连接已关闭！");
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }
    if(isValid){
        System.out.println("注册成功，请登录！");
        session.setAttribute("justRegister", "Yes");
        response.sendRedirect("login.jsp");
        //return;
    }else{
        System.out.println("用户名已存在！");
        session.setAttribute("registerFailed", "Yes");
        response.sendRedirect("register.jsp");
        //return;
    }
%>

