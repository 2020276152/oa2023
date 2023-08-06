package com.powernode.crm.settings.mapper;

import com.powernode.crm.settings.model.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface UserMapper {
    int deleteByPrimaryKey(String id);

    int insert(User row);

    int insertSelective(User row);

    User selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(User row);

    int updateByPrimaryKey(User row);


    /**
     * 根据账户名和密码查询用户（至少查询出，姓名，状态，被允许的ip），在此选择全部字段都查询出来，预防后续使用
     * @param map
     * @return
     */
    User selectUserByLoginActAndPwd(Map<String,Object> map);

    List<User> selectAllUsers();
}