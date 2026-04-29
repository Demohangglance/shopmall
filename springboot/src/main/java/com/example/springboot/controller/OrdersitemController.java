package com.example.springboot.controller;

import cn.hutool.core.date.DateUtil;
import cn.hutool.poi.excel.ExcelUtil;
import cn.hutool.poi.excel.ExcelReader;
import cn.hutool.poi.excel.ExcelWriter;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletOutputStream;
import java.net.URLEncoder;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.springboot.service.IOrdersitemService;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import java.io.InputStream;
import java.util.List;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.example.springboot.common.Result;
import org.springframework.web.multipart.MultipartFile;
import com.example.springboot.entity.Ordersitem;

import org.springframework.web.bind.annotation.RestController;

/**
* OrdersitemAPI接口
*/
@RestController
@RequestMapping("/ordersitem")
public class OrdersitemController {

    @Autowired
    private IOrdersitemService ordersitemService;

    /**
     * 新增
     */
    @PostMapping
    public Result save(@RequestBody Ordersitem ordersitem) {
        ordersitemService.save(ordersitem);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping
    public Result update(@RequestBody Ordersitem ordersitem) {
        ordersitemService.updateById(ordersitem);
        return Result.success();
    }

    /**
     * 删除
     */
    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        ordersitemService.removeById(id);
        return Result.success();
    }

    /**
     * 查询全部数据
     */
    @GetMapping
    public Result findAll() {
        return Result.success(ordersitemService.list());
    }

    /**
     * 查询详情
     */
    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        return Result.success(ordersitemService.getById(id));
    }

    /**
     * 分页查询
     */
    @GetMapping("/page")
    public Result findPage(@RequestParam(defaultValue = "") String name,
                           @RequestParam Integer pageNum,
                           @RequestParam Integer pageSize) {
        QueryWrapper<Ordersitem> queryWrapper = new QueryWrapper<Ordersitem>().orderByDesc("id");
        queryWrapper.like(!"".equals(name), "name", name);
        Page<Ordersitem> page = ordersitemService.page(new Page<>(pageNum, pageSize), queryWrapper);
        return Result.success(page);
    }

    /**
     * 获取商品评价
     */
    @GetMapping("/comment/goodsid/{goodsid}")
    public Result findPageByGoodsid(@PathVariable Long goodsid) {
        return Result.success(ordersitemService.findPageByGoodsid(goodsid));
    }

    /**
     * 商品关联订单评价接口
     */
    @PostMapping("/comment")
    public Result comment(@RequestBody Ordersitem ordersitem) {
        Ordersitem one = ordersitemService.getOne(new LambdaQueryWrapper<Ordersitem>()
                .eq(Ordersitem::getGoodsid, ordersitem.getGoodsid())
                .eq(Ordersitem::getOrdersid, ordersitem.getOrdersid()));
        one.setComment(ordersitem.getComment());
        one.setScore(ordersitem.getScore());
        one.setCommenttime(DateUtil.now());
        ordersitemService.updateById(one);
        return Result.success();
    }
}
