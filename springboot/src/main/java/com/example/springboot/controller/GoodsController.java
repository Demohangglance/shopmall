package com.example.springboot.controller;

import cn.hutool.json.JSON;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import cn.hutool.poi.excel.ExcelUtil;
import cn.hutool.poi.excel.ExcelReader;
import cn.hutool.poi.excel.ExcelWriter;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletOutputStream;
import java.net.URLEncoder;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.springboot.entity.*;
import com.example.springboot.service.*;
import com.example.springboot.utils.TokenUtils;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.example.springboot.common.Result;
import org.springframework.web.multipart.MultipartFile;

import org.springframework.web.bind.annotation.RestController;

/**
 * GoodsAPI接口
 */
@RestController
@RequestMapping("/goods")
public class GoodsController {

    @Autowired
    private IGoodsService goodsService;
    @Autowired
    private ITypeService typeService;
    @Autowired
    private ICollectService collectService;
    @Autowired
    private IOrdersService ordersService;
    @Autowired
    private IOrdersitemService ordersitemService;
    @Autowired
    private ICartService cartService;
    @Autowired
    private IUserService userService;
    /**
     * 新增
     */
    @PostMapping
    public Result save(@RequestBody Goods goods) {
        goodsService.save(goods);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping
    public Result update(@RequestBody Goods goods) {
        goodsService.updateById(goods);
        return Result.success();
    }

    /**
     * 删除
     */
    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        // 删除收藏
        collectService.remove(new LambdaQueryWrapper<Collect>().eq(Collect::getGoodsid,id));
        // 删除购物车
        cartService.remove(new LambdaQueryWrapper<Cart>().eq(Cart::getGoodsid,id));
        // 删除订单
        ordersService.remove(new LambdaQueryWrapper<Orders>().eq(Orders::getGoodsid,id));
        // 删除订单关联
        ordersitemService.remove(new LambdaQueryWrapper<Ordersitem>().eq(Ordersitem::getGoodsid,id));
        goodsService.removeById(id);
        return Result.success();
    }

    /**
     * 查询全部数据
     */
    @GetMapping
    public Result findAll() {
        return Result.success(goodsService.list());
    }

    /**
     * 查询店铺全部数据
     */
    @GetMapping("/shop/{shopid}")
    public Result findAllByShop(@PathVariable Integer shopid) {
        return Result.success(goodsService.list(new LambdaQueryWrapper<Goods>().eq(Goods::getShopid, shopid)));
    }

    /**
     * 查询详情
     */
    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        Goods goods = goodsService.getById(id);
        // 缩略图
        String imgs = goods.getImgs();
        if (Objects.nonNull(imgs)){
            JSONArray jsonArray = JSONUtil.parseArray(imgs);
            List<JSONObject> list = jsonArray.toList(JSONObject.class);
            List<String> urls = new ArrayList<>();
            for (JSONObject jsonObject : list) {
                urls.add(jsonObject.getStr("url"));
            }
            goods.setUrls(urls);
        }
        // 类型
        goods.setType(typeService.getById(goods.getTypeid()));
        User currentUser = TokenUtils.getCurrentUser();
        if (Objects.nonNull(currentUser)){
            // 是否收藏
            Collect one = collectService.getOne(new LambdaQueryWrapper<Collect>().eq(Collect::getUserid, currentUser.getId()).eq(Collect::getGoodsid, id));
            if (null == one) {
                goods.setIsCollect(false);
            } else {
                goods.setIsCollect(true);
            }
        }

        goods.setShop(userService.getById(goods.getShopid()));
        return Result.success(goods);
    }

    /**
     * 分页查询
     */
    @GetMapping("/page")
    public Result findPage(@RequestParam(defaultValue = "") String name, @RequestParam Integer pageNum, @RequestParam Integer pageSize) {
        QueryWrapper<Goods> queryWrapper = new QueryWrapper<Goods>().orderByDesc("id");
        queryWrapper.like(!"".equals(name), "name", name);
        User user = TokenUtils.getCurrentUser();
        if (!user.getRole().equals("ADMIN")){
            queryWrapper.eq("shopid",user.getId());
        }
        Page<Goods> page = goodsService.page(new Page<>(pageNum, pageSize), queryWrapper);
        return Result.success(page);
    }

    /**
     * 前端分页查询
     */
    @GetMapping("/page/front")
    public Result findPageFront(@RequestParam(defaultValue = "") String name, @RequestParam(required = false) Integer typeid, @RequestParam Integer pageNum, @RequestParam Integer pageSize) {
        QueryWrapper<Goods> queryWrapper = new QueryWrapper<Goods>().eq("state","0").orderByDesc("id");
        queryWrapper.like(!"".equals(name), "name", name);
        queryWrapper.eq(Objects.nonNull(typeid) && typeid != 0, "typeid", typeid);
        Page<Goods> page = goodsService.page(new Page<>(pageNum, pageSize), queryWrapper);
        return Result.success(page);
    }

    /**
     * 推荐商品
     */
    @GetMapping("/recommend")
    public Result recommend() {
        return Result.success(goodsService.recommend().stream().limit(4).collect(Collectors.toList()));
    }

    /**
     * 热销商品
     */
    @GetMapping("/sales")
    public Result sales() {
        return Result.success(goodsService.list(new LambdaQueryWrapper<Goods>().eq(Goods::getState,"0").orderByDesc(Goods::getSales)).stream().limit(4).collect(Collectors.toList()));
    }

    /**
     * 分类查询页面接口
     */
    @GetMapping("/type")
    public Result findAllByType(@RequestParam Integer typeid,@RequestParam String name) {
        return Result.success(goodsService.list(new LambdaQueryWrapper<Goods>().eq(Goods::getState,"0").eq(Objects.nonNull(typeid) && typeid != 0,Goods::getTypeid,typeid).like(Objects.nonNull(name),Goods::getName,name)));
    }

    /**
     * 查询页面接口
     */
    @GetMapping("/search")
    public Result findAllBySearch(@RequestParam String name) {
        return Result.success(goodsService.list(new LambdaQueryWrapper<Goods>().eq(Goods::getState,"0").like(Objects.nonNull(name),Goods::getName,name)));
    }

    /**
     * 近30天订单消费金额统计图
     */
    @GetMapping("/orderEcharts")
    public Result orderEcharts() {
        return Result.success(goodsService.orderEcharts());
    }

    /**
     * 商品销量统计图
     */
    @GetMapping("/goodsSaleEcharts")
    public Result goodsSale() {
        return Result.success(goodsService.goodsSaleEcharts());
    }

    /**
     * 分类商品统计图
     */
    @GetMapping("/goodsStoreEcharts")
    public Result goodsStoreEcharts() {
        return Result.success(goodsService.goodsStoreEcharts());
    }
}
