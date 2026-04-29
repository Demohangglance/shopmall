package com.example.springboot.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.springboot.entity.Ordersitem;
import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

public interface IOrdersitemService extends IService<Ordersitem> {

    boolean save(Ordersitem entity);

    boolean updateById(Ordersitem entity);

    boolean removeById(Ordersitem entity);

    boolean removeBatchByIds(Collection<?> list);

    List<Ordersitem> list();

    Ordersitem getById(Serializable id);

    <E extends IPage<Ordersitem>> E page(E page, Wrapper<Ordersitem> queryWrapper);

    List<Ordersitem> findPageByGoodsid(Long goodsid);
}

