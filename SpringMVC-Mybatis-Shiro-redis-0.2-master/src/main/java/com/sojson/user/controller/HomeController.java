package com.sojson.user.controller;

import com.sojson.common.controller.BaseController;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
@Scope(value="prototype")
@RequestMapping("home")
public class HomeController extends BaseController {

    /**
     * 首页页面
     * @return
     */
    @RequestMapping(value="view",method= RequestMethod.GET)
    public ModelAndView login(){

        return new ModelAndView("user/home");
    }

}
