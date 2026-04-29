package com.example.springboot.controller;

import cn.hutool.poi.excel.ExcelUtil;
import cn.hutool.poi.excel.ExcelReader;
import cn.hutool.poi.excel.ExcelWriter;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletOutputStream;
import java.net.URLEncoder;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.springboot.service.ITypeService;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import java.io.InputStream;
import java.util.List;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.example.springboot.common.Result;
import org.springframework.web.multipart.MultipartFile;
import com.example.springboot.entity.Type;

import org.springframework.web.bind.annotation.RestController;

/**
* TypeAPI接口
*/
@RestController
@RequestMapping("/type")
public class TypeController {

    @Autowired
    private ITypeService typeService;

    /**
     * 新增
     */
    @PostMapping
    public Result save(@RequestBody Type type) {
        typeService.save(type);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping
    public Result update(@RequestBody Type type) {
        typeService.updateById(type);
        return Result.success();
    }

    /**
     * 删除
     */
    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        typeService.removeById(id);
        return Result.success();
    }

    /**
     * 查询全部数据
     */
    @GetMapping
    public Result findAll() {
        return Result.success(typeService.list());
    }

    /**
     * 查询详情
     */
    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        return Result.success(typeService.getById(id));
    }

    /**
     * 分页查询
     */
    @GetMapping("/page")
    public Result findPage(@RequestParam(defaultValue = "") String name,
                           @RequestParam Integer pageNum,
                           @RequestParam Integer pageSize) {
        QueryWrapper<Type> queryWrapper = new QueryWrapper<Type>().orderByDesc("id");
        queryWrapper.like(!"".equals(name), "name", name);
        Page<Type> page = typeService.page(new Page<>(pageNum, pageSize), queryWrapper);
        return Result.success(page);
    }

}
