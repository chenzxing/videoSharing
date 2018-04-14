package com.sojson.financial.controller;

import com.sojson.common.controller.BaseController;
import com.sojson.common.model.URole;
import com.sojson.common.model.UUser;
import com.sojson.common.model.Uservideo;
import com.sojson.core.config.IConfig;
import com.sojson.core.mybatis.page.Pagination;
import com.sojson.financial.service.IUservideoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import static com.sojson.common.controller.BaseController.pageSize;

@Controller
@Scope(value="prototype")
@RequestMapping("uservideo")
public class UservideoController extends BaseController {

    @Autowired
    IUservideoService uservideoService;

    /**
     * 视频总报表
     * @return
     */
    @RequestMapping(value="index")
    public ModelAndView index(ModelMap map,Integer pageNo,String findContent){

        map.put("findContent", findContent);
        Pagination<Uservideo> page = uservideoService.findPage(map,pageNo,pageSize);
        map.put("page", page);
        return new ModelAndView("financial/total_report");
    }

    /**
     * 每日报表
     * @return
     */
    @RequestMapping(value="index_everyday")
    public ModelAndView index_everyday(ModelMap map,Integer pageNo,String findContent){
        map.put("findContent", findContent);
        Pagination<Uservideo> page = uservideoService.findPageEveryday(map,pageNo,pageSize);
        map.put("page", page);
        return new ModelAndView("financial/everyday_report");
    }
}
