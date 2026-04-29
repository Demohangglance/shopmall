<template>
  <div class="shop-page">
    <!-- 面包屑导航 -->
    <div class="breadcrumb">
      <el-breadcrumb separator=">">
        <el-breadcrumb-item :to="{ path: '/front/home' }">首页</el-breadcrumb-item>
        <el-breadcrumb-item style="font-weight: bold">{{ shop.name }}</el-breadcrumb-item>
      </el-breadcrumb>
    </div>

    <!-- 商家头部信息 -->
    <div class="shop-header">
      <div class="shop-info-bar">
        <div class="shop-logo">
          <el-image :src="shop.avatar " fit="cover" :alt="shop.name"></el-image>
        </div>
        <div class="shop-base-info">
          <h2 class="shop-name">{{ shop.name }}   <span class="metric-value">（商品数：{{ allGoods.length }}）</span>  </h2>
          <div class="shop-metrics">
            <div class="metric-item">
              <span class="metric-label">{{shop.infos}}</span>
            </div>
          </div>
        </div>
        <div class="shop-actions">
          <el-button type="primary" size="medium" @click="contactShop" icon="el-icon-phone">
            联系商家
          </el-button>
        </div>
      </div>
    </div>

    <!-- 内容区域 -->
    <div class="shop-content">
      <!-- 全部商品 -->
      <div class="all-goods-content">
        <div class="goods-list">
          <div
              class="goods-card"
              v-for="goods in allGoods"
              :key="goods.id"
              @click="goGoodsDetail(goods.id)"
          >
            <div class="goods-img">
              <el-image :src="goods.img" fit="cover" :alt="goods.name"></el-image>
              <div class="goods-tag" v-if="goods.discount < 1">
                {{ (goods.discount * 10).toFixed(1) }}折
              </div>
            </div>
            <div class="goods-info">
              <p class="goods-name">
                {{ goods.name }}
              </p>
              <div class="goods-price">
                <span class="current-price">¥{{ (goods.price * goods.discount).toFixed(2) }}</span>
                <span class="original-price" v-if="goods.discount < 1">¥{{ goods.price.toFixed(2) }}</span>
              </div>
              <div class="goods-metrics">
                <span class="sales">销量{{ goods.sales }}+</span>
              </div>
            </div>
          </div>
        </div>

        <!-- 空数据提示 -->
        <div class="empty-goods" v-if="allGoods.length === 0">
          <el-empty description="暂无符合条件的商品" :image-size="200"></el-empty>
        </div>
      </div>

    </div>
  </div>
</template>

<script>
export default {
  name: 'ShopPage',
  data() {
    return {
      shopid: this.$route.query.shopid,

      // 导航状态
      activeNav: 'allGoods',
      // 店铺数据

      // 商品数据
      allGoods: [],
      shop: {},
      // 筛选与排序参数
      selectedCategory: '',
      priceMin: '',
      priceMax: '',
      sortType: 'default',
      filteredGoods: [],
      // 分页参数
      currentPage: 1,
      pageSize: 12,
      // 关注状态
      isFollow: false,
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {},
      // 评价数据
      // 评价筛选参数
      selectedRating: '',
      reviewDateRange: [],
      filteredReviews: [],
      reviewsCount: 0,
      // 评价分页参数
      reviewCurrentPage: 1,
      reviewPageSize: 10,
      // 店铺信息表格数据
      shopInfoList: []
    }
  },
  created() {
    // 初始化数据
    this.loadGoods()
    this.loadShops()
  },
  methods: {
    loadGoods() {
      this.$request.get("/goods/shop/" + this.shopid).then(res => {
        this.allGoods = res.data
      })
    },
    loadShops() {
      this.$request.get("/user/selectAll").then(res => {
        this.shop = res.data.filter(v => v.id == this.shopid)[0]
      })
    },

    // 排序商品
    // 前往商品详情页
    goGoodsDetail(goodsId) {
      this.$router.push({
        path: '/front/goodsDetail',
        query: { id: goodsId }
      })
    },
    // 联系商家
    contactShop() {
      this.$notify.info({
        title: '联系商家',
        message: `商家电话：${this.shop.phone}\n营业时间：9:00-21:00`,
        duration: 3000
      })
    },
  }
}
</script>

<style scoped>
/* 店铺页面根容器 */
.shop-page {
  max-width: 1200px;
  margin: 10px auto;
  padding: 20px;
  background-color: #f5f5f5;
  min-height: 100vh;
}

/* 面包屑导航 */
.breadcrumb {
  margin-bottom: 20px;
  padding: 10px 0;
}

/* 商家头部区域 */
.shop-header {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
  overflow: hidden;
}

/* 商家 banner */
.shop-banner {
  height: 200px;
  width: 100%;
}

.shop-banner .el-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* 商家信息栏 */
.shop-info-bar {
  display: flex;
  align-items: center;
  padding: 20px;
  gap: 20px;
}

/* 商家 logo */
.shop-logo {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  overflow: hidden;
  border: 3px solid #f5f5f5;
}

.shop-logo .el-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* 商家基础信息 */
.shop-base-info {
  flex: 1;
}

.shop-name {
  font-size: 22px;
  font-weight: bold;
  color: #333;
  margin-bottom: 10px;
}

/* 商家数据指标 */
.shop-metrics {
  display: flex;
  gap: 30px;
  color: #666;
  font-size: 14px;
}

.metric-item {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.metric-value {
  font-size: 16px;
  font-weight: bold;
  color: #ff6b35;
  margin-bottom: 2px;
}

/* 商家操作按钮 */
.shop-actions {
  display: flex;
  gap: 15px;
}

/* 商家导航 */
.shop-nav {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
}

.nav-container {
  max-width: 1200px;
  margin: 0 auto;
}

.shop-nav-menu {
  border-bottom: none;
}

.shop-nav-menu .el-menu-item {
  font-size: 16px;
  padding: 0 25px;
  height: 60px;
  line-height: 60px;
}

.shop-nav-menu .el-menu-item.is-active {
  color: #ff6b35;
  border-bottom: 3px solid #ff6b35;
}

/* 商品筛选栏 */
.goods-filter-bar {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 15px 20px;
  margin-bottom: 20px;
}

.filter-container {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 15px;
}

.filter-label {
  color: #666;
  margin-right: 10px;
}

.category-filter, .price-filter, .sort-filter {
  display: flex;
  align-items: center;
}

.price-separator {
  margin: 0 10px;
  color: #999;
}

.price-filter .el-input-number {
  width: 120px;
}

/* 商品列表 */
.all-goods-content {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
  margin-bottom: 20px;
}

.goods-list {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  margin-bottom: 30px;
}

/* 商品卡片 */
.goods-card {
  width: calc((100% - 60px) / 4);
  min-width: 220px;
  border-radius: 8px;
  border: 1px solid #f5f5f5;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s ease;
}

.goods-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
}

/* 商品图片 */
.goods-img {
  position: relative;
  height: 180px;
  overflow: hidden;
}

.goods-img .el-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.goods-card:hover .goods-img .el-image {
  transform: scale(1.05);
}

/* 商品标签 */
.goods-tag {
  position: absolute;
  top: 10px;
  left: 10px;
  background-color: #ff6b35;
  color: white;
  font-size: 12px;
  padding: 2px 6px;
  border-radius: 3px;
}

/* 商品信息 */
.goods-info {
  padding: 12px;
}

.goods-name {
  font-size: 14px;
  color: #333;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  margin-bottom: 8px;
  height: 38px; /* 固定高度确保卡片对齐 */
}

.goods-price {
  margin-bottom: 6px;
}

.current-price {
  font-size: 16px;
  color: #ff6b35;
  font-weight: bold;
}

.original-price {
  font-size: 12px;
  color: #999;
  text-decoration: line-through;
  margin-left: 6px;
}

.goods-metrics {
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: #999;
}

/* 空商品提示 */
.empty-goods {
  padding: 50px 0;
  text-align: center;
}

/* 分页样式 */
.goods-pagination {
  text-align: center;
  margin-top: 20px;
}

/* 店铺介绍内容 */
.shop-intro-content {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
  margin-bottom: 20px;
}

.intro-card, .shop-info-card, .shop-gallery {
  margin-bottom: 30px;
  padding-bottom: 20px;
  border-bottom: 1px solid #f5f5f5;
}

.intro-card:last-child, .shop-info-card:last-child, .shop-gallery:last-child {
  border-bottom: none;
  margin-bottom: 0;
  padding-bottom: 0;
}

.intro-title, .info-title, .gallery-title {
  font-size: 18px;
  color: #333;
  font-weight: bold;
  margin-bottom: 15px;
  padding-left: 5px;
  border-left: 3px solid #ff6b35;
}

.intro-content {
  color: #666;
  line-height: 1.8;
  font-size: 14px;
}

.intro-content p {
  margin-bottom: 15px;
}

/* 店铺信息表格 */
.info-table {
  margin-top: 10px;
}

/* 店铺相册 */
.gallery-list {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
}

.gallery-item {
  width: calc((100% - 30px) / 3);
  height: 200px;
  border-radius: 6px;
  overflow: hidden;
  cursor: pointer;
}

.gallery-item .el-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.gallery-item:hover .el-image {
  transform: scale(1.05);
}

/* 客户评价内容 */
.customer-reviews-content {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
  margin-bottom: 20px;
}

/* 评价筛选栏 */
.reviews-filter {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  padding: 10px 0;
  margin-bottom: 20px;
  border-bottom: 1px solid #f5f5f5;
}

.reviews-rating-filter, .reviews-date-filter {
  display: flex;
  align-items: center;
}

.reviews-rating-filter .el-radio {
  margin-right: 15px;
}

/* 评价列表 */
.reviews-list {
  margin-bottom: 30px;
}

.review-item {
  padding: 20px 0;
  border-bottom: 1px solid #f5f5f5;
}

.review-item:last-child {
  border-bottom: none;
}

.review-header {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
}

.reviewer-avatar {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  overflow: hidden;
  margin-right: 15px;
}

.reviewer-avatar .el-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.reviewer-info {
  flex: 1;
}

.reviewer-name {
  font-weight: bold;
  color: #333;
  margin-bottom: 5px;
}

.review-date {
  font-size: 12px;
  color: #999;
}

.review-rating {
  margin-right: 20px;
}

.review-goods {
  display: flex;
  align-items: center;
  margin-left: auto;
  background-color: #f9f9f9;
  padding: 5px 10px;
  border-radius: 4px;
  font-size: 12px;
  color: #666;
}

.goods-thumb {
  width: 40px;
  height: 40px;
  border-radius: 4px;
  overflow: hidden;
  margin-right: 8px;
}

.goods-thumb .el-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* 评价内容 */
.review-content {
  color: #333;
  line-height: 1.6;
  margin-bottom: 15px;
  font-size: 14px;
}

/* 评价图片 */
.review-images {
  display: flex;
  gap: 10px;
  margin-bottom: 15px;
}

.review-img-item {
  width: 80px;
  height: 80px;
  border-radius: 4px;
  overflow: hidden;
  cursor: pointer;
}

.review-img-item .el-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* 商家回复 */
.review-reply {
  background-color: #f9f9f9;
  padding: 10px 15px;
  border-radius: 4px;
}

.reply-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 5px;
  font-size: 12px;
}

.merchant-tag {
  color: #ff6b35;
  font-weight: bold;
}

.reply-time {
  color: #999;
}

.reply-content {
  color: #666;
  font-size: 14px;
  line-height: 1.6;
}

/* 空评价提示 */
.empty-reviews {
  padding: 50px 0;
  text-align: center;
}

/* 评价分页 */
.reviews-pagination {
  text-align: center;
  margin-top: 20px;
}
</style>