package com.example.springboot.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.springboot.entity.Orders;
import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

public interface IOrdersService extends IService<Orders> {

    boolean save(Orders entity);

    boolean updateById(Orders entity);

    boolean removeById(Orders entity);

    boolean removeBatchByIds(Collection<?> list);

    List<Orders> list();

    Orders getById(Serializable id);

    <E extends IPage<Orders>> E page(E page, Wrapper<Orders> queryWrapper);

    void addOrder(Orders orders);

    void changeStatus(Orders orders);
}

