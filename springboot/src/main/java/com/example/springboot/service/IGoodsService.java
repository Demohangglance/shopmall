package com.example.springboot.service;

import cn.hutool.json.JSONObject;
import com.baomidou.mybatisplus.extension.service.IService;
import com.example.springboot.entity.Goods;
import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

public interface IGoodsService extends IService<Goods> {

    boolean save(Goods entity);

    boolean updateById(Goods entity);

    boolean removeById(Goods entity);

    boolean removeBatchByIds(Collection<?> list);

    List<Goods> list();

    Goods getById(Serializable id);

    <E extends IPage<Goods>> E page(E page, Wrapper<Goods> queryWrapper);

    JSONObject orderEcharts();

    List<JSONObject> goodsSaleEcharts();

    List<JSONObject> goodsStoreEcharts();

    List<Goods> recommend();
}

