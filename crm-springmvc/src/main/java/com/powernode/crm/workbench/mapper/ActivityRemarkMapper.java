package com.powernode.crm.workbench.mapper;

import com.powernode.crm.workbench.model.ActivityRemark;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ActivityRemarkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbg.generated Sun Jun 11 19:33:59 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbg.generated Sun Jun 11 19:33:59 CST 2023
     */
    int insertActivity(ActivityRemark row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbg.generated Sun Jun 11 19:33:59 CST 2023
     */
    int insertSelective(ActivityRemark row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbg.generated Sun Jun 11 19:33:59 CST 2023
     */
    ActivityRemark selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbg.generated Sun Jun 11 19:33:59 CST 2023
     */
    int updateByPrimaryKeySelective(ActivityRemark row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbg.generated Sun Jun 11 19:33:59 CST 2023
     */
    int updateByPrimaryKey(ActivityRemark row);

    /**
     * 查询市场活动信息的备注信息
     * @param activityId
     * @return
     */
    List<ActivityRemark> selectActivityRemarkForDetailByActivityId(String activityId);

    /**
     *添加市场活动备注
     */
    int insertActivityRemark(ActivityRemark activityRemark);

    int deleteActivityRemarkById(String id);

    ActivityRemark selectActivityRemarkByIdForEdit(String id);

    int updateActivityRemark(ActivityRemark activityRemark);

}