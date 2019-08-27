package com.DJQWeb.servlet;

import com.DJQWeb.JDBCOperation;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

public class UpdateServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        JDBCOperation op = new JDBCOperation();
        try {
            // 解析请求的内容提取文件数据
            List<FileItem> formItems = upload.parseRequest(request);
            int id = 1;
            String event = "";
            float x = 0;
            float y = 0;
            InputStream inputImg = null;
            String info = "";
            for (FileItem item : formItems) {
                // 处理在表单中的字段
                if (item.isFormField()) {
                    switch (item.getFieldName()) {
                        case "id":
                            id = Integer.parseInt(item.getString());
                            break;
                        case "event":
                            event = item.getString("UTF-8");
                            break;
                        case "x":
                            x = Float.parseFloat(item.getString());
                            break;
                        case "y":
                            y = Float.parseFloat(item.getString());
                            break;
                        case "info":
                            info = item.getString("UTF-8");
                            break;
                    }
                } else {
                    inputImg = item.getInputStream();
                }
            }
            Connection conn = op.getConn();
            String sql = "UPDATE ugc_point SET event = ?,x = ?,y = ?,pic = ?,info=? WHERE id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, event);
            pstmt.setFloat(2, x);
            pstmt.setFloat(3, y);
            pstmt.setBinaryStream(4, inputImg, inputImg.available());
            pstmt.setString(5, info);
            pstmt.setInt(6, id);
            if (inputImg.available() != 0) {
                pstmt.execute();
            }
            PrintWriter out = response.getWriter();
            out.write("Update Success");
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
            PrintWriter out = response.getWriter();
            out.write("Update Failed");
            out.close();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.print("doGet");
        PrintWriter out = response.getWriter();
        out.println("doGet");
        out.close();
    }
}
