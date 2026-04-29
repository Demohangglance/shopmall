package com.example.springboot.service.impl;;

import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.springboot.entity.Collect;
import com.example.springboot.entity.Goods;
import com.example.springboot.mapper.CollectMapper;
import com.example.springboot.mapper.GoodsMapper;
import com.example.springboot.service.ICollectService;
import com.example.springboot.utils.TokenUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

@Service
public class CollectServiceImpl extends ServiceImpl<CollectMapper, Collect> implements ICollectService{

    @Autowired
    private GoodsMapper goodsMapper;

    @Override
    public boolean save(Collect entity) {
        return super.save(entity);
    }

    @Override
    public boolean updateById(Collect entity) {
        return super.updateById(entity);
    }

    @Override
    public boolean removeById(Collect entity) {
        return super.removeById(entity);
    }

    @Override
    public boolean removeBatchByIds(Collection<?> list) {
        return super.removeBatchByIds(list);
    }

    @Override
    public List<Collect> list() {
        return super.list();
    }

    @Override
    public Collect getById(Serializable id) {
        return super.getById(id);
    }

    @Override
    public <E extends IPage<Collect>> E page(E page, Wrapper<Collect> queryWrapper) {
        return super.page(page, queryWrapper);
    }

    @Override
    public List<Collect> myCollect() {
        List<Collect> list = super.list(new LambdaQueryWrapper<Collect>().eq(Collect::getUserid, TokenUtils.getCurrentUser().getId()));
        list.stream().forEach(collect -> {
            Goods goods = goodsMapper.selectById(collect.getGoodsid());
            goods.setCollectCount(super.count(new LambdaQueryWrapper<Collect>().eq(Collect::getGoodsid, collect.getGoodsid())));
            collect.setGoods(goods);
        });
        return list;
    }

}
