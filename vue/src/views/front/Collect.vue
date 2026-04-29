<template>
  <div class="collection-page">
    <div class="header">
      <h2>我的收藏</h2>
    </div>

    <div class="product-list">
      <div v-for="(item, index) in collects" :key="index" class="product-card clickable-image" v-if="collects.length > 0">
        <div class="product-img-wrapper">
          <img :src="item.goods.img" alt="商品图片" class="product-img" />
          <div class="delete-btn" @click="removeItem(item.id)">
            <i class="el-icon-delete"></i>
          </div>
        </div>
        <div class="product-info" @click="goDetail('/front/goodsDetail?id=' + item.id)">
          <div class="product-title" :title="item.goods.name">{{ item.goods.name }}</div>
          <div class="collect-count">
            {{ item.goods.collectCount }}人收藏
          </div>
          <div class="price">¥{{ item.goods.price }}</div>
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
  name: 'MyCollect',
  data() {
    return {
      collects: [],
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {},
    }
  },
  created() {
    this.loadCollect()
  },
  methods: {
    // 加载收藏数据
    loadCollect() {
      if (typeof this.user.name === 'undefined'){
        this.$notify.warning({title: '成功', message: '请登录', showClose: false, duration: 2000});
        this.$router.push('/login')
        return;
      }
      this.$request.get("/collect/myCollect").then(res => {
        this.collects = res.data || []
      })
    },
    // 删除收藏
    removeItem(id) {
      this.$confirm('您确认删除这些数据吗？', '确认删除', {type: "warning"}).then(response => {
        this.$request.delete("/collect/" + id).then(res => {
          if (res.code === '200') {
            this.$notify.success({title: '成功', message: '操作成功', showClose: false, duration: 2000});
          } else {
            this.$notify.error({title: '成功', message: res.msg, showClose: false, duration: 2000});
          }
          this.loadCollect()
        })
      }).catch(() => {})
    },
    // 商品详情
    goDetail(path) {
      location.href = path
    }
  }
}
</script>

<style>
/* 收藏页面容器样式 */
.collection-page {
  width: 1000px;                            /* 页面宽度 */
  min-height: 90vh;                         /* 最小高度为视口高度的70% */
  margin: 10px auto;                        /* 上下10px外边距，水平居中 */
  padding: 20px;                            /* 内边距20px */
  background-color: #fff;                   /* 白色背景 */
  font-family: 'Microsoft YaHei', sans-serif; /* 字体设置 */
}

/* 头部标题样式 */
.header {
  display: flex;                            /* 弹性布局 */
  justify-content: space-between;           /* 主轴方向两端对齐 */
  align-items: center;                      /* 交叉轴方向居中对齐 */
  margin-bottom: 15px;                      /* 下边距15px */
}

/* 标题文字样式 */
.header h2 {
  margin: 0;                                /* 无外边距 */
  color: #333;                              /* 深灰色文字 */
  font-size: 20px;                          /* 字体大小20px */
}

/* 商品列表网格布局 */
.product-list {
  display: grid;                            /* 网格布局 */
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); /* 自动填充列，每列最小280px，最大1fr */
  gap: 20px;                                /* 网格间距20px */
  margin-top: 10px;                         /* 上边距10px */
}

/* 商品卡片基础样式 */
.product-card {
  border: 1px solid #eee;                   /* 浅灰色边框 */
  border-radius: 8px;                       /* 圆角8px */
  overflow: hidden;                         /* 超出部分隐藏 */
  transition: box-shadow 0.3s ease;         /* 阴影过渡效果，持续0.3秒，缓动函数 */
}

/* 商品卡片悬停效果 */
.product-card:hover {
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);   /* 悬停时添加阴影 */
}

/* 商品图片容器样式 */
.product-img-wrapper {
  position: relative;                       /* 相对定位，为删除按钮定位做准备 */
  width: 100%;                              /* 宽度100% */
  height: 300px;                            /* 高度300px */
  overflow: hidden;                         /* 超出部分隐藏 */
}

/* 商品图片样式 */
.product-img {
  width: 100%;                              /* 宽度100% */
  height: 100%;                             /* 高度100% */
  object-fit: cover;                        /* 图片保持宽高比，覆盖整个容器 */
}

/* 删除按钮样式 */
.delete-btn {
  position: absolute;                       /* 绝对定位 */
  top: 10px;                                /* 距离顶部10px */
  right: 10px;                              /* 距离右侧10px */
  background: rgba(255, 255, 255, 0.8);     /* 半透明白色背景 */
  border: none;                             /* 无边框 */
  width: 30px;                              /* 宽度30px */
  height: 30px;                             /* 高度30px */
  border-radius: 50%;                       /* 圆形按钮 */
  display: flex;                            /* 弹性布局 */
  align-items: center;                      /* 垂直居中 */
  justify-content: center;                  /* 水平居中 */
  cursor: pointer;                          /* 鼠标指针为手型 */
  opacity: 0;                               /* 初始透明度为0，不可见 */
  transition: opacity 0.3s;                 /* 透明度过渡效果，持续0.3秒 */
}

/* 图片容器悬停时删除按钮显示 */
.product-img-wrapper:hover .delete-btn {
  opacity: 1;                               /* 悬停时透明度为1，完全可见 */
}

/* 商品信息区域样式 */
.product-info {
  padding: 12px;                            /* 内边距12px */
  text-align: left;                         /* 文字左对齐 */
}

/* 商品标题样式 */
.product-title {
  font-size: 14px;                          /* 字体大小14px */
  color: #333;                              /* 深灰色文字 */
  line-height: 1.4;                         /* 行高1.4倍 */
  white-space: normal;                      /* 正常换行 */
  word-break: break-word;                   /* 单词可断行 */
  overflow: hidden;                         /* 超出部分隐藏 */
  text-overflow: ellipsis;                  /* 超出部分显示省略号 */
  display: -webkit-box;                     /* 使用Webkit的box模型 */
  -webkit-line-clamp: 2;                    /* 限制显示2行 */
  -webkit-box-orient: vertical;             /* 垂直排列 */
}

/* 收藏人数样式 */
.collect-count {
  font-size: 12px;                          /* 字体大小12px */
  color: #999;                              /* 灰色文字 */
  margin: 6px 0;                            /* 上下6px外边距，左右0 */
}

/* 价格样式 */
.price {
  font-weight: bold;                        /* 加粗 */
  color: #e64340;                           /* 红色文字 */
  font-size: 16px;                          /* 字体大小16px */
}

/* 可点击图片样式 */
.clickable-image {
  cursor: pointer;                          /* 鼠标指针为手型 */
  transition: transform 0.2s;               /* 变换过渡效果，持续0.2秒 */
}

/* 可点击图片悬停效果 */
.clickable-image:hover {
  transform: scale(1.05);                   /* 悬停时放大1.05倍 */
}
</style>
