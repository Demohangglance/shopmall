package com.example.springboot.controller;

import cn.hutool.core.date.DateUtil;
import cn.hutool.poi.excel.ExcelUtil;
import cn.hutool.poi.excel.ExcelReader;
import cn.hutool.poi.excel.ExcelWriter;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletOutputStream;
import java.net.URLEncoder;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.springboot.entity.User;
import com.example.springboot.service.INoticeService;
import com.example.springboot.utils.TokenUtils;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import java.io.InputStream;
import java.util.List;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.example.springboot.common.Result;
import org.springframework.web.multipart.MultipartFile;
import com.example.springboot.entity.Notice;

import org.springframework.web.bind.annotation.RestController;

/**
* NoticeAPI接口
*/
@RestController
@RequestMapping("/notice")
public class NoticeController {

    @Resource
    private INoticeService noticeService;

    /**
     * 新增
     */
    @PostMapping
    public Result save(@RequestBody Notice notice) {
        User currentUser = TokenUtils.getCurrentUser();
        notice.setUserid(currentUser.getId());
        notice.setTime(DateUtil.now());
        noticeService.save(notice);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping
    public Result update(@RequestBody Notice notice) {
        noticeService.updateById(notice);
        return Result.success();
    }

    /**
     * 删除
     */
    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        noticeService.removeById(id);
        return Result.success();
    }

    /**
     * 查询全部数据
     */
    @GetMapping
    public Result findAll() {
        return Result.success(noticeService.list());
    }

    /**
     * 查询详情
     */
    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        return Result.success(noticeService.getById(id));
    }

    /**
     * 分页查询
     */
    @GetMapping("/page")
    public Result findPage(@RequestParam(defaultValue = "") String name,
                           @RequestParam Integer pageNum,
                           @RequestParam Integer pageSize) {
        QueryWrapper<Notice> queryWrapper = new QueryWrapper<Notice>().orderByDesc("id");
        queryWrapper.like(!"".equals(name), "name", name);
        Page<Notice> page = noticeService.page(new Page<>(pageNum, pageSize), queryWrapper);
        return Result.success(page);
    }
}
