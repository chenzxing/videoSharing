package com.sojson.financial.service;

import com.sojson.common.model.URole;
import com.sojson.common.model.Uservideo;
import com.sojson.core.mybatis.page.Pagination;

import java.util.List;
import java.util.Map;

public interface IUservideoService{
	
	public int insert(Uservideo uservideo);
	public int insertSelective(Uservideo uservideo);
	
	public int insertBatch(List<Uservideo> uservideoList);

	public int deleteByPrimaryKey(Integer id);

	public Uservideo selectByPrimaryKey(Integer id);

	public int updateByPrimaryKey(Uservideo uservideo);

	public int updateByPrimaryKeySelective(Uservideo uservideo);

	Pagination<Uservideo> findPage(Map<String, Object> resultMap, Integer pageNo,Integer pageSize);

	Pagination<Uservideo> findPageEveryday(Map<String, Object> resultMap, Integer pageNo,Integer pageSize);
}