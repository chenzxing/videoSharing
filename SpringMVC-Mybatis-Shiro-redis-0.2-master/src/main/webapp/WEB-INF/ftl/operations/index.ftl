<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8" />
    <title>代理运营 —视频管理</title>
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
    <link   rel="icon" href="${basePath}/favicon.ico" type="image/x-icon" />
    <link   rel="shortcut icon" href="${basePath}/favicon.ico" />
    <link href="${basePath}/js/common/bootstrap/3.3.5/css/bootstrap.min.css?${_v}" rel="stylesheet"/>
    <link href="${basePath}/css/common/base.css?${_v}" rel="stylesheet"/>
    <script  src="${basePath}/js/common/jquery/jquery1.8.3.min.js"></script>
    <script  src="${basePath}/js/common/layer/layer.js"></script>
    <script  src="${basePath}/js/common/bootstrap/3.3.5/js/bootstrap.min.js"></script>
    <script  src="${basePath}/js/shiro.demo.js"></script>
    <script >
        so.init(function(){
            //初始化全选。
            so.checkBoxInit('#checkAll','[check=box]');
				<@shiro.hasPermission name="/operations/deleteVideoById.shtml">
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
                    return _delete(array);
                });
                </@shiro.hasPermission>

            <@shiro.hasPermission name="/operations/generate.shtml">
				//全选
				so.id('generateAll').on('click',function(){
                    var checkeds = $('[check=box]:checked');
                    if(!checkeds.length){
                        return layer.msg('请选择要生成的视频。',so.default),!0;
                    }
                    var array = [];
                    checkeds.each(function(){
                        array.push(this.value);
                    });
                    return generateBtn(array);
                });
            </@shiro.hasPermission>


        });
			<@shiro.hasPermission name="/operations/deleteVideoById.shtml">
			//根据ID数组，删除
			function _delete(ids){
                var index = layer.confirm("确定这"+ ids.length +"个视频？",function(){
                    var load = layer.load();
                    $.post('${basePath}/operations/deleteVideoById.shtml',{ids:ids.join(',')},function(result){
                        layer.close(load);
                        if(result && result.status != 200){
                            return layer.msg(result.message,so.default),!0;
                        }else{
                            layer.msg('删除成功');
                            setTimeout(function(){
                                $('#formId').submit();
                            },1000);
                        }
                    },'json');
                    layer.close(index);
                });
            }
            </@shiro.hasPermission>
        <!-- 用户修改-->
			<@shiro.hasPermission name="/operations/editVideo.shtml">
			function editBtn(id){
                var load = layer.load();
                $.post('${basePath}/operations/editVoideo_view.shtml',
                        {id:id.join(',')},
                        function(data){
                            layer.close(load);
                            if(data.resultCode=="0000"){

                                var video=data.data.video;

                                $('#id').val(video.id);
                                $('#edit_VideoName').val(video.videoName);
                                $('#edit_MinPrice').val(video.minPrice);
                                $('#edit_FixedPrice').val(video.fixedPrice);
                                $('#edit_MaxPrice').val(video.maxPrice);
                                if(video.isFixedPrice==1){
                                    $("#IsFixedPrice_1").prop("checked",true);
                                }
                                else{
                                    $("#IsFixedPrice_2").prop("checked",true);
                                }

                                $('#editVideo').modal();
                            }
                            else{
                                layer.msg('打开修改页面失败。');
                            }
                        },'json');
            }

            <#--修改用户-->
            function editVideo(){
                var VideoName = $('#edit_VideoName').val(),
                        MinPrice = $('#edit_MinPrice').val(),
                        FixedPrice = $('#edit_FixedPrice').val(),
                        IsFixedPrice =$("input[name='edit_IsFixedPrice']:checked").val(),
                        MaxPrice = $('#edit_MaxPrice').val(),
                        id=$("#id").val();

                if($.trim(VideoName) == ''){
                    return layer.msg('视频名称不能为空。',so.default),!1;
                }
                if($.trim(IsFixedPrice) == ''){
                    return layer.msg('请选择是否固定价。',so.default),!1;
                }
                if($.trim(IsFixedPrice) == '1'){

                    if($.trim(FixedPrice) == ''){
                        return layer.msg('固定价格不能为空。',so.default),!1;
                    }
                }
                else {
                    if($.trim(MaxPrice) == ''){
                        return layer.msg('最高价格不能为空。',so.default),!1;
                    }
                    if($.trim(MinPrice) == ''){
                        return layer.msg('最低价格不能为空。',so.default),!1;
                    }
                    if(parseFloat(MaxPrice)  < parseFloat(MinPrice)){
                        return layer.msg('最高价格必须高于最低价格。',so.default),!1;
                    }
                }


            <#--loding-->
                var load = layer.load();
                $.post('${basePath}/operations/editVideo.shtml',
                        {id:id,videoName:VideoName,MinPrice:MinPrice,FixedPrice:FixedPrice,IsFixedPrice:IsFixedPrice,MaxPrice:MaxPrice},

                        function(result){
                            layer.close(load);
                            if(result && result.status != 200){
                                return layer.msg(result.message,so.default),!1;
                            }
                            layer.msg('修改成功。');
                            setTimeout(function(){
                                $('#formId').submit();
                            },1000);
                        },'json');
            }
            </@shiro.hasPermission>

        <@shiro.hasPermission name="/operations/addVideo.shtml">
        <#--添加视频-->
            function addVideo() {
                var VideoName = $('#VideoName').val(),
                        MinPrice = $('#MinPrice').val(),
                        FixedPrice = $('#FixedPrice').val(),
                        IsFixedPrice = $("input[name='IsFixedPrice']:checked").val(),
                        MaxPrice = $('#MaxPrice').val(),
                        f = $('#ck_attach_path').val();

                if ($.trim(f) == '') {
                    return layer.msg('请选择上传视频。', so.default), !1;
                }


                if ($.trim(VideoName) == '') {
                    return layer.msg('视频名称不能为空。', so.default), !1;
                }
                if ($.trim(IsFixedPrice) == '') {
                    return layer.msg('请选择是否固定价。', so.default), !1;
                }
                if ($.trim(IsFixedPrice) == '1') {

                    if ($.trim(FixedPrice) == '') {
                        return layer.msg('固定价格不能为空。', so.default), !1;
                    }
                }
                else {
                    if ($.trim(MaxPrice) == '') {
                        return layer.msg('最高价格不能为空。', so.default), !1;
                    }
                    if ($.trim(MinPrice) == '') {
                        return layer.msg('最低价格不能为空。', so.default), !1;
                    }
                    if (parseFloat(MaxPrice) < parseFloat(MinPrice)) {
                        return layer.msg('最高价格必须高于最低价格。', so.default), !1;
                    }
                }

                var load = layer.load();

                var fileresult = file();//开始上传视频


                if(fileresult !=null && fileresult.status != 200){
                    layer.close(load);
                    return layer.msg(fileresult.message,so.default),!1;
                }
                var VideoAddress = fileresult.url +fileresult.currentTime+fileresult.extName;
                var fileName = fileresult.fileName;
                var Alias = fileresult.currentTime;

            <#--loding-->

                $.post('${basePath}/operations/addVideo.shtml',
                        {videoName:VideoName,MinPrice:MinPrice,FixedPrice:FixedPrice,IsFixedPrice:IsFixedPrice,MaxPrice:MaxPrice,VideoAddress:VideoAddress,By1:fileName,Alias:Alias},
                        function(result){
                            layer.close(load);
                            if(result && result.status != 200){
                                return layer.msg(result.message,so.default),!1;
                            }
                            layer.msg('添加成功。');
                            setTimeout(function(){
                                $('#formId').submit();
                            },1000);
                        },'json');
            }
        </@shiro.hasPermission>


        //文件传到后台的方法
        function file()
        {
            var result ;

            var formData = new FormData();
            formData.append("file", $("#ck_attach_path")[0].files[0]);
            $.ajax({
                url: '${basePath}/operations/uploadVideo.shtml',
                type: 'post',
                data: formData,
                datatype:'JSON',
                fileElementId: 'fileContent',
                // 告诉jQuery不要去处理发送的数据
                processData: false,
                // 告诉jQuery不要去设置Content-Type请求头
                contentType: false,
                cache: false,
                traditional: true,
                async : false,
                success: function (data) {
                    // $('#img').attr('src', data);
                    result = data;
                }
            });
            return result;
        }


        <@shiro.hasPermission name="/operations/generate.shtml">
			//根据ID数组，获取
			function generateBtn(ids){

                var load = layer.load();
                $.post('${basePath}/operations/generate.shtml',{ids:ids.join(',')},function(result){
                    layer.close(load);
                    if(result && result.status != 200){
                        return layer.msg(result.message,so.default),!0;
                    }else{

                        setTimeout(function(){

                        },1000);
                    }
                },'json');


                
            }
        </@shiro.hasPermission>


    </script>
</head>
<body data-target="#one" data-spy="scroll">

		<@_top.top 4/>
<div class="container" style="padding-bottom: 15px;min-height: 300px; margin-top: 40px;">
    <div class="row">
		<@_left.viode 1/>
        <div class="col-md-10">
            <h2>视频管理</h2>
            <hr>
            <form method="post" action="" id="formId" class="form-inline">

                <div clss="well">
                    <div class="form-group">
                        <input type="text" class="form-control" style="width: 300px;" value="${findContent?default('')}"
                               name="findContent" id="findContent" placeholder="输入视频名称">
                    </div>
                    <span class=""> <#--pull-right -->
				         	<button type="submit" class="btn btn-primary">查询</button>
							 <@shiro.hasPermission name="/operations/generate.shtml">
									<button type="button" id="generateAll" class="btn  btn-danger">生成</button>
                             </@shiro.hasPermission>
                         <@shiro.hasPermission name="/operations/addVideo.shtml">
								 <a class="btn btn-success" onclick="$('#addVideo').modal();">增加视频</a>
                         </@shiro.hasPermission>
				         	<@shiro.hasPermission name="/operations/deleteVideoById.shtml">
				         		<button type="button" id="deleteAll" class="btn  btn-danger">删除视频</button>
                            </@shiro.hasPermission>
				         </span>
                </div>


                <hr>
                <table class="table table-bordered">
                    <tr>
                        <th><input type="checkbox" id="checkAll"/>  全选</th>
                        <th>编号</th>
                        <th>上传人</th>
                        <th>影片名称</th>
                        <th>价格(元)</th>
                        <th>短链接</th>
                        <th>添加时间</th>
                        <th>操作</th>
                    </tr>
						<#if page?exists && page.list?size gt 0 >
                            <#list page.list as it>
								<tr>
                                    <td><input value="${it.id}" check='box' type="checkbox" /></td>
                                    <td>${it_index + 1 }</td>
                                    <td>${it.userName?default('')}</td>
                                    <td>${it.videoName?default('未设置')}</td>
                                    <td>${(it.isFixedPrice==1)?string(it.fixedPrice?default('未设置'),it.minPrice?default('0') +'~'+ it.maxPrice?default('0') )}</td>
                                    <td>${it.SKB?default('未设置')}</td>
                                    <td>${it.uploadDate}</td>
                                    <td>
										<@shiro.hasPermission name="/operations/generate.shtml">
										<a href="javascript:generateBtn([${it.id}]);">生成</a>
                                        </@shiro.hasPermission>
                                        <@shiro.hasPermission name="/operations/editVideo.shtml">
										<a href="javascript:editBtn([${it.id}]);">编辑</a>
                                        </@shiro.hasPermission>
										<@shiro.hasPermission name="/operations/deleteVideoById.shtml">
										<a href="javascript:_delete([${it.id}]);">删除</a>
                                        </@shiro.hasPermission>
                                    </td>
                                </tr>
                            </#list>
                        <#else>
							<tr>
                                <td class="text-center danger" colspan="6">没有找到视频</td>
                            </tr>
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


    <!-- 新增视频-->
			<@shiro.hasPermission name="/operations/addVideo.shtml">
            <#--添加弹框-->
				<div class="modal fade" id="addVideo" tabindex="-1" role="dialog" aria-labelledby="addVideoLabel">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                <h4 class="modal-title" id="addVideoLabel">添加视频</h4>
                            </div>
                            <div class="modal-body">
                                <form id="boxRoleForm">
                                    <div class="form-group">
                                        <label for="recipient-name" class="control-label">视频名称:</label>
                                        <input type="text" class="form-control" name="VideoName" id="VideoName" maxlength="500" placeholder="请输入视频名称"/>
                                    </div>


                                    <label for="recipient-name" class="control-label">收款金额:</label>
                                    <div class="form-group "  >
                                        <div class="form-group"align="left" style="float:left">
                                            <input type="radio" checked  name="IsFixedPrice" value="0" >区间价（元）</input>
                                        </div>
                                        <div class="form-group"align="left" style="float:left">
                                            <label for="recipient-name" style="width: 30px" class="control-label">  </label>
                                        </div>
                                        <div class="form-group"align="left" style="float:left">
                                            <input type="text" class="form-control" name="MinPrice" id="MinPrice" maxlength="10" placeholder="请输入最低价格" onkeyup= "if( isNaN(this.value) || (this.value.indexOf('.') != -1  &&  this.value.length - this.value.indexOf('.')>3) ){alert('只能输入数字并且小数点后只能保留两位');this.value='';}"/>

                                        </div>
                                        <div class="form-group"align="left" style="float:left">
                                            <label for="recipient-name" style="width: 20px" class="control-label">  </label>
                                        </div>
                                        <div class="form-group"align="left" style="float:left">
                                            <label for="recipient-name"   class="control-label"> ~ </label>
                                        </div>
                                        <div class="form-group"align="left"  style="float:right">
                                            <input type="text" class="form-control"  name="MaxPrice" id="MaxPrice" maxlength="10" placeholder="请输入最高价格"  onkeyup= "if( isNaN(this.value) || (this.value.indexOf('.') != -1  &&  this.value.length - this.value.indexOf('.')>3) ){alert('只能输入数字并且小数点后只能保留两位');this.value='';}"/>

                                        </div>


                                        <div class="form-group" align="left"  style="float:left">
                                            <div class="form-group" align="left"  style="float:left">
                                                <input type="radio" name="IsFixedPrice" value="1">固定价（元）</input>
                                            </div>
                                            <div class="form-group"align="left" style="float:left">
                                                <label for="recipient-name" style="width: 30px" class="control-label">  </label>
                                            </div>

                                            <div class="form-group" align="left"  style="float:right">
                                                <input type="text"  onkeyup= "if( isNaN(this.value) || (this.value.indexOf('.') != -1  &&  this.value.length - this.value.indexOf('.')>3) ){alert('只能输入数字并且小数点后只能保留两位');this.value='';}"  class="form-control" style="width: 150px" name="FixedPrice" id="FixedPrice" maxlength="10" placeholder="请输入固定价格"/>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="recipient-name" class="control-label">  </label>
                                    </div>
                                    <div class="form-group">
                                        <label for="recipient-name" class="control-label">  </label>
                                    </div>
                                    <div class="form-group">
                                        <label for="recipient-name" class="control-label">  </label>
                                    </div>


                                    <div class="form-group" align="left"  style="float:left">

                                        <input type="file" name="file" id="ck_attach_path" style="width:98%;"/>
                                        <label for="recipient-name" class="control-label"> 目前仅支持MP4格式视频,上传中会有卡顿,请勿关闭界面 </label>
                                    </div>
                                </form>
                            </div>



                            <div class="form-group">
                                <label for="recipient-name" class="control-label">  </label>
                            </div>

                            <div class="modal-footer" >

                                <button type="button" onclick="addVideo();" class="btn btn-primary">保存</button>
                                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>

                            </div>
                        </div>
                    </div>
                </div>
            <#--/添加用户弹框-->
            </@shiro.hasPermission>

    <!-- 修改用户弹窗-->
			<@shiro.hasPermission name="/operations/editVideo.shtml">
            <#--添加弹框-->
				<div class="modal fade" id="editVideo" tabindex="-1" role="dialog" aria-labelledby="editVideoLabel">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                <h4 class="modal-title" id="editVideoLabel">修改视频信息</h4>
                            </div>
                            <div class="modal-body">
                                <form id="boxRoleForm">

                                    <div class="form-group" style="display: none">
                                        <input type="text" class="form-control" name="id" id="id" />
                                    </div>
                                    <div class="form-group">
                                        <label for="recipient-name" class="control-label">视频名称:</label>
                                        <input type="text" class="form-control" name="VideoName" id="edit_VideoName" maxlength="500" placeholder="请输入视频名称"/>
                                    </div>


                                    <label for="recipient-name" class="control-label">收款金额:</label>
                                    <div class="form-group "  >
                                        <div class="form-group"align="left" style="float:left">
                                            <input type="radio" checked  name="edit_IsFixedPrice" value="0" id="IsFixedPrice_2">区间价（元）</input>
                                        </div>
                                        <div class="form-group"align="left" style="float:left">
                                            <label for="recipient-name" style="width: 30px" class="control-label">  </label>
                                        </div>
                                        <div class="form-group"align="left" style="float:left">
                                            <input type="text" class="form-control" name="MinPrice" id="edit_MinPrice" maxlength="10" placeholder="请输入最低价格" onkeyup= "if( isNaN(this.value) || (this.value.indexOf('.') != -1  &&  this.value.length - this.value.indexOf('.')>3) ){alert('只能输入数字并且小数点后只能保留两位');this.value='';}"/>

                                        </div>
                                        <div class="form-group"align="left" style="float:left">
                                            <label for="recipient-name" style="width: 20px" class="control-label">  </label>
                                        </div>
                                        <div class="form-group"align="left" style="float:left">
                                            <label for="recipient-name"   class="control-label"> ~ </label>
                                        </div>
                                        <div class="form-group"align="left"  style="float:right">
                                            <input type="text" class="form-control"  name="MaxPrice" id="edit_MaxPrice" maxlength="10" placeholder="请输入最高价格"  onkeyup= "if( isNaN(this.value) || (this.value.indexOf('.') != -1  &&  this.value.length - this.value.indexOf('.')>3) ){alert('只能输入数字并且小数点后只能保留两位');this.value='';}"/>

                                        </div>


                                        <div class="form-group" align="left"  style="float:left">
                                            <div class="form-group" align="left"  style="float:left">
                                                <input type="radio" name="edit_IsFixedPrice" value="1" id="IsFixedPrice_1">固定价（元）</input>
                                            </div>
                                            <div class="form-group"align="left" style="float:left">
                                                <label for="recipient-name" style="width: 30px" class="control-label">  </label>
                                            </div>

                                            <div class="form-group" align="left"  style="float:left">
                                                <input type="text"  onkeyup= "if( isNaN(this.value) || (this.value.indexOf('.') != -1  &&  this.value.length - this.value.indexOf('.')>3) ){alert('只能输入数字并且小数点后只能保留两位');this.value='';}"  class="form-control" style="width: 150px" name="FixedPrice" id="edit_FixedPrice" maxlength="10" placeholder="请输入固定价格"/>
                                            </div>

                                        </div>
                                    </div>

                                </form>
                            </div>

                            <div class="form-group">
                                <label for="recipient-name" class="control-label">  </label>
                            </div>
                            <div class="form-group">
                                <label for="recipient-name" class="control-label">  </label>
                            </div>

                            <div class="modal-footer">
                                <button type="button" onclick="editVideo();" class="btn btn-primary">保存</button>
                                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                            </div>
                        </div>
                    </div>
                </div>
            <#--/添加弹框-->
            </@shiro.hasPermission>

    <!-- 修改用户弹窗-->
			<@shiro.hasPermission name="/operations/generate.shtml">
            <#--添加弹框-->
				<div class="modal fade" id="generate" tabindex="-1" role="dialog" aria-labelledby="generateLabel">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                <h4 class="modal-title" id="generateLabel">视频短链接信息</h4>
                            </div>
                            <div class="modal-body">


                                <div class="form-group"align="left" style="float:left">
                                    <label for="recipient-name" style="width: 30px" class="control-label" id = "generateShow">  </label>
                                </div>


                            </div>
                        </div>


                    </div>
                </div>
                </div>
            <#--/添加弹框-->
            </@shiro.hasPermission>

</div>

</body>
</html>