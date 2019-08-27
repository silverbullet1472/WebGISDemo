<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <script src="js/jquery-3.4.1.min.js" type="text/javascript"></script>
    <style type="text/css">
        body {
            background: #040f3c;
        }
        input {
            float: left;
            margin: 6px 6px 6px 6px;
            text-align: center;
            color: #fff;
            border: 1px solid #147891;
            background-color: #4545E3;
            border-radius: 6px;
            height: 24px;
            line-height: 22px;
        }
        input::-webkit-input-placeholder, textarea::-webkit-input-placeholder {
            color:    #fff;
        }
        input:-moz-placeholder, textarea:-moz-placeholder {
            color:    #fff;
        }
        input::-moz-placeholder, textarea::-moz-placeholder {
            color:    #fff;
        }
        input:-ms-input-placeholder, textarea:-ms-input-placeholder {
            color:    #fff;
        }
        img {
            margin: 0 0 0 0;
        }
        section {
            text-align: center;
            width: 100%;
            height: 100%;
        }

        button {
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

        a {
            text-decoration: none;
        }

    </style>
    <script type="text/javascript">
        function fileSelected(file) {
            var img = document.getElementById('uploadImg');
            console.log(img);
            if (file.files && file.files[0]) {
                console.log(window.URL.createObjectURL(file.files[0]));
                img.src = window.URL.createObjectURL(file.files[0]);
                console.log(img.src);
            }
        }
    </script>
</head>
<body>
<section>
    <img id="uploadImg" src="img/default.jpg"
         onerror="this.src='img/default.jpg'" width=100% height=60%"
         title="上传图片"/>
    <form id="updateForm" action="UpdateServlet" method="post"
          enctype="multipart/form-data" style="display:inline;">
        <input type="text" name="id" id="id" style="width:45%" placeholder="id">
        <input type="text" name="event" id="event" style="width:45%" placeholder="event"/>
        <input type="text" name="x" id="x" style="width:45%" placeholder="x"/>
        <input type="text" name="y" id="y" style="width:45%" placeholder="y"/>
        <input type="text" name="info" id="info" style="width:95%" placeholder="info"/>
        <input type="file" name="image" id="image" style="width:95%" onchange="fileSelected(this);"/><br/>
        <button type="submit" id="submit" style="width:60%">submit</button>
    </form>
</section>
</body>
</html>
