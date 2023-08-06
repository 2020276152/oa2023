package com.powernode.crm.settings.web.controller;

import com.powernode.crm.commons.constant.Constants;
import com.powernode.crm.commons.model.ReturnObject;
import com.powernode.crm.commons.utils.DateUtils;
import com.powernode.crm.settings.model.User;
import com.powernode.crm.settings.service.inter.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        return "settings/qx/user/login";    //   http://127.0.0.1:8080/crm
                                            //   /WEB-INF/pages/
                                            //   settings/qx/user/login
                                            //   .jsp
    }

    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpSession session,HttpServletResponse response){
        //销毁session
        session.invalidate();
        //清除cookie
        Cookie c1 = new Cookie("loginAct", "0");
        Cookie c2 = new Cookie("loginPwd", "0");
        c1.setMaxAge(0);
        c2.setMaxAge(0);
        response.addCookie(c1);
        response.addCookie(c2);
        return "redirect:/";//注意这里需要使用重定向（底层：response.sendRedirect(request.getContextPath()/)）
    }


    @ResponseBody
    @RequestMapping("/settings/qx/user/login.do")
    public Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpServletResponse response,HttpSession session){
        Map<String,Object> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user = userService.queryUserByLoginActAndPwd(map);
        ReturnObject returnObject = new ReturnObject();
        returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
        //判断用户是否为空
        if(user==null){//用户名或密码错误
            //返回账户或密码错误信息
            returnObject.setMsg("用户名或密码错误！");
        }else{
            long expireTime = 0L;
            long nowTime = 0L;
            try {
                expireTime = DateUtils.strDateToMillis(user.getExpireTime());
                nowTime = new Date().getTime();
            } catch (ParseException e) {
                throw new RuntimeException(e);
            }
            if (nowTime>expireTime){//账户过期
                //返回：登录失败，账号已过期
                returnObject.setMsg("账户已过期！");
            }else if("0".equals(user.getLockState())){
                //登录失败账户已锁定
                returnObject.setMsg("账户已锁定！");
            }else if(!user.getAllowIps().contains(request.getRemoteAddr())){
                //ip受限
                returnObject.setMsg("ip地址受限，请联系管理员！");
            }else {//登录成功（跳转到主页面）
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                request.getSession().setAttribute(Constants.SESSION_USER,user);
                //登录成功后判断是否存在cookie，不存在则添加cookie
                Cookie[] cs = request.getCookies();
                String cookieAct = "";
                String cookiePwd = "";
                for (Cookie c : cs) {
                    if ("loginAct".equals(c.getName())){
                        cookieAct = c.getValue();
                    }else if ("loginPwd".equals(c.getName())){
                        cookiePwd = c.getValue();
                    }
                }
                //fasle  cookieAct==loginAct and cooikePwd==loginPwd ，且如果用户勾选了记住密码不需要重置cookie的生命周期
                //如果用户更新了的密码，即使cookie中存在在账号密码，在用户勾选了记住密码也会重新写入cookie到客户端
                boolean isAddCookie = loginAct.equals(cookieAct)&&loginPwd.equals(cookiePwd)? false: true;
                if(isAddCookie){
                    //没有cookie，还需要判断是否选择了保存密码,添加10天的cookie
                    if("true".equals(isRemPwd)){
                        Cookie c1 = new Cookie("loginAct", loginAct);
                        Cookie c2 = new Cookie("loginPwd", loginPwd);
                        c1.setMaxAge(3600*24*10);
                        c2.setMaxAge(3600*24*10);
                        //当前路径是 ：http://127.0.0.1:8080/crm/settings/qx/user/login.do
                        //cookie的携带路径为:http://127.0.0.1:8080/crm/settings/qx/user及其子路径
                        response.addCookie(c1);
                        response.addCookie(c2);
                    }
                }else {
                    //有cookie，判断是否需要清除cookie
                    if ("false".equals(isRemPwd)){
                        Cookie c1 = new Cookie("loginAct", loginAct);
                        Cookie c2 = new Cookie("loginPwd", loginPwd);
                        //如果没有记住密码，说明用户觉得记住密码不安全，就删除没有过期的cookie，重置cookie时间为0
                        c1.setMaxAge(0);
                        c2.setMaxAge(0);
                        response.addCookie(c1);
                        response.addCookie(c2);
                    }
                }
            }
        }
        return returnObject;
    }


}
