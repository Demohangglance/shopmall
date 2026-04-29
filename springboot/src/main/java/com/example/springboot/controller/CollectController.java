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
import com.example.springboot.entity.User;
import com.example.springboot.service.ICollectService;
import com.example.springboot.utils.TokenUtils;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import java.io.InputStream;
import java.util.List;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.example.springboot.common.Result;
import org.springframework.web.multipart.MultipartFile;
import com.example.springboot.entity.Collect;

import org.springframework.web.bind.annotation.RestController;

/**
* CollectAPI接口
*/
@RestController
@RequestMapping("/collect")
public class CollectController {

    @Autowired
    private ICollectService collectService;

    /**
     * 新增
     */
    @PostMapping
    public Result save(@RequestBody Collect collect) {
        // 判断是否重复收藏，收藏了删除之前的收藏，页面显示未收藏，没收藏新增，显示已收藏
        Collect one = collectService.getOne(new LambdaQueryWrapper<Collect>().eq(Collect::getUserid, collect.getUserid()).eq(Collect::getGoodsid, collect.getGoodsid()));
        if (null != one){
            collectService.remove(new LambdaQueryWrapper<Collect>().eq(Collect::getGoodsid,collect.getGoodsid()).eq(Collect::getUserid,collect.getUserid()));
            return Result.error("202","已取消收藏");
        }
        collect.setTime(DateUtil.now());
        collectService.save(collect);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping
    public Result update(@RequestBody Collect collect) {
        collectService.updateById(collect);
        return Result.success();
    }

    /**
     * 删除
     */
    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        collectService.removeById(id);
        return Result.success();
    }

    /**
     * 查询全部数据
     */
    @GetMapping
    public Result findAll() {
        return Result.success(collectService.list());
    }

    /**
     * 查询详情
     */
    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        return Result.success(collectService.getById(id));
    }

    /**
     * 分页查询
     */
    @GetMapping("/page")
    public Result findPage(@RequestParam(defaultValue = "") String name,
                           @RequestParam Integer pageNum,
                           @RequestParam Integer pageSize) {
        QueryWrapper<Collect> queryWrapper = new QueryWrapper<Collect>().orderByDesc("id");
        queryWrapper.like(!"".equals(name), "name", name);
        User currentUser = TokenUtils.getCurrentUser();
        if (currentUser.getRole().equals("USER")){
            queryWrapper.eq("userid",currentUser.getId());
        }
        Page<Collect> page = collectService.page(new Page<>(pageNum, pageSize), queryWrapper);
        return Result.success(page);
    }

    /**
     * 用户-我的收藏
     */
    @GetMapping("/myCollect")
    public Result myCollect() {
        return Result.success(collectService.myCollect());
    }
}
