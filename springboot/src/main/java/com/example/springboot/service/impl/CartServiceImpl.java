package com.example.springboot.service.impl;;

import cn.hutool.json.JSONObject;
import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.springboot.entity.Cart;
import com.example.springboot.entity.Goods;
import com.example.springboot.mapper.CartMapper;
import com.example.springboot.mapper.GoodsMapper;
import com.example.springboot.mapper.UserMapper;
import com.example.springboot.service.ICartService;
import com.example.springboot.utils.TokenUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
public class CartServiceImpl extends ServiceImpl<CartMapper, Cart> implements ICartService{

    @Autowired
    private GoodsMapper goodsMapper;

    @Autowired
    private UserMapper userMapper;

    @Override
    public boolean save(Cart entity) {
        Integer userid = TokenUtils.getCurrentUser().getId();
        // 如果是同一个goodsid，说明是同一个商品，num累加
        Cart cart = super.getOne(new LambdaQueryWrapper<Cart>().eq(Cart::getUserid, userid).eq(Cart::getGoodsid, entity.getGoodsid()));
        if (Objects.nonNull(cart)){
            cart.setNum(cart.getNum() + entity.getNum());
            return super.updateById(cart);
        }
        entity.setUserid(userid);
        return super.save(entity);
    }

    @Override
    public boolean updateById(Cart entity) {
        return super.updateById(entity);
    }

    @Override
    public boolean removeById(Cart entity) {
        return super.removeById(entity);
    }

    @Override
    public boolean removeBatchByIds(Collection<?> list) {
        return super.removeBatchByIds(list);
    }

    @Override
    public List<JSONObject> selectAll() {
        List<Cart> carts = super.list(new LambdaQueryWrapper<Cart>().eq(Cart::getUserid, TokenUtils.getCurrentUser().getId()));
        // 过滤出店铺ID
        List<Integer> distinctShopIds = carts.stream()
                // 提取shopId（注意过滤null，避免空指针）
                .map(Cart::getShopid)
                .filter(Objects::nonNull)  // 排除shopId为null的情况
                .distinct()                // 去重
                .collect(Collectors.toList());  // 收集为List

        List<JSONObject> result = new ArrayList<>();
        for (Integer shopid : distinctShopIds) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("shop",userMapper.selectById(shopid));

            List<Cart> shopCarts = super.list(new LambdaQueryWrapper<Cart>().eq(Cart::getUserid, TokenUtils.getCurrentUser().getId()).eq(Cart::getShopid,shopid));
            shopCarts.stream().forEach(cart -> {
                cart.setGoods(goodsMapper.selectById(cart.getGoodsid()));
            });
            jsonObject.put("carts", shopCarts);
            result.add(jsonObject);
        }
        return result;
    }

    @Override
    public Cart getById(Serializable id) {
        return super.getById(id);
    }

    @Override
    public <E extends IPage<Cart>> E page(E page, Wrapper<Cart> queryWrapper) {
        return super.page(page, queryWrapper);
    }

}
