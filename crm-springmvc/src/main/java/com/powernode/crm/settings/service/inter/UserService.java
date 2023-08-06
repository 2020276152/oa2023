package com.powernode.crm.settings.service.inter;

import com.powernode.crm.settings.model.User;

import java.util.List;
import java.util.Map;

public interface UserService {
     User queryUserByLoginActAndPwd(Map<String,Object> map);
     List<User> queryAllUsers();
}
