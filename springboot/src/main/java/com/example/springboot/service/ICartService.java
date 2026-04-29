package com.example.springboot.service;

import cn.hutool.json.JSONObject;
import com.baomidou.mybatisplus.extension.service.IService;
import com.example.springboot.entity.Cart;
import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

public interface ICartService extends IService<Cart> {

    boolean save(Cart entity);

    boolean updateById(Cart entity);

    boolean removeById(Cart entity);

    boolean removeBatchByIds(Collection<?> list);

    List<JSONObject> selectAll();

    Cart getById(Serializable id);

    <E extends IPage<Cart>> E page(E page, Wrapper<Cart> queryWrapper);

}

