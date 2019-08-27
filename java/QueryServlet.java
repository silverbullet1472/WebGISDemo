package com.DJQWeb.servlet;

import com.DJQWeb.JDBCOperation;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class QueryServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        response.setContentType("text/html;charset=utf-8");
        response.setCharacterEncoding("utf-8");
        String queryId = request.getParameter("NAME");
        JDBCOperation op = new JDBCOperation();
        String result = op.getData(queryId);
        PrintWriter out = response.getWriter();
        out.println(result);
        out.close();
    }
}
