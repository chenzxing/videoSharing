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
                $("#fullName").val("");
                $("#idNumber").val("");
                $('#adduser').modal();
			}

			<#--添加用户-->
            function addUser(){
                var nickname = $('#nickname').val(),
                        email = $('#email').val(),
                        pswd = $('#pswd').val(),
                        sex =$("input[name='sex']:checked").val(),
                        phone = $('#phone').val(),
                        fullName=$("#fullName").val(),
                		idNumber=$("#idNumber").val();
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
                if($.trim(fullName) == ''){
                    return layer.msg('姓名不能为空。',so.default),!1;
                }
                if($.trim(idNumber) == ''){
                    return layer.msg('身份证号码不能为空。',so.default),!1;
                }

                if(!IdentityCodeValid(idNumber)){
                    return layer.msg('请输入正确的身份证号码。',so.default),!1;
				}
				<#--loding-->
                var load = layer.load();
                $.post('${basePath}/member/addUser.shtml',
						{nickname:nickname,email:email,pswd:pswd,sex:sex,phone:phone,roleId:check_val,fullName:fullName,idNumber:idNumber},
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
                                $("#edit_fullName").val(user.fullName);
                                $("#edit_idNumber").val(user.idNumber);
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
						id=$("#id").val(),
                        fullName=$("#edit_fullName").val(),
                        idNumber=$("#edit_idNumber").val();
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
                if($.trim(fullName) == ''){
                    return layer.msg('姓名不能为空。',so.default),!1;
                }
                if($.trim(idNumber) == ''){
                    return layer.msg('身份证号码不能为空。',so.default),!1;
                }
                if(!IdentityCodeValid(idNumber)){
                    return layer.msg('请输入正确的身份证号码。',so.default),!1;
                }
				<#--loding-->
                var load = layer.load();
                $.post('${basePath}/member/editUser.shtml',
                        {id:id,nickname:nickname,email:email,pswd:pswd,sex:sex,phone:phone,roleId:check_val,fullName:fullName,idNumber:idNumber},
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

            //身份证号码校验
            function IdentityCodeValid(code) {
                var city={11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江 ",31:"上海",32:"江苏",33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",42:"湖北 ",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",51:"四川",52:"贵州",53:"云南",54:"西藏 ",61:"陕西",62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外 "};
                var tip = "";
                var pass= true;

                if(!code || !/^\d{6}(18|19|20)?\d{2}(0[1-9]|1[12])(0[1-9]|[12]\d|3[01])\d{3}(\d|X)$/i.test(code)){
                    tip = "身份证号格式错误";
                    pass = false;
                }

                else if(!city[code.substr(0,2)]){
                    tip = "地址编码错误";
                    pass = false;
                }
                else{
                    //18位身份证需要验证最后一位校验位
                    if(code.length == 18){
                        code = code.split('');
                        //∑(ai×Wi)(mod 11)
                        //加权因子
                        var factor = [ 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 ];
                        //校验位
                        var parity = [ 1, 0, 'X', 9, 8, 7, 6, 5, 4, 3, 2 ];
                        var sum = 0;
                        var ai = 0;
                        var wi = 0;
                        for (var i = 0; i < 17; i++)
                        {
                            ai = code[i];
                            wi = factor[i];
                            sum += ai * wi;
                        }
                        var last = parity[sum % 11];
                        if(parity[sum % 11] != code[17]){
                            tip = "校验位错误";
                            pass =false;
                        }
                    }
                }
                return pass;
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
							<th>姓名</th>
							<th>身份证号码</th>
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
									<td>${it.fullName?default('未设置')}</td>
									<td>${it.idNumber?default('未设置')}</td>
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
                                        <label for="recipient-name" class="control-label">姓名:</label>
                                        <input type="text" class="form-control" name="fullName" id="fullName" maxlength="30" placeholder="请输入姓名"/>
                                    </div>
                                    <div class="form-group">
                                        <label for="recipient-name" class="control-label">身份证号码:</label>
                                        <input type="text" class="form-control" name="idNumber" id="idNumber" maxlength="30" placeholder="请输入身份证号码"/>
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
                                        <label for="recipient-name" class="control-label">姓名:</label>
                                        <input type="text" class="form-control" name="fullName" id="edit_fullName" maxlength="30" placeholder="请输入姓名"/>
                                    </div>
                                    <div class="form-group">
                                        <label for="recipient-name" class="control-label">身份证号码:</label>
                                        <input type="text" class="form-control" name="idNumber" id="edit_idNumber" maxlength="30" placeholder="请输入身份证号码"/>
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