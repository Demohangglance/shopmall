package com.example.springboot.entity;

import cn.hutool.core.annotation.Alias;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.List;

@Data
@TableName("ordersitem")
public class Ordersitem {

    @TableId(type=IdType.AUTO)
    private Integer id;
    private Integer goodsid;
    private Integer num;
    private Double price;
    private Integer userid;
    private Integer ordersid;
    private String comment;
    private Double score;
    private String commenttime;
    private Integer shopid;

    @TableField(exist = false)
    private Goods goods;

    @TableField(exist = false)
    private User user;

    @TableField(exist = false)
    private Boolean isComment;

}
