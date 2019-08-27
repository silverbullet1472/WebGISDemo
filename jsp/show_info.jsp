<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.DJQWeb.JDBCOperation" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="sun.misc.BASE64Encoder" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Show Info</title>
    <style type="text/css">
        body{
            background: #040f3c;
        }
        div{
            float: left;
            margin: 6px 6px 6px 6px;
            text-align: center;
            color: #fff;
            border: 1px solid #147891;
            background-color: #4545E3;
            border-radius: 6px;
        }
        img{
            margin: 6px 0 6px 0;
        }
        section {
            text-align: center;
            width: 100%;
            height: 100%;
        }
        button{
            margin: 2px 4px 2px 4px;
            box-sizing: border-box;
            height: 24px;
            text-align: center;
            background: #4545E3;
            border: 1px solid #147891;
            border-radius: 6px;
            color: #fff;
            cursor: pointer;
            -webkit-transition: 0.3s ease-in-out;
            -moz-transition: 0.3s ease-in-out;
            -ms-transition: 0.3s ease-in-out;
            -o-transition: 0.3s ease-in-out;
            transition: 0.3s ease-in-out;
        }
        a{
            text-decoration:none;
        }
    </style>
    <script src="js/jquery-3.4.1.min.js" type="text/javascript"></script>
    <%
        int id = Integer.parseInt(request.getParameter("ID"));
        String event = "";
        float x = 0;
        float y = 0;
        String info = "";
        byte[] imageData;
        JDBCOperation op = new JDBCOperation();
        Connection conn = op.getConn();
        PreparedStatement pstmt = null;
        BASE64Encoder encoder = new BASE64Encoder();
        String data = "";
        try {
            String sql = "select * FROM ugc_point WHERE id= ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                event = rs.getString(2);
                x = rs.getFloat(3);
                y = rs.getFloat(4);
                imageData= rs.getBytes(5);
                System.out.println(imageData);
                data = encoder.encode(imageData);//比特转换为BASE64String
                info = rs.getString(6);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null)
                pstmt.close();
            if (conn != null)
                conn.close();
        }
    %>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#testBtn").click(function () {
                $.ajax({
                    type: "get",
                    url: "TestServlet",
                    async: true,
                    success: function (result) {
                        $("#div1").html(result);

                        var geojsonObject = result;
                        var vectorSource = new ol.source.Vector({
                            features: (new ol.format.GeoJSON()).readFeatures(geojsonObject)
                        });

                        var queryLayer = new ol.layer.Vector({
                            title: 'Queryed Geojson Layer',
                            source: vectorSource
                        });

                        map.addLayer(queryLayer);
                    }
                });
            });
        });
    </script>
</head>
<body>
<section>
    <div id="id" style="width:45%" >Id: <%= id %></div>
    <div id="event" style="width: 45%" >Event: <%= event %></div>
    <div id="x" style="width: 45%" >X: <%= x %></div>
    <div id="y" style="width: 45%" >Y: <%= y %> </div>
    <img id="pic" src="data:image/jpg;base64,<%= data %>"
         onerror="this.src='img/default.jpg'" width=100% height=60% />
    <div id="info" style="width: 90%">Info: <%= info %> </div>
    <a href="update_info.jsp?ID=<%= id %>" >
        <button id="updateBtn" style="width:30%" >Update</button>
    </a>
    <a href="DeleteServlet?ID=<%= id %>" >
        <button id="deleteBtn" style="width:30%">Delete</button>
    </a>
</section>
</body>
</html>
