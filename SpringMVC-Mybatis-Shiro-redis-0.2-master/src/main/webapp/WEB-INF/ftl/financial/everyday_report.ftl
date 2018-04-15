<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8" />
    <title>财务管理 - 每日报表</title>
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
    <link   rel="icon" href="${basePath}/favicon.ico" type="image/x-icon" />
    <link   rel="shortcut icon" href="${basePath}/favicon.ico" />
    <link href="${basePath}/js/common/bootstrap/3.3.5/css/bootstrap.min.css?${_v}" rel="stylesheet"/>
    <link href="${basePath}/css/common/base.css?${_v}" rel="stylesheet"/>
    <script  src="${basePath}/js/common/jquery/jquery1.8.3.min.js"></script>
    <script  src="${basePath}/js/common/layer/layer.js"></script>
    <script  src="${basePath}/js/common/bootstrap/3.3.5/js/bootstrap.min.js"></script>
    <script  src="${basePath}/js/shiro.demo.js"></script>
    <script  language="javascript" type="text/javascript" src="${basePath}/js/My97DatePicker/WdatePicker.js"></script>
    <script >
        so.init(function(){
            //初始化全选。
            so.checkBoxInit('#checkAll','[check=box]');

        <@shiro.hasPermission name="/role/deleteRoleById.shtml">
                //全选
                so.id('deleteAll').on('click',function(){
                    var checkeds = $('[check=box]:checked');
                    if(!checkeds.length){
                        return layer.msg('请选择要删除的选项。',so.default),!0;
                    }
                    var array = [];
                    checkeds.each(function(){
                        array.push(this.value);
                    });
                    return deleteById(array);
                });
        </@shiro.hasPermission>
        });

    </script>
</head>
<body data-target="#one" data-spy="scroll">
<#--引入头部-->
    <@_top.top 5/>
    <div class="container" style="padding-bottom: 15px;min-height: 300px; margin-top: 40px;">
        <div class="row">
            <#--引入左侧菜单-->
                <@_left.financial 2/>
                <div class="col-md-10">
                    <h2>每日报表</h2>
                    <hr>
                    <form method="post" action="" id="formId" class="form-inline">
                        <div clss="well">
                            <div class="form-group">
                                用&nbsp;户&nbsp;名：
                                <input type="text" class="form-control" style="width: 180px;" value="${userName?default('')}"
                                       name="userName" id="userName" placeholder="输入用户名称">
                                &nbsp;&nbsp;
                                视频名称：
                                <input type="text" class="form-control" style="width: 180px;" value="${videoName?default('')}"
                                       name="videoName" id="videoName" placeholder="输入视频名称">
                                <br><br>
                                开始时间：
                                <input type="text" value="${startDate?default('')}" id="startDate" name="startDate" class="form-control" style="width: 180px"
                                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd' ,maxDate:'#F{$dp.$D(\'endDate\')}'});"/>
                                &nbsp;&nbsp;
                                结束时间：
                                <input type="text" value="${endDate?default('')}" id="endDate" name="endDate" class="form-control" style="width: 180px"
                                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd' ,minDate:'#F{$dp.$D(\'startDate\')}'});" />
                                &nbsp;&nbsp;&nbsp;&nbsp;
                                <button type="submit" class="btn btn-primary">查询</button>
                            </div>
                        </div>
                        <hr>
                        <table class="table table-bordered">
                            <tr>
                                <th>编号</th>
                                <th>视频名称</th>
                                <th>短连接</th>
                                <th>时间</th>
                                <th>总播放次数</th>
                                <th>总收入</th>
                                <th>上传人</th>
                                <th>生成时间</th>
                            </tr>
                            <#if page?exists && page.list?size gt 0 >
                                <#list page.list as it>
                                    <tr>
                                        <td>${it_index+1}</td>
                                        <td>${it.weixinNikename?default('未设置')}</td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </#list>
                            </#if>
                        </table>
                        <#if page?exists>
                            <div class="pagination pull-right">
                                ${page.pageHtml}
                            </div>
                        </#if>
                    </form>
                </div>
        </div><#--/row-->


    </div>

</body>
</html>
