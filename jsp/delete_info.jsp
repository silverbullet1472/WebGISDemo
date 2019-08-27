<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <script src="js/jquery-3.4.1.min.js" type="text/javascript"></script>
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
<div id="hover" align="center">
    <a href="javascript:fileSelect();">
        <img id="uploadImg" src="img/uploadImage.png"
             onerror="this.src='img/uploadImage.png'" width=100px height=100px
             title="上传图片"/>
    </a>
    <form id="updateForm" action="DeleteServlet" method="post"
          enctype="multipart/form-data" style="display:none;">
        id:<input type="text" name="id" id="id"><br/>
        event:<input type="text" name="event" id="event"/><br/>
        x:<input type="text" name="x" id="x"/><br/>
        y:<input type="text" name="y" id="y"/><br/>
        imag:<input type="file" name="image" id="image" onchange="fileSelected(this);"/><br/>
        info:<input type="text" name="info" id="info"/>
        <button type="submit" id="submit">submit</button>
    </form>
</div>
</body>
</html>