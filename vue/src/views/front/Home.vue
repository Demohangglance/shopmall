<template>
  <div class="main-content">
    <el-carousel height="700px" indicator-position="none">
      <el-carousel-item v-for="(carousel, idx) in carousels" :key="idx" class="el-carousel-item">
        <el-image :src="carousel.img" :alt="carousel.name" fit="cover" class="el-carousel-img"/>
            <div class="el-carousel-title">
              <h1 class="el-carousel h1">{{carousel.name}}</h1>
              <el-button type="primary" size="large" @click="goPage('/front/goodsDetail?id=' + carousel.goodsid)">查看详情</el-button>
            </div>
      </el-carousel-item>
    </el-carousel>

    <div class="card img-width" @click="goPage('/front/goodsDetail?id=6')">
      <el-image class="clickable-image" :src="horiImg" />
    </div>

    <div class="good-category-title">商品分类</div>
    <div class="good-category">
        <div class="good-category-left">
          <div class="good-category-left-2" :class="{ active: activeTypeId === item.id }" v-for="(item, index) in types" :key="index" @click="selectCategory(item.id)">
            <el-image :src="item.img"/>
            <div class="good-category-left-name">
              <span class="color-change-span">{{item.name}}</span>
            </div>
          </div>
          <div class="good-category-left-2">
            <el-image :src="moreImg" />
            <div class="good-category-left-name">
              <span class="color-change-span" @click="goPage('/front/goods')">更多</span>
            </div>
          </div>
        </div>
        <div class="good-category-right" v-if="products.length > 0">
          <div class="product-grid">
            <div class="product-item" v-for="(product, index) in products" :key="index" @click="goPage('/front/goodsDetail?id=' + product.id)">
              <div class="product-image">
                <el-image v-if="product.img" :src="product.img" fit="cover" class="product-img clickable-image"></el-image>
                <div v-else class="placeholder-image">{{ product.name.substring(0, 2) }}</div>
              </div>
              <div class="product-info">
                <div class="product-title">{{ product.name }}</div>
                <div class="product-price">
                  ¥{{ product.price }}
                  <span class="product-discount-price">¥{{ (product.price * product.discount).toFixed(2) }}</span>
                </div>
                <div class="product-sales">销量 {{ product.sales }}</div>
              </div>
            </div>
          </div>
          <div class="good-category-right-page">
            <el-pagination background layout="total, prev, pager, next" @current-change="handleCurrentChange" :current-page="pageNum" :page-size="pageSize" :total="total"></el-pagination>
          </div>
        </div>
        <div class="good-category-right" v-else>
          <el-empty :image-size="200"></el-empty>
        </div>
    </div>

    <div class="product-hot-container">
      <div class="product-hot-container-title">热销商品</div>
      <div class="product-list" v-if="hotProducts.length > 0">
        <div v-for="(item, index) in hotProducts" :key="index" class="product-card clickable-image"  @click="goPage('/front/goodsDetail?id=' + item.id)">
          <div class="product-image">
            <el-image v-if="item.img" :src="item.img" fit="cover"></el-image>
            <div v-else class="placeholder-image">{{ item.name.substring(0, 2) }}</div>
          </div>
          <div class="product-info">
            <div class="product-title">{{ item.name }}</div>
            <div class="product-price">
              ¥{{ item.price }}
              <span class="product-discount-price">¥{{ (item.price * item.discount).toFixed(2) }}</span>
            </div>
            <div class="product-sales">销量 {{ item.sales }}</div>
          </div>
        </div>
      </div>
      <div v-else>
        <el-empty description="暂无数据" :image-size="200"></el-empty>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  data() {
    return {
      types: [],
      typeid: 1,
      total: 0,
      pageNum: 1,
      pageSize: 8,
      products: [],
      hotProducts: [],
      carousels: [],
      moreImg: require('@/assets/more.png'),
      horiImg: 'https://cdn.cnbj1.fds.api.mi-img.com/mi-mall/9e9c620dbad5c650b6ff0c573df76e14.jpg?thumb=1&w=2146&h=210&f=webp&q=90',
      activeTypeId: 0,
    }
  },
  created() {
    this.loadCategory()
    this.loadGoods(this.typeid)
    this.loadCarousel()
    this.loadHotGoods()
  },
  methods: {
    selectCategory(typeid) {
      this.activeTypeId = typeid; // 设置当前选中分类
      this.loadGoodsType(typeid); // 加载对应商品
    },
    goPage(path) {
      location.href = path;
    },
    loadCarousel() {
      this.$request.get('/carousel').then(res => {
        this.carousels = res.data
      })
    },
    loadHotGoods() {
      this.$request.get('/goods/sales').then(res => {
        this.hotProducts = res.data
      })
    },
    loadCategory() {
      this.$request.get('/type').then(res => {
        this.types = res.data
        if (this.types.length > 0) {
          this.selectCategory(this.types[0].id) // 默认选中第一个
        }
      })
      this.loadGoods(this.typeid)
    },
    loadGoods(typeid) {
      this.typeid = typeid
      this.$request.get("/goods/page/front", {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          typeid: this.typeid
        }
      }).then(res => {
        this.products = res.data?.records
        this.total = res.data?.total
      })
    },
    loadGoodsType(typeid) {
      this.typeid = typeid
      this.pageNum = 1
      this.$request.get("/goods/page/front", {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          typeid: this.typeid
        }
      }).then(res => {
        this.products = res.data?.records
        this.total = res.data?.total
      })
    },
    handleCurrentChange(pageNum) {
      console.log(this.typeid)
      this.pageNum = pageNum
      this.loadGoods(this.typeid)
    },
  }
}
</script>

<style scoped>
/* 通用交互文字样式：颜色变化 + 手型光标 */
.color-change-span {
  color: #333;                /* 默认深灰色文字，确保可读性 */
  cursor: pointer;            /* 鼠标悬停显示手型光标，提示用户可点击 */
}

/* 悬停状态：文字变为橙黄色，提供视觉反馈 */
.color-change-span:hover {
  color: #FFB31A;             /* 橙黄色，醒目且符合电商常用交互色 */
}

/* 激活状态（点击时）：保持悬停色，增强点击反馈一致性 */
.color-change-span:active {
  color: #FFB31A;
}

/* 商品网格布局（4列） */
.product-grid {
  display: grid;              /* 启用 CSS Grid 布局系统 */
  grid-template-columns: repeat(4, 1fr); /* 创建4列，每列等宽（1fr = 剩余空间均分） */
  gap: 15px;                  /* 设置网格项之间的横向和纵向间距 */
  margin-bottom: 30px;        /* 底部留白，与下方分页器保持视觉呼吸感 */
}

/* 单个商品项容器 */
.product-item {
  background: white;          /* 白色背景，突出商品内容 */
  border-radius: 8px;         /* 圆角设计，提升现代感和亲和力 */
  overflow: hidden;           /* 隐藏子元素溢出，如图片超出容器 */
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); /* 添加轻微阴影，制造“浮起”立体感 */
  transition: transform 0.3s; /* 启用 transform 动画过渡，时长0.3秒 */
  cursor: pointer;            /* 鼠标悬停变手型，提示可点击跳转 */
}

/* 商品项悬停效果：轻微上浮，模拟“拿起商品”的动效 */
.product-item:hover {
  transform: translateY(-5px); /* Y轴向上平移5像素，制造悬浮感 */
}

/* 商品图片容器 */
.product-image {
  width: 100%;                /* 宽度撑满父容器，确保图片区域完整 */
  height: 250px;              /* 固定高度，统一视觉高度，避免布局抖动 */
  display: flex;              /* 启用弹性布局，便于内容居中 */
  align-items: center;        /* 垂直居中对齐（上下居中） */
  justify-content: center;    /* 水平居中对齐（左右居中） */
}

/* 图片占位符（无图时显示首字母） */
.placeholder-image {
  height: 250px;              /* 与 .product-image 高度一致，保持布局稳定 */
  width: 100%;                /* 撑满容器宽度 */
  background: linear-gradient(45deg, #a8edea, #fed6e3); /* 使用柔和渐变背景提升视觉友好度 */
  display: flex;
  align-items: center;
  justify-content: center;
  color: #666;                /* 灰色文字，降低视觉权重 */
  font-size: 14px;            /* 小字号，仅作占位提示 */
  font-weight: bold;          /* 加粗，使首字母更清晰 */
}

/* 商品标题（名称） */
.product-title {
  font-size: 13px;            /* 标准商品标题字号 */
  color: #333;                /* 深灰文字，确保可读性 */
  margin-bottom: 10px;        /* 与价格区域保持间距 */
  height: 40px;               /* 固定高度，为两行文本预留空间 */
  overflow: hidden;           /* 超出部分隐藏 */
  display: -webkit-box;       /* 启用 WebKit 的弹性盒模型（用于多行截断） */
  -webkit-line-clamp: 2;      /* 最多显示2行 */
  -webkit-box-orient: vertical; /* 设置子元素垂直排列 */
  line-height: 1.4;           /* 行高适中，避免文字拥挤 */
}

/* 商品价格（当前价） */
.product-price {
  color: #ff5000;             /* 醒目的橙红色，吸引用户注意价格 */
  font-size: 16px;            /* 较大字号，突出显示 */
  font-weight: bold;          /* 加粗，强化价格信息 */
}

/* 商品原价（划线价/折扣前价格） */
.product-discount-price {
  color: #999;                /* 浅灰色，降低视觉优先级 */
  font-size: 13px;            /* 较小字号，作为辅助信息 */
  margin-left: 10px;          /* 与当前价保持适当间距 */
  text-decoration: line-through; /* 添加删除线，表示原价已被优惠 */
}

/* 商品销量 */
.product-sales {
  font-size: 12px;            /* 小字号，作为辅助数据 */
  color: #999;                /* 浅灰色，不抢价格风头 */
  margin-top: 5px;            /* 与价格区域保持微小间距 */
}

/* 热销商品列表（自适应网格） */
.product-list {
  display: grid;              /* 启用网格布局 */
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); /* 自适应列数，每列最小280px，自动填满容器 */
  gap: 20px;                  /* 卡片之间的间距 */
  margin-top: 10px;           /* 与上方标题保持距离 */
  padding: 0 20px;            /* 左右内边距，避免贴边 */
}

/* 热销商品卡片样式 */
.product-card {
  border: 1px solid #eee;     /* 浅灰色细边框，区分卡片边界 */
  border-radius: 8px;         /* 圆角，与商品项风格统一 */
  overflow: hidden;           /* 隐藏溢出内容 */
  transition: box-shadow 0.3s ease; /* 阴影变化启用缓动过渡 */
  cursor: pointer;            /* 手型光标，提示可点击 */
  background: white;          /* 明确设置背景色，避免继承干扰 */
}

/* 卡片悬停效果：阴影加深，增强交互反馈 */
.product-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); /* 提升阴影强度和范围，制造“浮起”感 */
}

/* 商品图片（在热销卡片中） */
.product-img {
  width: 100%;                /* 图片宽度撑满容器 */
  height: 100%;               /* 高度撑满容器，配合父容器的固定高度 */
  object-fit: cover;          /* 保持比例裁剪填充，避免变形 */
}

/* 商品信息区（标题、价格、销量） */
.product-info {
  padding: 12px;              /* 内边距，让文字与边框保持呼吸感 */
  text-align: left;           /* 文字左对齐，符合阅读习惯 */
}

/* 通用可点击图片样式（缩放反馈） */
.clickable-image {
  cursor: pointer;            /* 手型光标 */
  transition: transform 0.2s;  /* 启用 transform 过渡动画，时长0.2秒 */
}

/* 悬停缩放效果：轻微放大，增强点击欲望 */
.clickable-image:hover {
  transform: scale(1.05);     /* 放大至105%，制造“被选中”反馈 */
}

/* 轮播图项容器 */
.el-carousel-item {
  height: 700px;              /* 固定轮播项高度，确保视觉冲击力 */
}

/* 轮播图图片 */
.el-carousel-img {
  width: 100%;                /* 图片宽度100% */
  height: 100%;               /* 高度100%，填充整个轮播项 */
  filter: brightness(0.8);    /* 降低亮度20%，使上方白色文字更易阅读 */
}

/* 轮播图标题容器（绝对定位居中） */
.el-carousel-title {
  position: absolute;         /* 绝对定位，脱离文档流 */
  top: 40%;                   /* 距离顶部40%，视觉中心偏上 */
  left: 50%;                  /* 水平居中基准点 */
  transform: translate(-50%, -50%); /* 向左上各偏移50%，实现精确居中 */
  color: white;               /* 白色文字，与暗化图片形成对比 */
  text-align: center;         /* 文字居中对齐 */
  z-index: 10;                /* 提高层级，确保在图片上方显示 */
  text-shadow: 0 2px 4px rgba(0,0,0,0.6); /* 添加文字阴影，提升可读性 */
}

/* 轮播图主标题样式 */
.el-carousel-title .h1 {
  font-size: 40px;            /* 大字号，突出主标题 */
  margin-bottom: 20px;        /* 与按钮保持间距 */
  font-weight: bold;          /* 加粗，增强视觉重量 */
  letter-spacing: 1px;        /* 字母间距微调，提升高级感 */
}

/* 首屏横幅广告图容器 */
.img-width {
  margin: 20px 0 10px 0;      /* 上边距20px，下边距10px，制造模块间隔 */
}

.img-width .el-image{
  width: 100%;                /* 宽度铺满 */
  height: 120px;              /* 高度120px */
}

/* 商品分类标题 */
.good-category-title {
  margin: 10px 0;             /* 上下外边距，与其他模块分隔 */
  font-size: 24px;            /* 大标题字号 */
  font-weight: bold;          /* 加粗 */
  color: #333;                /* 深灰文字，稳重专业 */
  text-align: center;         /* 居中显示，作为模块引导 */
}

/* 商品分类容器（左右结构） */
.good-category {
  margin: 10px 0;             /* 上下外边距 */
  background: #f8f9fa;        /* 浅灰背景色，区分内容区域 */
  padding: 20px 0;            /* 上下内边距 */
  display: flex;              /* 启用弹性布局，实现左右分栏 */
  align-items: flex-start;    /* 子项顶部对齐 */
}

/* 商品分类容器（左右结构） */
.good-category-left {
  width: 15%;                 /* 占总宽度15%，固定侧边栏 */
  margin-left: 20px;          /* 左侧留白，避免贴边 */
}

/* 分类菜单单项 */
.good-category-left-2 {
  color: rgb(102, 102, 102);  /* 灰色文字，降低视觉权重 */
  display: flex;              /* 启用弹性布局，图标+文字横向排列 */
  align-items: center;        /* 垂直居中对齐 */
  margin: 3px 0px;           /* 上下间距，制造呼吸感 */
  padding: 8px 10px;          /* 内边距，增大点击热区 */
  border-radius: 6px;         /* 圆角，提升亲和力 */
  transition: background 0.2s; /* 背景变化启用过渡 */
}

/* 悬停背景色变化，增强可点击反馈 */
.good-category-left-2:hover {
  background: #e9ecef;        /* 更浅灰背景，表示“可交互” */
}

/* 分类图标样式 */
.good-category-left-2 .el-image {
  width: 20px;                /* 固定图标宽度 */
  height: 20px;               /* 固定图标高度 */
}

/* 选中状态：文字变橙黄，背景微亮 */
.good-category-left-2.active {
  color: #eee;             /* 点击后文字颜色 */
  font-weight: bold;          /* 可选：加粗 */
}

/* 分类文字容器 */
.good-category-left-name {
  margin-left: 10px;          /* 与图标保持间距 */
  font-size: 14px;            /* 标准字号 */
}

/* 商品分类右侧商品展示区 */
.good-category-right {
  width: 85%;                 /* 占据剩余85%宽度 */
  padding: 0 30px;            /* 左右内边距，避免内容贴边 */
}

/* 分页器容器 */
.good-category-right-page {
  margin: 30px auto 0;        /* 上边距30px，水平居中 */
  text-align: right;          /* 分页器右对齐，符合常见设计 */
}

/* Element 分页器样式增强 */
.good-category-right-page .el-pagination {
  padding: 10px;              /* 内边距，增大点击区域 */
  background: white;          /* 白色背景，突出分页器 */
  border-radius: 6px;         /* 圆角 */
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); /* 轻微阴影，提升层级感 */
}

/* 热销商品模块容器 */
.product-hot-container {
  margin: 50px 0;             /* 上下大边距，制造模块分隔 */
}

/* 热销商品标题 */
.product-hot-container-title {
  margin-bottom: 30px;        /* 与商品列表保持距离 */
  font-size: 24px;            /* 大标题字号 */
  font-weight: bold;          /* 加粗 */
  color: #333;                /* 深灰文字 */
  text-align: center;         /* 居中显示 */
}
</style>
