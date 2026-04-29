package com.example.springboot.service.impl;;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.json.JSONObject;
import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.metadata.OrderItem;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.springboot.entity.*;
import com.example.springboot.mapper.*;
import com.example.springboot.service.IGoodsService;
import com.example.springboot.utils.TokenUtils;
import com.example.springboot.utils.recommend.RelateDTO;
import com.example.springboot.utils.recommend.UserCF;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class GoodsServiceImpl extends ServiceImpl<GoodsMapper, Goods> implements IGoodsService{

    @Autowired
    private OrdersMapper ordersMapper;

    @Autowired
    private CollectMapper collectMapper;

    @Autowired
    private OrdersitemMapper ordersitemMapper;

    @Autowired
    private CartMapper cartMapper;

    @Autowired
    private UserMapper userMapper;

    @Override
    public boolean save(Goods entity) {
        entity.setShopid(TokenUtils.getCurrentUser().getId());
        return super.save(entity);
    }

    @Override
    public boolean updateById(Goods entity) {
        return super.updateById(entity);
    }

    @Override
    public boolean removeById(Goods entity) {
        return super.removeById(entity);
    }

    @Override
    public boolean removeBatchByIds(Collection<?> list) {
        return super.removeBatchByIds(list);
    }

    @Override
    public List<Goods> list() {
        return super.list();
    }

    @Override
    public Goods getById(Serializable id) {
        return super.getById(id);
    }

    @Override
    public <E extends IPage<Goods>> E page(E page, Wrapper<Goods> queryWrapper) {
        return super.page(page, queryWrapper);
    }

    @Override
    public JSONObject orderEcharts() {
        List<Double> y = new ArrayList<>();
        for (String day: last30Days()){
            List<Orders> orders = ordersMapper.selectList(new LambdaQueryWrapper<Orders>().like(Orders::getTime, day));
            Double total = 0.0;
            for (Orders order : orders) {
                total += order.getTotal();
            }
            y.add(total);
        }

        JSONObject result = new JSONObject();
        result.set("x",last30Days());
        result.set("y",y);
        return result;
    }

    @Override
    public List<JSONObject> goodsSaleEcharts() {
        List<Goods> goods = super.list();
        List<JSONObject> result = new ArrayList<>();
        for (Goods good : goods) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.set("name",good.getName());
            jsonObject.set("value",good.getSales());
            result.add(jsonObject);
        }
        return result;
    }

    @Override
    public List<JSONObject> goodsStoreEcharts() {
        List<Goods> goods = super.list();
        List<JSONObject> result = new ArrayList<>();
        for (Goods good : goods) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.set("name",good.getName());
            jsonObject.set("value",good.getNums());
            result.add(jsonObject);
        }
        return result;
    }

    private static List<String> last30Days(){
        LocalDate today = LocalDate.now();
        List<String> last30DaysDates = new ArrayList<>();

        // 循环生成30天前到今天的所有日期
        for (int i = 30; i >= 0; i--) {
            LocalDate date = today.minusDays(i);
            last30DaysDates.add(date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        }
        return last30DaysDates;
    }

    public List<Goods> recommend() {
        User currentUser = TokenUtils.getCurrentUser();
        if (ObjectUtil.isEmpty(currentUser)) {
            // 未登录用户随机推荐4个商品
            return getRandomGoods(4);
        }

        Integer currentUserId = currentUser.getId();
        // 1. 批量查询所需数据（只查必要字段）
        List<Collect> allCollects = collectMapper.selectList(Wrappers.lambdaQuery(Collect.class)
                .select(Collect::getUserid, Collect::getGoodsid));
        List<Cart> allCarts = cartMapper.selectList(Wrappers.lambdaQuery(Cart.class)
                .select(Cart::getUserid, Cart::getGoodsid));
        List<Orders> allOrders = ordersMapper.selectList(Wrappers.lambdaQuery(Orders.class)
                .select(Orders::getUserid, Orders::getGoodsid)
                .eq(Orders::getStatus, "已完成"));
        List<Ordersitem> allComments = ordersitemMapper.selectList(Wrappers.lambdaQuery(Ordersitem.class)
                .select(Ordersitem::getUserid, Ordersitem::getGoodsid));

        List<User> allUsers = userMapper.selectList(Wrappers.lambdaQuery(User.class)
                .select(User::getId));
        List<Goods> allGoods = super.list(new LambdaQueryWrapper<Goods>().eq(Goods::getState,"0"));
        if (CollectionUtil.isEmpty(allGoods)) {
            return Collections.emptyList();
        }

        // 2. 构建行为映射表（提升查询效率）
        Map<String, Boolean> collectMap = buildBehaviorMap(allCollects, Collect::getUserid, Collect::getGoodsid);
        Map<String, Boolean> cartMap = buildBehaviorMap(allCarts, Cart::getUserid, Cart::getGoodsid);
        Map<String, Boolean> orderMap = buildBehaviorMap(allOrders, Orders::getUserid, Orders::getGoodsid);
        Map<String, Boolean> commentMap = buildBehaviorMap(allComments, Ordersitem::getUserid, Ordersitem::getGoodsid);

        // 3. 计算用户-商品关联度
        List<RelateDTO> data = new ArrayList<>();
        for (Goods goods : allGoods) {
            Integer goodsId = goods.getId();
            for (User user : allUsers) {
                Integer userId = user.getId();
                int score = 0; // 初始分数为0，避免使用1作为基数

                // 使用映射表快速判断，避免流遍历
                String key = buildKey(userId, goodsId);
                if (collectMap.containsKey(key)) score += 1;
                if (cartMap.containsKey(key)) score += 2;
                if (orderMap.containsKey(key)) score += 3;
                if (commentMap.containsKey(key)) score += 2;

                if (score > 0) {
                    data.add(new RelateDTO(userId, goodsId, score));
                }
            }
        }

        // 4. 执行推荐算法
        List<Integer> goodsIds = UserCF.recommend(currentUserId, data);
        if (CollectionUtil.isEmpty(goodsIds)) {
            return getRandomGoods(4);
        }

        // 5. 转换推荐结果（使用Map快速查找）
        Map<Integer, Goods> goodsMap = allGoods.stream()
                .collect(Collectors.toMap(Goods::getId, Function.identity()));

        List<Goods> recommendResult = goodsIds.stream()
                .map(goodsMap::get)
                .filter(Objects::nonNull) // 过滤无效商品
                .distinct() // 去重
                .limit(4)
                .collect(Collectors.toList());

        // 6. 补充不足的推荐数量
        if (recommendResult.size() < 4) {
            int need = 10 - recommendResult.size();
            // 排除已推荐的商品
            List<Goods> candidates = allGoods.stream()
                    .filter(goods -> !recommendResult.contains(goods))
                    .collect(Collectors.toList());
            recommendResult.addAll(getRandomGoods(candidates, need));
        }

        return recommendResult;
    }

    /**
     * 构建行为映射表（userid+goodsid -> true）
     */
    private <T> Map<String, Boolean> buildBehaviorMap(List<T> list,
                                                      Function<T, Integer> userIdGetter,
                                                      Function<T, Integer> goodsIdGetter) {
        Map<String, Boolean> map = new HashMap<>(list.size());
        for (T item : list) {
            Integer userId = userIdGetter.apply(item);
            Integer goodsId = goodsIdGetter.apply(item);
            if (userId != null && goodsId != null) {
                map.put(buildKey(userId, goodsId), true);
            }
        }
        return map;
    }

    /**
     * 构建用户-商品唯一键
     */
    private String buildKey(Integer userId, Integer goodsId) {
        return userId + "_" + goodsId;
    }

    /**
     * 从候选商品中随机选择指定数量（排除已推荐的）
     */
    private List<Goods> getRandomGoods(List<Goods> candidates, int num) {
        if (candidates.size() <= num) {
            return new ArrayList<>(candidates);
        }
        List<Goods> result = new ArrayList<>(num);
        Random random = new Random();
        for (int i = 0; i < num; i++) {
            int index = random.nextInt(candidates.size());
            result.add(candidates.remove(index)); // 移除已选商品避免重复
        }
        return result;
    }

    /**
     * 随机推荐商品（全量商品中）
     */
    private List<Goods> getRandomGoods(int num) {
        List<Goods> allGoods = super.list();
        return getRandomGoods(allGoods, num);
    }
}
