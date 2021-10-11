<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <title>myTitle</title>
    <script src="ECharts/echarts.min.js"></script>
    <script src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript">
        $(function () {
            //页面加载完毕后，绘制图表
            getCharts();

        })
        function getCharts() {
            $.ajax({
                url:"workbench/activity/getCharts.do",
                type:"GET",
                dataType:"json",
                success:function (data) {
                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));
                    // 指定图表的配置项和数据
                    option = {
                        title: {
                            text: '活动漏斗图',
                            subtext: '各类活动占比图',
                            left: 'center'
                        },
                        tooltip: {
                            trigger: 'item'
                        },
                        legend: {
                            orient: 'vertical',
                            left: 'left'
                        },
                        series: [
                            {
                                name: 'Access From',
                                type: 'pie',
                                radius: '50%',
                                data: data.dataList,
                                emphasis: {
                                    itemStyle: {
                                        shadowBlur: 10,
                                        shadowOffsetX: 0,
                                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                                    }
                                }
                            }
                        ]
                    };

                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);
                }
            })

        }

    </script>


</head>
<body>
<!-- 为 ECharts 准备一个定义了宽高的 DOM -->
<div id="main" style="width: 600px;height:400px;"></div>
</body>
</html>