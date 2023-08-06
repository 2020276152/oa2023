package com.powernode.crm.workbench.service.impl;

import com.powernode.crm.workbench.mapper.ClueMapper;
import com.powernode.crm.workbench.model.Clue;
import com.powernode.crm.workbench.service.inter.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {
    @Autowired
    private ClueMapper clueMapper;
    @Override
    public List<Clue> queryAllCLueByConditionsForPage(Map<String, Object> map) {
        return clueMapper.selectAllCLueByConditionsForPage(map);
    }

    @Override
    public int queryCountOfClueByConditionForPage(Map<String, Object> map) {
        return clueMapper.selectCountOfClueByConditionForPage(map);
    }

    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public Clue queryClueForDetailById(String id) {
        return clueMapper.selectClueByIdForDetail(id);
    }

}
