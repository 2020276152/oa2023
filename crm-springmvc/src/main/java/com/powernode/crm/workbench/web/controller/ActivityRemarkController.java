package com.powernode.crm.workbench.web.controller;

import com.fasterxml.jackson.databind.util.ObjectBuffer;
import com.powernode.crm.commons.constant.Constants;
import com.powernode.crm.commons.model.ReturnObject;
import com.powernode.crm.commons.utils.DateUtils;
import com.powernode.crm.commons.utils.UUIDUtils;
import com.powernode.crm.settings.model.User;
import com.powernode.crm.settings.service.inter.UserService;
import com.powernode.crm.workbench.model.ActivityRemark;
import com.powernode.crm.workbench.service.inter.ActivityRemarkService;
import com.powernode.crm.workbench.service.inter.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ActivityRemarkController {
    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/saveCreateActivityRemark.do")
    @ResponseBody
    public Object saveCreateActivityRemark(ActivityRemark activityRemark, HttpSession session){
        User user = (User)session.getAttribute(Constants.SESSION_USER);
        ReturnObject retData = new ReturnObject();
        //封装参数
        //唯一id
        activityRemark.setId(UUIDUtils.getUUID());
        //创建时间
        activityRemark.setCreateTime(DateUtils.dateTimeToStr(new Date()));
        //创建者
        activityRemark.setCreateBy(user.getId());
        //编辑标识
        activityRemark.setEditFlag(Constants.Activity_Remark_Unedited);
        try {
            int row = activityRemarkService.saveCreateActivityRemark(activityRemark);
            if (row>0){
                retData.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                retData.setRetData(activityRemark);
            }else {
                retData.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                retData.setMsg("系统忙，请稍后再试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            retData.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            retData.setMsg("系统忙，请稍后再试...");
        }
        return retData;
    }

    @RequestMapping("/workbench/activity/removeActivityRemarkById.do")
    @ResponseBody
    public Object removeActivityRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
            int row = activityRemarkService.removeActivityRemarkById(id);
            if (row>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMsg("系统繁忙，请稍后再试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMsg("系统繁忙，请稍后再试...");
        }
        return returnObject;

    }

    @RequestMapping("/workbench/activity/queryActivityRemarkByIdForEdit.do")
    @ResponseBody
    public Object queryActivityRemarkByIdForEdit(String id){
        ActivityRemark activityRemark = activityRemarkService.selectActivityRemarkByIdForEdit(id);
        if (activityRemark!=null){
            return activityRemark;
        }
        return null;
    }

    @RequestMapping("/workbench/activity/editActivityRemark.do")
    @ResponseBody
    public Object editActivityRemark(ActivityRemark activityRemark,HttpSession session) {
        //封装参数
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        activityRemark.setEditBy(user.getId());
        activityRemark.setEditFlag(Constants.Activity_Remark_edited);
        activityRemark.setEditTime(DateUtils.dateTimeToStr(new Date()));
        ReturnObject returnObject = new ReturnObject();
        //调用service
        try {
            int row = activityRemarkService.editActivityRemark(activityRemark);
            if (row > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(activityRemark);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMsg("系统繁忙，请稍后再试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMsg("系统繁忙，请稍后再试！");
        }
        return  returnObject;
    }
}
