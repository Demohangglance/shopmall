package com.example.springboot.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.springboot.entity.Address;
import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

public interface IAddressService extends IService<Address> {

    boolean save(Address entity);

    boolean updateById(Address entity);

    boolean removeById(Address entity);

    boolean removeBatchByIds(Collection<?> list);

    List<Address> list();

    Address getById(Serializable id);

    <E extends IPage<Address>> E page(E page, Wrapper<Address> queryWrapper);

    void setDefault(Address address);
}

