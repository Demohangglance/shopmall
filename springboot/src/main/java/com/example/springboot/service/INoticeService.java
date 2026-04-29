package com.example.springboot.service;

import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.example.springboot.entity.Notice;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

public interface INoticeService extends IService<Notice> {

    boolean save(Notice entity);

    boolean updateById(Notice entity);

    boolean removeById(Notice entity);

    boolean removeBatchByIds(Collection<?> list);

    List<Notice> list();

    Notice getById(Serializable id);

    <E extends IPage<Notice>> E page(E page, Wrapper<Notice> queryWrapper);
}
