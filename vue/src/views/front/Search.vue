<template>
  <div class="product-page">
    <!-- 商品列表区域 -->
    <div class="product-section">
      <div class="header">
        <h2>全部商品<span v-if="name"> · 搜索“{{ name }}”</span></h2>
      </div>
      <!-- 商品列表 -->
      <div class="product-list" ref="productList" v-if="productList.length > 0">
        <div v-for="product in productList" :key="product.id" class="product-card">
          <div class="product-image">
            <el-image :src="product.img" :alt="product.name" fit="cover"/>
          </div>
          <div class="product-info">
            <el-tooltip style="margin: 4px" effect="dark" :content="product.name" placement="top">
              <h3 class="product-title text-ellipsis">{{ product.name }}</h3>
            </el-tooltip>
            <p class="product-desc">{{ product.description }}</p>
            <div class="product-price">¥{{ product.price }}</div>
            <div class="product-actions">
              <el-button class="add-cart-btn" @click="goDetail('/front/goodsDetail?id=' + product.id)">查看详情</el-button>
            </div>
          </div>
        </div>
      </div>
      <div v-else>
        <el-empty :image-size="200"></el-empty>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ProductPage',
  data() {
    return {
      name: this.$route.query.name || '',
      productList: [],
      categories: []
    }
  },
  created() {
    // 初始化时加载商品分类
    this.loadProducts()
  },
  methods: {
    // 加载商品数据
    loadProducts() {
      // 全部商品
      this.$request.get("/goods/search?name=" + this.name).then(res => {
        this.productList = res.data
      })
    },
    // 商品详情
    goDetail(path) {
      location.href = path
    }
  }
}
</script>

<style scoped>
/* ==================== 🖼️ 页面根容器 ==================== */
.product-page {
  min-height: 100vh;          /* 设置最小高度为视口高度，确保背景铺满，避免内容过少时留白 */
}

/* ==================== 🧭 商品区域头部 ==================== */
.header {
  display: flex;              /* 启用弹性布局 */
  justify-content: space-between; /* 子元素两端对齐 */
  align-items: center;        /* 垂直居中对齐 */
  margin-bottom: 15px;        /* 底部外边距，与商品列表分隔 */
}

/* 商品展示区域容器 */
.product-section {
  max-width: 1200px;          /* 限制最大宽度，适配大屏 */
  margin: 0 auto;             /* 水平居中 */
  padding: 30px 20px;         /* 上下留白30px，左右20px，增强呼吸感 */
}

/* 商品卡片网格布局 */
.product-list {
  display: grid;                                     /* 使用 CSS Grid 布局 */
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); /* 自适应列：最小280px，自动填满容器 */
  gap: 25px;                  /* 卡片间距，避免视觉拥挤 */
  margin-bottom: 40px;        /* 底部外边距，留出视觉缓冲区 */
}

/* 单个商品卡片容器 */
.product-card {
  background: white;          /* 白色背景，突出商品内容 */
  border-radius: 12px;        /* 圆角边框，现代感设计 */
  overflow: hidden;           /* 隐藏子元素溢出（如图片） */
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1); /* 轻微阴影，营造立体悬浮感 */
  position: relative;         /* 为未来绝对定位子元素预留空间 */
  cursor: pointer;            /* 小鼠标 */
  transition: transform 0.2s; /* 添加过渡或悬停效果 */
}

/* 商品卡片悬停效果 */
.product-card:hover {
  transform: translateY(-5px); /* 向上平移5px，模拟“拿起”交互 */
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15); /* 阴影扩大加深，增强反馈 */
}

/* 商品图片区域 */
.product-image {
  position: relative;         /* 为未来扩展（如叠加角标）预留定位能力 */
  height: 200px;              /* 固定高度，确保所有卡片图片区域对齐 */
  overflow: hidden;           /* 隐藏超出部分，避免图片变形 */
}

/* 注意：选择 .el-image 类，是 Element 渲染后的真实类名 */
.product-image .el-image {
  width: 100%;                /* 宽度撑满容器 */
  height: 100%;               /* 高度撑满容器 */
  object-fit: cover;          /* 图片裁剪填充，保持比例不拉伸 */
  transition: transform 0.3s ease; /* 添加缩放过渡动画 */
}

/* 商品信息区域 */
.product-card:hover .product-image .el-image {
  transform: scale(1.05);     /* 鼠标悬停时图片放大5%，增强互动趣味性 */
}

/* 商品信息区域 */
.product-info {
  padding: 20px;              /* 内边距，与图片区分离，提升可读性 */
}

/* 商品标题 */
.product-title {
  height: 45px;               /* 固定高度，配合2行文字 */
  font-size: 16px;            /* 标准字号，清晰易读 */
  font-weight: 600;           /* 加粗，突出商品名 */
  margin: 0 0 8px 0;          /* 下边距，与描述分隔 */
  color: #333;                /* 深灰色，稳重专业 */
  line-height: 1.4;           /* 行高适中，避免拥挤 */
  display: -webkit-box;       /* 启用 WebKit 多行文本省略 */
  -webkit-line-clamp: 2;      /* 限制最多显示2行 */
  -webkit-box-orient: vertical; /* 设置子元素垂直排列 */
  overflow: hidden;           /* 超出部分隐藏 */
}

/* 商品描述 */
.product-desc {
  height: 45px;               /* 与标题高度一致，视觉对齐 */
  font-size: 13px;            /* 较小字号，区分主次 */
  color: #666;                /* 浅灰色，弱化次要信息 */
  margin: 0 0 12px 0;         /* 下边距，与价格分隔 */
  line-height: 1.5;           /* 稍大行高，提升小字号可读性 */
  display: -webkit-box;
  -webkit-line-clamp: 2;      /* 限制最多显示2行 */
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* 商品操作按钮区域 */
.product-price {
  font-size: 22px;            /* 大字号，吸引注意力 */
  font-weight: 700;           /* 超粗体，强化价格信息 */
  color: #ff6b35;             /* 橙红色，常用于促销/价格，刺激消费 */
  margin: 0 0 15px 0;         /* 下边距，与操作按钮分隔 */
}

/* 商品操作按钮区域 */
.product-actions {
  text-align: center;         /* 按钮文字居中，视觉聚焦 */
}

/* “查看详情”按钮样式 */
.add-cart-btn {
  width: 100%;                /* 宽度铺满父容器，提升点击区域 */
  padding: 12px;              /* 内边距，确保文字不贴边 */
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); /* 渐变背景，与品牌色统一 */
  color: white;               /* 白色文字，高对比 */
  border: none;               /* 无边框 */
  border-radius: 6px;         /* 小圆角，现代感 */
  font-size: 14px;            /* 标准按钮字号 */
  cursor: pointer;            /* 手型光标，提示可操作 */
  transition: transform 0.2s; /* 轻微缩放过渡，增强点击反馈 */
}

/* 按钮悬停轻微放大 */
.add-cart-btn:hover {
  transform: scale(1.02);     /* 放大2%，提供微妙反馈，不破坏布局 */
}
</style>
