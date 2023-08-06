package com.powernode.crm.workbench.service.inter;

import com.powernode.crm.workbench.model.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {
    List<Clue> queryAllCLueByConditionsForPage(Map<String,Object> map);

    int queryCountOfClueByConditionForPage(Map<String,Object> map);

    int saveCreateClue(Clue clue);

    Clue queryClueForDetailById(String id);

}
