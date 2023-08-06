package com.powernode.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Controller
public class WorkbenchIndexController {

    /**
     * 跳转到业务主页面
     * @return
     */
    @RequestMapping("/workbench/index.do")
    public String index(){
        return "workbench/index";
    }


}
