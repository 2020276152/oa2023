package com.powernode.crm.workbench.mapper;

import com.powernode.crm.workbench.model.ClueRemark;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ClueRemarkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbg.generated Tue Jul 25 20:10:33 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbg.generated Tue Jul 25 20:10:33 CST 2023
     */
    int insert(ClueRemark row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbg.generated Tue Jul 25 20:10:33 CST 2023
     */
    int insertSelective(ClueRemark row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbg.generated Tue Jul 25 20:10:33 CST 2023
     */
    ClueRemark selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbg.generated Tue Jul 25 20:10:33 CST 2023
     */
    int updateByPrimaryKeySelective(ClueRemark row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbg.generated Tue Jul 25 20:10:33 CST 2023
     */
    int updateByPrimaryKey(ClueRemark row);

    /**
     * 根据线索id，查询所有此线索下的备注
     * @param id
     * @return
     */
    List<ClueRemark> selectClueRemarkByClueId(String id);

    /**
     * 保存线索备注
     * @param clueRemark
     * @return
     */
    int insertClueRemark(ClueRemark clueRemark);
}