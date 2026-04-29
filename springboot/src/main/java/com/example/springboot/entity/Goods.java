package com.example.springboot.entity;

import cn.hutool.core.annotation.Alias;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.List;

@Data
@TableName("goods")
public class Goods {

    @TableId(type=IdType.AUTO)
    private Integer id;
    private String name;
    private String description;
    private Double price;
    private String unit;
    private String img;
    private Integer nums;
    private Integer sales;
    private String time;
    private String state;
    private Integer typeid;
    private String recommend;
    private String content;
    private String code;
    private String imgs;
    private Double discount;
    private Integer shopid;

    @TableField(exist = false)
    private List<String> urls;

    @TableField(exist = false)
    private Type type;

    @TableField(exist = false)
    private Boolean isCollect;

    @TableField(exist = false)
    private Long collectCount;

    @TableField(exist = false)
    private User shop;
}
