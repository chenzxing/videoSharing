package com.sojson.common.dao;

import java.util.List;
import com.sojson.common.model.Uservideo;

public interface UservideoMapper{

	int insert(Uservideo uservideo);

	int insertSelective(Uservideo uservideo);

	int insertBatch(List<Uservideo> uservideoList);

	int deleteByPrimaryKey(Integer id);

	Uservideo selectByPrimaryKey(Integer id);

	int updateByPrimaryKey(Uservideo uservideo);

	int updateByPrimaryKeySelective(Uservideo uservideo);

	List<Uservideo> queryByKeyword(Uservideo uservideo);


}
