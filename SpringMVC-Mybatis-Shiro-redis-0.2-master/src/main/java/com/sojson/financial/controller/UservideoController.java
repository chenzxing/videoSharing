package com.sojson.financial.controller;

import com.sojson.common.controller.BaseController;
import com.sojson.common.model.ReportVideo;
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

import java.text.SimpleDateFormat;
import java.util.Date;

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
    public ModelAndView index(ModelMap map, Integer pageNo, String userName, String videoName, String startDate, String endDate){
        Date d = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd");

        map.put("userName", userName);
        map.put("videoName", videoName);
        if( startDate == null || startDate.length() == 0)
        {

            map.put("startDate", date.format(d));
        }
        else {
            map.put("startDate", startDate);

        }
        if( startDate == null || startDate.length() == 0)
        {
            map.put("endDate",  date.format(d));
        }
        else {
            map.put("endDate", endDate);
        }


        Pagination<ReportVideo> page = uservideoService.findPage(map,pageNo,pageSize);

        for (ReportVideo reportVideo:
                page.getList()) {
            reportVideo.setSkb(IConfig.get("domain.videoarea") + "?movie_id=" +  reportVideo.getPromulgatorid());
        }

        map.put("page", page);

        return new ModelAndView("financial/total_report",map);
    }

    /**
     * 每日报表
     * @return
     */
    @RequestMapping(value="index_everyday")
    public ModelAndView index_everyday(ModelMap map,Integer pageNo,String userName, String videoName, String startDate, String endDate){
        Date d = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd");
        map.put("userName", userName);
        map.put("videoName", videoName);
        if( startDate == null || startDate.length() == 0)
        {

            map.put("startDate",  date.format(d));
        }
        else {
            map.put("startDate", startDate);

        }
        if( startDate == null || startDate.length() == 0)
        {
            map.put("endDate",  date.format(d));
        }
        else {
            map.put("endDate", endDate);
        }

        Pagination<ReportVideo> page = uservideoService.findPageEveryday(map,pageNo,pageSize);
        for (ReportVideo reportVideo:
                page.getList()) {
            reportVideo.setSkb(IConfig.get("domain.videoarea") + "?movie_id=" +  reportVideo.getPromulgatorid());
        }

        map.put("page", page);
        return new ModelAndView("financial/everyday_report");
    }
}
