package com.example.springboot.service.impl;;

import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.springboot.entity.Ordersitem;
import com.example.springboot.mapper.GoodsMapper;
import com.example.springboot.mapper.OrdersMapper;
import com.example.springboot.mapper.OrdersitemMapper;
import com.example.springboot.mapper.UserMapper;
import com.example.springboot.service.IOrdersitemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Objects;

@Service
public class OrdersitemServiceImpl extends ServiceImpl<OrdersitemMapper, Ordersitem> implements IOrdersitemService{

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private GoodsMapper goodsMapper;

    @Autowired
    private OrdersMapper ordersMapper;

    @Override
    public boolean save(Ordersitem entity) {
        return super.save(entity);
    }

    @Override
    public boolean updateById(Ordersitem entity) {
        return super.updateById(entity);
    }

    @Override
    public boolean removeById(Ordersitem entity) {
        return super.removeById(entity);
    }

    @Override
    public boolean removeBatchByIds(Collection<?> list) {
        return super.removeBatchByIds(list);
    }

    @Override
    public List<Ordersitem> list() {
        return super.list();
    }

    @Override
    public Ordersitem getById(Serializable id) {
        return super.getById(id);
    }

    @Override
    public <E extends IPage<Ordersitem>> E page(E page, Wrapper<Ordersitem> queryWrapper) {
        return super.page(page, queryWrapper);
    }

    @Override
    public List<Ordersitem> findPageByGoodsid(Long goodsid) {
        List<Ordersitem> list = super.list(new LambdaQueryWrapper<Ordersitem>().eq(Ordersitem::getGoodsid, goodsid).isNotNull(Ordersitem::getScore));
        list.stream().forEach(ordersitem -> {
            ordersitem.setUser(userMapper.selectById(ordersitem.getUserid()));
            ordersitem.setGoods(goodsMapper.selectById(ordersitem.getGoodsid()));
        });
        return list;
    }
}
