package com.powernode.crm.workbench.service.impl;

import com.powernode.crm.settings.model.DicValue;
import com.powernode.crm.settings.mapper.DicValueMapper;
import com.powernode.crm.workbench.service.inter.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DicValueServiceImpl implements DicValueService {

    @Autowired
    private DicValueMapper dicValueMapper;

    @Override
    public List<DicValue> queryDicValueByDicTypeCode(String typeCode) {
        return dicValueMapper.selectDicValueByDicTypeCode(typeCode);
    }
}
