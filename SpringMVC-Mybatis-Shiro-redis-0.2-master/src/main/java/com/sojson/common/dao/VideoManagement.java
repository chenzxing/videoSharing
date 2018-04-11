package com.sojson.common.dao;


import com.sojson.common.model.Video;
import com.sojson.permission.bo.URoleBo;

import java.util.List;
import java.util.Map;
import java.util.Set;

public interface VideoManagement {

    int deleteVideoById(Long id);

    Set<String> findVideoByName(String name);

    int updateVideoInfo(Video video);

    int findVideoByID (Long id);

    Video selectByPrimaryKey(Long id);

    int insert(Video video);
}