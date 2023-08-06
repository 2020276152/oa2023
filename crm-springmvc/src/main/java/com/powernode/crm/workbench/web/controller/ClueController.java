package com.powernode.crm.workbench.web.controller;

import com.powernode.crm.commons.constant.Constants;
import com.powernode.crm.commons.model.ReturnObject;
import com.powernode.crm.commons.utils.DateUtils;
import com.powernode.crm.commons.utils.UUIDUtils;
import com.powernode.crm.settings.model.DicValue;
import com.powernode.crm.settings.model.User;
import com.powernode.crm.settings.service.inter.UserService;
import com.powernode.crm.workbench.model.ACRelation;
import com.powernode.crm.workbench.model.Activity;
import com.powernode.crm.workbench.model.Clue;
import com.powernode.crm.workbench.model.ClueRemark;
import com.powernode.crm.workbench.service.inter.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ClueController {
    @Autowired
    private ClueService clueService;
    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ACRelationService acRelationService;

    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        //称呼下拉列表
        List<DicValue> appellationList = dicValueService.queryDicValueByDicTypeCode("appellation");
        //线索来源下拉列表
        List<DicValue> sourceList = dicValueService.queryDicValueByDicTypeCode("source");
        //线索状态下拉列表
        List<DicValue> clueStateList = dicValueService.queryDicValueByDicTypeCode("clueState");
        request.setAttribute("userList",userList);
        request.setAttribute("appellationList",appellationList);
        request.setAttribute("clueStateList",clueStateList);
        request.setAttribute("sourceList",sourceList);
        return "workbench/clue/index";
    }

    @RequestMapping("/workbench/clue/queryAllClueByConditionForPage.do")
    @ResponseBody
    public Object queryAllClueByConditionForPage(String fullname,String company,String phone,String source,String owner,
                                                String mphone,String state,Integer pageNum,Integer pageSize){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("fullname",fullname);
        map.put("company",company);
        map.put("phone",phone);
        map.put("source",source);
        map.put("owner",owner);
        map.put("mphone",mphone);
        map.put("state",state);
        map.put("startIndex",(pageNum-1)*pageSize);
        map.put("pageSize",pageSize);
        //调用service
        List<Clue> clueList = clueService.queryAllCLueByConditionsForPage(map);
        Integer rows = clueService.queryCountOfClueByConditionForPage(map);
        //响应
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("clueList",clueList);
        retMap.put("rows",rows);
        return retMap;
    }

    @RequestMapping("/workbench/clue/saveCreateClue.do")
    @ResponseBody
    public Object saveCreateClue(Clue clue, HttpSession session){
        User user = (User)session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        //生成唯一主键
        clue.setId(UUIDUtils.getUUID());
        //创建者
        clue.setCreateBy(user.getId());
        //创建日期
        clue.setCreateTime(DateUtils.dateToStr(new Date()));
        try {
            int row = clueService.saveCreateClue(clue);
            if (row>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMsg("系统繁忙，请稍后再试");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMsg("系统繁忙，请稍后再试");
        }
        return  returnObject;
    }

    @RequestMapping("/workbench/clue/queryClueDetailById.do")
    public String queryClueForDetailById(String id,HttpServletRequest request){
        //获取线索
        Clue clue = clueService.queryClueForDetailById(id);
        //获取线索备注信息
        List<ClueRemark> clueRemarkList = clueRemarkService.queryClueForDetailById(id);
        //获取线索关联的市场活动信息
        List<Activity> associatedActivityList = activityService.queryActivityForClueDetailByClueId(id);
        request.setAttribute("clue",clue);
        request.setAttribute("clueRemarkList",clueRemarkList);
        request.setAttribute("associatedActivityList",associatedActivityList);
        return "workbench/clue/detail";
    }


    @RequestMapping("/workbench/clue/queryActivityForAssociation.do")
    @ResponseBody
    public Object queryActivityForAssociation(String activityName,String clueId){
        ReturnObject returnObject = new ReturnObject();
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("activityName",activityName);
        map.put("clueId",clueId);
        //调用service
        List<Activity> disassociatedActivityList = activityService.queryActivityForAssociation(map);
        if (disassociatedActivityList.size()>=0){
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setRetData(disassociatedActivityList);
        }else{
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMsg("系统繁忙，请稍后再试");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/saveCreateClueRemark.do")
    @ResponseBody
    public Object saveCreateClueRemark(ClueRemark clueRemark,HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User)session.getAttribute(Constants.SESSION_USER);
        //封装参数
        clueRemark.setId(UUIDUtils.getUUID());
        clueRemark.setCreateBy(user.getId());
        clueRemark.setCreateTime(DateUtils.dateTimeToStr(new Date()));
        clueRemark.setEditFlag(Constants.Activity_Remark_Unedited);
        //调用service
        try {
            int row = clueRemarkService.saveCreateClueRemark(clueRemark);
            if (row>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(clueRemark);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMsg("系统繁忙，请稍后再试");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMsg("系统繁忙，请稍后再试");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/saveCreateACRelationByList.do")
    @ResponseBody
    public Object saveCreateACRelationByList(String clueId,String[] activityIds){
        List<ACRelation> acRelationList = new ArrayList<>();
        ReturnObject retObj = new ReturnObject();
        //遍历activityIds
        ACRelation acRelation = null; //定义到循环体外面，效率更高，新创建对象的内存地址每遍历一次都存储在同一个变量当中
        for (String activityId : activityIds) {
            acRelation = new ACRelation();
            acRelation.setId(UUIDUtils.getUUID());
            acRelation.setClueId(clueId);
            acRelation.setActivityId(activityId);
            acRelationList.add(acRelation);
        }
        //调用service层
        try {
            int row = acRelationService.saveCreateACRelationByList(acRelationList);
            if (row>0){
                //查询关联成功的市场活动信息
                List<Activity> activityList = activityService.queryActivityForDetailByIs(activityIds);
                retObj.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                retObj.setRetData(activityList);
            }
        }catch (Exception e){
            e.printStackTrace();
            retObj.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            retObj.setMsg("系统繁忙，请稍后再试");
        }
        return retObj;
    }

    @RequestMapping("/workbench/clue/removeACRelationByClueIdAndActivityId.do")
    @ResponseBody
    public Object removeACRelationByClueIdAndActivityId(ACRelation acRelation){
        ReturnObject retObj = new ReturnObject();
        System.out.println(acRelation);
        try {
            int row = acRelationService.removeACRelationByClueIdAndActivityId(acRelation);
            if (row>0){
                retObj.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                retObj.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                retObj.setMsg("系统繁忙，请稍后再试");
            }
        }catch (Exception e){
            e.printStackTrace();
            retObj.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            retObj.setMsg("系统繁忙，请稍后再试");
        }
        return retObj;
    }

}
