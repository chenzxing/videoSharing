<!DOCTYPE html>
<html lang="zh-cn">
	<head>
		<meta charset="utf-8" />
		<title>用户列表 - 用户中心</title>
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
				<@shiro.hasPermission name="/member/deleteUserById.shtml">
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

                selectRoleById();
			});
			<@shiro.hasPermission name="/member/deleteUserById.shtml">
			//根据ID数组，删除
			function _delete(ids){
				var index = layer.confirm("确定这"+ ids.length +"个用户？",function(){
					var load = layer.load();
					$.post('${basePath}/member/deleteUserById.shtml',{ids:ids.join(',')},function(result){
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
			<@shiro.hasPermission name="/member/forbidUserById.shtml">
			/*
			*激活 | 禁止用户登录
			*/
			function forbidUserById(status,id){
				var text = status?'激活':'禁止';
				var index = layer.confirm("确定"+text+"这个用户？",function(){
					var load = layer.load();
					$.post('${basePath}/member/forbidUserById.shtml',{status:status,id:id},function(result){
						layer.close(load);
						if(result && result.status != 200){
							return layer.msg(result.message,so.default),!0;
						}else{
							layer.msg(text +'成功');
							setTimeout(function(){
								$('#formId').submit();
							},1000);
						}
					},'json');
					layer.close(index);
				});
			}
			</@shiro.hasPermission>

			<@shiro.hasPermission name="/member/addUser.shtml">
			function add_onclick(){
				$("#email").val("");
                $("#nickname").val("");
                $("#pswd").val("");
                $("#phone").val("");
                $('#adduser').modal();
			}

			<#--添加用户-->
            function addUser(){
                var nickname = $('#nickname').val(),
                        email = $('#email').val(),
                        pswd = $('#pswd').val(),
                        sex =$("input[name='sex']:checked").val(),
                        phone = $('#phone').val();
                //获取角色id
                obj = document.getElementsByName("add_role");
                check_val = [];
                var check_val ="" ;
                for(k in obj){
                    if(obj[k].checked){
                        if(k!=0){
                            check_val=check_val+",";
                        }
                        check_val=check_val+obj[k].value;
                    }
                }
                if($.trim(email) == ''){
                    return layer.msg('账号不能为空。',so.default),!1;
                }
                if($.trim(nickname) == ''){
                    return layer.msg('昵称不能为空。',so.default),!1;
                }
                if($.trim(pswd) == ''){
                    return layer.msg('密码不能为空。',so.default),!1;
                }
                if($.trim(sex) == ''){
                    return layer.msg('性别不能为空。',so.default),!1;
                }
                if($.trim(phone) == ''){
                    return layer.msg('手机号码不能为空。',so.default),!1;
                }
                if(!isPoneAvailable(phone)){
                    return layer.msg('请输入正确的手机号码。',so.default),!1;
                }
                if($.trim(check_val).length<1){
                    return layer.msg('角色不能为空。',so.default),!1;
                }
				<#--loding-->
                var load = layer.load();
                $.post('${basePath}/member/addUser.shtml',
						{nickname:nickname,email:email,pswd:pswd,sex:sex,phone:phone,roleId:check_val},
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

			<!-- 用户修改-->
			<@shiro.hasPermission name="/member/editUser.shtml">
			function editBtn(id){
                var load = layer.load();
                $.post('${basePath}/member/editUser_view.shtml',
                        {id:id},
                        function(data){
                            layer.close(load);
                            if(data.resultCode=="0000"){
                                var roleId =data.data.roleIds;
                                var user=data.data.user;

								$('#id').val(user.id);
                                $('#edit_email').val(user.email);
                                $('#edit_nickname').val(user.nickname);
                                $('#edit_pswd').val(user.pswd);
                                $('#edit_phone').val(user.phone);
                                if(user.sex==1){
                                    $("#sex_1").prop("checked",true);
								}
								else{
                                    $("#sex_2").prop("checked",true);
								}
								for(var i=0;i<roleId.length;i++){
                                    var checkeId="#edit_role_"+roleId[i];
                                    $(checkeId).attr('checked', "checked")
								}
                                $('#edituser').modal();
                            }
                            else{
                                layer.msg('打开修改页面失败。');
							}
						},'json');
			}

			<#--修改用户-->
            function editUser(){
                var nickname = $('#edit_nickname').val(),
                        email = $('#edit_email').val(),
                        pswd = $('#edit_pswd').val(),
                        sex =$("input[name='edit_sex']:checked").val(),
                        phone = $('#edit_phone').val(),
						id=$("#id").val();
                //获取角色id
                obj = document.getElementsByName("edit_role");
                var check_val ="" ;
                for(k in obj){
                    if(obj[k].checked){
                        if(k!=0){
                            check_val=check_val+",";
                        }
                        check_val=check_val+obj[k].value;
					}
                }
                if($.trim(email) == ''){
                    return layer.msg('账号不能为空。',so.default),!1;
                }
                if($.trim(nickname) == ''){
                    return layer.msg('昵称不能为空。',so.default),!1;
                }
                if($.trim(pswd) == ''){
                    return layer.msg('密码不能为空。',so.default),!1;
                }
                if($.trim(sex) == ''){
                    return layer.msg('性别不能为空。',so.default),!1;
                }
                if($.trim(phone) == ''){
                    return layer.msg('手机号码不能为空。',so.default),!1;
                }
                if(!isPoneAvailable(phone)){
                    return layer.msg('请输入正确的手机号码。',so.default),!1;
				}
                if($.trim(check_val).length<1){
                    return layer.msg('角色不能为空。',so.default),!1;
                }
				<#--loding-->
                var load = layer.load();
                $.post('${basePath}/member/editUser.shtml',
                        {id:id,nickname:nickname,email:email,pswd:pswd,sex:sex,phone:phone,roleId:check_val},
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

            /*
            *根据角色ID选择权限，分配权限操作。
            */
            function selectRoleById(id){
                var load = layer.load();
                $.post("/role/selectRoleByUserId.shtml",{id:id},function(result){
                    layer.close(load);
                    if(result && result.length){
                        var add_html ="";
                        var edit_html ="";
                        $.each(result,function(){
                            //新增用户的角色
                            add_html=add_html+"<label><input type='checkbox' id='role_"+this.id+"' name='add_role' value='"+this.id+"'>"+this.name+"</label>&nbsp;&nbsp;";
                            //修改用户的角色
                            edit_html=edit_html+"<label><input type='checkbox' id='edit_role_"+this.id+"' name='edit_role' value='"+this.id+"'>"+this.name+"</label>&nbsp;&nbsp;";
                        });
                        $("#role_btn").html(add_html);
                        $("#edit_role_btn").html(edit_html);
                        return;
                    }else{
                        return layer.msg('没有获取到用户数据，请先注册数据。',so.default);
                    }
                },'json');
            }

            //手机号码正则校验
            function isPoneAvailable(phone) {
                var myreg=/^[1][3,4,5,7,8][0-9]{9}$/;
                if (!myreg.test(phone)) {
                    return false;
                } else {
                    return true;
                }
            }
		</script>
	</head>
	<body data-target="#one" data-spy="scroll">
		
		<@_top.top 2/>
		<div class="container" style="padding-bottom: 15px;min-height: 300px; margin-top: 40px;">
			<div class="row">
				<@_left.member 1/>
				<div class="col-md-10">
					<h2>用户列表</h2>
					<hr>
					<form method="post" action="" id="formId" class="form-inline">
						<div clss="well">
					      <div class="form-group">
					        <input type="text" class="form-control" style="width: 300px;" value="${findContent?default('')}" 
					        			name="findContent" id="findContent" placeholder="输入昵称 / 帐号">
					      </div>
					     <span class=""> <#--pull-right -->
				         	<button type="submit" class="btn btn-primary">查询</button>
							 <@shiro.hasPermission name="/member/addUser.shtml">
								 <a class="btn btn-success" onclick="add_onclick()">增加用户</a>
							 </@shiro.hasPermission>
				         	<@shiro.hasPermission name="/member/deleteUserById.shtml">
				         		<button type="button" id="deleteAll" class="btn  btn-danger">删除用户</button>
				         	</@shiro.hasPermission>
				         </span>    
				        </div>
					<hr>
					<table class="table table-bordered">
						<tr>
							<th><input type="checkbox" id="checkAll"/></th>
							<th>昵称</th>
							<th>Email/帐号</th>
							<th>登录状态</th>
							<th>创建时间</th>
							<th>最后登录时间</th>
							<th>操作</th>
						</tr>
						<#if page?exists && page.list?size gt 0 >
							<#list page.list as it>
								<tr>
									<td><input value="${it.id}" check='box' type="checkbox" /></td>
									<td>${it.nickname?default('未设置')}</td>
									<td>${it.email?default('未设置')}</td>
									<td>${(it.status==1)?string('有效','禁止')}</td>
									<td>${it.createTime?string('yyyy-MM-dd HH:mm')}</td>
									<td>${it.lastLoginTime?string('yyyy-MM-dd HH:mm')}</td>
									<td>
										<@shiro.hasPermission name="/member/forbidUserById.shtml">
										${(it.status==1)?string('<i class="glyphicon glyphicon-eye-close"></i>&nbsp;','<i class="glyphicon glyphicon-eye-open"></i>&nbsp;')}
										<a href="javascript:forbidUserById(${(it.status==1)?string(0,1)},${it.id})">
											${(it.status==1)?string('禁止登录','激活登录')}
										</a>
										</@shiro.hasPermission>
										<@shiro.hasPermission name="/member/editUser.shtml">
											<#if it.status==1>
                                            	<a  onclick="editBtn(${it.id})">修改</a>
											</#if>
										</@shiro.hasPermission>
										<@shiro.hasPermission name="/member/deleteUserById.shtml">
										<a href="javascript:_delete([${it.id}]);">删除</a>
										</@shiro.hasPermission>
									</td>
								</tr>
							</#list>
						<#else>
							<tr>
								<td class="text-center danger" colspan="6">没有找到用户</td>
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

            <!-- 新增用户-->
			<@shiro.hasPermission name="/member/addUser.shtml">
			<#--添加弹框-->
				<div class="modal fade" id="adduser" tabindex="-1" role="dialog" aria-labelledby="adduserLabel">
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
								<h4 class="modal-title" id="adduserLabel">添加用户</h4>
							</div>
							<div class="modal-body">
								<form id="boxRoleForm">
                                    <div class="form-group">
                                        <label for="recipient-name" class="control-label">账号:</label>
                                        <input type="text" class="form-control" name="email" id="email" maxlength="20" placeholder="请输入账号"/>
                                    </div>
									<div class="form-group">
										<label for="recipient-name" class="control-label">昵称:</label>
										<input type="text" class="form-control" name="nickname" id="nickname" maxlength="8" placeholder="请输入昵称"/>
									</div>
									<div class="form-group">
										<label for="recipient-name" class="control-label">密码:</label>
										<input type="password" class="form-control" id="pswd" name="pswd"  maxlength="16" placeholder="请输入密码">
									</div>
                                    <div class="form-group">
                                        <label for="recipient-name" class="control-label">性别:</label>
                                        <input type="radio" name="sex" value="1">男
                                        <input type="radio" name="sex" value="2">女
                                    </div>
                                    <div class="form-group">
                                        <label for="recipient-name" class="control-label">手机号码:</label>
                                        <input type="text" class="form-control" id="phone" name="phone"  maxlength="11" placeholder="请输入手机号码">
                                    </div>
                                    <div class="form-group">
                                        <label for="recipient-name" class="control-label">角色：</label>
                                        <div id="role_btn">

										</div>
                                    </div>
								</form>
							</div>
							<div class="modal-footer">
                                <button type="button" onclick="addUser();" class="btn btn-primary">保存</button>
								<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
							</div>
						</div>
					</div>
				</div>
			<#--/添加用户弹框-->
			</@shiro.hasPermission>

            <!-- 修改用户弹窗-->
			<@shiro.hasPermission name="/member/editUser.shtml">
			<#--添加弹框-->
				<div class="modal fade" id="edituser" tabindex="-1" role="dialog" aria-labelledby="edituserLabel">
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
								<h4 class="modal-title" id="edituserLabel">修改用户</h4>
							</div>
							<div class="modal-body">
								<form id="boxRoleForm">
                                    <div class="form-group" style="display: none">
                                        <input type="text" class="form-control" name="id" id="id" />
                                    </div>
									<div class="form-group">
										<label for="recipient-name" class="control-label">账号:</label>
										<input type="text" class="form-control" name="email" id="edit_email" maxlength="20" disabled="disabled" placeholder="请输入账号"/>
									</div>
									<div class="form-group">
										<label for="recipient-name" class="control-label">昵称:</label>
										<input type="text" class="form-control" name="nickname" maxlength="8" id="edit_nickname" placeholder="请输入昵称"/>
									</div>
									<div class="form-group">
										<label for="recipient-name" class="control-label">密码:</label>
										<input type="password" class="form-control" id="edit_pswd" name="pswd" maxlength="16"  placeholder="请输入密码">
									</div>
									<div class="form-group">
										<label for="recipient-name" class="control-label">性别:</label>
										<input type="radio" id="sex_1" name="edit_sex" value="1">男
										<input type="radio" id="sex_2" name="edit_sex" value="2">女
									</div>
									<div class="form-group">
										<label for="recipient-name" class="control-label">手机号码:</label>
										<input type="text" class="form-control" id="edit_phone" name="phone" maxlength="11"  placeholder="请输入手机号码">
									</div>
                                    <div class="form-group">
                                        <label for="recipient-name" class="control-label">角色：</label>
                                        <div id="edit_role_btn">

                                        </div>
                                    </div>
								</form>
							</div>
							<div class="modal-footer">
								<button type="button" onclick="editUser();" class="btn btn-primary">保存</button>
								<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
							</div>
						</div>
					</div>
				</div>
			<#--/添加弹框-->
			</@shiro.hasPermission>


		</div>
			
	</body>
</html>