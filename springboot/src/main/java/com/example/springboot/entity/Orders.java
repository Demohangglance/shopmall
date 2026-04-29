package com.example.springboot.entity;

import cn.hutool.core.annotation.Alias;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.core.metadata.OrderItem;
import lombok.Data;

import java.util.List;

@Data
@TableName("orders")
public class Orders {

    @TableId(type=IdType.AUTO)
    private Integer id;
    private String name;
    private String orderno;
    private Integer num;
    private Double total;
    private String username;
    private String address;
    private String phone;
    private String status;
    private String time;
    private Integer userid;
    private Integer goodsid;
    private String ordertype;
    private Integer shopid;

    @TableField(exist = false)
    private List<Cart> cartList;

    @TableField(exist = false)
    private Long addressId;

    @TableField(exist = false)
    private List<Ordersitem> orderItems;
}