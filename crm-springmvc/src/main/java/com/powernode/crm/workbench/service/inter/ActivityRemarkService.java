package com.powernode.crm.workbench.service.inter;

import com.powernode.crm.workbench.model.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {
    List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String activityId);
    int saveCreateActivityRemark(ActivityRemark activityRemark);
    int removeActivityRemarkById(String id);
    ActivityRemark selectActivityRemarkByIdForEdit(String id);
    int editActivityRemark(ActivityRemark activityRemark);
}
