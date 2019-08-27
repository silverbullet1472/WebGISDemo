package com.DJQWeb;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class JDBCOperation {
    public static void main( String args[] )
    {

    }

    public Connection getConn() {
        String driver = "org.postgresql.Driver";
        String url = "jdbc:postgresql://localhost:5432/DJQ_db";
        String username = "postgres";
        String password = "postgresql";
        Connection conn = null;
        try {
            Class.forName(driver);
            conn = (Connection) DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return conn;
    }

    public String getData(){
        Connection conn = getConn();
        String sql = "SELECT ST_AsGeoJSON(geom) FROM county";
        String geojson= null;
        try {
            PreparedStatement pstmt;
            pstmt = (PreparedStatement)conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                geojson=rs.getString(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return geojson;
    }

    public String getData(String queryId) throws IOException {
        System.out.println(queryId);
        Connection conn = getConn();
        PreparedStatement pstmt = null;
        String sql = "select * FROM ugc_point WHERE ugc_point.id= "+ queryId;
        System.out.println(sql);
        float x=0;
        float y=0;
        String result="";
        try {
            pstmt = (PreparedStatement) conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                x = rs.getFloat(3);
                y = rs.getFloat(4);
                result = x+","+y;

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

}