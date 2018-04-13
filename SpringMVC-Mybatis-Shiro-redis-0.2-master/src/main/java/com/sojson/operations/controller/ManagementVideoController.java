package com.sojson.operations.controller;

import com.sojson.common.controller.BaseController;

import com.sojson.common.model.UUser;
import com.sojson.common.utils.AjaxData;
import com.sojson.common.utils.LoggerUtils;
import com.sojson.core.mybatis.page.Pagination;
import com.sojson.core.shiro.session.CustomSessionManager;
import com.sojson.core.shiro.token.manager.TokenManager;
import com.sojson.operations.service.VideoService;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.ProgressListener;
import org.apache.commons.fileupload.disk.DiskFileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;
import com.sojson.common.model.Video;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.math.BigDecimal;
import java.util.*;
import java.text.SimpleDateFormat;


import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;

@Controller
@Scope(value="prototype")
@RequestMapping("operations")
public class ManagementVideoController  extends BaseController {



    @Autowired
    CustomSessionManager customSessionManager;
    @Autowired
    VideoService videoService;

    private  FTPClient ftp;
    /**
     *
     * @param path 上传到ftp服务器哪个路径下
     * @param addr 地址
     * @param port 端口号
     * @param username 用户名
     * @param password 密码
     * @return
     * @throws Exception
     */
    private  boolean connect(String path,String addr,int port,String username,String password) throws Exception {
        boolean result = false;
        ftp = new FTPClient();
        int reply;
        ftp.connect(addr,port);
        ftp.login(username,password);
        ftp.setFileType(FTPClient.BINARY_FILE_TYPE);
        reply = ftp.getReplyCode();
        if (!FTPReply.isPositiveCompletion(reply)) {
            ftp.disconnect();
            return result;
        }
        ftp.changeWorkingDirectory(path);
        result = true;
        return result;
    }
    /**
     *
     * @param fileName 上传的文件名
     *  @param input 上传的文件流
     * @throws Exception
     */
    private boolean upload(String fileName,FileInputStream input) throws Exception{

        boolean result =  ftp.storeFile(fileName, input);
        input.close();
        return result;
    }

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

        for (Video video:
        videos.getList()) {

        }


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
     * 视频信息
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
     * 视频添加
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


    /**
     * 视频添加
     * @param
     * @return
     */
    @RequestMapping(value="uploadVideo",method=RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> uploadVideo(@RequestParam MultipartFile file){
        try {
            String url= "/Video/";

            boolean result =false;
            //获取文件名
            String fileName = file.getOriginalFilename();
            //文件扩展名
            String extName = fileName.substring(fileName.lastIndexOf("."));

            long currentTime=System.currentTimeMillis();

            // 判断文件是否为空
            if (!file.isEmpty()) {



               // String filePath = "F://"+url+currentTime+newName+extName;
                 //   file.transferTo(new File(filePath));

                    connect(url, "192.168.0.103", 21, "administrator", "123");

                    InputStream inputStream = file.getInputStream();
                    FileInputStream input = (FileInputStream) (inputStream);

                   result =   upload(currentTime+extName,input);

            }

            if(result)
            {
                resultMap.put("url", url);
                resultMap.put("currentTime", currentTime );
                resultMap.put("status", 200);
                resultMap.put("successCount", "添加视频成功");
            }
            else {
                resultMap.put("status", 500);
                resultMap.put("message", "添加失败，请刷新后再试！");

            }

        } catch (Exception e) {
            resultMap.put("status", 500);
            resultMap.put("message", "添加失败，请刷新后再试！");
            LoggerUtils.fmtError(getClass(), e, "添加视频报错。source[%s]");
        }
        return resultMap;
    }


}
