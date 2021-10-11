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
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;
        $(function () {
            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });
            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });
            $(".remarkDiv").mouseover(function () {
                $(this).children("div").children("div").show();
            });
            $(".remarkDiv").mouseout(function () {
                $(this).children("div").children("div").hide();
            });
            $(".myHref").mouseover(function () {
                $(this).children("span").css("color", "red");
            });

            $(".myHref").mouseout(function () {
                $(this).children("span").css("color", "#E6E6E6");
            });
            //	-------------------------------------------------------
            //市场活动详情页面点击编辑出现模态框
            $("#editBtn").click(function () {
                $.ajax({
                    url: "workbench/activity/getUserListAndActivity.do",
                    data: {
                        "id": $("#activityId").val()
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            var html = "<option></option>";
                            $.each(data.uList, function (i, n) {
                                html += "<option value='" + n.id + "'>" + n.name + "</option>"
                            })
                            $("#edit-marketActivityOwner").html(html)
                            $("#edit-marketActivityOwner").val(data.a.owner);
                            $("#edit-id").val(data.a.id);
                            $("#edit-name").val(data.a.name);
                            $("#edit-startDate").val(data.a.startDate);
                            $("#edit-endDate").val(data.a.endDate);
                            $("#edit-cost").val(data.a.cost);
                            $("#edit-description").val(data.a.description);

                            $("#editActivityModal").modal("show");
                        } else {
                            alert("失败")
                        }
                    }
                })
            })

            //市场活动详情页面点击编辑出现模态框中更新按钮提交事件
            $("#updateBtn").click(function () {
                $.ajax({
                    url: "workbench/activity/update.do",
                    data: {
                        "id": $.trim($("#edit-id").val()),
                        "owner": $.trim($("#edit-marketActivityOwner").val()),
                        "name": $.trim($("#edit-name").val()),
                        "startDate": $.trim($("#edit-startDate").val()),
                        "endDate": $.trim($("#edit-endDate").val()),
                        "cost": $.trim($("#edit-cost").val()),
                        "description": $.trim($("#edit-description").val()),
                    },
                    dataType: "json",
                    type: "POST",
                    success: function (data) {
                        if (data.success) {
                            $("#editActivityModal").modal("hide");
                            //刷新页面
                            location.reload();
                        } else {
                            alert("失败")
                        }
                    }
                })
            })
            //点击删除按钮
            $("#deleteBtn").click(function () {
                let id = $.trim($("#activityId").val())
                if (confirm("确定要删除吗")) {
                    $.ajax({
                        url: "workbench/activity/delete.do",
                        type: "POST",
                        data: {
                            "id": id
                        },
                        dataType: "json",
                        success: function (data) {
                            if (data.success) {
                                document.location.href = "workbench/activity/index.jsp";
                            }
                        }
                    })
                }

            })
            //页面加载完毕；展现该活动市场关联的备注信息列表
            showRemarkList();

            //与备注删除修改有关按钮的js操作
            $("#remarkBody").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            })
            $("#remarkBody").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            })

            //为保存备注按钮添加绑定事件
            $("#saveRemarkBtn").click(function () {
                $.ajax({
                    url: "workbench/activity/saveRemark.do",
                    type: "GET",
                    data: {
                        "noteContent": $.trim($("#remark").val()),
                        "activityId": "${a.id}"
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            var html = "";
                            html += '<div id="' + data.ar.id + '" class="remarkDiv" style="height: 60px;">';
                            html += '         <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '         <div style="position: relative; top: -40px; left: 40px;">';
                            html += '         <h5 id="e'+data.ar.id+'">' + data.ar.noteContent + '</h5>';
                            html += '         <font color="gray">市场活动</font> <font color="gray">-</font> <b>${a.name}</b> <small style="color: gray;" id="s'+data.ar.id+'">' + (data.ar.createTime) + ' 由' + (data.ar.createBy) + '</small>';
                            html += '          <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                            html += '         <a class="myHref" onclick="editRemark(\'' + data.ar.id + '\')"   href="javascript:void(0);"><span class="glyphicon glyphicon-edit"style="font-size: 20px; color: #FF0000;"></span></a>';
                            html += '      &nbsp;&nbsp;&nbsp;&nbsp;';
                            //注意onclick="deleteRemark(\''+n.id+'\')中字符串拼接转义
                            html += '     <a class="myHref" onclick="deleteRemark(\'' + data.ar.id + '\')" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                            html += '     </div>';
                            html += '     </div>';
                            html += '     </div>';
                            $("#remarkDiv").before(html);

                            $("#remark").val("")
                        } else {
                            alert("添加备注失败")
                        }
                    }

                })
            })

            //修改备注模态框中 更新按钮绑定事件
            $("#updateRemarkBtn").click(function () {

                var id = $("#remarkId").val();
               $.ajax({
                   url:"workbench/activity/updateRemark.do",
                   type:"GET",
                   data:{
                       "id": id,
                       "noteContent": $.trim($("#noteContent").val())
                   },
                   dataType:"json",
                   success:function (data) {
                        if(data.success){
                            //修改备注成功需要更新内容有，noteContent，editTime，editBy
                            $("#e"+id).html(data.ar.noteContent);
                            $("#s"+id).html(data.ar.editTime+"由"+data.ar.editBy);

                            //更新内容后关闭模态窗

                            $("#editRemarkModal").modal("hide")

                        }else {
                            alert("失败")
                        }
                   }
               })

            })

        });//$(function(){})到此结束


        function showRemarkList() {
            $.ajax({
                url: "workbench/activity/getRemarkListByActivityId.do",
                type: "GET",
                data: {
                    "activityId": "${a.id}"
                },
                dataType: "json",
                success: function (data) {

                    var html = "";
                    $.each(data, function (i, n) {
                        html += '<div id="' + n.id + '" class="remarkDiv" style="height: 60px;">';
                        html += '         <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html += '         <div style="position: relative; top: -40px; left: 40px;">';
                        html += '         <h5 id="e'+n.id+'">' + n.noteContent + '</h5>';
                        html += '         <font color="gray">市场活动</font> <font color="gray">-</font> <b>${a.name}</b> <small style="color: gray;" id="s'+n.id+'">' + (n.editFlag == 0 ? n.createTime : n.editTime) + ' 由' + (n.editFlag == 0 ? n.createBy : n.editBy) + '</small>';
                        html += '          <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                        html += '         <a class="myHref" onclick="editRemark(\'' + n.id + '\')"     href="javascript:void(0);"><span class="glyphicon glyphicon-edit"style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '      &nbsp;&nbsp;&nbsp;&nbsp;';
                        //注意onclick="deleteRemark(\''+n.id+'\')中字符串拼接转义
                        html += '     <a class="myHref" onclick="deleteRemark(\'' + n.id + '\')" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '     </div>';
                        html += '     </div>';
                        html += '     </div>';
                    })
                    //找到这个div向前追加一个元素
                    $("#remarkDiv").before(html);

                }
            })
        }

        //备注删除主动触发事件函数
        function deleteRemark(id) {
            if (confirm("确定要删除此条备注信息吗")) {
                $.ajax({
                    url: "workbench/activity/deleteRemark.do",
                    type: "GET",
                    data: {
                        "id": id
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            //删除备注成功
                            //这种做法不行，记录使用的是before方法，每一次删除之后，页面上都会保留原有的数据
                            //showRemarkList();

                            //找到需要删除记录的div，将div移除掉
                            $("#" + id).remove();
                        } else {
                            alert("删除失败")
                        }
                    }
                })
            }
        }

        //修改备注按钮触发事件
        function editRemark(id) {
            //把id放到提交的from表单的隐藏域，供更新使用
            $("#remarkId").val(id);

            //找到存放信息的h5标签中
            let noteContent = $("#e"+id).html();
            //展现值
            $("#noteContent").val(noteContent);
            //打开备注修改模态窗
            $("#editRemarkModal").modal("show")
        }

    </script>

</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
        <%-- 备注的id --%>

    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <%--					修改了id--%>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="hidden" id="remarkId">
                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
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
                <h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">
                    <input id="edit-id" type="hidden">
                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">
                                <%--                                    <option>zhangsan</option>--%>
                                <%--                                    <option>lisi</option>--%>
                                <%--                                    <option>wangwu</option>--%>
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
                            <input type="text" class="form-control" id="edit-startDate">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-endDate">
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

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <input type="hidden" id="activityId" value="${a.id}">
    <div class="page-header">
        <h3>${a.name} <small>${a.startDate}~${a.endDate}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除
        </button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">开始日期</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.startDate}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.endDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">成本</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.cost}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${a.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${a.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${a.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${a.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${a.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="remarkBody" style="position: relative; top: 30px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <!-- 备注1 -->


    <!-- 备注2 -->
    <%--    <div class="remarkDiv" style="height: 60px;">--%>
    <%--        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
    <%--        <div style="position: relative; top: -40px; left: 40px;">--%>
    <%--            <h5>呵呵！</h5>--%>
    <%--            <font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;">--%>
    <%--            2017-01-22 10:20:10 由zhangsan</small>--%>
    <%--            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
    <%--                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"--%>
    <%--                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
    <%--                &nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"--%>
    <%--                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
    <%--            </div>--%>
    <%--        </div>--%>
    <%--    </div>--%>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;"></div>
</body>
</html>