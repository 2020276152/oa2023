package com.powernode.crm.workbench.service.inter;

import com.powernode.crm.workbench.model.Clue;
import com.powernode.crm.workbench.model.ClueRemark;

import java.util.List;

public interface ClueRemarkService {
     List<ClueRemark> queryClueForDetailById(String id);

     int saveCreateClueRemark(ClueRemark clueRemark);
}
