package com.powernode.crm.workbench.service.impl;

import com.powernode.crm.workbench.mapper.ACRelationMapper;
import com.powernode.crm.workbench.model.ACRelation;
import com.powernode.crm.workbench.service.inter.ACRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ACRelationServiceImpl implements ACRelationService {

    @Autowired
    private ACRelationMapper acRelationMapper;

    @Override
    public int saveCreateACRelationByList(List<ACRelation> acRelationList) {
        return acRelationMapper.insertCreateACRelationByList(acRelationList);
    }

    @Override
    public int removeACRelationByClueIdAndActivityId(ACRelation acRelation) {
        return acRelationMapper.deleteACRelationByClueIdAndActivityId(acRelation);
    }
}
