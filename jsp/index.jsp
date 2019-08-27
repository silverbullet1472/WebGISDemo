<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>

<!doctype html>
<html>
<head>
    <link rel="stylesheet" href="ol3/ol.css" type="text/css">
    <link rel="stylesheet" href="css/sidenav.css">
    <link rel="stylesheet" href="css/index.css">
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/stat.css"/>
    <title>Leaf Vein</title>
    <script src="ol3/ol.js" type="text/javascript"></script>
    <script src="js/jquery-3.4.1.min.js" type="text/javascript"></script>
    <script src="js/echarts.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var userName = '<%=session.getAttribute("email")%>';
            if (userName != "null") {
                $("#user_name").html(userName);
            } else {
                $("#user_name").html("Visitor");
            }
            $("#queryBtn").click(function () {
                var queryId = $("#queryInput").val();
                $.ajax({
                    type: "get",
                    data:
                        {
                            "NAME": queryId
                        },
                    url: "QueryServlet",
                    async: true,
                    success: function (result) {
                        var data = result.split(",");
                        var x = parseFloat(data[0]);
                        var y = parseFloat(data[1]);
                        //创建图标特性
                        var iconFeature = new ol.Feature({
                            geometry: new ol.geom.Point([x,y], "XY"),
                            name: "my Icon",
                        });
                        //将图标特性添加进矢量中
                        iconSource.addFeature(iconFeature);
                        var iconStyle = new ol.style.Style({
                            image: new ol.style.Icon({
                                opacity: 0.75,
                                src: "img/pin.png"
                            })
                        });
                        //创建矢量层
                        var iconLayer = new ol.layer.Vector({
                            source: iconSource,
                            style: iconStyle
                        });
                        map.addLayer(iconLayer);
                        $("#infoJsp").attr("src", "show_info.jsp?ID=" + queryId);
                    }
                });
            });

            $("#uploadBtn").click(function () {
                $("#infoJsp").attr("src", "upload_info.jsp");
            });
        });
    </script>
</head>
<body>
<!--侧栏界面设计-->
<div id="mySidenav" class="sidenav">
    <a href="javascript:void(0)" class="closebtn" onclick="closeNav()">&times;</a>
    <a href="#map" onclick="closeNav()" >Map</a>
    <a href="#stat"  onclick="closeNav()" >Stat</a>
    <a href="#about"  onclick="closeNav()" >About</a>
</div>
<div id="main">
    <span style="font-size:18px;cursor:pointer" onclick="openNav()">&#9776; Leaf Vein 生态信息WebGIS系统</span>
    <a href="login.jsp" style="font-size:16px;float: right;margin-right: 32px;color: #FFFFFF">Exit</a>
    <div id="user_name" style="font-size:16px;float: right;margin-right: 18px" >Username</div>
</div>
<script type="text/javascript" src="js/sidenav.js"></script>
<!--地图-->
<section id="map">
    <div class="sept" id="mapContainer">
        <div id="popup">
            <a href="#" id="popup-closer"></a>
            <div id="popup-content"><p>你点击的坐标为：</p></div>
        </div>
        <script>
            var bounds = [73.441277, 18.159829, 135.08693, 53.561771];//范围
            //中国各省底图（面）
            var imageMap = new ol.layer.Image({
                source: new ol.source.ImageWMS({
                    ratio: 1,
                    //自己的服务url
                    url: 'http://localhost:8080/geoserver/DJQWP/wms',
                    //设置服务参数
                    params: {
                        'FORMAT': 'image/png',
                        'VERSION': '1.1.0',
                        STYLES: '',
                        //图层信息
                        LAYERS: 'boundarychn',
                    }
                })
            });

            function createStyle(feature) {
                var score = feature.get('score');
                return new ol.style.Style({
                    geometry: feature.getGeometry(),
                    fill: new ol.style.Fill({
                        color: [20, score *2, 115, 0.95]
                    })
                });
            }
            var jsonSource = new ol.source.Vector({
                url: 'json/GeoJSON_Chn.json',
                format: new ol.format.GeoJSON()
            });
            var jsonLayer = new ol.layer.Vector({
                title: 'Geojson Layer',
                source: jsonSource,
                style:  function (feature) {
                    return createStyle(feature);
                }
            });

            var osmSource = new ol.source.OSM();
            var osmLayer = new ol.layer.Tile({
                source: osmSource
            });

            //设置地图投影
            var projection = new ol.proj.Projection({
                code: 'EPSG:4326',//投影编码
                units: 'degrees',
                axisOrientation: 'neu'
            });
            //空间查询动效
            function styleFunction(feature, isSelect) {
                var featureName = "";
                var featureColor = "rgba(70, 70, 227, 0.95)";
                if (isSelect == true) {
                    featureName = feature.get("name");
                    featureColor = "rgba(70, 70, 227, 0.95)";
                    isSelect = false;
                }
                featureName = map.getView().getZoom() > 4 ? featureName : "";
                console.log(featureName);
                return new ol.style.Style({
                    fill: new ol.style.Fill({ //矢量图层填充颜色，以及透明度
                        color: featureColor
                    }),
                    text: new ol.style.Text({ //文本样式
                        text: featureName,
                        font: '12px Calibri,sans-serif'
                    })
                });
            }
            //select
            var select = new ol.interaction.Select({
                layers: [jsonLayer],
                multi: true,
                style: function (feature) {
                    return styleFunction(feature, true);
                }
            });
            select.on("select", function (e) {
                var features=e.selected;
                var feature=features[0];
                var attribute=  feature.getProperties();
                var temp=attribute["score"];
                console.log(feature.getProperties());
                alert(temp);
            });
            //marker
            var iconSource = new ol.source.Vector({});

            //popup
            var container = document.getElementById("popup");
            var content = document.getElementById("popup-content");
            var popupCloser = document.getElementById("popup-closer");

            var overlay = new ol.Overlay({
                //设置弹出框的容器
                element: container,
                //是否自动平移，即假如标记在屏幕边缘，弹出时自动平移地图使弹出框完全可见
                autoPan: true
            });
            //设置地图
            var map = new ol.Map({
                //地图中的比例尺等控制要素
                controls: ol.control.defaults({
                    attribution: false
                }).extend([
                    new ol.control.ScaleLine()
                ]),
                //设置显示的容器
                target: 'mapContainer',
                //设置图层
                layers: [
                    //添加图层
                    osmLayer,
                    imageMap,
                    jsonLayer
                ],
                //设置视图
                view: new ol.View({
                    //设置投影
                    projection: projection,
                    size: [100,200],
                    zoom: 5,
                    minZoom: 4,
                    maxZoom: 7
                })
            });
            //地图显示
            map.getView().fit(bounds, map.getSize());
            map.addInteraction(select);
            map.on('click', function (e) {
                //在点击时获取像素区域
                var pixel = map.getEventPixel(e.originalEvent);
                map.forEachFeatureAtPixel(pixel, function (feature) {
                    //coodinate存放了点击时的坐标信息
                    var coodinate = e.coordinate;
                    //设置弹出框内容，可以HTML自定义
                    content.innerHTML = "<p style='color:#0000B0' >coodinate:" + coodinate + "</p>";
                    //设置overlay的显示位置
                    overlay.setPosition(coodinate);
                    //显示overlay
                    map.addOverlay(overlay);
                });
            });
        </script>
    </div>
    <div id="infoArea">
        <div class="sept" id="btnContainer">
            <div>
            <button id="uploadBtn" style="width:95% ;color: #fff;">Upload Info</button>
            </div>
            <input style="width:75%;" id="queryInput" type="text" placeholder="Enter Search Key Word"/>
            <button id="queryBtn" style="color: #fff" >Search Info</button>
        </div>
        <div class="sept" id="infoContainer" >
            <iframe src="show_info.jsp?ID=1" id="infoJsp"></iframe>
        </div>
    </div>
</section>

<section id="stat">
    <div class="main clearfix">
        <div class="main-left">
            <div class="border-container containertop">
                <h5 class="name-title tile-size-color">
                    EcoIndex Distribution
                </h5>
                <div id="radar">
                    <div class="radarkong">
                        <p class="tile-size-color">Total:<span class="Totalequipment"> 31</span>Time:<span> 2019.03.26 15:28</span></p>
                    </div>
                    <div class="pie-chart" id="pie-chart"></div>
                    <ul class="SiteStatusList">
                        <li><i class="Statusnormal Statussame"></i>90+:<span>5</span></li>
                        <li><i class="Statusemergency Statussame"></i>80~90:<span>14</span></li>
                        <li><i class="StatusOffline Statussame"></i>65~80:<span>12</span></li>
                    </ul>
                </div>
            </div>

            <div class="border-container containerbottom">
                <div class="name-title tile-size-color">
                    Top 4
                </div>
                <div class="graduateyear">
                    <div class="bar-chart" id="bar-chart"></div>
                    <ul class="SiteStatusList">
                        <li>2013</li>
                        <li class="DataSwitch"><i class="ThisweekData Datasame" onClick="DataSwitch(this,1)"></i><i class="ThisweekData" onClick="DataSwitch(this,2)"></i></li>
                        <li class="Defaultgray">2018</li>
                    </ul>
                </div>


            </div>
        </div>
        <div class="main-middle">
            <div class="border-container containertop">
                <div class="name-title tile-size-color">
                    Forest Index
                </div>
                <div id="mapadd">
                    <div class="mapleft">
                        <div class="progress2-chart" id="progress2-chart">
                        </div>
                        <a href="http://www.forestry.gov.cn/" class="progressMore">More&gt;</a>
                    </div>

                    <div class="map-chart" id="map-chart">
                    </div>
                    <ul class="Devicestatus-List">
                        <li class="Online2">63.8%
                            <span class="DevicestatusName">FJ</span>
                        </li>
                        <li class="Online2">63.1%
                            <span class="DevicestatusName">JX</span>
                        </li>
                        <li class="Online2">61%
                            <span class="DevicestatusName">ZJ</span>
                        </li>
                        <li class="Online2">60.5%
                            <span class="DevicestatusName">GX</span>
                        </li>
                    </ul>

                </div>
            </div>
            <div class="border-container containerbottom borderno-container">
                <ul class="teacher-pie clearfix">
                    <li class="teacherList">
                        <div class="name-title tile-size-color">
                            HuBei Forest Index
                        </div>
                        <div id="courserate">
                            <div class="line-chart" id="line-chart"></div>
                            <ul class="SiteStatusList">
                                <li><i class="Statusnormal Statussame"></i>5-time investigation</li>
                            </ul>
                        </div>
                    </li>
                    <li class="teacherList">
                        <div class="name-title tile-size-color">
                            5-Time Top4 Change
                        </div>
                        <div class="bars-chart" id="bars-chart"></div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="main-right">
            <div class="border-container containertop">
                <div class="name-title tile-size-color">
                    Top Provinces
                </div>
                <div class="progress1-chart" id="progress1-chart"></div>
            </div>
            <div class="border-container containerbottom">
                <div class="name-title tile-size-color">
                    Top 5 Radar
                </div>
                <div id="radar-chart" class="radar-chart">
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="js/echarts.js"></script>
    <script type="text/javascript" src="js/new_file.js"></script>
    <script type="text/javascript" src="js/maps.js"></script>
</section>

<section id="about">
<div class="main" style="margin:auto auto;width: 80%;height: 80%;text-align: center" >
    <h2 style="color: #FFFFFF">地信四班：丁家祺</h2>
    <h3 style="color: #FFFFFF">学号：2016301110170</h3>
    <img src="img/about.jpg" style="height: 80%;">
</div>

</section>

</body>
</html>


