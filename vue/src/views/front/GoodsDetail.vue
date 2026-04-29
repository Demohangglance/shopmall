<template>
  <div class="product-detail-page">
    <!-- 面包屑导航 -->
    <div class="breadcrumb">
      <el-breadcrumb separator=">">
        <el-breadcrumb-item :to="{ path: '/front/home' }">首页</el-breadcrumb-item>
        <el-breadcrumb-item style="font-weight: bold">{{product.type.name}}</el-breadcrumb-item>
        <el-breadcrumb-item>{{product.name}}</el-breadcrumb-item>
      </el-breadcrumb>
    </div>

    <!-- 商品详情主体 -->
    <div class="product-detail">
      <!-- 商品图片区域 -->
      <div class="product-images">
        <div class="main-image">
          <el-image :src="currentImage" :alt="product.name" fit="contain" :preview-src-list="[currentImage]"></el-image>
        </div>
        <div class="thumbnail-images">
          <div v-for="(image, index) in product.urls" :key="index" class="thumbnail" :class="{ active: currentImage === image }" @click="currentImage = image">
            <img :src="image" :alt="'缩略图' + (index + 1)">
          </div>
        </div>
      </div>

      <!-- 商品信息区域 -->
      <div class="product-info">
        <!-- 1. 新增：店铺信息模块 -->
        <div class="shop-info-container">
          <!-- 店铺logo + 名称 + 进店按钮 -->
          <div class="shop-header">
            <img
                :src="product.shop?.avatar"
                alt="店铺logo"
                class="shop-avatar"
            >
            <div class="shop-main-info">
              <h3 class="shop-name" @click="goPage('/front/shop?shopid=' + product.shop.id)">{{ product.shop?.name || '未知店铺' }}</h3>
              <!-- 店铺资质标签 -->
            </div>
            <el-button
                type="text"
                class="enter-shop-btn"
                @click="goPage('/front/shop?shopid=' + product.shop.id)"
            >
              进店逛逛 <i class="el-icon-arrow-right el-icon--mini"></i>
            </el-button>
          </div>
        </div>
        <h1 class="product-title">{{ product.name }}</h1>

        <div class="product-price">
          <span class="current-price">¥{{ (product.price * product.discount).toFixed(2)}}</span>
          <span class="original-price" v-if="product.price">¥{{ product.price }}</span>
          <span class="discount" v-if="product.discount < 1">{{ product.discount }}折</span>
          <span class="discount">销量：{{ product.sales }}</span>
        </div>

        <p class="product-description">{{ product.description }}</p>

        <!-- 数量选择 -->
        <div class="quantity-selector">
          <span class="quantity-label">数量</span>
          <el-input-number v-model="quantity" :min="1" :max="99" size="small"/>
          <span class="quantity-label-right">库存：{{product.nums}}</span>
        </div>

        <!-- 操作按钮 -->
        <div class="action-buttons">
          <el-button type="danger" size="large" class="buy-now" @click="buyNow">
            立即购买
          </el-button>
          <el-button type="warning" size="large" class="buy-now" @click="addToCart">
            加入购物车
          </el-button>
          <el-button
              :type="isCollect ? 'danger' : 'default'"
              size="large"
              class="buy-now"
              @click="toggleFavorite"
              icon="el-icon-star-off"
          >
            {{ isCollect ? '已收藏' : '收藏' }}
          </el-button>
        </div>

        <!-- 服务保障 -->
        <div class="service-guarantee">
          <div class="service-item" v-for="service in services" :key="service.id">
            <i class="service-icon" :class="service.icon"></i>
            <span>{{ service.name }}</span>
          </div>
        </div>
      </div>
    </div>

    <div class="recommended-products">
      <div class="recommend-header">
        <h3>为您推荐</h3>
        <div class="divider"></div>
      </div>
      <div class="recommend-list">
        <!-- 推荐商品卡片 -->
        <div class="recommend-card" v-for="goods in recommendedGoods" :key="goods.id"  @click="goPage('/front/goodsDetail?id=' + goods.id)">
          <div class="card-img">
            <el-image :src="goods.img" :alt="goods.name" fit="cover" />
          </div>
          <div class="card-info">
            <p class="card-name">{{ goods.name }}</p>
            <div class="card-price">
              <span class="card-current-price">¥{{ (goods.price * goods.discount).toFixed(2) }}</span>
              <span class="card-original-price" v-if="goods.price">¥{{ goods.price }}</span>
            </div>
            <div class="card-sales">销量：{{ goods.sales }}</div>
          </div>
        </div>
      </div>
    </div>

    <!-- 商品详情tabs -->
    <div class="product-tabs">
      <div class="card">
        <el-tabs v-model="activeTab">
          <el-tab-pane label="商品详情" name="detail">
            <div class="product-detail-content">
              <div class="feature-list w-e-text" v-html="product.content"></div>
            </div>
          </el-tab-pane>

          <el-tab-pane :label="`商品评价( ${reviews.length}+)`" name="reviews">
            <div class="product-reviews" v-if="reviews.length != 0">
              <div class="review-item" v-for="review in reviews" :key="review.id">
                <div class="review-header">
                  <div><img :src="review.user.avatar || '/default-avatar.png'" class="reviewer-avatar" onerror="this.src='/default-avatar.png'"/></div>
                  <div class="reviewer-info">
                    <div class="reviewer-name">{{ review.user.name }}</div>
                    <div class="review-date">{{ review.commenttime }}</div>
                  </div>
                  <div class="review-rating">
                    <el-rate v-model="review.score" disabled show-score text-color="#ff9900"></el-rate>
                  </div>
                </div>
                <div class="review-content">{{ review.comment }}</div>
              </div>
            </div>
            <div class="product-reviews" v-else>
              <el-empty description="暂无数据" :image-size="200"></el-empty>
            </div>
          </el-tab-pane>

          <el-tab-pane :label="`商品问答( ${questions.length}+)`" name="qa">
            <div class="product-qa" v-if="questions.length != 0">
              <div class="qa-item" v-for="qa in questions" :key="qa.id">
                <div class="qa-question">
                  <strong>Q：</strong>{{ qa.name }}
                </div>
                <div class="qa-answer">
                  <strong>A：</strong>{{ qa.content}}
                </div>
              </div>
            </div>
            <div class="product-qa" v-else>
              <el-empty description="暂无数据" :image-size="200"></el-empty>
            </div>
          </el-tab-pane>
        </el-tabs>
      </div>
    </div>

    <el-dialog title="地址" :visible.sync="dialogFormVisible" width="60%" :close-on-click-modal="false">
      <!-- 收货地址区域 -->
      <div class="order-section address-section">
        <div class="section-title">
          <i class="el-icon-location"></i>
          <span>收货地址</span>
        </div>
        <div class="address-content">
          <div class="address-card" :class="{ active: selectedAddressId === address.id }" v-for="address in addressList" :key="address.id" @click="selectAddress(address)">
            <div class="address-default" v-if="address.isDefault">默认地址</div>
            <div class="address-info">
              <p class="address-name">{{ address.receiver }} {{ address.phone }}</p>
              <p class="address-detail">{{ address.province }} {{ address.city }} {{ address.district }} {{ address.detail }}</p>
            </div>
            <div class="address-operate">
              <i class="el-icon-edit-outline"></i>
            </div>
          </div>
          <div class="add-new-address">
            <i class="el-icon-plus"></i>
            <span>添加新地址</span>
          </div>
        </div>
      </div>

      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="buyNow">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'ProductDetail',
  data() {
    return {
      activeTab: 'detail',
      currentImage: '',
      quantity: 1,
      isCollect: false,
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {},
      id: this.$route.query.id,
      product: {
        type: {
          name: ''
        }
      },
      dialogFormVisible: false,
      selectedAddressId: 1,
      addressList: [],
      services: [
        { id: 1, name: '正品保证', icon: 'el-icon-success' },
        { id: 2, name: '7天无理由退货', icon: 'el-icon-refresh' },
        { id: 3, name: '全国包邮', icon: 'el-icon-truck' },
        { id: 4, name: '售后无忧', icon: 'el-icon-service' }
      ],
      reviews: [],
      questions: [],
      recommendedGoods: [], // 推荐商品列表
    }
  },
  created() {
    this.loadProduct()
    this.loadQuestions()
    this.loadGoodsComment()
    this.loadRecommendedGoods() // 新增：创建时加载推荐商品
  },
  methods: {
    goPage(path) {
      location.href = path;
    },
    // 选择地址
    selectAddress(data) {
      this.selectedAddressId = data.id
    },
    // 加入到购物车
    addToCart(){
      let data = {
        num: this.quantity,
        goodsid: this.product.id,
        shopid: this.product.shopid
      }
      this.$request({
        method: 'POST',
        url: "/cart",
        data: data
      }).then(res => {
        if (res.code === '200') {
          this.$notify.success({title: '成功', message: '已添加到购物车', showClose: false, duration: 2000});
        } else {
          this.$notify.error({title: '成功', message: res.msg, showClose: false, duration: 2000});
        }
      })
    },
    buyNow(){
      console.log(this.user.name)
      if (typeof this.user.name === 'undefined'){
        this.$notify.warning({title: '成功', message: '请登录', showClose: false, duration: 2000});
        this.$router.push('/login')
        return;
      }
      this.$router.push({
        path: '/front/confirmOrder',
        query: {
          goods: JSON.stringify({
            goods: this.product,
            quantity: this.quantity
          })
        }
      });
    },
    loadRecommendedGoods() {
      this.$request.get("/goods/recommend").then(res => {
        this.recommendedGoods = res.data || {}
      })
    },
    loadProduct() {
      this.$request.get("/goods/" + this.id).then(res => {
        this.product = res.data || {}
        this.currentImage = this.product.urls[0]
        this.isCollect = this.product.isCollect || false
      })
    },
    loadQuestions() {
      this.$request.get("/questions/goodsid/" + this.id).then(res => {
        this.questions = res.data || {}
      })
    },
    toggleFavorite() {
      if (typeof this.user.name === 'undefined'){
        this.$notify.warning({title: '成功', message: '请登录', showClose: false, duration: 2000});
        this.$router.push('/login')
        return;
      }
      let data = {
        userid: this.user.id,
        goodsid: this.product.id
      }
      this.$request({
        method: 'POST',
        url: "/collect",
        data: data
      }).then(res => {
        if (res.code === '200') {
          this.$notify.success({title: '成功', message: '收藏成功', showClose: false, duration: 2000});
          this.isCollect = false;
        } else {
          this.isCollect = true;
          this.$notify.warning({title: '成功', message: res.msg, showClose: false, duration: 2000});
        }
        this.loadProduct()
      })
    },
    loadGoodsComment() {
      this.$request.get("/ordersitem/comment/goodsid/" + this.id).then(res => {
        this.reviews = res.data || []
      })
    },
  }
}
</script>

<style scoped>
/* 订单相关区域通用容器样式 */
.order-section {
  background-color: #fff;                 /* 白色背景，突出内容 */
  border-radius: 4px;                     /* 小圆角，柔和边框 */
  margin-bottom: 15px;                    /* 与其他模块保持间距 */
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05); /* 轻微阴影，提升层次感 */
}

/* 区块标题样式 */
.section-title {
  padding: 15px 20px;                     /* 内边距，避免文字贴边 */
  border-bottom: 1px solid #f5f5f5;       /* 底部边框线，区分内容区 */
  font-size: 16px;                        /* 标题字号 */
  color: #333;                            /* 深灰文字，稳重 */
  display: flex;                          /* 弹性布局，便于图标与文字对齐 */
  align-items: center;                    /* 垂直居中对齐 */
}

.section-title i {
  margin-right: 8px;                      /* 图标与文字间距 */
  color: #ff4400;                         /* 橙红色图标，突出重要性 */
}

/* 收货地址内容容器 */
.address-content {
  padding: 20px;                          /* 内边距，与标题分隔 */
  display: flex;                          /* 弹性布局，横向排列地址卡片 */
  flex-wrap: wrap;                        /* 允许换行，适配不同屏幕 */
  gap: 15px;                              /* 卡片间距，现代浏览器原生支持 */
}

/* 地址卡片样式 */
.address-card {
  width: 370px;                           /* 固定宽度，保持统一视觉 */
  padding: 15px;                          /* 内边距，内容不贴边 */
  border: 2px solid #f5f5f5;              /* 默认边框，浅灰色 */
  border-radius: 4px;                     /* 小圆角 */
  cursor: pointer;                        /* 手型光标，提示可点击 */
  position: relative;                     /* 为“默认地址”标签定位准备 */
}

/* 选中状态地址卡片 */
.address-card.active {
  border-color: #ff4400;                  /* 选中时边框变橙红色，突出当前选择 */
}

/* 默认地址标签 */
.address-default {
  position: absolute;                     /* 绝对定位在左上角 */
  top: 0;
  left: 0;
  background-color: #ff4400;              /* 橙红背景 */
  color: #fff;                            /* 白色文字 */
  font-size: 12px;                        /* 小字号 */
  padding: 2px 8px;                       /* 内边距 */
  border-radius: 0 0 4px 0;               /* 只保留右下圆角，贴合卡片 */
}

/* 地址信息容器 */
.address-info {
  margin-top: 10px;                       /* 与顶部信息分隔 */
}

/* 收件人姓名与电话 */
.address-name {
  font-weight: bold;                      /* 加粗，突出关键信息 */
  margin-bottom: 5px;                     /* 与下一行分隔 */
}

/* 详细地址文本 */
.address-detail {
  color: #666;                            /* 浅灰文字，弱化次要信息 */
  font-size: 14px;                        /* 标准字号 */
  line-height: 1.5;                       /* 行高适中，提升可读性 */
}

/* 地址操作图标（编辑） */
.address-operate {
  position: absolute;                     /* 绝对定位在右上角 */
  right: 10px;
  top: 10px;
  color: #999;                            /* 灰色图标 */
  font-size: 16px;                        /* 图标大小 */
}

/* 添加新地址卡片 */
.add-new-address {
  width: 370px;                           /* 与地址卡片同宽 */
  height: 105px;                          /* 固定高度 */
  border: 2px dashed #e5e5e5;             /* 虚线边框，表示“可添加” */
  border-radius: 4px;                     /* 圆角 */
  display: flex;                          /* 弹性布局，居中内容 */
  align-items: center;                    /* 垂直居中 */
  justify-content: center;                /* 水平居中 */
  color: #666;                            /* 灰色文字 */
  cursor: pointer;                        /* 手型光标 */
}

.add-new-address i {
  margin-right: 5px;                      /* 图标与文字间距 */
}

/* 商品详情页根容器 */
.product-detail-page {
  max-width: 1200px;                      /* 最大宽度限制，适配大屏 */
  margin: 10px auto;                      /* 水平居中，上下10px外边距 */
  padding: 20px;                          /* 内边距，避免内容贴边 */
  background-color: #f5f5f5;              /* 浅灰背景，舒适浏览 */
  min-height: 100vh;                      /* 至少占满视口高度 */
}

/* 面包屑导航区域 */
.breadcrumb {
  margin-bottom: 20px;                    /* 与下方内容分隔 */
  padding: 10px 0;                        /* 上下内边距 */
}

/* 商品详情主体容器 */
.product-detail {
  background: white;                      /* 白色背景，突出商品内容 */
  border-radius: 8px;                     /* 圆角边框 */
  padding: 30px;                          /* 内边距 */
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* 轻微阴影，提升立体感 */
  display: flex;                          /* 弹性布局，图片与信息横向排列 */
  gap: 40px;                              /* 图片区与信息区间距 */
  margin-bottom: 30px;                    /* 与下方 Tabs 区域分隔 */
}

/* 商品图片区域容器 */
.product-images {
  flex: 1;                                /* 占据剩余空间 */
  max-width: 500px;                       /* 最大宽度限制，避免过宽 */
}

/* 主图容器 */
.main-image {
  height: 280px;                          /* 固定高度，保持布局稳定 */
  border-radius: 8px;                     /* 圆角 */
  display: flex;                          /* 弹性布局，居中图片 */
  align-items: center;                    /* 垂直居中 */
  justify-content: center;                /* 水平居中 */
  margin-bottom: 20px;                    /* 与缩略图分隔 */
  overflow: hidden;                       /* 隐藏溢出，避免变形 */
}

.main-image .el-image {
  width: 100%;                            /* 宽度撑满容器 */
  height: 100%;                           /* 高度撑满容器 */
  object-fit: cover;                      /* 裁剪填充，保持比例 */
}

/* 缩略图容器 */
.thumbnail-images {
  display: flex;                          /* 弹性布局，横向排列 */
  gap: 10px;                              /* 缩略图间距 */
}

/* 单个缩略图样式 */
.thumbnail {
  width: 80px;                            /* 固定宽度 */
  height: 80px;                           /* 固定高度 */
  background-color: #f8f9fa;              /* 浅灰背景，占位提示 */
  border-radius: 4px;                     /* 小圆角 */
  cursor: pointer;                        /* 手型光标，提示可点击 */
  border: 1px solid transparent;          /* 默认透明边框 */
  display: flex;                          /* 弹性布局，居中内容 */
  align-items: center;                    /* 垂直居中 */
  justify-content: center;                /* 水平居中 */
  overflow: hidden;                       /* 隐藏溢出图片 */
}

/* 缩略图悬停或激活状态 */
.thumbnail:hover,
.thumbnail.active {
  border-color: #ff6b35;                  /* 边框变为橙红色，突出当前/悬停项 */
}

/* 缩略图内图片样式 */
.thumbnail img {
  max-width: 100%;                        /* 最大宽度100%，避免超出容器 */
  max-height: 100%;                       /* 最大高度100% */
  object-fit: cover;                      /* 裁剪填充，保持比例 */
}

/* 商品信息区域 */
.product-info {
  flex: 1;                                /* 占据剩余空间 */
  max-width: 600px;                       /* 最大宽度限制 */
}

/* 商品标题 */
.product-title {
  font-size: 24px;                        /* 大字号，突出商品名 */
  font-weight: bold;                      /* 加粗 */
  margin-bottom: 15px;                    /* 与价格区隔 */
  line-height: 1.4;                       /* 行高适中 */
  color: #333;                            /* 深灰文字 */
}

/* 价格容器 */
.product-price {
  margin-bottom: 20px;                    /* 与描述区隔 */
}

/* 当前价格（折后价） */
.current-price {
  font-size: 28px;                        /* 超大字号，吸引注意 */
  color: #ff6b35;                         /* 橙红色，促销色 */
  font-weight: bold;                      /* 加粗 */
}

/* 原价（划线价） */
.original-price {
  font-size: 16px;                        /* 较小字号 */
  color: #999;                            /* 灰色 */
  text-decoration: line-through;          /* 添加删除线 */
  margin-left: 10px;                      /* 与当前价保持间距 */
}

/* 折扣/销量标签 */
.discount {
  background-color: #ff6b35;              /* 橙红背景 */
  color: white;                           /* 白色文字 */
  padding: 2px 6px;                       /* 小内边距 */
  border-radius: 3px;                     /* 小圆角 */
  font-size: 12px;                        /* 小字号 */
  margin-left: 10px;                      /* 与前一个元素保持间距 */
}

/* 商品描述 */
.product-description {
  color: #666;                            /* 浅灰文字 */
  line-height: 1.6;                       /* 行高宽松，提升可读性 */
  margin-bottom: 25px;                    /* 与数量选择器分隔 */
}

/* 数量选择器容器 */
.quantity-selector {
  display: flex;                          /* 弹性布局，横向排列 */
  align-items: center;                    /* 垂直居中对齐 */
  margin-bottom: 30px;                    /* 与按钮区隔 */
}

/* 数量标签 */
.quantity-label {
  margin-right: 15px;                     /* 与输入框间距 */
  font-weight: bold;                      /* 加粗 */
  color: #333;                            /* 深灰文字 */
}

/* 库存标签 */
.quantity-label-right {
  margin-left: 20px;                      /* 与输入框保持距离 */
  color: #ff6b35;                         /* 橙红色，突出库存信息 */
}

/* 操作按钮区域 */
.action-buttons {
  display: flex;                          /* 弹性布局 */
  gap: 15px;                              /* 按钮间距 */
  margin-bottom: 30px;                    /* 与服务保障区隔 */
}

.buy-now {
  flex: 1;                                /* 均分宽度 */
}

/* 服务保障区域 */
.service-guarantee {
  display: flex;                          /* 弹性布局，横向排列服务项 */
  gap: 20px;                              /* 服务项间距 */
  padding: 20px;                          /* 内边距 */
  background-color: #f8f9fa;              /* 浅灰背景，区分内容 */
  border-radius: 4px;                     /* 圆角 */
}

/* 单个服务项 */
.service-item {
  display: flex;                          /* 弹性布局，图标与文字横向排列 */
  align-items: center;                    /* 垂直居中 */
  gap: 8px;                               /* 图标与文字间距 */
  font-size: 14px;                        /* 标准字号 */
  color: #666;                            /* 浅灰文字 */
}

/* 服务图标 */
.service-icon {
  color: #ff6b35;                         /* 橙红色，统一视觉 */
  font-size: 18px;                        /* 图标大小 */
}

/* 商品详情富文本内容 */
/* 注意：此样式作用于 v-html 注入的内容，保留基础排版 */
.feature-list {
  padding-left: 20px;                     /* 左内边距，模拟列表缩进 */
  line-height: 1.8;                       /* 宽松行高，提升阅读体验 */
  color: #666;                            /* 浅灰文字 */
}

/* 商品评价项  */
.review-item {
  padding: 20px;                          /* 内边距 */
  border-bottom: 1px solid #eee;          /* 底部分隔线 */
}

/* 评价头部容器 */
.review-header {
  display: flex;                          /* 弹性布局 */
  align-items: center;                    /* 垂直居中 */
  margin-bottom: 10px;                    /* 与评价内容分隔 */
}

/* 评价者头像 */
.reviewer-avatar {
  width: 40px;                            /* 固定宽度 */
  height: 40px;                           /* 固定高度 */
  border-radius: 50%;                     /* 圆形 */
  margin-right: 10px;                     /* 与信息区保持间距 */
}

/* 评价者信息容器 */
.reviewer-info {
  flex: 1;                                /* 占据剩余空间 */
}

/* 评价者姓名 */
.reviewer-name {
  font-weight: bold;                      /* 加粗 */
  margin-bottom: 5px;                     /* 与日期分隔 */
}

/* 评价日期 */
.review-date {
  font-size: 12px;                        /* 小字号 */
  color: #999;                            /* 浅灰文字 */
}

/* 评价内容 */
.review-content {
  color: #666;                            /* 浅灰文字 */
  line-height: 1.6;                       /* 行高适中 */
  margin-top: 10px;                       /* 与头部信息分隔 */
}

/* ==================== 商品问答项 ==================== */
.qa-item {
  padding: 15px 0;                        /* 上下内边距 */
  border-bottom: 1px solid #eee;          /* 底部分隔线 */
}

/* 问题文本 */
.qa-question {
  margin-bottom: 10px;                    /* 与答案分隔 */
  color: #333;                            /* 深灰文字 */
}

/* 答案文本 */
.qa-answer {
  color: #666;                            /* 浅灰文字 */
  line-height: 1.6;                       /* 行高适中 */
}

/* 推荐商品模块容器 */
.recommended-products {
  margin: 30px 0; /* 上下间距，与其他模块分隔 */
  background-color: #fff;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

/* 推荐标题栏 */
.recommend-header {
  margin-bottom: 20px;
}
.recommend-header h3 {
  font-size: 18px;
  color: #333;
  font-weight: bold;
  margin-bottom: 8px;
}
.recommend-header .divider {
  height: 2px;
  width: 60px;
  background-color: #ff6b35;
}

/* 推荐商品列表：控制一行4个，超出换行 */
.recommend-list {
  display: flex;          /* 弹性布局 */
  flex-wrap: wrap;        /* 超出自动换行 */
  gap: 20px;              /* 卡片之间的间距（水平+垂直） */
  justify-content: flex-start; /* 左对齐，避免间距不均匀 */
}

/* 推荐商品卡片：固定宽度，确保一行4个 */
.recommend-card {
  width: calc((100% - 60px) / 4); /* 关键：100%宽度 - 3个间距(20px*3)，再除以4 */
  min-width: 220px;       /* 最小宽度，防止屏幕过窄时卡片变形 */
  border-radius: 6px;
  border: 1px solid #f5f5f5;
  cursor: pointer;
  transition: all 0.3s ease;
  box-sizing: border-box; /* 确保padding和border不影响宽度计算 */
}
/* 卡片hover效果 */
.recommend-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
}

/* 卡片图片：固定比例，避免拉伸 */
.card-img {
  width: 100%;
  height: 180px; /* 固定图片高度，保持视觉统一 */
  border-radius: 6px 6px 0 0;
  overflow: hidden;
}
.card-img .el-image {
  width: 100%;
  height: 100%;
  object-fit: cover; /* 图片裁剪填充，避免变形 */
}

/* 卡片信息区：固定内边距，保持排版统一 */
.card-info {
  padding: 12px;
}
/* 商品名称：超出1行省略 */
.card-name {
  font-size: 14px;
  color: #333;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 1; /* 仅显示1行 */
  -webkit-box-orient: vertical;
  overflow: hidden;
  margin-bottom: 8px;
}
/* 价格区样式不变 */
.card-price {
  margin-bottom: 6px;
}
.card-current-price {
  font-size: 16px;
  color: #ff6b35;
  font-weight: bold;
}
.card-original-price {
  font-size: 12px;
  color: #999;
  text-decoration: line-through;
  margin-left: 6px;
}
/* 销量样式不变 */
.card-sales {
  font-size: 12px;
  color: #999;
}


.product-tabs{
  margin-top: 20px;
}

/* ==================== 新增：店铺信息模块样式 ==================== */
/* 店铺信息容器：与标题间距15px，底部边框分隔 */
.shop-info-container {
  margin-bottom: 15px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f5f5f5;
}

/* 店铺头部（logo+名称+进店按钮） */
.shop-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 8px;
}

/* 店铺logo */
.shop-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  object-fit: cover;
  border: 1px solid #f0f0f0;
  margin-right: 12px;
}

/* 店铺名称+标签容器 */
.shop-main-info {
  flex: 1;
  min-width: 0; /* 解决文字溢出问题 */
}

/* 店铺名称：hover变色，提示可点击 */
.shop-name {
  font-size: 16px;
  color: #333;
  font-weight: 500;
  margin-bottom: 4px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  cursor: pointer;
}
.shop-name:hover {
  color: #ff6b35;
}

/* 店铺标签容器：横向排列，间距4px */
.shop-tags {
  display: flex;
  gap: 4px;
  flex-wrap: wrap;
}

/* 进店按钮：文字右对齐，hover变色 */
.enter-shop-btn {
  color: #ff6b35;
  font-size: 14px;
  padding: 0;
}
.enter-shop-btn:hover {
  color: #ff4400;
  background: transparent;
}

/* 店铺数据统计栏：横向均分，居中对齐 */
.shop-stats {
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: #666;
}

/* 单个统计项：居中对齐 */
.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 25%;
}

/* 统计标签：浅灰色，统计值：深灰色 */
.stat-label {
  color: #999;
  margin-bottom: 2px;
}
.stat-value {
  color: #333;
  font-weight: 500;
}

/* ==================== 原有样式调整：仅调整商品标题间距 ==================== */
/* 商品标题：与店铺模块间距调整为10px（原15px） */
.product-title {
  margin-bottom: 10px;
}
</style>
