package com.powernode.crm.workbench.model;

public class ACRelation {
    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_clue_activity_relation.id
     *
     * @mbg.generated Mon Jul 31 23:21:16 CST 2023
     */
    private String id;

    @Override
    public String toString() {
        return "ACRelation{" +
                "id='" + id + '\'' +
                ", clueId='" + clueId + '\'' +
                ", activityId='" + activityId + '\'' +
                '}';
    }

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_clue_activity_relation.clue_id
     *
     * @mbg.generated Mon Jul 31 23:21:16 CST 2023
     */
    private String clueId;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_clue_activity_relation.activity_id
     *
     * @mbg.generated Mon Jul 31 23:21:16 CST 2023
     */
    private String activityId;

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_clue_activity_relation.id
     *
     * @return the value of tbl_clue_activity_relation.id
     *
     * @mbg.generated Mon Jul 31 23:21:16 CST 2023
     */
    public String getId() {
        return id;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_clue_activity_relation.id
     *
     * @param id the value for tbl_clue_activity_relation.id
     *
     * @mbg.generated Mon Jul 31 23:21:16 CST 2023
     */
    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_clue_activity_relation.clue_id
     *
     * @return the value of tbl_clue_activity_relation.clue_id
     *
     * @mbg.generated Mon Jul 31 23:21:16 CST 2023
     */
    public String getClueId() {
        return clueId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_clue_activity_relation.clue_id
     *
     * @param clueId the value for tbl_clue_activity_relation.clue_id
     *
     * @mbg.generated Mon Jul 31 23:21:16 CST 2023
     */
    public void setClueId(String clueId) {
        this.clueId = clueId == null ? null : clueId.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_clue_activity_relation.activity_id
     *
     * @return the value of tbl_clue_activity_relation.activity_id
     *
     * @mbg.generated Mon Jul 31 23:21:16 CST 2023
     */
    public String getActivityId() {
        return activityId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_clue_activity_relation.activity_id
     *
     * @param activityId the value for tbl_clue_activity_relation.activity_id
     *
     * @mbg.generated Mon Jul 31 23:21:16 CST 2023
     */
    public void setActivityId(String activityId) {
        this.activityId = activityId == null ? null : activityId.trim();
    }
}