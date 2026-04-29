package com.example.springboot.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.springboot.entity.Questions;
import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

public interface IQuestionsService extends IService<Questions> {

    boolean save(Questions entity);

    boolean updateById(Questions entity);

    boolean removeById(Questions entity);

    boolean removeBatchByIds(Collection<?> list);

    List<Questions> list();

    Questions getById(Serializable id);

    <E extends IPage<Questions>> E page(E page, Wrapper<Questions> queryWrapper);

}

