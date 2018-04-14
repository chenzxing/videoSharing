package com.sojson.financial.service.impl;

import com.sojson.common.dao.UservideoMapper;
import com.sojson.common.model.Uservideo;
import com.sojson.core.mybatis.BaseMybatisDao;
import com.sojson.core.mybatis.page.Pagination;
import com.sojson.financial.service.IUservideoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class UservideoService extends BaseMybatisDao<UservideoMapper> implements IUservideoService {

	@Autowired
    private UservideoMapper uservideoMapper;
	
	@Override
	public int insert(Uservideo uservideo){
		return uservideoMapper.insert(uservideo);
	}
	@Override
	public int insertSelective(Uservideo uservideo){
		return uservideoMapper.insertSelective(uservideo);
	}
	@Override
	public int insertBatch(List<Uservideo> uservideoList){
		return uservideoMapper.insertBatch(uservideoList);
	}

	@Override
	public int deleteByPrimaryKey(Integer id){
		return uservideoMapper.deleteByPrimaryKey(id);
	}
	
	@Override
	public Uservideo selectByPrimaryKey(Integer id){
		return uservideoMapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKey(Uservideo uservideo){
		return uservideoMapper.updateByPrimaryKey(uservideo);
	}
	@Override
	public int updateByPrimaryKeySelective(Uservideo uservideo){
			return uservideoMapper.updateByPrimaryKeySelective(uservideo);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Pagination<Uservideo> findPage(Map<String, Object> resultMap,
									  Integer pageNo, Integer pageSize) {
		return super.findPage(resultMap, pageNo, pageSize);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Pagination<Uservideo> findPageEveryday(Map<String, Object> resultMap, Integer pageNo, Integer pageSize) {
		return super.findPage("findAll_everyday","findCount_everyday",resultMap, pageNo, pageSize);
	}
}