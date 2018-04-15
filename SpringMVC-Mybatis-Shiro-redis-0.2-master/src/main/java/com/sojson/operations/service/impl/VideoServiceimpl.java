package com.sojson.operations.service.impl;


import com.sojson.common.dao.VideoManagement;
import com.sojson.common.model.Video;
import com.sojson.common.utils.LoggerUtils;
import com.sojson.core.mybatis.BaseMybatisDao;
import com.sojson.core.mybatis.page.Pagination;
import com.sojson.operations.service.VideoService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class VideoServiceimpl extends BaseMybatisDao<VideoManagement> implements VideoService{

    @Autowired
    VideoManagement videoManagement;
    @Override
    public Pagination<Video> findPage(Map<String, Object> resultMap,
                                      Integer pageNo, Integer pageSize) {
        return super.findPage(resultMap, pageNo, pageSize);
    }

    @Override
    public int deleteByPrimaryKey(Long id) {
        return videoManagement.deleteVideoById(id);
    }

    @Override
    public Video selectByPrimaryKey(Long id) {
        return videoManagement.selectByPrimaryKey(id);
    }

    @Override
    public Map<String, Object> deleteVideoById(String ids) {
        Map<String,Object> resultMap = new HashMap<String,Object>();
        try {
            int count=0;
            String[] idArray = new String[]{};
            if(StringUtils.contains(ids, ",")){
                idArray = ids.split(",");
            }else{
                idArray = new String[]{ids};
            }

            for (String id : idArray) {
                count+=this.deleteByPrimaryKey(new Long(id));
            }
            resultMap.put("status", 200);
            resultMap.put("count", count);
        } catch (Exception e) {
            LoggerUtils.fmtError(getClass(), e, "根据IDS删除视频出现错误，ids[%s]", ids);
            resultMap.put("status", 500);
            resultMap.put("message", "删除出现错误，请刷新后再试！");
        }
        return resultMap;
    }

    @Override
    public int updateVideoInfo(Video entity) {
        return videoManagement.updateVideoInfo(entity);
    }


    @Override
    public int insert(Video entity) {
      return   videoManagement.insert(entity);

    }

    @Override
    public List<Video> findPageByID(String ids) {

        List<Video> videoList = new ArrayList<Video>();
        try {

            String count="";
            String[] idArray = new String[]{};
            if(StringUtils.contains(ids, ",")){
                idArray = ids.split(",");
            }else{
                idArray = new String[]{ids};
            }

            for (String id : idArray) {
                videoList.add(videoManagement.findPageByID( id)) ;
            }


        } catch (Exception e) {

        }

        return videoList;
    }
}
