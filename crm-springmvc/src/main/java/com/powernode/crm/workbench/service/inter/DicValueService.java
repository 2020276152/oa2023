package com.powernode.crm.workbench.service.inter;

import com.powernode.crm.settings.model.DicValue;

import java.util.List;

public interface DicValueService {
    List<DicValue> queryDicValueByDicTypeCode(String typeCode);
}
