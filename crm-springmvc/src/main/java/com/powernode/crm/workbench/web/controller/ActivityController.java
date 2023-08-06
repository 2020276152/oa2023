package com.powernode.crm.workbench.web.controller;

import com.powernode.crm.commons.constant.Constants;
import com.powernode.crm.commons.model.ReturnObject;
import com.powernode.crm.commons.utils.DateUtils;
import com.powernode.crm.commons.utils.HSSFUtils;
import com.powernode.crm.commons.utils.UUIDUtils;
import com.powernode.crm.settings.model.User;
import com.powernode.crm.settings.service.inter.UserService;
import com.powernode.crm.workbench.model.Activity;
import com.powernode.crm.workbench.model.ActivityRemark;
import com.powernode.crm.workbench.service.inter.ActivityRemarkService;
import com.powernode.crm.workbench.service.inter.ActivityService;
import org.apache.poi.hssf.usermodel.*;
import org.springframework.aop.support.AopUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
        import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;

@Controller
public class ActivityController {
    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        request.setAttribute("userList",userList);
        return "workbench/activity/index";
    }

    @ResponseBody
    @RequestMapping("/workbench/activity/savaCreateActivity.do")
    public Object savaCreateActivity(Activity activity, HttpSession session){
        //生成唯一主键
        activity.setId(UUID.randomUUID().toString().replaceAll("-",""));
        //市场活动的创建用户
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        activity.setCreateBy(user.getId());
        //市场活动的创建时间
        activity.setCreateTime(DateUtils.dateTimeToStr(new Date()));
        ReturnObject returnObject = new ReturnObject();
        try {
            int affcet = activityService.savaCreateActivity(activity);
            if (affcet>0){
                //创建市场活动成功
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMsg("创建市场活动失败！");
            }
            return returnObject;
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    @ResponseBody
    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    public Object queryActivityByConditionForPage(String name,String owner,String startDate,String endDate,Integer pageNum,Integer pageSize){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("startIndex",(pageNum-1)*pageSize);
        map.put("pageSize",pageSize);
        //调用service
        List<Activity> activityList = activityService.queryActivityByConditionForPage(map);
        Integer totalRows = activityService.queryCountOfActivityByCondition(map);
        //封装返回结果集
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("activityList",activityList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }
    @ResponseBody
    @RequestMapping("/workbench/activity/removeActivity.do")
    public Object removeActivityByIds(String[] ids){
        //调用service
        try {
            int rows = activityService.removeActivityByIds(ids);
            ReturnObject returnObject = new ReturnObject();
            if (rows>0){
                //删除成功
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                //删除失败
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMsg("网络繁忙，请稍后再试...");
            }
            return returnObject;
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    @ResponseBody
    @RequestMapping("/workbench/activity/queryActivityById.do")
    public Object queryActivityById(String id){
        Activity activity = activityService.queryActivityById(id);
        if (activity!=null){
            return activity;
        }
        return null;
    }

    @ResponseBody
    @RequestMapping("/workbench/activity/modifyActivity.do")
    public Object modifyActivity(Activity activity,HttpSession session){
        //更新编辑时间 和 编辑者
        //获取user
        User user = (User)session.getAttribute(Constants.SESSION_USER);
        activity.setEditBy(user.getId());
        activity.setEditTime(DateUtils.dateToStr(new Date()));
        try {
            int row = activityService.modifyActivityById(activity);
            ReturnObject returnObject = new ReturnObject();
            if (row<0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMsg("系统繁忙，请稍后再试...");
                return returnObject;
            }
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            return returnObject;
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    @RequestMapping("/workbench/activity/exportAllActivities.do")
    public void exportAllActivities(HttpServletResponse response) throws Exception{
        List<Activity> activityList = activityService.queryAllActivities();
        for (Activity activity : activityList) {
            System.out.println(activity);
        }
        //创建Excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        //创建第一行
        HSSFSheet sheet = wb.createSheet("市场活动信息列表");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("费用");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("编辑日期");
        cell = row.createCell(10);
        cell.setCellValue("编辑者");
        //判断一下activityList是否为null，避免空指针异常，如果size<=0，则没必要遍历了
        if (activityList!=null&&activityList.size()>0){
            for(int i =0;i<activityList.size();i++){
                Activity activity = activityList.get(i);
                row = sheet.createRow(i+1);
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }
        //响应资源，文件下载
        response.setContentType("application/octet-stream;charset=utf-8");
        response.setHeader("content-Disposition","attachment;filename=allActivityList.xls");
        ServletOutputStream out = response.getOutputStream();
        //将wb（excel文件）直接写到一个字节流当中
        //内存 --- 》内存
        wb.write(out);
        wb.close();
        out.flush();
    }

    @RequestMapping("/workbench/activity/exportActivities.do")
    public void exportActivities(String[] ids,HttpServletResponse response) throws Exception{
        List<Activity> activityList = activityService.queryActivities(ids);
        //创建Excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        //创建第一行
        HSSFSheet sheet = wb.createSheet("市场活动信息列表");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("费用");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("编辑日期");
        cell = row.createCell(10);
        cell.setCellValue("编辑者");
        //判断一下activityList是否为null，避免空指针异常，如果size<=0，则没必要遍历了
        if (activityList!=null&&activityList.size()>0){
            for(int i =0;i<activityList.size();i++){
                Activity activity = activityList.get(i);
                row = sheet.createRow(i+1);
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }
        //响应资源，文件下载
        response.setContentType("application/octet-stream;charset=utf-8");
        response.setHeader("content-Disposition","attachment;filename=activityList.xls");
        ServletOutputStream out = response.getOutputStream();
        //将wb（excel文件）直接写到一个字节流当中
        //内存 --- 》内存
        wb.write(out);
        wb.close();
        out.flush();
    }

    @RequestMapping("/workbench/activity/importActivity.do")
    @ResponseBody
    public Object importActivity(MultipartFile activityFile,HttpSession session){
        //获取当前登录用户对象
        User user = (User)session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        List<Activity> activityList = new ArrayList<>();
        try {
            InputStream is = activityFile.getInputStream();
            HSSFWorkbook wb = new HSSFWorkbook(is);
            HSSFSheet sheet = wb.getSheetAt(0);
            HSSFRow row = null;
            HSSFCell cell = null;
            for (int i = 1;i<=sheet.getLastRowNum();i++){
                row = sheet.getRow(i);
                //id由服务器内部算法生成，无需用户填写
                Activity activity = new Activity();
                activity.setId(UUIDUtils.getUUID());
                //经由与用户协商，所有者使用当前用户
                activity.setOwner(user.getId());
                //创建时间即数据的导入的系统当前时间，无需用户填写
                activity.setCreateTime(DateUtils.dateTimeToStr(new Date()));
                //创建者统一设置为导入者
                activity.setCreateBy(user.getId());
                for(int j = 0;j<row.getLastCellNum();j++){
                    cell = row.getCell(j);
                    String cellValue = HSSFUtils.getCellValueForStr(cell);
                    //excel文件每一列的内容一定是约定好的，用户不能乱写，比如第一列规约定是“id”，第二列约定写“市场活动的名称”...
                    if (j==0){
                        activity.setName(cellValue);
                    }else if (j==1){
                        activity.setStartDate(cellValue);
                    }else if(j==2){
                        activity.setEndDate(cellValue);
                    }else if(j==3){
                        activity.setCost(cellValue);
                    }else if (j==4){
                        activity.setDescription(cellValue);
                    }else if (j==5){
                    }
                }
                //将activity保存到List集合中
                activityList.add(activity);
            }
            //调用service层方法保存市场活动
            int rows = activityService.saveCreateActivitiesByList(activityList);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setRetData(rows);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMsg("系统繁忙，请稍后再试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/activityDetail.do")
    public String activityDetail(String id,HttpServletRequest request){
        Activity activity = activityService.queryActivityForDetail(id);
        List<ActivityRemark> activityRemarkList = activityRemarkService.queryActivityRemarkForDetailByActivityId(id);
        request.setAttribute("activity",activity);
        request.setAttribute("activityRemarkList",activityRemarkList);
        return "workbench/activity/detail";
    }

}
