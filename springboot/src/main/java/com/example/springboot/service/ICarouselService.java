package com.example.springboot.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.springboot.entity.Carousel;
import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

public interface ICarouselService extends IService<Carousel> {

    boolean save(Carousel entity);

    boolean updateById(Carousel entity);

    boolean removeById(Carousel entity);

    boolean removeBatchByIds(Collection<?> list);

    List<Carousel> list();

    Carousel getById(Serializable id);

    <E extends IPage<Carousel>> E page(E page, Wrapper<Carousel> queryWrapper);

}

