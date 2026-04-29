package com.example.springboot.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.springboot.entity.Collect;
import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

public interface ICollectService extends IService<Collect> {

    boolean save(Collect entity);

    boolean updateById(Collect entity);

    boolean removeById(Collect entity);

    boolean removeBatchByIds(Collection<?> list);

    List<Collect> list();

    Collect getById(Serializable id);

    <E extends IPage<Collect>> E page(E page, Wrapper<Collect> queryWrapper);

    List<Collect> myCollect();
}

