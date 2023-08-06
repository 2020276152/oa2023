package com.powernode.crm.workbench.service.impl;

import com.powernode.crm.workbench.mapper.ActivityMapper;
import com.powernode.crm.workbench.model.Activity;
import com.powernode.crm.workbench.service.inter.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;

    @Override
    public int savaCreateActivity(Activity activity) {
        int rows = activityMapper.insertActivity(activity);
        return rows;
    }

    @Override
    public List<Activity> queryActivityByConditionForPage(Map<String, Object> map) {
        List<Activity> activityList = activityMapper.selectActivityByConditionForPage(map);
        return activityList;
    }

    @Override
    public int queryCountOfActivityByCondition(Map<String, Object> map) {
        int countOfActivity = activityMapper.selectCountOfActivityByCondition(map);
        return countOfActivity;
    }

    @Override
    public int removeActivityByIds(String[] ids) {
        int rows = activityMapper.deleteActivityByIds(ids);
        return rows;
    }

    @Override
    public Activity queryActivityById(String id) {
        Activity activity = activityMapper.selectByPrimaryKey(id);
        return activity;
    }

    @Override
    public int modifyActivityById(Activity activity) {
        int row = activityMapper.updateActivityById(activity);
        return row;
    }

    @Override
    public List<Activity> queryAllActivities() {
        return activityMapper.selectAllActivities();
    }

    @Override
    public List<Activity> queryActivities(String[] ids) {
        return activityMapper.selectActivities(ids);
    }

    @Override
    public int saveCreateActivitiesByList(List<Activity> activityList) {
        return activityMapper.insertActivitiesByList(activityList);
    }

    @Override
    public Activity queryActivityForDetail(String id) {
        return activityMapper.selectActivityForDetail(id);
    }

    @Override
    public List<Activity> queryActivityForClueDetailByClueId(String clueId) {
        return activityMapper.selectActivityForClueDetailByClueId(clueId);
    }

    @Override
    public List<Activity> queryActivityForAssociation(Map<String, Object> map){
        return activityMapper.selectActivityForAssociation(map);
    }

    @Override
    public List<Activity> queryActivityForDetailByIs(String[] activityIds) {
        return activityMapper.selectActivityForDetailByIs(activityIds);
    }

}
