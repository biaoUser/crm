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
            pageList(1, 2);

            //时间
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "top-left"
            });


            //为创建按钮绑定事件，打开添加模态窗窗口
            $("#addBtn").click(function () {
                $.ajax({
                    url: "workbench/clue/getUserList.do",
                    dataType: "json",
                    type: "GET",
                    success: function (data) {
                        var html = "<option></option>";
                        $.each(data, function (i, n) {
                            html += "<option value='" + n.id + "'>" + n.name + "</option>"
                        })
                        $("#create-owner").html(html);

                    }
                })
                $("#createClueModal").modal("show")
            })

            //为保存按钮添加事件，执行线索添加
            $("#saveBtn").click(function () {
                $.ajax({
                    url: "workbench/clue/save.do",
                    data: {
                        "fullname": $.trim($("#create-fullname").val()),
                        "appellation": $.trim($("#create-appellation").val()),
                        "owner": $.trim($("#create-owner").val()),
                        "company": $.trim($("#create-company").val()),
                        "job": $.trim($("#create-job").val()),
                        "email": $.trim($("#create-email").val()),
                        "phone": $.trim($("#create-phone").val()),
                        "website": $.trim($("#create-website").val()),
                        "mphone": $.trim($("#create-mphone").val()),
                        "state": $.trim($("#create-state").val()),
                        "source": $.trim($("#create-source").val()),
                        "description": $.trim($("#create-description").val()),
                        "contactSummary": $.trim($("#create-contactSummary").val()),
                        "nextContactTime": $.trim($("#create-nextContactTime").val()),
                        "address": $.trim($("#create-address").val())
                    },
                    dataType: "json",
                    type: "GET",
                    success: function (data) {
                        if (data.success) {
                            pageList(1, 2);
                            //此处还应该刷新列表
                            // pageList(1, $("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
                            $("#createClueModal").modal("hide")
                        } else {
                            alert("shibai")
                        }

                    }
                })

            })


            //条件查询
            $("#searchBtn").click(function () {
                $("#hidden-fullname").val($.trim($("#search-fullname").val()));
                $("#hidden-company").val($.trim($("#search-company").val()));
                $("#hidden-phone").val($.trim($("#search-phone").val()));
                $("#hidden-owner").val($.trim($("#search-owner").val()));
                $("#hidden-mphone").val($.trim($("#search-mphone").val()));
                $("#hidden-clueState").val($.trim($("#search-clueState").val()));
                $("#hidden-source").val($.trim($("#search-source").val()));
                pageList(1, 2)
            })
            //全选复选框事件
            $("#qx").click(function () {
                $("input[name=xz]").prop("checked", this.checked);
            })
            //动态生成的元素无法以普通的事件进行绑定，需要已on的形式进行事件触发
            //语法：$(需要绑定元素的有效外层元素).on（绑定事件的方式，需要绑定的jquery方式，回调函数）
            $("#clueBody").on("click", $("input[name=xz]"), function () {
                $("#qx").prop("checked", $("input[name=xz]").length == $("input[name=xz]:checked").length);
            })

            //打开线索修改模态框
            $("#OpenEditBtn").click(function () {
                //首先判断用户是否选择记录进行修改(条数只能为1，不能为0或多条)
                let $xz = $("input[name=xz]:checked");
                if($xz.length==0){
                    alert("请选一条进行修改")
                }else if($xz.length>1){
                    alert("一次只能选择一条进行修改")
                }else {
                    $("#editClueModal").modal("show")
                    var id = $xz.val();
                    $.ajax({
                        url:"workbench/clue/getUserListAndClue.do",
                        type:"GET",
                        data:{
                            "id":id
                        },
                        dataType:"json",
                        success:function (data) {
                            var html = "<option></option>";
                            $.each(data.uList, function (i, n) {
                                html += "<option value='" + n.id + "'>" + n.name + "</option>"
                            })

                            $("#edit-owner").html(html)
                            $("#edit-id").val(id)
                            $("#edit-company").val(data.c.company);
                            $("#Oappellation").html(data.c.appellation);
                            $("#Ostate").html(data.c.state);
                            $("#Osource").html(data.c.source);
                            $("#edit-fullname").val(data.c.fullname);
                            $("#edit-job").val(data.c.job);
                            $("#edit-email").val(data.c.email);
                            $("#edit-phone").val(data.c.phone);
                            $("#edit-website").val(data.c.website);
                            $("#edit-mphone").val(data.c.mphone);
                            $("#edit-description").val(data.c.description);
                            $("#edit-contactSummary").val(data.c.contactSummary);
                            $("#edit-nextContactTime").val(data.c.nextContactTime);
                            $("#edit-address").val(data.c.address);
                            $("#editClueModal").modal("show")
                        }
                    })
                }

            })


            //提交更新按钮事件
            $("#editBtn").click(function () {
                $.ajax({
                    url:"workbench/clue/update.do",
                    type:"GET",
                    data:{
                        "id": $.trim($("#edit-id").val()),
                        "owner": $.trim($("#edit-owner").val()),
                        "company":$.trim($("#edit-company").val()),
                        "appellation":$.trim($("#Oappellation").html()),
                        "state":$.trim($("#Ostate").html()),
                        "source":$.trim($("#Osource").html()),
                        "fullname":$.trim($("#edit-fullname").val()),
                        "job":$.trim($("#edit-job").val()),
                        "email":$.trim($("#edit-email").val()),
                        "phone":$.trim($("#edit-phone").val()),
                        "mphone":$.trim($("#edit-mphone").val()),
                        "website":$.trim($("#edit-website").val()),
                        "description":$.trim($("#edit-description").val()),
                        "contactSummary":$.trim($("#edit-contactSummary").val()),
                        "nextContactTime":$.trim($("#edit-nextContactTime").val()),
                        "address":$.trim($("#edit-address").val()),
                        "editClueModal":$.trim($("#editClueModal").val())
                    },
                    dataType:"json",
                    success:function (data) {
                        if(data.success){
                            alert("更新成功")
                            $("#editClueModal").modal("hide")
                        }else {
                            alert("更新失败")
                        }
                    }
                })

            })

            $("#delBtn").click(function () {
                if(confirm("确定要删除吗")){
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
                            url: "workbench/clue/delete.do",
                            type: "GET",
                            data: param,
                            dataType: "json",
                            success: function (data) {
                                if (data.success) {
                                    alert("删除成功")
                                    pageList(1, 2);
                                } else {
                                    alert("删除失败")
                                }
                            }
                        })
                    }else {
                        alert("请至少选择一条记录")
                    }
                }else {
                    return false;
                }

            })
        });//$(function(){})函数到此结束

        function pageList(pageNo, pageSize) {
            $("#qx").prop("checked", false);

            $.ajax({
                url: "workbench/clue/pageList.do",
                type: "GET",
                dataType: "json",
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    //查询条件
                    "fullname": $.trim($("#hidden-fullname").val()),
                    "company": $.trim($("#hidden-company").val()),
                    "phone": $.trim($("#hidden-phone").val()),
                    "source": $.trim($("#hidden-source").val()),
                    "owner": $.trim($("#hidden-owner").val()),
                    "mphone": $.trim($("#hidden-mphone").val()),
                    "state": $.trim($("#hidden-clueState").val())
                },

                success: function (data) {
                    //在此拼接数据
                    var html = "";
                    $.each(data.dataList, function (i, n) {
                        html += '<tr>';
                        html += '<td><input type="checkbox" name="xz" value="' + n.id + '" /></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail.do?id=' + n.id + '\';">' + n.fullname + '</a></td>';
                        html += '<td>' + n.company + '</td>';
                        html += '<td>' + n.phone + '</td>';
                        html += '<td>' + n.mphone + '</td>';
                        html += '<td>' + n.source + '</td>';
                        html += '<td>' + n.owner + '</td>';
                        html += '<td>' + n.state + '</td>';
                        html += '</tr>';
                    })
                    $("#clueBody").html(html);
                    //数据处理完毕结合前端展现分页信息  导航条
                    //计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
                    $("#cluePage").bs_pagination({
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
<input type="hidden" id="hidden-fullname">
<input type="hidden" id="hidden-company">
<input type="hidden" id="hidden-phone">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-mphone">
<input type="hidden" id="hidden-clueState">
<input type="hidden" id="hidden-source">
<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <%--								  <option>zhangsan</option>--%>
                                <%--								  <option>lisi</option>--%>
                                <%--								  <option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-appellation">
                                <option></option>
                                <%--									<c:forEach items="${applicationScope.appellationList}注意这个地方不能有空格" var="a">--%>
                                <c:forEach items="${applicationScope.appellationList}" var="a">
                                    <option value="${a.value}">${a.text}</option>
                                </c:forEach>

                            </select>
                        </div>
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-fullname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                        <label for="create-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-state">
                                <option></option>
                                <c:forEach items="${applicationScope.clueStateList}" var="c">
                                    <option value="${c.value}"> ${c.text}</option>
                                </c:forEach>


                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <option></option>
                                <c:forEach items="${applicationScope.sourceList}" var="s">
                                    <option value="${s.value}"> ${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">线索描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="create-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
<input id="edit-id" type="hidden">
                    <div class="form-group">
                        <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">

                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company" >
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                                <option id="Oappellation"></option>
                                <c:forEach items="${applicationScope.appellationList}" var="a">
                                    <option value="${a.value}">${a.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullname" >
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" >
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" >
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                  >
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" >
                        </div>
                        <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-state">
                                <option id="Ostate"></option>
                               <c:forEach items="${applicationScope.clueStateList}" var="c">
                                   <option value="${c.value}">${c.text}</option>
                               </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <option id="Osource"></option>

                                <c:forEach items="${applicationScope.sourceList}" var="s">
                                    <option value="${s.value}">${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="editBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>线索列表</h3>
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
                        <input class="form-control" type="text" id="search-fullname">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司</div>
                        <input class="form-control" type="text" id="search-company">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" id="search-phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索来源</div>
                        <select class="form-control" id="search-source">
                            <option></option>
                            <c:forEach items="${applicationScope.sourceList}" var="s">
                                <option value="${s.value}">${s.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">手机</div>
                        <input class="form-control" type="text" id="search-mphone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索状态</div>
                        <select class="form-control" id="search-clueState">
                            <option></option>
                            <c:forEach items="${applicationScope.clueStateList}" var="c">
                                <option value="${c.value}">${c.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <button type="button" id="searchBtn" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span>
                    创建
                </button>
                <button type="button" class="btn btn-default" id="OpenEditBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger"  id="delBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>


        </div>
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input id="qx" type="checkbox"/></td>
                    <td>名称</td>
                    <td>公司</td>
                    <td>公司座机</td>
                    <td>手机</td>
                    <td>线索来源</td>
                    <td>所有者</td>
                    <td>线索状态</td>
                </tr>
                </thead>
                <tbody id="clueBody">
                <%--						<tr>--%>
                <%--							<td><input type="checkbox" /></td>--%>
                <%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/detail.jsp';">李四先生</a></td>--%>
                <%--							<td>动力节点</td>--%>
                <%--							<td>010-84846003</td>--%>
                <%--							<td>12345678901</td>--%>
                <%--							<td>广告</td>--%>
                <%--							<td>zhangsan</td>--%>
                <%--							<td>已联系</td>--%>
                <%--						</tr>--%>

                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 60px;">
            <div id="cluePage">

            </div>
            <%--            <div>--%>
            <%--                <button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
            <%--            </div>--%>
            <%--            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
            <%--                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
            <%--                <div class="btn-group">--%>
            <%--                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
            <%--                        10--%>
            <%--                        <span class="caret"></span>--%>
            <%--                    </button>--%>
            <%--                    <ul class="dropdown-menu" role="menu">--%>
            <%--                        <li><a href="#">20</a></li>--%>
            <%--                        <li><a href="#">30</a></li>--%>
            <%--                    </ul>--%>
            <%--                </div>--%>
            <%--                <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
            <%--            </div>--%>
            <%--            <div style="position: relative;top: -88px; left: 285px;">--%>
            <%--                <nav>--%>
            <%--                    <ul class="pagination">--%>
            <%--                        <li class="disabled"><a href="#">首页</a></li>--%>
            <%--                        <li class="disabled"><a href="#">上一页</a></li>--%>
            <%--                        <li class="active"><a href="#">1</a></li>--%>
            <%--                        <li><a href="#">2</a></li>--%>
            <%--                        <li><a href="#">3</a></li>--%>
            <%--                        <li><a href="#">4</a></li>--%>
            <%--                        <li><a href="#">5</a></li>--%>
            <%--                        <li><a href="#">下一页</a></li>--%>
            <%--                        <li class="disabled"><a href="#">末页</a></li>--%>
            <%--                    </ul>--%>
            <%--                </nav>--%>
            <%--            </div>--%>
        </div>

    </div>

</div>
</body>
</html>