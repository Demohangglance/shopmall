package com.example.springboot.entity;

import cn.hutool.core.annotation.Alias;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("cart")
public class Cart {

    @TableId(type=IdType.AUTO)
    private Integer id;
    private Integer goodsid;
    private Integer num;
    private Integer userid;
    private Integer shopid;

    @TableField(exist = false)
    private Goods goods;
}
