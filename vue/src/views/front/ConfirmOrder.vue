<template>
  <div class="order-page">
    <!-- 主内容区 -->
    <div class="order-container">
      <!-- 收货地址区域 -->
      <div class="order-section address-section">
        <div class="section-title">
          <i class="el-icon-location"></i>
          <span>收货地址</span>
        </div>
        <div class="address-content">
          <div class="address-card" :class="{ active: selectedAddressId === address.id }"
               v-for="address in addressList" :key="address.id"
               @click="selectAddress(address.id)">
            <div class="address-default" v-if="address.isdefault == '是'">默认地址</div>
            <div class="address-info">
              <p class="address-name">{{ address.name }} {{ address.phone }}</p>
              <p class="address-detail">{{ address.address }}</p>
            </div>
          </div>
          <div class="add-new-address">
            <span @click="goDetail('/front/address')">管理地址</span>
          </div>
        </div>
      </div>

      <!-- 商品信息区域 -->
      <div class="order-section goods-section">
        <div class="section-title">
          <i class="el-icon-shopping-cart-full"></i>
          <span>商品信息</span>
        </div>
        <div class="goods-shop">
          <div class="shop-name">
            <img :src="shops.find(v => v.id === goodsList[0].goods.shopid).avatar" alt="店铺logo" class="shop-logo">
            <span>{{shops.find(v => v.id === goodsList[0].goods.shopid).name}}</span>
            <span class="shop-tag clickable" @click="goDetail('/front/shop?shopid=' + goodsList[0].goods.shopid)">进店逛逛</span>
          </div>
          <div class="goods-list">
            <div class="goods-item" v-for="item in goodsList" :key="item.goods.id">
              <div class="goods-pic">
                <img :src="item.goods.img" alt="商品图片">
              </div>
              <div class="goods-info">
                <div class="goods-title">{{ item.goods.name }}</div>
              </div>
              <div class="goods-price">¥{{ item.goods.price.toFixed(2) }} / {{item.goods.unit}}</div>
              <div class="goods-quantity">
                <el-input-number size="mini" v-model="item.quantity" @change="(value) => handleChange(value, item)" :min="1" :max="10" label="商品数量"></el-input-number>
              </div>
              <div class="goods-total" v-if="item.goods.discount < 1">{{ item.goods.discount * 10 }}折</div>
              <div class="goods-total" v-else></div>
            </div>
          </div>
        </div>
      </div>

      <!-- 支付信息区域 -->
      <div class="order-section payment-section">
        <div class="section-title">
          <i class="el-icon-credit-card"></i>
          <span>支付方式</span>
        </div>
        <div class="payment-content">
          <el-radio-group v-model="paymentMethod">
            <el-radio label="支付宝" class="payment-method">
              <i class="el-icon-alipay"></i>
              <span>支付宝</span>
            </el-radio>
            <el-radio label="微信支付" class="payment-method">
              <i class="el-icon-wechat"></i>
              <span>微信支付</span>
            </el-radio>
            <el-radio label="银行卡支付" class="payment-method">
              <i class="el-icon-credit-card"></i>
              <span>银行卡支付</span>
            </el-radio>
          </el-radio-group>
        </div>
      </div>

      <!-- 价格明细区域 -->
      <div class="order-section price-section">
        <div class="price-item">
          <span>商品原价</span>
          <span>¥{{ totalGoodsPrice.toFixed(2) }}</span>
        </div>
        <div class="price-item">
          <span>运费</span>
          <span>{{ freightFee > 0 ? '¥' + freightFee.toFixed(2) : '免运费' }}</span>
        </div>
        <div class="price-item">
          <span>商品优惠价</span>
          <span>-¥{{ (totalGoodsPrice.toFixed(2) - actualPayment.toFixed(2)).toFixed(2)}}</span>
        </div>
        <div class="price-item total-price">
          <span>实付款</span>
          <span>¥{{ actualPayment.toFixed(2) }}</span>
        </div>
      </div>

      <!-- 提交订单按钮 -->
      <div class="submit-order">
        <button class="submit-btn" @click="submitOrder">
          提交订单
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'TmallConfirmOrder',
  data() {
    return {
      id: this.$route.query.id,
      goods: this.$route.query.goods,
      // 地址数据
      addressList: [],
      // 选择地址
      selectedAddressId: null,
      // 店铺信息
      shopInfo: {
        logo: 'https://picsum.photos/id/237/60/60',
        name: '品牌官方旗舰店',
        type: 'tmall'
      },
      // 商品列表
      goodsList: [],
      // 支付方式
      paymentMethod: '支付宝',
      // 价格信息
      freightFee: 0,
      shops: []
    }
  },
  created() {
    this.goodsList.push( JSON.parse(this.goods))
    console.log(this.goodsList)
    this.loadAddress()
  },
  computed: {
    // 商品总价
    totalGoodsPrice() {
      return this.goodsList.reduce((total, item) => {
        return total + (item.goods.price * item.quantity)
      }, 0)
    },
    // 实付款 - 折扣价
    actualPayment() {
      return this.goodsList.reduce((total, item) => {
        return total + (item.goods.price * item.quantity * item.goods.discount)
      }, 0)
    }
  },
  methods: {
    // 商品详情
    goDetail(path) {
      location.href = path
    },
    loadAddress() {
      this.$request.get("/address").then(res => {
        this.addressList = res.data || {}
        if (this.addressList.length > 0){
          this.selectedAddressId = this.addressList.find(v => v.isdefault == '是').id
        } else {
          this.selectedAddressId = this.addressList[0].id
        }
      })

      this.$request.get("/user/selectAll").then(res => {
        this.shops = res.data || {}
      })
    },
    // 选择地址
    selectAddress(id) {
      this.selectedAddressId = id
    },
    handleChange(value, item) {

    },
    // 提交订单
    submitOrder() {
      console.log(this.selectedAddressId)
      if (this.selectedAddressId == null){
        this.$notify.warning({title: '成功', message: '请选择地址', showClose: false, duration: 2000});
        return;
      }
      // 实际项目中这里会调用接口提交订单
      let data = {
        addressId: this.selectedAddressId,
        goodsid: this.goodsList[0].goods.id,
        shopid: this.goodsList[0].goods.shopid,
        name: this.goodsList[0].goods.name,
        num: this.goodsList[0].quantity,
        total: this.actualPayment,
        ordertype: this.paymentMethod
      }
      this.$request({
        method: 'POST',
        url: "/orders/addOrder",
        data: data
      }).then(res => {
        if (res.code === '200') {
          this.$notify.success({title: '成功', message: '订单提交成功，请尽快付款', showClose: false, duration: 2000});
          this.$router.push({path: '/front/orders'});
        } else {
          this.$notify.error({title: '失败', message: res.msg, showClose: false, duration: 2000});
        }
      })
    }
  }
}
</script>

<style scoped>
/* 订单确认页全局容器 */
.order-page {
  background-color: #f5f5f5 !important; /* 背景色，强制覆盖 */
  padding-bottom: 100px;               /* 底部留白，避免按钮被遮挡 */
  font-family: "Microsoft YaHei", sans-serif; /* 中文字体优先 */
  padding-top: 5px;                    /* 顶部微调间距 */
}

/* ==================== 主内容容器 ==================== */
/* 主内容区：居中、最大宽度限制 */
.order-container {
  width: 100%;
  max-width: 1200px;                   /* 最大宽度，适配大屏 */
  margin: 20px auto;                   /* 上下20px，水平居中 */
}

/* ==================== 通用区块样式 ==================== */
/* 所有订单区块的公共样式：白底、圆角、阴影、间距 */
.order-section {
  background-color: #fff;              /* 白色背景 */
  border-radius: 4px;                  /* 圆角 */
  margin-bottom: 15px;                 /* 区块间垂直间距 */
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05); /* 轻微阴影，提升层次感 */
}

/* 区块标题：带图标、左对齐、下边框 */
.section-title {
  padding: 15px 20px;                  /* 内边距 */
  border-bottom: 1px solid #f5f5f5;    /* 标题下划线 */
  font-size: 16px;                     /* 字号 */
  color: #333;                         /* 深灰文字 */
  display: flex;                       /* 弹性布局，图标+文字水平排列 */
  align-items: center;                 /* 垂直居中 */
}

/* 标题图标样式 */
.section-title i {
  margin-right: 8px;                   /* 图标与文字间距 */
  color: #ff4400;                      /* 京东红 */
}

/* ==================== 收货地址区域 ==================== */
/* 地址卡片容器：弹性换行布局 */
.address-content {
  padding: 20px;                       /* 内边距 */
  display: flex;                       /* 弹性布局 */
  flex-wrap: wrap;                     /* 换行 */
  gap: 15px;                           /* 卡片间距 */
}

/* 单个地址卡片样式 */
.address-card {
  width: 375px;                        /* 固定宽度 */
  padding: 15px;                       /* 内边距 */
  border: 2px solid #f5f5f5;           /* 默认边框色 */
  border-radius: 4px;                  /* 圆角 */
  cursor: pointer;                     /* 鼠标悬停手型 */
  position: relative;                  /* 为“默认地址”标签定位准备 */
}

/* 选中状态地址卡片 */
.address-card.active {
  border-color: #ff4400;               /* 选中时边框变红 */
}

/* “默认地址”标签样式 */
.address-default {
  position: absolute;                  /* 绝对定位在左上角 */
  top: 0;
  left: 0;
  background-color: #ff4400;           /* 京东红背景 */
  color: #fff;                         /* 白色文字 */
  font-size: 12px;                     /* 小字号 */
  padding: 2px 8px;                    /* 内边距 */
  border-radius: 0 0 4px 0;            /* 只圆右下角 */
}

/* 地址信息文本容器 */
.address-info {
  margin-top: 15px;                    /* 与“默认标签”保持距离 */
}

/* 收货人姓名+电话样式 */
.address-name {
  font-weight: bold;                   /* 加粗 */
  margin-bottom: 5px;                  /* 与下一行间距 */
}

/* 详细地址文本样式 */
.address-detail {
  color: #666;                         /* 灰色 */
  font-size: 14px;                     /* 标准字号 */
  line-height: 1.5;                    /* 行高，增强可读性 */
}

/* “管理地址”入口按钮样式 */
.add-new-address {
  width: 375px;                        /* 与地址卡片同宽 */
  height: 105px;                       /* 固定高度 */
  border: 2px dashed #e5e5e5;          /* 虚线边框，表示“可操作” */
  border-radius: 4px;                  /* 圆角 */
  display: flex;                       /* 弹性居中 */
  align-items: center;
  justify-content: center;
  color: #666;                         /* 灰色文字 */
  cursor: pointer;                     /* 手型光标 */
}

/* “管理地址”图标间距 */
.add-new-address i {
  margin-right: 5px;
}

/* ==================== 商品信息区域 ==================== */
/* 店铺名称行：logo + 名称 + 标签 */
.shop-name {
  padding: 15px 20px;                  /* 内边距 */
  display: flex;                       /* 水平排列 */
  align-items: center;                 /* 垂直居中 */
}

/* 店铺 Logo 样式 */
.shop-logo {
  width: 30px;
  height: 30px;
  border-radius: 50%;                  /* 圆形 */
  margin-right: 10px;                  /* 与文字间距 */
}

/* 店铺类型标签（如“京东”） */
.shop-tag {
  margin-left: 10px;                   /* 与店名间距 */
  background-color: #ff4400;           /* 京东红背景 */
  color: #fff;                         /* 白字 */
  font-size: 12px;                     /* 小字 */
  padding: 2px 5px;                    /* 内边距 */
  border-radius: 2px;                  /* 微圆角 */
}

/* 单个商品项容器 */
.goods-item {
  display: flex;                       /* 水平弹性布局 */
  padding: 15px 20px;                  /* 内边距 */
  border-top: 1px solid #f5f5f5;       /* 分隔线 */
  align-items: center;                 /* 垂直居中 */
}

/* 商品图片容器 */
.goods-pic img {
  width: 80px;
  height: 80px;
  object-fit: cover;                   /* 图片裁剪填充 */
  border: 1px solid #f5f5f5;           /* 边框 */
}

/* 商品信息文本区域（中间弹性增长） */
.goods-info {
  flex: 1;                             /* 占据剩余空间 */
  margin: 0 20px;                      /* 左右间距 */
}

/* 商品标题 */
.goods-title {
  color: #333;                         /* 深灰 */
  margin-bottom: 5px;                  /* 与属性间距 */
  line-height: 1.4;                    /* 行高 */
}

/* 商品属性（颜色、尺寸等） */
.goods-attrs {
  color: #999;                         /* 浅灰 */
  font-size: 14px;                     /* 标准字号 */
  margin-bottom: 5px;                  /* 与服务标签间距 */
}

/* 商品服务标签容器（如“正品保障”） */
.goods-service {
  display: flex;                       /* 水平排列 */
  gap: 10px;                           /* 标签间距 */
}

/* 单个服务标签 */
.goods-service span {
  color: #666;                         /* 灰色文字 */
  font-size: 12px;                     /* 小字 */
  display: flex;                       /* 为图标对齐准备 */
  align-items: center;                 /* 图文垂直居中 */
}

/* 服务标签前的对勾图标 */
.goods-service i {
  color: #ff4400;                      /* 京东红 */
  margin-right: 3px;                   /* 与文字间距 */
  font-size: 12px;                     /* 小图标 */
}

/* 商品单价列 */
.goods-price {
  width: 100px;                        /* 固定宽度 */
  text-align: center;                  /* 居中对齐 */
  color: #333;                         /* 深灰 */
}

/* 商品数量选择器容器 */
.goods-quantity {
  width: 120px;                        /* 固定宽度 */
  display: flex;                       /* 居中对齐 */
  align-items: center;
  justify-content: center;
}

/* 商品小计金额 */
.goods-total {
  width: 100px;                        /* 固定宽度 */
  text-align: center;                  /* 居中 */
  font-weight: bold;                   /* 加粗 */
  color: #ff4400;                      /* 京东红，突出显示 */
}

/* ==================== 支付方式区域 ==================== */
/* 支付方式容器内边距 */
.payment-content {
  padding: 15px 20px;
}

/* 单个支付方式选项 */
.payment-method {
  display: inline-flex;                /* 行内弹性布局 */
  align-items: center;                 /* 图文垂直居中 */
  margin-right: 30px;                  /* 横向间距 */
  margin-bottom: 15px;                 /* 纵向间距（换行时） */
}

/* 支付方式图标 */
.payment-method i {
  font-size: 20px;                     /* 图标大小 */
  margin-right: 8px;                   /* 与文字间距 */
}

/* 支付宝图标专用色 */
.el-icon-alipay {
  color: #1677ff;                      /* 支付宝蓝 */
}

/* 微信支付图标专用色 */
.el-icon-wechat {
  color: #07c160;                      /* 微信绿 */
}

/* ==================== 价格明细区域 ==================== */
/* 价格明细容器内边距 */
.price-section {
  padding: 15px 20px;
}

/* 单行价格项：左右对齐 */
.price-item {
  display: flex;                       /* 弹性布局 */
  justify-content: flex-end;           /* 文字靠右 */
  margin-bottom: 10px;                 /* 行间距 */
  font-size: 14px;                     /* 标准字号 */
}

/* 价格项左侧描述文字 */
.price-item span:first-child {
  margin-right: 30px;                  /* 与价格数字间距 */
  color: #666;                         /* 灰色 */
}

/* 总价行：顶部边框 + 上下间距 */
.total-price {
  font-size: 16px;                     /* 稍大字号 */
  margin-top: 15px;                    /* 与上一项间距 */
  padding-top: 15px;                   /* 内边距 */
  border-top: 1px solid #f5f5f5;       /* 分隔线 */
}

/* 总价金额特殊样式 */
.total-price span:last-child {
  color: #ff4400;                      /* 京东红 */
  font-weight: bold;                   /* 加粗 */
  font-size: 18px;                     /* 更大字号，突出显示 */
}

/* ==================== 提交订单按钮区域 ==================== */
/* 提交订单固定栏（实际未 fixed，仅为语义） */
.submit-order {
  bottom: 0;
  left: 0;
  right: 0;
  background-color: #fff;              /* 白底 */
  border-top: 1px solid #e5e5e5;       /* 顶部边框分隔 */
  padding: 15px 20px;                  /* 内边距 */
  display: flex;                       /* 弹性布局 */
  justify-content: flex-end;           /* 按钮靠右 */
  align-items: center;                 /* 垂直居中 */
}

/* 提交按钮样式 */
.submit-btn {
  background-color: #ff4400;           /* 京东红背景 */
  color: #fff;                         /* 白字 */
  border: none;                        /* 无边框 */
  width: 180px;                        /* 固定宽度 */
  height: 48px;                        /* 高度 */
  border-radius: 24px;                 /* 大圆角（胶囊形） */
  font-size: 16px;                     /* 字号 */
  font-weight: bold;                   /* 加粗 */
  cursor: pointer;                     /* 手型光标 */
}

/* 按钮悬停效果 */
.submit-btn:hover {
  background-color: #ff5722;           /* 稍亮红色，增强交互感 */
}

.clickable {
  cursor: pointer;            /* 手型光标 */
  transition: transform 0.2s;  /* 启用 transform 过渡动画，时长0.2秒 */
}
</style>
