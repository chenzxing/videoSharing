package com.sojson.user.controller;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.sojson.common.utils.AjaxData;
import com.sojson.common.utils.LoggerUtils;
import com.sojson.core.shiro.token.manager.TokenManager;
import com.sojson.user.manager.UserManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sojson.common.controller.BaseController;
import com.sojson.common.model.UUser;
import com.sojson.core.mybatis.page.Pagination;
import com.sojson.core.shiro.session.CustomSessionManager;
import com.sojson.user.bo.UserOnlineBo;
import com.sojson.user.service.UUserService;
/**
 * 
 * 开发公司：itboy.net<br/>
 * 版权：itboy.net<br/>
 * <p>
 * 
 * 用户会员管理
 * 
 * <p>
 * 
 * 区分　责任人　日期　　　　说明<br/>
 * 创建　周柏成　2016年5月26日 　<br/>
 * <p>
 * *******
 * <p>
 * @author zhou-baicheng
 * @email  i@itboy.net
 * @version 1.0,2016年5月26日 <br/>
 * 
 */
@Controller
@Scope(value="prototype")
@RequestMapping("member")
public class MemberController extends BaseController {
	/***
	 * 用户手动操作Session
	 * */
	@Autowired
	CustomSessionManager customSessionManager;
	@Autowired
	UUserService userService;
	/**
	 * 用户列表管理
	 * @return
	 */
	@RequestMapping(value="list")
	public ModelAndView list(ModelMap map,Integer pageNo,String findContent){
		
		map.put("findContent", findContent);
		Pagination<UUser> page = userService.findByPage(map,pageNo,pageSize);
		map.put("page", page);
		return new ModelAndView("member/list");
	}
	/**
	 * 在线用户管理
	 * @return
	 */
	@RequestMapping(value="online")
	public ModelAndView online(){
		List<UserOnlineBo> list = customSessionManager.getAllUser();
		return new ModelAndView("member/online","list",list);
	}
	/**
	 * 在线用户详情
	 * @return
	 */
	@RequestMapping(value="onlineDetails/{sessionId}",method=RequestMethod.GET)
	public ModelAndView onlineDetails(@PathVariable("sessionId")String sessionId){
		UserOnlineBo bo = customSessionManager.getSession(sessionId);
		return new ModelAndView("member/onlineDetails","bo",bo);
	}
	/**
	 * 改变Session状态
	 * @param status
	 * @param sessionId
	 * @return
	 */
	@RequestMapping(value="changeSessionStatus",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> changeSessionStatus(Boolean status,String sessionIds){
		return customSessionManager.changeSessionStatus(status,sessionIds);
	}
	/**
	 * 根据ID删除，
	 * @param ids	如果有多个，以“,”间隔。
	 * @return
	 */
	@RequestMapping(value="deleteUserById",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> deleteUserById(String ids){
		return userService.deleteUserById(ids);
	}
	/**
	 * 禁止登录
	 * @param id		用户ID
	 * @param status	1:有效，0:禁止登录
	 * @return
	 */
	@RequestMapping(value="forbidUserById",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> forbidUserById(Long id,Long status){
		return userService.updateForbidUserById(id,status);
	}

	/**
	 * 用户添加
	 * @param UUser
	 * @return
	 */
	@RequestMapping(value="addUser",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> addUser(UUser user){
		try {
			Date date = new Date();
			user.setCreateTime(date);
			user.setLastLoginTime(date);
			//把密码md5
			user = UserManager.md5Pswd(user);
			//设置有效
			user.setStatus(UUser._1);

			//获取当前登录用户的id
			Long userId = TokenManager.getToken().getId();
			user.setUserId(userId);

			user = userService.insert(user);
			resultMap.put("status", 200);
			resultMap.put("successCount", "添加用户成功");
		} catch (Exception e) {
			resultMap.put("status", 500);
			resultMap.put("message", "添加失败，请刷新后再试！");
			LoggerUtils.fmtError(getClass(), e, "添加用户报错。source[%s]",user.toString());
		}
		return resultMap;
	}

	/**
	 * 用户信息
	 * @param id
	 * @return
	 */
	@RequestMapping(value="editUser_view",method=RequestMethod.POST)
	@ResponseBody
	public AjaxData editUser_view(Long id){
		AjaxData ajaxData=new AjaxData();
		try {

			UUser user = userService.selectByPrimaryKey(id);
			ajaxData.setResultCode("0000");
			ajaxData.setResultMessage("查找成功");
			ajaxData.setData(user);
		} catch (Exception e) {
			ajaxData.setResultCode("0001");
			ajaxData.setResultMessage("查找失败，请刷新后再试");
		}
		return ajaxData;
	}

	/**
	 * 用户修改
	 * @param UUser
	 * @return
	 */
	@RequestMapping(value="editUser",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> editUser(UUser user){
		try {
			int a = userService.updateByPrimaryKeySelective(user);
			resultMap.put("status", 200);
			resultMap.put("successCount", "修改用户成功");
		} catch (Exception e) {
			resultMap.put("status", 500);
			resultMap.put("message", "修改失败，请刷新后再试！");
			LoggerUtils.fmtError(getClass(), e, "修改用户报错。source[%s]",user.toString());
		}
		return resultMap;
	}

}
