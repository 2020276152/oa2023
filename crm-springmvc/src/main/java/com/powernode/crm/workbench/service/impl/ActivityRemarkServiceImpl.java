package com.powernode.crm.workbench.service.impl;

import com.powernode.crm.workbench.mapper.ActivityRemarkMapper;
import com.powernode.crm.workbench.model.ActivityRemark;
import com.powernode.crm.workbench.service.inter.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;

    @Override
    public List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String activityId) {
        return activityRemarkMapper.selectActivityRemarkForDetailByActivityId(activityId);
    }

    @Override
    public int saveCreateActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.insertActivityRemark(activityRemark);
    }

    @Override
    public int removeActivityRemarkById(String id) {
        return activityRemarkMapper.deleteActivityRemarkById(id);
    }

    @Override
    public ActivityRemark selectActivityRemarkByIdForEdit(String id) {
        return activityRemarkMapper.selectActivityRemarkByIdForEdit(id);
    }

    @Override
    public int editActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.updateActivityRemark(activityRemark);
    }
}
