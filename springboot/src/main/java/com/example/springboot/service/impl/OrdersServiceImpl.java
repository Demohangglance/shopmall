package com.example.springboot.service.impl;;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.RandomUtil;
import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.metadata.OrderItem;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.springboot.entity.*;
import com.example.springboot.exception.ServiceException;
import com.example.springboot.mapper.*;
import com.example.springboot.service.IOrdersService;
import com.example.springboot.utils.TokenUtils;
import org.apache.el.parser.Token;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class OrdersServiceImpl extends ServiceImpl<OrdersMapper, Orders> implements IOrdersService{

    @Autowired
    private GoodsMapper goodsMapper;

    @Autowired
    private OrdersitemMapper ordersitemMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private AddressMapper addressMapper;

    @Autowired
    private CartMapper cartMapper;

    /**
     * 生成订单号
     */
    public static String generateOrderNo() {
        String ts = DateUtil.format(DateUtil.date(), "yyyyMMddHHmmss");
        String random = RandomUtil.randomNumbers(3);
        return ts + random;
    }

    /**
     * 购物车订单流程
     * 1、遍历订单中的购物车
     * 2、将购物车中的产品添加到订单商品关联表
     * 3、组装订单数据：商品名称、总商品数量等
     * 4、添加到订单
     *
     * @param entity 订单实体
     */
    @Override
    public boolean save(Orders entity) {
        // 1、获取购物车列表
        List<Cart> cartList = entity.getCartList();
        if (cartList == null || cartList.isEmpty()) {
            throw new ServiceException("202", "购物车为空");
        }

        // 2、按店铺ID分组（过滤空店铺ID）
        Map<Integer, List<Cart>> shopCartMap = cartList.stream()
                .filter(cart -> cart.getShopid() != null)
                .collect(Collectors.groupingBy(Cart::getShopid));

        if (shopCartMap.isEmpty()) {
            throw new ServiceException("203", "未找到有效店铺信息");
        }

        // 3、为每个店铺生成独立订单
        boolean allSuccess = true;
        for (Map.Entry<Integer, List<Cart>> entry : shopCartMap.entrySet()) {
            Integer shopId = entry.getKey();
            List<Cart> shopCarts = entry.getValue();

            // 3.1 检查当前店铺商品库存并处理商品数据
            List<String> goodsNameList = new ArrayList<>();
            List<Integer> goodsNumList = new ArrayList<>();
            BigDecimal shopTotalPrice = BigDecimal.ZERO; // 店铺订单总金额（含折扣）

            for (Cart cart : shopCarts) {
                Goods goods = goodsMapper.selectById(cart.getGoodsid());
                if (goods == null) {
                    throw new ServiceException("204", "商品不存在：" + cart.getGoodsid());
                }
                if (cart.getNum() > goods.getNums()) {
                    throw new ServiceException("201", "商品《" + goods.getName() + "》库存不足");
                }

                // 收集商品信息
                goodsNameList.add(goods.getName());
                goodsNumList.add(cart.getNum());

                // 计算商品折扣后总价（单价 × 数量 × 折扣）
                BigDecimal goodsPrice = BigDecimal.valueOf(goods.getPrice()); // 商品单价
                BigDecimal discount = BigDecimal.valueOf(goods.getDiscount()); // 折扣（如0.8表示8折）
                BigDecimal quantity = BigDecimal.valueOf(cart.getNum()); // 购买数量
                BigDecimal itemTotal = goodsPrice.multiply(quantity).multiply(discount); // 订单项总价
                shopTotalPrice = shopTotalPrice.add(itemTotal); // 累加至店铺总金额

                // 减库存、加销量
                goods.setNums(goods.getNums() - cart.getNum());
                goods.setSales(goods.getSales() + cart.getNum()); // 修正：累加购买数量
                goodsMapper.updateById(goods);
            }

            // 3.2 计算当前店铺订单的总数量
            int totalNum = goodsNumList.stream().mapToInt(Integer::intValue).sum();

            // 3.3 创建店铺订单（复制原实体的基础信息，重置订单相关字段）
            Orders shopOrder = new Orders();
            BeanUtils.copyProperties(entity, shopOrder); // 复制地址、用户等基础信息
            shopOrder.setId(null); // 重置ID，生成新订单

            // 设置订单特有信息
            shopOrder.setNum(totalNum);
            shopOrder.setName(String.join("、", goodsNameList) + "等" + totalNum + "件商品");
            shopOrder.setTime(DateUtil.now());
            shopOrder.setOrderno(generateOrderNo()); // 生成新订单号
            shopOrder.setStatus("待付款");
            shopOrder.setShopid(shopId); // 关联当前店铺ID
            // 地址信息
            Address address = addressMapper.selectById(entity.getAddressId());
            if (Objects.nonNull(address)){
                shopOrder.setAddress(address.getAddress());
                shopOrder.setUsername(address.getName());
                shopOrder.setPhone(address.getPhone());
            }
            shopOrder.setUserid(TokenUtils.getCurrentUser().getId());
            shopOrder.setTotal(shopTotalPrice.doubleValue()); // 设置店铺订单总金额（含折扣）

            // 保存店铺订单
            boolean save = super.save(shopOrder);
            if (!save) {
                allSuccess = false;
                throw new ServiceException("205", "店铺订单创建失败");
            }

            // 3.4 创建订单项并清空购物车
            for (Cart cart : shopCarts) {
                Ordersitem ordersitem = new Ordersitem();
                ordersitem.setGoodsid(cart.getGoodsid());
                ordersitem.setNum(cart.getNum());

                Goods goods = goodsMapper.selectById(cart.getGoodsid());
                // 订单项价格 = 商品单价 × 数量 × 折扣（与店铺总金额计算逻辑一致）
                BigDecimal goodsPrice = BigDecimal.valueOf(goods.getPrice());
                BigDecimal discount = BigDecimal.valueOf(goods.getDiscount());
                BigDecimal quantity = BigDecimal.valueOf(cart.getNum());
                ordersitem.setPrice(goodsPrice.multiply(quantity).multiply(discount).doubleValue());

                ordersitem.setOrdersid(shopOrder.getId()); // 关联当前店铺订单ID
                ordersitem.setUserid(TokenUtils.getCurrentUser().getId());
                ordersitem.setShopid(shopId);

                ordersitemMapper.insert(ordersitem);
                cartMapper.deleteById(cart.getId()); // 删除购物车项
            }
        }

        return allSuccess;
    }

    @Override
    public boolean updateById(Orders entity) {
        return super.updateById(entity);
    }

    @Override
    public boolean removeById(Orders entity) {
        // 删除订单关联商品
        ordersitemMapper.delete(new LambdaQueryWrapper<Ordersitem>().eq(Ordersitem::getOrdersid,entity.getId()));
        return super.removeById(entity);
    }

    @Override
    public boolean removeBatchByIds(Collection<?> list) {
        return super.removeBatchByIds(list);
    }

    @Override
    public List<Orders> list() {
        return super.list();
    }

    @Override
    public Orders getById(Serializable id) {
        return super.getById(id);
    }

    @Override
    public <E extends IPage<Orders>> E page(E page, Wrapper<Orders> queryWrapper) {
        E page1 = super.page(page, queryWrapper);
        page1.getRecords().stream().forEach(orders -> {
            List<Ordersitem> ordersitems = ordersitemMapper.selectList(new LambdaQueryWrapper<Ordersitem>().eq(Ordersitem::getOrdersid, orders.getId()));
            ordersitems.stream().forEach(ordersitem -> {
                ordersitem.setGoods(goodsMapper.selectById(ordersitem.getGoodsid()));
                if (Objects.isNull(ordersitem.getScore())){
                    ordersitem.setIsComment(false);
                } else {
                    ordersitem.setIsComment(true);
                }
            });
            orders.setOrderItems(ordersitems);
        });
        return page1;
    }

    /**
     * 直接下单
     */
    @Override
    public void addOrder(Orders entity) {
        // 直接下单
        // 这里如果是直接下单，不走购物车，不需要遍历购物车
        // 1、判断商品库存
        Goods goods = goodsMapper.selectById(entity.getGoodsid());
        if (entity.getNum() > goods.getNums()){
            throw new ServiceException("201","商品库存不足");
        }

        // 地址
        Address address = addressMapper.selectById(entity.getAddressId());
        entity.setUsername(address.getName());
        entity.setAddress(address.getAddress());
        entity.setPhone(address.getPhone());
        // 添加订单商品关联表
        entity.setTime(DateUtil.now());
        entity.setOrderno(generateOrderNo());
        entity.setUserid(TokenUtils.getCurrentUser().getId());
        // 已取消 待付款 待评价 已完成
        entity.setStatus("待付款");
        entity.setShopid(entity.getShopid());
        //entity.setTotal(goods.getPrice() * goods.getDiscount() * entity.getNum());
        super.save(entity);

        // 商品减库存
        goods.setNums(goods.getNums() - entity.getNum());
        // 销量加1
        goods.setSales(goods.getSales() + 1);
        goodsMapper.updateById(goods);

        // 添加到订单商品项关联表
        Ordersitem ordersitem = new Ordersitem();
        ordersitem.setGoodsid(entity.getGoodsid());
        ordersitem.setNum(entity.getNum());
        ordersitem.setPrice(entity.getTotal());
        ordersitem.setOrdersid(entity.getId());
        ordersitem.setUserid(TokenUtils.getCurrentUser().getId());
        ordersitem.setShopid(entity.getShopid());
        ordersitemMapper.insert(ordersitem);
    }

    /**
     * 修改订单状态
     */
    @Override
    public void changeStatus(Orders orders) {
        /**
         * 改变状态：待付款 待发货 待收货 待评价 已完成 已取消
         * 1、生成订单、订单商品项（订单商品关联表），状态为待付款 √
         * 2、付款：判断账户余额是否足够，足够减去余额，不足够给提示，"账户余额不足，请充值"，状态改为待发货 √
         * 3、取消：库存加1，销量减1，状态改为已取消 √
         * 4、发货：状态改为待收货
         * 5、收货：状态改为已完成
         * 6、评价：评价商品信息（订单商品关联表），状态改为已完成
         */
        Orders ordersDB = super.getById(orders.getId());
        // 付款操作：status = 待发货 ， 说明已经付款了
        if(("待发货").equals(orders.getStatus())){
            // 用户金额减去对应值
            User user = userMapper.selectById(TokenUtils.getCurrentUser().getId());
            // 账户余额
            Double account = user.getAccount();
            // 订单价格
            Double total = ordersDB.getTotal();
            if (account < total){
                throw new ServiceException("202","账户余额不足，请充值");
            }
            user.setAccount(account - total);
            userMapper.updateById(user);
        }
        // 取消操作：status = 已取消
        if ("已取消".equals(orders.getStatus())){
            // 去订单商品关联表查询
            List<Ordersitem> ordersitems = ordersitemMapper.selectList(new LambdaQueryWrapper<Ordersitem>()
                    .eq(Ordersitem::getOrdersid, orders.getId()));
            for (Ordersitem ordersitem : ordersitems) {
                Goods goods = goodsMapper.selectById(ordersitem.getGoodsid());
                // 商品库存加1
                goods.setNums(goods.getNums() + 1);
                // 销量减1
                goods.setSales(goods.getSales() - 1);
                goodsMapper.updateById(goods);
            }
        }
        // 评价操作：status = 已完成
        if ("已完成".equals(orders.getStatus())){
            // 直接改状态
        }
        super.updateById(orders);
    }

}
