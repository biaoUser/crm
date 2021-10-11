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
        //页面加载完成时
        $(function () {
            //页面加载完毕需要显示数据
            pageList(1, 2);

            //时间
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });


            //打开添加操作模态窗口
            /*
            * 查询出所有者信息，进行信息填充*/
            $("#addBtn").click(function () {
                $.ajax({
                    url: "workbench/activity/getUserList.do",
                    type: "GET",
                    dataType: "json",
                    success: function (data) {
                        var html = "<option></option>";
                        $.each(data, function (i, n) {
                            html += "<option value='" + n.id + "'>" + n.name + "</option>"
                        })
                        $("#create-owner").html(html);
                    }
                })
                //将登陆者选为默认下拉框选项 js中用el表达式需要""
                var id = "${sessionScope.user.id}"//
                $("#create-owner").val(id);//不生效无语
                //处理完下拉框打开模态框
                //操作模态窗口方式：需要操作jquery对象，调用model方法，为该方法传递参数：show打开模态窗口，hide关闭
                $("#createActivityModal").modal("show");
            })


            //  模态框  保存按钮绑定单击，执行添加操作
            $("#saveBtn").click(function () {
                $.ajax({
                    url: "workbench/activity/save.do",
                    type: "POST",
                    data: {
                        "owner": $.trim($("#create-owner").val()),
                        "name": $.trim($("#create-name").val()),
                        "startDate": $.trim($("#create-startDate").val()),
                        "endDate": $.trim($("#create-endDate").val()),
                        "cost": $.trim($("#create-cost").val()),
                        "description": $.trim($("#create-description").val()),
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            //局部刷新列表
                            //清空模态框数据
                            /*jquery的from对象提供的submit方法我们可以用
                            * 提供的reset方法不可以用（idea功能提示了）
                            * 原生的js的from对象可以用
                            * 因此需要jquery转换成js */
                            // $("#activityAddForm")[0].reset();
                            //关闭模态窗口
                            $("#createActivityModal").modal("hide");
                            //添加成功后
                            //刷新市场活动信息列表（局部刷新）
                            //pageList(1,2);
                            /*
                            *
                            * $("#activityPage").bs_pagination('getOption', 'currentPage'):
                            * 		操作后停留在当前页
                            *
                            * $("#activityPage").bs_pagination('getOption', 'rowsPerPage')
                            * 		操作后维持已经设置好的每页展现的记录数
                            *
                            * 这两个参数不需要我们进行任何的修改操作
                            * 	直接使用即可
                            *
                            *
                            *
                            * */
                            //做完添加操作后，应该回到第一页，维持每页展现的记录数
                            pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                        } else {

                            alert(data.msg)
                        }
                    }
                })
            })


            //条件查询按钮触发事件
            $("#searchBtn").click(function () {
                //点击查询按钮的时候，将搜索框中的信息保存起来
                $("#hidden-name").val($.trim($("#search-name").val()));
                $("#hidden-owner").val($.trim($("#search-owner").val()));
                $("#hidden-startDate").val($.trim($("#search-startDate").val()));
                $("#hidden-endDate").val($.trim($("#search-endDate").val()));
                pageList(1, 2)
            })

            //全选复选框事件
            $("#qx").click(function () {
                $("input[name=xz]").prop("checked", this.checked);
            })

            //动态生成的元素无法以普通的事件进行绑定，需要已on的形式进行事件触发
            //语法：$(需要绑定元素的有效外层元素).on（绑定事件的方式，需要绑定的jquery方式，回调函数）
            $("#activityBody").on("click", $("input[name=xz]"), function () {
                $("#qx").prop("checked", $("input[name=xz]").length == $("input[name=xz]:checked").length);

            })


            //市场活动删除按钮绑定事件
            $("#deleteBtn").click(function () {
                if (confirm("确定要删除吗")) {
                    //找到复选框中所有选中的复选框jquery对象
                    let $xz = $("input[name=xz]:checked");
                    if ($xz.length != 0) {
                        //拼接参数
                        let param = "";
                        //将$xz中的每个dom对象遍历出来，取value值，就是取得了id
                        for (let i = 0; i < $xz.length; i++) {
                            //$xz[i]表示取得dom对象
                            param += "id=" + $($xz[i]).val();
                            //如果不是最后一个元素，需要追加一个连接符&
                            if (i < $xz.length - 1) {
                                param += "&";
                            }
                        }

                        $.ajax({
                            url: "workbench/activity/delete.do",
                            type: "POST",
                            data: param,
                            dataType: "json",
                            success: function (data) {
                                if (data.success) {

                                    pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                                } else {
                                    alert("删除失败")
                                }
                            }
                        })
                    } else {
                        alert("请选择要删除的记录")
                    }
                }
            })


            //打开修改模态框,为修改按钮绑定事件
            $("#editBtn").click(function () {
                let $xz = $("input[name=xz]:checked");
                if ($xz.length == 0) {
                    alert("请选择一条记录进行修改")
                } else if ($xz.length > 1) {
                    alert("请选择一条进行修改")
                } else {
                    var id = $xz.val();
                    $.ajax({
                        url: "workbench/activity/getUserListAndActivity.do",
                        type: "GET",
                        data: {
                            "id": id
                        },
                        dataType: "json",
                        success: function (data) {
                            //成功需要市场活动数据   和当前选中的activity数据
                            //{uList:"[{用户1},{用户2}]",a:{activity}}
                            if (data.success) {
                                var html = "<option></option>";
                                $.each(data.uList, function (i, n) {
                                    html += "<option value='" + n.id + "'>" + n.name + "</option>"
                                })
                                $("#edit-owner").html(html)
                                //处理单条activity
                                $("#edit-id").val(data.a.id);
                                $("#edit-name").val(data.a.name);
                                $("#edit-owner").val(data.a.owner);
                                $("#edit-startDate").val(data.a.startDate);
                                $("#edit-endDate").val(data.a.endDate);
                                $("#edit-cost").val(data.a.cost);
                                $("#edit-description").val(data.a.description);
                                //所有的值都填写好之后，打开修改操作的模态窗口
                                $("#editActivityModal").modal("show");
                            } else {
                                alert("拿取数据失败")
                            }
                        }
                    })
                }
            })


            //更新模态框中的更新提交按钮绑定事件
            $("#updateBtn").click(function () {
                $.ajax({
                    url: "workbench/activity/update.do",
                    type: "POST",
                    data: {
                        "id": $.trim($("#edit-id").val()),
                        "owner": $.trim($("#edit-owner").val()),
                        "name": $.trim($("#edit-name").val()),
                        "startDate": $.trim($("#edit-startDate").val()),
                        "endDate": $.trim($("#edit-endDate").val()),
                        "cost": $.trim($("#edit-cost").val()),
                        "description": $.trim($("#edit-description").val()),
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            $("#editActivityModal").modal("hide");


                            pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                , $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                        } else {
                            alert("修改失败")
                        }
                    }
                })

            })
        });//$(function(){})函数到此结束


        //那些情况需要调用pageList：
        /*1：点击市场活动，初次加载页面的时候
           2：添加修改删除后刷新
           3：点击查询按钮的时候
           4：点击分页组件的时候
        * */
        //分页操作
        function pageList(pageNo, pageSize) {
            //把总全选框改为不勾选每次请求前
            $("#qx").prop("checked", false);


            //查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
            $("#search-name").val($.trim($("#hidden-name").val()));
            $("#search-owner").val($.trim($("#hidden-owner").val()));
            $("#search-startDate").val($.trim($("#hidden-startDate").val()));
            $("#search-endDate").val($.trim($("#hidden-endDate").val()));
            $.ajax({
                url: "workbench/activity/pageList.do",
                type: "GET",
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "name": $.trim($("#search-name").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "startDate": $.trim($("#search-startDate").val()),
                    "endDate": $.trim($("#search-endDate").val()),
                },
                dataType: "json",
                success: function (data) {
                    /*
                    * data:分页插件：总记录数total
                    *
                    * */
                    var html = "";
                    //每一个n就是市场活动动向  activityBody
                    //每一个n就是每一个市场活动对象
                    $.each(data.dataList, function (i, n) {
                        html += '<tr class="active">';
                        html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id=' + n.id + '\';">' + n.name + '</a></td>';
                        html += '<td>' + n.owner + '</td>';
                        html += '<td>' + n.startDate + '</td>';
                        html += '<td>' + n.endDate + '</td>';
                        html += '</tr>';
                    })
                    $("#activityBody").html(html);
                    //数据处理完毕结合前端展现分页信息  导航条
                    //计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
                    $("#activityPage").bs_pagination({
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
<input type="hidden" id="hidden-name"/>
<input type="hidden" id="hidden-owner"/>
<input type="hidden" id="hidden-startDate"/>
<input type="hidden" id="hidden-endDate"/>

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form id="activityAddForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">


                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-startDate">
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endDate">
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <!--

                    data-dismiss="modal"
                        表示关闭模态窗口

                -->
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id">
                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <%--                                <option>zhangsan</option>--%>
                                <%--                                <option>lisi</option>--%>
                                <%--                                <option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-startDate">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endDate">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <%--                            文本域：要以标签对形式存在。正常状态下标签对紧挨着不要留空否则被认为是数据，也是val()取值赋值--%>
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control time" type="text" id="search-startDate"/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control time" type="text" id="search-endDate">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span>
                    创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="activityBody">

                <%--                <tr class="active">--%>
                <%--                    <td><input type="checkbox"/></td>--%>
                <%--                    <td><a style="text-decoration: none; cursor: pointer;"--%>
                <%--                           onclick="window.location.href='detail.html';">发传单</a></td>--%>
                <%--                    <td>zhangsan</td>--%>
                <%--                    <td>2020-10-10</td>--%>
                <%--                    <td>2020-10-20</td>--%>
                <%--                </tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div id="activityPage">

            </div>
        </div>

    </div>

</div>
</body>
</html>