package com.example.springboot.service.impl;;

import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.springboot.entity.Carousel;
import com.example.springboot.mapper.CarouselMapper;
import com.example.springboot.mapper.GoodsMapper;
import com.example.springboot.service.ICarouselService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

@Service
public class CarouselServiceImpl extends ServiceImpl<CarouselMapper, Carousel> implements ICarouselService{

    @Autowired
    private GoodsMapper goodsMapper;

    @Override
    public boolean save(Carousel entity) {
        entity.setName(goodsMapper.selectById(entity.getGoodsid()).getName());
        return super.save(entity);
    }

    @Override
    public boolean updateById(Carousel entity) {
        entity.setName(goodsMapper.selectById(entity.getGoodsid()).getName());
        return super.updateById(entity);
    }

    @Override
    public boolean removeById(Carousel entity) {
        return super.removeById(entity);
    }

    @Override
    public boolean removeBatchByIds(Collection<?> list) {
        return super.removeBatchByIds(list);
    }

    @Override
    public List<Carousel> list() {
        return super.list();
    }

    @Override
    public Carousel getById(Serializable id) {
        return super.getById(id);
    }

    @Override
    public <E extends IPage<Carousel>> E page(E page, Wrapper<Carousel> queryWrapper) {
        return super.page(page, queryWrapper);
    }

}
