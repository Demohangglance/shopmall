package com.example.springboot.utils.recommend;

import lombok.Data;

@Data
public class RelateDTO {
    /**
     * 用户Id
     */
    private Integer useId;

    /**
     * 商品ID
     */
    private Integer goodsId;
    /**
     * 指数
     */
    private Integer index;

    public RelateDTO(Integer useId, Integer goodsId, Integer index) {
        this.useId = useId;
        this.goodsId = goodsId;
        this.index = index;
    }
}