package com.powernode.crm.workbench.service.impl;

import com.powernode.crm.workbench.mapper.ClueRemarkMapper;
import com.powernode.crm.workbench.model.ClueRemark;
import com.powernode.crm.workbench.service.inter.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Override
    public List<ClueRemark> queryClueForDetailById(String id) {
        return clueRemarkMapper.selectClueRemarkByClueId(id);
    }

    @Override
    public int saveCreateClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.insertClueRemark(clueRemark);
    }


}
