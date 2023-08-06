package com.powernode.crm.workbench.service.inter;

import com.powernode.crm.workbench.model.ACRelation;

import java.util.List;

public interface ACRelationService {
    int saveCreateACRelationByList(List<ACRelation> acRelationList);
    int removeACRelationByClueIdAndActivityId(ACRelation acRelation);
}
