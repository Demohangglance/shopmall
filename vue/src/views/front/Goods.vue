<template>
  <div class="product-page">
    <!-- 搜索和分类区域 -->
    <div class="search-section">
      <div class="search-container">
        <!-- 分类筛选 -->
        <div class="category-filter">
          <span class="filter-label">分类:</span>
          <div class="category-list">
            <el-button :class="['category-item', { active: typeid === 0 }]" @click="selectCategory(0)" size="medium">
              全部
            </el-button>
            <el-button v-for="category in categories" :key="category.id" :class="['category-item', { active: typeid === category.id }]" @click="selectCategory(category.id)" size="medium">
              {{ category.name }}
            </el-button>
          </div>
        </div>
      </div>
    </div>

    <!-- 商品列表区域 -->
    <div class="product-section">
      <!-- 商品列表 -->
      <div class="product-list" ref="allProducts" v-if="allProducts.length > 0">
        <div v-for="product in allProducts" :key="product.id" class="product-card clickable-image">
          <div class="product-image">
            <el-image :src="product.img" :alt="product.name" fit="cover"/>
          </div>
          <div class="product-info">
            <el-tooltip effect="dark" :content="product.name" placement="top">
              <h3 class="product-title text-ellipsis">{{ product.name }}</h3>
            </el-tooltip>
            <p class="product-desc">{{ product.description }}</p>
            <div class="product-tags">
              <span class="tag">{{ categories.find(value => value.id == product.typeid).name }}</span>
            </div>
            <div class="product-price">¥{{ product.price }}</div>
            <div class="product-actions">
              <el-button class="detail-btn" @click="goDetail('/front/goodsDetail?id=' + product.id)">查看详情</el-button>
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
  name: 'Goods',
  data() {
    return {
      searchKeyword: this.$route.query.name || '',
      typeid: 0,
      allProducts: [],
      categories: []
    }
  },
  created() {
    this.loadType();
    this.selectCategory(this.typeid)
  },
  methods: {
    // 选择分类
    selectCategory(categoryId) {
      this.typeid = categoryId;
      this.loadProducts(this.typeid);
    },
    // 加载商品数据
    loadProducts() {
      this.$request.get("/goods/type?typeid=" + this.typeid + '&name=' + this.searchKeyword).then(res => {
        this.allProducts = res.data
      })
    },
    // 全部分类
    loadType() {
      this.$request.get("/type").then(res => {
        this.categories = res.data
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

/* ==================== 🔍 顶部筛选栏（固定定位） ==================== */
.search-section {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); /* 紫蓝渐变背景，增强品牌感和视觉吸引力 */
  padding: 20px 0;            /* 上下内边距，避免内容贴边 */
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* 添加轻微阴影，提升悬浮层次感 */
  position: sticky;           /* 粘性定位，滚动时固定在顶部 */
  top: 0;                     /* 固定在视口顶部 */
  z-index: 100;               /* 高层级，确保不被其他内容遮挡 */
}

/* ==================== 📦 顶部内容容器（最大宽度 + 居中） ==================== */
.search-container {
  max-width: 1200px;          /* 限制最大宽度，适配大屏，避免布局过宽 */
  margin: 0 auto;             /* 水平居中 */
  padding: 0 20px;            /* 左右内边距，适配移动端，防止贴边 */
}

/* ==================== 🏷️ 分类筛选器容器 ==================== */
.category-filter {
  display: flex;              /* 启用弹性布局，便于对齐子元素 */
  align-items: center;        /* 垂直居中对齐，使文字与按钮高度一致 */
  flex-wrap: wrap;            /* 允许子元素在空间不足时换行，适配小屏幕 */
  gap: 15px;                  /* 子元素间距，现代浏览器原生支持，替代 margin */
}

/* ==================== 📝 “分类:” 标签文字样式 ==================== */
.filter-label {
  color: white;               /* 白色文字，与深色背景高对比，确保可读性 */
  font-size: 16px;            /* 中等字号，清晰醒目 */
  font-weight: 500;           /* 中等加粗，突出但不喧宾夺主 */
  white-space: nowrap;        /* 禁止换行，保持“分类:”语义完整性 */
}

/* ==================== 📋 分类按钮列表容器 ==================== */
.category-list {
  display: flex;              /* 启用弹性布局排列按钮 */
  flex-wrap: wrap;            /* 按钮过多时自动换行 */
  gap: 10px;                  /* 按钮间距，提升点击区域和视觉舒适度 */
}

/* ==================== 🎛️ 分类按钮通用样式 ==================== */
.category-item {
  padding: 8px 16px;          /* 内边距，确保点击区域足够大 */
  background: rgba(255, 255, 255, 0.2); /* 半透明白色背景，模拟磨砂玻璃效果 */
  color: white;               /* 白色文字，高对比度 */
  border: none;               /* 无边框，视觉简洁 */
  border-radius: 20px;        /* 大圆角，柔和美观 */
  cursor: pointer;            /* 鼠标悬停显示手型，提示可点击 */
  transition: all 0.3s;       /* 所有属性变化添加过渡动画，提升交互流畅度 */
  font-size: 14px;            /* 小字号，符合辅助控件视觉层级 */
  white-space: nowrap;        /* 禁止文字换行，保持按钮紧凑 */
}

/* ==================== 🖱️ 分类按钮悬停状态 ==================== */
.category-item:hover {
  background: rgba(255, 255, 255, 0.3); /* 背景微亮，提供视觉反馈 */
}

/* ==================== ✅ 分类按钮激活状态（选中） ==================== */
.category-item.active {
  background: white;          /* 纯白背景，突出当前选中状态 */
  color: #667eea;             /* 主题色文字，与顶部渐变呼应 */
  font-weight: 600;           /* 加粗，强化选中提示 */
}

/* ==================== 🛍️ 商品展示区域容器 ==================== */
.product-section {
  max-width: 1200px;          /* 与顶部区域宽度一致，保持视觉对齐 */
  margin: 0 auto;             /* 水平居中 */
  padding: 30px 20px;         /* 上下留白30px，左右20px，增强内容呼吸感 */
}

/* ==================== 🧱 商品卡片网格布局 ==================== */
.product-list {
  display: grid;                                     /* 使用 CSS Grid 布局 */
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); /* 自适应列：最小280px，自动填满 */
  gap: 25px;                  /* 卡片间距，避免视觉拥挤 */
  margin-bottom: 40px;        /* 底部外边距，留出视觉缓冲区 */
}

/* ==================== 🖼️ 单个商品卡片容器 ==================== */
.product-card {
  background: white;          /* 白色背景，突出商品内容 */
  border-radius: 12px;        /* 圆角边框，现代感设计 */
  overflow: hidden;           /* 隐藏子元素溢出（如图片） */
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1); /* 轻微阴影，营造立体悬浮感 */
  position: relative;         /* 为未来绝对定位子元素（如角标）预留空间 */
  cursor: pointer;            /* 小鼠标 */
  transition: transform 0.2s; /* 添加过渡或悬停效果 */
}

/* ==================== 🖱️ 商品卡片悬停效果 ==================== */
.product-card:hover {
  transform: translateY(-5px); /* 向上平移5px，模拟“拿起”交互 */
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15); /* 阴影扩大加深，增强反馈 */
}

/* ==================== 📷 商品图片区域 ==================== */
.product-image {
  position: relative;         /* 为未来扩展（如叠加播放按钮、角标）预留定位能力 */
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

/* ==================== 🖱️ 图片悬停放大效果 ==================== */
.product-card:hover .product-image .el-image {
  transform: scale(1.05);     /* 鼠标悬停时图片放大5%，增强互动趣味性 */
}

/* ==================== 🧾 商品信息区域 ==================== */
.product-info {
  padding: 20px;              /* 内边距，与图片区分离，提升可读性 */
}

/* ==================== 🏷️ 商品标题（2行省略） ==================== */
.product-title {
  height: 45px;               /* 固定高度，配合2行文字 */
  font-size: 16px;            /* 标准字号，清晰易读 */
  font-weight: 600;           /* 加粗，突出商品名 */
  margin: 0 0 12px 0;          /* 下边距，与描述分隔 */
  color: #333;                /* 深灰色，稳重专业 */
  line-height: 1.4;           /* 行高适中，避免拥挤 */
  display: -webkit-box;       /* 启用 WebKit 多行文本省略 */
  -webkit-line-clamp: 2;      /* 限制最多显示2行 */
  -webkit-box-orient: vertical; /* 设置子元素垂直排列 */
  overflow: hidden;           /* 超出部分隐藏 */
}

/* ==================== 📄 商品描述（2行省略） ==================== */
.product-desc {
  height: 45px;               /* 与标题高度一致，视觉对齐 */
  font-size: 13px;            /* 较小字号，区分主次 */
  color: #666;                /* 浅灰色，弱化次要信息 */
  margin: 0 0 12px 0;         /* 下边距，与标签分隔 */
  line-height: 1.5;           /* 稍大行高，提升小字号可读性 */
  display: -webkit-box;
  -webkit-line-clamp: 2;      /* 限制最多显示2行 */
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* ==================== 💰 商品价格 ==================== */
.product-price {
  font-size: 22px;            /* 大字号，吸引注意力 */
  font-weight: 700;           /* 超粗体，强化价格信息 */
  color: #ff6b35;             /* 橙红色，常用于促销/价格，刺激消费 */
  margin: 0 0 15px 0;         /* 下边距，与操作区分离 */
}

/* ==================== 🏷️ 商品标签容器 ==================== */
.product-tags {
  display: flex;              /* 启用弹性布局 */
  flex-wrap: wrap;            /* 标签过多时自动换行 */
  gap: 5px;                   /* 标签间距，紧凑不拥挤 */
  margin-bottom: 15px;        /* 与下方价格或按钮保持距离 */
}

/* ==================== 🏷️ 单个标签样式 ==================== */
.tag {
  background: #f0f0f0;        /* 浅灰背景，低调不抢镜 */
  color: #666;                /* 灰色文字 */
  padding: 3px 8px;           /* 小内边距，适合标签尺寸 */
  border-radius: 10px;        /* 圆角，柔和视觉 */
  font-size: 11px;            /* 超小字号，符合标签属性 */
}

/* ==================== 🎯 商品操作按钮区域 ==================== */
.product-actions {
  text-align: center;         /* 按钮文字居中，视觉聚焦 */
}

/* ==================== 🔍 “查看详情”按钮样式 ==================== */
.detail-btn {
  width: 100%;                /* 宽度铺满父容器，提升点击区域 */
  padding: 12px;              /* 内边距，确保文字不贴边 */
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); /* 与顶部同款渐变，视觉统一 */
  color: white;               /* 白色文字，高对比 */
  border: none;               /* 无边框 */
  border-radius: 6px;         /* 小圆角，现代感 */
  font-size: 14px;            /* 标准按钮字号 */
  cursor: pointer;            /* 手型光标，提示可操作 */
  transition: transform 0.2s; /* 轻微缩放过渡，增强点击反馈 */
}

/* ==================== 🖱️ 按钮悬停轻微放大 ==================== */
.detail-btn:hover {
  transform: scale(1.02);     /* 放大2%，提供微妙反馈，不破坏布局 */
}
</style>
