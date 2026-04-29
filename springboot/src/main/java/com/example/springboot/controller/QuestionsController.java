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
import com.example.springboot.service.IQuestionsService;
import com.example.springboot.utils.TokenUtils;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import java.io.InputStream;
import java.util.List;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.example.springboot.common.Result;
import org.springframework.web.multipart.MultipartFile;
import com.example.springboot.entity.Questions;

import org.springframework.web.bind.annotation.RestController;

/**
* QuestionsAPI接口
*/
@RestController
@RequestMapping("/questions")
public class QuestionsController {

    @Autowired
    private IQuestionsService questionsService;

    /**
     * 新增
     */
    @PostMapping
    public Result save(@RequestBody Questions questions) {
        questions.setUserid(TokenUtils.getCurrentUser().getId());
        questions.setTime(DateUtil.now());
        questionsService.save(questions);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping
    public Result update(@RequestBody Questions questions) {
        questionsService.updateById(questions);
        return Result.success();
    }

    /**
     * 删除
     */
    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        questionsService.removeById(id);
        return Result.success();
    }

    /**
     * 查询全部数据
     */
    @GetMapping
    public Result findAll() {
        return Result.success(questionsService.list());
    }

    /**
     * 查询详情
     */
    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        return Result.success(questionsService.getById(id));
    }

    /**
     * 分页查询
     */
    @GetMapping("/page")
    public Result findPage(@RequestParam(defaultValue = "") String name,
                           @RequestParam Integer pageNum,
                           @RequestParam Integer pageSize) {
        QueryWrapper<Questions> queryWrapper = new QueryWrapper<Questions>().orderByDesc("id");
        queryWrapper.like(!"".equals(name), "name", name);
        Page<Questions> page = questionsService.page(new Page<>(pageNum, pageSize), queryWrapper);
        return Result.success(page);
    }

    /**
     * 商品关联问答接口
     */
    @GetMapping("/goodsid/{goodsid}")
    public Result findAllByGoodsid(@PathVariable Long goodsid) {
        return Result.success(questionsService.list(new LambdaQueryWrapper<Questions>().eq(Questions::getGoodsid, goodsid)));
    }

}
