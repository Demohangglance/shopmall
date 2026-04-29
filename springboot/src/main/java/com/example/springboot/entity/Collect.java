package com.example.springboot.entity;

import cn.hutool.core.annotation.Alias;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("collect")
public class Collect {

    @TableId(type=IdType.AUTO)
    private Integer id;
    private Integer userid;
    private Integer goodsid;
    private String time;

    @TableField(exist = false)
    private Goods goods;
}