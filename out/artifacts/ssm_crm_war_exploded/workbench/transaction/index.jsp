<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
    <script type="text/javascript">

        $(function () {
            pageList(1, 2)
            $("#searchTran").click(function () {
                pageList(1,3)

            })

        });

        function pageList(pageNo, pageSize) {
            $.ajax({
                url: "workbench/transaction/pageList.do",
                type: "GET",
                dataType: "json",
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "owner": $.trim($("#owner").val()),
                    "name": $.trim($("#name").val()),
                    "customer": $.trim($("#customer").val()),//获取的客户姓名
                    "stage": $.trim($("#stage").val()),
                    "type": $.trim($("#type").val()),
                    "source": $.trim($("#source").val()),
                    "contacts": $.trim($("#contacts").val()),//获取的联系人姓名
                },
                success: function (data) {
                    var html = "";
                    $.each(data.dataList, function (i, n) {
                        html += ' <tr>';
                        html += '<td><input type="checkbox"/></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;"onclick="window.location.href=\'workbench/transaction/detail.do?id=' + n.id + '\';">' + n.name + '</a></td>';
                        html += '<td>' + n.customerId + '</td>';//customerId在tran属性中，使用其他名字，映射不到属性中，即使从数据库中取出也获取不到，只能使用跟实体属性一致的名
                        html += '<td>' + n.stage + '</td>';
                        html += '<td>' + n.type + '</td>';
                        html += '<td>' + n.owner + '</td>';//一样
                        html += '<td>' + n.source + '</td>';
                        html += '<td>' + n.contactsId + '</td>';//一样
                        html += '</tr>';
                    })
                    $("#tranBody").html(html);
                    //数据处理完毕结合前端展现分页信息  导航条
                    //计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
                    $("#tranPage").bs_pagination({
                        currentPage: pageNo, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: data.total, // 总记录条数
                        visiblePageLinks: 3, // 显示几个卡片
                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,
                        //该回调函数时在，点击分页组件的时候触发的
                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                        }
                    });
                }
            })

        }

    </script>
</head>
<body>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>交易列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input class="form-control" type="text" id="customer">
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">阶段</div>
                        <select class="form-control" id="stage">
                            <option></option>
                            <c:forEach items="${applicationScope.stageList}" var="s">
                                <option value="${s.value}">${s.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">类型</div>
                        <select class="form-control" id="type">
                            <option></option>
                            <c:forEach items="${applicationScope.transactionTypeList}" var="t">
                                <option value="${t.value}">${t.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">来源</div>
                        <select class="form-control" id="source">
                            <option></option>
                            <c:forEach items="${applicationScope.sourceList}" var="s">
                                <option value="${s.value}">${s.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">联系人名称</div>
                        <input class="form-control" type="text" id="contacts">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchTran">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary"
                        onclick="window.location.href='workbench/transaction/add.do';"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default"
                        onclick="window.location.href='workbench/transaction/edit.jsp';"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>


        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox"/></td>
                    <td>名称</td>
                    <td>客户名称</td>
                    <td>阶段</td>
                    <td>类型</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>联系人名称</td>
                </tr>
                </thead>
                <tbody id="tranBody">

                <%--                        <tr class="active">--%>
                <%--                            <td><input type="checkbox" /></td>--%>
                <%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点-交易01</a></td>--%>
                <%--                            <td>动力节点</td>--%>
                <%--                            <td>谈判/复审</td>--%>
                <%--                            <td>新业务</td>--%>
                <%--                            <td>zhangsan</td>--%>
                <%--                            <td>广告</td>--%>
                <%--                            <td>李四</td>--%>
                <%--                        </tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 20px;">
            <div id="tranPage">

            </div>
        </div>

    </div>

</div>
</body>
</html>