package com.sojson.operations.controller;

import com.sojson.common.controller.BaseController;

import com.sojson.common.model.UUser;
import com.sojson.common.utils.AjaxData;
import com.sojson.common.utils.LoggerUtils;
import com.sojson.core.mybatis.page.Pagination;
import com.sojson.core.shiro.session.CustomSessionManager;
import com.sojson.core.shiro.token.manager.TokenManager;
import com.sojson.operations.service.VideoService;
import com.sojson.user.service.UUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import com.sojson.common.model.Video;


import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.*;
import java.text.SimpleDateFormat;

@Controller
@Scope(value="prototype")
@RequestMapping("operations")
public class ManagementVideoController  extends BaseController {


    @Autowired
    UUserService userService;
    @Autowired
    CustomSessionManager customSessionManager;
    @Autowired
    VideoService videoService;
    /**
     * 视频列表
     * @return
     */
    @RequestMapping(value="index")
    public ModelAndView index(String findContent, ModelMap modelMap,Integer pageNo){
        modelMap.put("findContent", findContent);
        //获取当前登录用户的id
        Long userId = TokenManager.getToken().getId();
        modelMap.put("userid", userId);
        Pagination<Video> videos = videoService.findPage(modelMap,pageNo,pageSize);

        return new ModelAndView("operations/index","page",videos);
    }
    /**
     * 根据ID删除，
     * @param ids	如果有多个，以“,”间隔。
     * @return
     */
    @RequestMapping(value="deleteVideoById",method=RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> deleteVideoById(String ids){
        return videoService.deleteVideoById(ids);
    }

    /**
     * 根据ID删除，
     * @param ids	如果有多个，以“,”间隔。
     * @return
     */
    @RequestMapping(value="findVideoByID",method=RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> findVideoByID(String ids){
        return videoService.deleteVideoById(ids);
    }



    /**
     * 视频信息修改
     * @param video
     * @return
     */


    @RequestMapping(value="editVideo",method=RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> editVideo(Video video,HttpServletRequest request){
        try {
            Date date = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String dateString =  sdf.format(date);
            video.setUpdateTime(dateString);
            int a = videoService.updateVideoInfo(video);

            resultMap.put("status", 200);
            resultMap.put("successCount", "修改视频信息成功");
        } catch (Exception e) {
            resultMap.put("status", 500);
            resultMap.put("message", "修改失败，请刷新后再试！");
            LoggerUtils.fmtError(getClass(), e, "修改视频信息报错。source[%s]",video.toString());
        }
        return resultMap;
    }

    /**
     * 用户信息
     * @param id
     * @return
     */
    @RequestMapping(value="editVoideo_view",method=RequestMethod.POST)
    @ResponseBody
    public AjaxData editVoideo_view(Long id){
        AjaxData ajaxData=new AjaxData();
        try {

            Video video = videoService.selectByPrimaryKey(id);

            Map<String,Object> map=new HashMap<String, Object>();
            map.put("video",video);

            ajaxData.setResultCode("0000");
            ajaxData.setResultMessage("查找成功");
            ajaxData.setData(map);
        } catch (Exception e) {
            ajaxData.setResultCode("0001");
            ajaxData.setResultMessage("查找失败，请刷新后再试");
        }
        return ajaxData;
    }



    /**
     * 用户添加
     * @param video
     * @return
     */
    @RequestMapping(value="addVideo",method=RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> addVideo(Video video){
        try {
            Date date = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String dateString =  sdf.format(date);
            video.setUploadDate(dateString);
            video.setUpdateTime(dateString);
            video.setStatus((long)1);
            video.setPassed((long)1);
            video.setPassedTiime(dateString);
            video.setMaxPrice((BigDecimal) video.getMaxPrice());
            video.setMinPrice((BigDecimal) video.getMinPrice());
            video.setFixedPrice((BigDecimal) video.getFixedPrice());

            //获取当前登录用户的id
            Long userId = TokenManager.getToken().getId();
            video.setPromulgatorID(userId);


            int a = videoService.insert(video);

            resultMap.put("status", 200);
            resultMap.put("successCount", "添加视频成功");
        } catch (Exception e) {
            resultMap.put("status", 500);
            resultMap.put("message", "添加失败，请刷新后再试！");
            LoggerUtils.fmtError(getClass(), e, "添加视频报错。source[%s]",video.toString());
        }
        return resultMap;
    }
}
