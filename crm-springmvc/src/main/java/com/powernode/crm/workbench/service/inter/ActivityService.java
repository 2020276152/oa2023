package com.powernode.crm.workbench.service.inter;


import com.powernode.crm.workbench.model.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    /**
    保存创建市场活动
     */
    int savaCreateActivity(Activity activity);

    /**
     * 根据条件查询市场活动
     * @param map
     * @return
     */
    List<Activity> queryActivityByConditionForPage(Map<String,Object> map);

    int queryCountOfActivityByCondition(Map<String,Object> map);
    int removeActivityByIds(String[] ids);

    Activity queryActivityById(String id);

    int modifyActivityById(Activity activity);

    List<Activity> queryAllActivities();

    List<Activity> queryActivities(String[] ids);

    int saveCreateActivitiesByList(List<Activity> activityList);

    Activity queryActivityForDetail(String id);

    List<Activity> queryActivityForClueDetailByClueId(String clueId);

    List<Activity> queryActivityForAssociation(Map<String,Object> map);

    List<Activity> queryActivityForDetailByIs(String[] activityIds);

}
