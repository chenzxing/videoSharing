package com.sojson.operations.service;


import com.sojson.common.model.Video;
import com.sojson.core.mybatis.page.Pagination;
import org.springframework.ui.ModelMap;

import java.util.List;
import java.util.Map;
import java.util.Set;

public interface VideoService {

	Pagination<Video> findPage(Map<String, Object> resultMap, Integer pageNo,
							   Integer pageSize);

	int deleteByPrimaryKey(Long id);

	Map<String, Object> deleteVideoById(String ids);

	int updateVideoInfo(Video video);

	Video selectByPrimaryKey(Long id);

	int insert(Video video);
}
