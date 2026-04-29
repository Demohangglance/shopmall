package com.example.springboot.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.springboot.entity.Type;
import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

public interface ITypeService extends IService<Type> {

    boolean save(Type entity);

    boolean updateById(Type entity);

    boolean removeById(Type entity);

    boolean removeBatchByIds(Collection<?> list);

    List<Type> list();

    Type getById(Serializable id);

    <E extends IPage<Type>> E page(E page, Wrapper<Type> queryWrapper);

}

