package com.example.springboot.controller;

import cn.hutool.poi.excel.ExcelUtil;
import cn.hutool.poi.excel.ExcelReader;
import cn.hutool.poi.excel.ExcelWriter;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletOutputStream;
import java.net.URLEncoder;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.springboot.entity.Ordersitem;
import com.example.springboot.entity.User;
import com.example.springboot.mapper.GoodsMapper;
import com.example.springboot.mapper.OrdersitemMapper;
import com.example.springboot.service.IGoodsService;
import com.example.springboot.service.IOrdersService;
import com.example.springboot.service.IOrdersitemService;
import com.example.springboot.utils.TokenUtils;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import java.io.InputStream;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.example.springboot.common.Result;
import org.springframework.web.multipart.MultipartFile;
import com.example.springboot.entity.Orders;

import org.springframework.web.bind.annotation.RestController;

/**
 * OrdersAPI接口
 */
@RestController
@RequestMapping("/orders")
public class OrdersController {

    @Autowired
    private IOrdersService ordersService;

    @Autowired
    private IGoodsService goodsService;

    @Autowired
    private IOrdersitemService ordersitemService;

    /**
     * 新增
     */
    @PostMapping
    public Result save(@RequestBody Orders orders) {
        ordersService.save(orders);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping
    public Result update(@RequestBody Orders orders) {
        ordersService.updateById(orders);
        return Result.success();
    }

    /**
     * 删除
     */
    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        // 删除订单关联
        ordersitemService.remove(new LambdaQueryWrapper<Ordersitem>().eq(Ordersitem::getOrdersid,id));
        ordersService.removeById(id);
        return Result.success();
    }

    /**
     * 查询全部数据
     */
    @GetMapping
    public Result findAll() {
        return Result.success(ordersService.list());
    }

    /**
     * 查询详情
     */
    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        return Result.success(ordersService.getById(id));
    }

    /**
     * 管理端分页查询
     */
    @GetMapping("/page")
    public Result findPage(@RequestParam(defaultValue = "") String name,
                           @RequestParam(defaultValue = "") String status,
                           @RequestParam(defaultValue = "") String orderno,
                           @RequestParam Integer pageNum,
                           @RequestParam Integer pageSize) {
        QueryWrapper<Orders> queryWrapper = new QueryWrapper<Orders>().orderByDesc("id");
        queryWrapper.like(!"".equals(name), "name", name);
        queryWrapper.like(!"".equals(orderno), "orderno", orderno);
        queryWrapper.like(!"all".equals(status), "status", status);
        User user = TokenUtils.getCurrentUser();
        if (!user.getRole().equals("ADMIN")){
            queryWrapper.eq("shopid",user.getId());
        }
        Page<Orders> page = ordersService.page(new Page<>(pageNum, pageSize), queryWrapper);
        return Result.success(page);
    }


    /**
     * 用户端分页查询
     */
    @GetMapping("/page/front")
    public Result findPageFront(@RequestParam(defaultValue = "") String name,
                                @RequestParam(defaultValue = "") String status,
                                @RequestParam(defaultValue = "") String orderno,
                                @RequestParam Integer pageNum,
                                @RequestParam Integer pageSize) {
        QueryWrapper<Orders> queryWrapper = new QueryWrapper<Orders>().orderByDesc("id");
        queryWrapper.like(!"".equals(name), "name", name);
        queryWrapper.like(!"".equals(orderno), "orderno", orderno);
        queryWrapper.like(((!"all".equals(status)) && (!"待评价".equals(status))), "status", status);
        User currentUser = TokenUtils.getCurrentUser();
        if (Objects.nonNull(currentUser)){
            if (currentUser.getRole().equals("USER")){
                queryWrapper.eq("userid", currentUser.getId());
            }
        }

        Page<Orders> page;
        // 处理待评价逻辑 - 单独处理，因为它需要关联订单商品表
        if ("待评价".equals(status)) {
            // 1. 先查询当前用户所有已完成的订单（根据你的业务定义，比如状态为"已完成"）
            queryWrapper.eq("status", "已完成");

            // 2. 执行分页查询
            page = ordersService.page(new Page<>(pageNum, pageSize), queryWrapper);

            // 3. 过滤出含有未评价商品的订单
            List<Orders> filteredRecords = page.getRecords().stream()
                    .filter(orders -> {
                        // 查询该订单下的所有商品
                        List<Ordersitem> items = ordersitemService.list(
                                new LambdaQueryWrapper<Ordersitem>().eq(Ordersitem::getOrdersid, orders.getId())
                        );
                        // 判断是否存在未评价的商品（score为null或未填写）
                        return items.stream().anyMatch(item -> Objects.isNull(item.getScore()) || item.getScore() <= 0);
                    })
                    .collect(Collectors.toList());

            // 4. 重新构建分页对象
            Page<Orders> resultPage = new Page<>(pageNum, pageSize);
            resultPage.setTotal(filteredRecords.size());
            resultPage.setRecords(filteredRecords);
            page = resultPage;
        } else {
            // 非待评价状态的普通查询
            if (!"all".equals(status)) {
                queryWrapper.like("status", status);
            }
            page = ordersService.page(new Page<>(pageNum, pageSize), queryWrapper);
        }
        return Result.success(page);
    }

    /**
     * 直接下单
     */
    @PostMapping("/addOrder")
    public Result addOrder(@RequestBody Orders orders) {
        ordersService.addOrder(orders);
        return Result.success();
    }

    /**
     * 改变订单状态
     */
    @PostMapping("changeStatus")
    public Result changeStatus(@RequestBody Orders orders) {
        ordersService.changeStatus(orders);
        return Result.success();
    }
}
