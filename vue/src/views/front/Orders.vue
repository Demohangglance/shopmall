<template>
  <div class="order-list-container">
    <!-- 标签栏 -->
    <el-tabs v-model="activeName" type="card" @tab-click="loadOrders">
      <el-tab-pane label="所有订单" name="all"></el-tab-pane>
      <el-tab-pane label="待付款" name="待付款"></el-tab-pane>
      <el-tab-pane label="待发货" name="待发货"></el-tab-pane>
      <el-tab-pane label="待收货" name="待收货"></el-tab-pane>
      <el-tab-pane label="待评价" name="待评价"></el-tab-pane>
      <el-tab-pane label="已完成" name="已完成"></el-tab-pane>
      <el-tab-pane label="已取消" name="已取消"></el-tab-pane>
    </el-tabs>

    <!-- 搜索及操作栏 -->
    <el-row :gutter="10" class="search-bar">
      <el-col :span="6">
        <el-input v-model="searchKey" placeholder="商品名/订单号" clearable>
          <i slot="suffix" class="el-input__icon el-icon-search"></i>
        </el-input>
      </el-col>
      <el-col :span="2">
        <el-button type="primary" plain @click="loadOrders">搜索</el-button>
      </el-col>
    </el-row>

    <!-- 订单列表 -->
    <el-card v-if="orders.length == 0" >
      <el-empty description="暂无数据" :image-size="200"></el-empty>
    </el-card>
    <el-card
        v-for="(order, index) in orders"
        :key="index"
        class="order-card"
    >
      <!-- 订单头部信息 -->
      <div slot="header" class="order-header">
        🔢订单号: <span class="order-number">{{ order.orderno }}</span>
        📅订单日期：<span class="order-number">{{ order.time }}</span>
        📍地址信息：<span class="order-number">{{order.username}}，{{order.phone}}，{{order.address}}</span>
        <span class="order-status" :style="{ color: getStatusColor(order.status) }">
          {{ order.status }}
        </span>
      </div>

      <!-- 主体内容：左侧商品信息 + 右侧操作按钮 -->
      <div class="order-body">
        <!-- 左侧：商品信息列表 -->
        <div class="product-info-list">
          <div class="product-info" v-for="(item, index) in order.orderItems" :key="index">
            <img :src="item.goods.img" alt="商品" class="product-img" />
            <div class="product-desc">
              <p class="product-title price" @click="$router.push('/front/shop?shopid=' + item.shopid)">{{shops.find(v => v.id === item.shopid).name}}</p>
              <p class="product-title" @click="$router.push('/front/goodsDetail?id=' + item.goods.id)">{{ item.goods.name }}</p>
              <p class="product-subtitle">{{ item.goods.description }}</p>
              <p class="product-subtitle" v-if="item.goods.discount < 1"><el-tag size="mini">{{ item.goods.discount * 10}}折</el-tag></p>
              <p class="product-subtitle" v-else>正品保证 7天无理由退货 全国包邮 售后无忧</p>
              <div>
                <el-button type="text" @click="handleAdd(item)" v-if="order.status == '已完成' && !item.isComment">评价</el-button>
                <div v-if="order.status == '已完成' && item.isComment"><p class="product-subtitle">已评价</p></div>
              </div>

<!--              <p class="product-address">收货信息</p>
              <p class="product-subtitle">{{order.username}}，{{order.phone}}，{{order.address}}</p>-->
            </div>
            <div class="price-info">
              <p class="price">¥{{ (item.goods.price * item.goods.discount).toFixed(2) }}</p>
              <p class="original-price">¥{{ item.goods.price }}</p>
              <p class="quantity">x{{ item.num }}</p>
            </div>
          </div>
        </div>

        <!-- 右侧：操作按钮区 -->
        <div class="price-info2">
          <p class="real-pay">实付款 ¥{{ order.total }}</p>
          <p class="post-fee">含运费: ¥0.00</p>
          <p class="post-fee">💳付款方式: {{ order.ordertype }}</p>
        </div>

        <div class="operation-btns">
          <el-button type="text" @click="changeStatus(order,'已取消')" v-if="order.status == '待付款'">取消</el-button>
          <el-button type="text" @click="changeStatus(order,'待发货')" v-if="order.status == '待付款'">付款</el-button>
          <el-button type="text" @click="changeStatus(order,'已完成')" v-if="order.status == '待收货'">收货</el-button>
          <el-button type="text" @click="deleteOrder(order)" v-if="order.status == '已取消' || order.status == '已完成'">删除订单</el-button>
        </div>
      </div>
    </el-card>
    <div style="margin: 10px 0;text-align: right">
      <el-pagination
          style="padding: 0"
          background
          layout="total, prev, pager, next"
          @current-change="handleCurrentChange"
          :current-page="pageNum"
          :page-size="pageSize"
          :total="total">
      </el-pagination>
    </div>

    <!--评价弹框-->
    <el-dialog title="评价" :visible.sync="dialogFormVisible" width="30%" :close-on-click-modal="false">
      <el-form label-width="100px" style="padding-right: 40px" :model="form">
        <el-form-item prop="comment" label="评价">
          <el-input type="textarea" v-model="form.comment" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item prop="score" label="评分">
          <el-rate v-model="form.score" style="margin-top: 7px"></el-rate>
        </el-form-item>

      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="save">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'OrderList',
  data() {
    return {
      activeName: '',
      searchKey: '',
      orders: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
      dialogFormVisible: false,
      form: {},
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {},
      shops: []
    };
  },
  created() {
    this.loadOrders()
  },
  methods: {
    getStatusColor(status) {
      const map = {
        '待付款': '#ff5000',
        '待发货': '#1989fa',
        '待收货': '#ee0a24',
        '待评价': '#ffb31a',
        '已完成': '#07c160',
        '已取消': '#999'
      }
      return map[status] || '#333'
    },
    save() {
      this.$request({
        method: 'POST',
        url: "/ordersitem/comment",
        data: this.form
      }).then(res => {
        if (res.code === '200') {
          this.$notify.success({title: '成功', message: '操作成功', showClose: false, duration: 2000});
          this.dialogFormVisible = false
          // 修改订单状态
          // let data = {id: this.form.ordersid}
          // this.changeStatus(data,'已完成')
          this.activeName = status
          this.loadOrders()
        } else {
          this.$notify.error({title: '成功', message: res.msg, showClose: false, duration: 2000});
        }
      })
    },
    handleAdd(data) {
      this.dialogFormVisible = true
      this.form = {goodsid: data.goodsid, ordersid: data.ordersid}
      this.$nextTick(() => {
        if(this.$refs.img) {
          this.$refs.img.clearFiles();
        }
        if(this.$refs.file) {
          this.$refs.file.clearFiles();
        }
      })
    },
    changeStatus(row,status){
      let data = {
        id: row.id,
        status: status
      }
      this.$request({
        method: 'POST',
        url: "/orders/changeStatus",
        data: data
      }).then(res => {
        if (res.code === '200') {
          this.activeName = status
          this.loadOrders()
          this.$notify.success({title: '成功', message: '操作成功', showClose: false, duration: 2000});
        } else {
          this.$notify.error({title: '成功', message: res.msg, showClose: false, duration: 2000});
        }
      })
    },
    handleCurrentChange(pageNum) {
      this.pageNum = pageNum
      this.loadOrders()
    },
    loadOrders() {
      if (typeof this.user.name === 'undefined'){
        this.$notify.warning({title: '成功', message: '请登录', showClose: false, duration: 2000});
        this.$router.push('/login')
        return;
      }
      this.$request.get("/orders/page/front", {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          name: this.name,
          status: this.activeName,
          orderno: this.searchKey,
        }
      }).then(res => {
        this.orders = res.data.records || []
        this.total = res.data.total || 0
      })

      this.$request.get("/user/selectAll").then(res => {
        this.shops = res.data
      })
    },
    deleteOrder(order) {
      this.$confirm('您确认删除这些数据吗？', '确认删除', {type: "warning"}).then(response => {
        this.$request.delete("/orders/" + order.id).then(res => {
          if (res.code === '200') {
            this.$notify.success({title: '成功', message: '操作成功', showClose: false, duration: 2000});
            this.loadOrders('all')
          } else {
            this.$notify.error({title: '成功', message: res.msg, showClose: false, duration: 2000});
          }
        })
      }).catch(() => {})
    },
  },
};
</script>

<style scoped>
/* 容器基础样式 */
.order-list-container {
  min-height: 100vh;          /* 至少占满视口高度，避免内容过少时页面留白 */
  width: 70%;                 /* 主内容区宽度设为70%，留出两侧空间，视觉更聚焦 */
  margin: 0 auto;             /* 水平居中布局 */
  font-family: Arial, sans-serif; /* 设置标准无衬线字体，确保跨浏览器一致性 */
  color: #333;                /* 默认深灰色文字，保证可读性 */
  padding: 20px;              /* 内边距，让内容与容器边缘保持距离，避免贴边 */
  box-sizing: border-box;     /* 启用 border-box 盒模型，使 padding 和 border 包含在 width 内 */
}

/* 标签页（订单状态分类） */
.el-tabs {
  margin: 10px 0;             /* 上下外边距，与上下模块（如搜索栏、订单列表）分隔 */
}

/* 搜索栏布局 */
.search-bar {
  margin-bottom: 20px;        /* 与下方订单列表保持间距，避免视觉拥挤 */
  display: flex;              /* 启用弹性布局，便于水平排列子元素 */
  align-items: center;        /* 垂直居中对齐，使输入框和按钮高度一致 */
}

/* 订单卡片容器 */
.order-card {
  margin-bottom: 20px;        /* 卡片之间纵向间距，制造视觉呼吸感 */
  border-radius: 8px;         /* 圆角设计，提升现代感和亲和力 */
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05); /* 轻微阴影，增强立体感和层次感 */
}

/* 订单头部信息（订单号 + 状态） */
.order-header {
  display: flex;              /* 启用弹性布局，横向排列子元素（订单号、日期、状态） */
  flex-wrap: wrap;            /* 屏幕宽度不足时自动换行，适配移动端 */
  align-items: center;        /* 子元素垂直居中对齐 */
  gap: 15px;                  /* 子元素横向间距，提升可读性 */
  padding-bottom: 5px;        /* 与下方订单主体内容保持微小间距，视觉分区 */
  font-size: 16px;            /* 设置标准字号，清晰易读 */
}

.order-number {
  font-size: 14px;            /* 设置标准字号，清晰易读 */
  color: #666;                /* 灰色文字，降低视觉权重，突出状态标签 */
  margin-top: 5px;             /* 上边距 */
}

.order-status {
  margin-left: auto;          /* 自动推至容器最右侧，实现右对齐效果 */
  font-weight: bold;          /* 加粗显示，突出当前订单状态 */
}

/* 订单主体：左右结构（商品信息 + 价格&操作） */
.order-body {
  display: flex;              /* 启用弹性布局，创建左右结构 */
  justify-content: space-between; /* 左右分布：商品信息在左，价格和操作按钮在右 */
  gap: 30px;                  /* 左右区块之间留白30px，避免视觉拥挤 */
  padding: 20px 0;            /* 上下内边距，与头部、尾部内容保持距离 */
  align-items: flex-start;    /* 顶部对齐，防止因高度不一致导致布局错位 */
}

/* 商品信息列表容器 */
.product-info-list {
  flex: 1;                    /* 占据左侧弹性剩余空间，自适应宽度 */
  display: flex;
  flex-direction: column;     /* 子项（多个商品）垂直排列 */
}

/* 单个商品项 */
.product-info {
  display: flex;              /* 启用弹性布局，横向排列：图片 + 描述 + 价格 */
  align-items: flex-start;    /* 顶部对齐，避免因图片高度导致文字下沉 */
  gap: 15px;                  /* 图片、描述、价格三者之间横向间距 */
  padding: 10px 0;            /* 上下内边距，与其他商品项保持间距 */
}

/* 商品图片 */
.product-img {
  width: 80px;                /* 固定宽度，统一视觉尺寸 */
  height: 80px;               /* 固定高度，避免布局因图片尺寸不同而抖动 */
  object-fit: cover;          /* 保持图片原始比例并裁剪填充，避免变形 */
  border-radius: 4px;         /* 微圆角，提升视觉精致感 */
  background-color: #f5f5f5;  /* 图片加载前或加载失败时的默认占位背景色 */
}

/* 商品描述区 */
.product-desc {
  flex: 1;                    /* 占据中间弹性空间，自适应宽度 */
  min-width: 0;               /* 防止因内容过长导致 flex 容器溢出 */
}

.product-title {
  font-weight: 600;           /* 半加粗，突出商品名称 */
  font-size: 14px;            /* 标准字号，清晰可读 */
  margin: 0 0 5px 0;          /* 下边距，与副标题保持间距 */
  color: #333;                /* 深灰文字，确保可读性 */
  line-height: 1.4;           /* 行高适中，避免文字拥挤 */
  cursor: pointer;            /* 小鼠标 */
}

.product-subtitle {
  font-size: 12px;            /* 较小字号，作为辅助信息 */
  color: #999;                /* 浅灰文字，降低视觉权重 */
  margin: 3px 0;              /* 上下微小边距，与其他文本分隔 */
  line-height: 1.4;           /* 保持行高一致，提升阅读体验 */
}

.product-address {
  font-weight: 600;           /* 加粗，突出“收货信息”标题 */
  font-size: 13px;            /* 略小于商品名，作为次级标题 */
  color: #333;                /* 深灰文字，确保可读 */
  margin: 15px 0 5px 0;       /* 上边距较大，与商品信息分组；下边距较小，贴近收货详情 */
}

/* 价格信息区（右侧） */
.price-info {
  width: 200px;               /* 固定宽度，避免因内容长度变化导致布局抖动 */
  text-align: right;          /* 文字右对齐，符合价格阅读习惯（数字右对齐更易比较） */
  flex-shrink: 0;             /* 禁止压缩，确保在空间不足时仍保持固定宽度 */
}

.price-info2 {
  width: 200px;               /* 固定宽度，避免因内容长度变化导致布局抖动 */
  text-align: right;          /* 文字右对齐，符合价格阅读习惯（数字右对齐更易比较） */
  flex-shrink: 0;             /* 禁止压缩，确保在空间不足时仍保持固定宽度 */
  margin-top: 5px;
}

.price {
  font-weight: bold;          /* 加粗，突出当前售价 */
  font-size: 16px;            /* 较大字号，吸引用户注意 */
  color: #ff5000;             /* 醒目橙红色，电商常用价格强调色 */
  margin: 0 0 5px 0;          /* 下边距，与原价分隔 */
}

.original-price {
  text-decoration: line-through; /* 添加删除线，表示原价 */
  color: #999;                /* 浅灰文字，表示已失效价格 */
  font-size: 12px;            /* 较小字号，作为辅助信息 */
  margin: 0 0 5px 0;          /* 下边距，与数量分隔 */
}

.quantity {
  color: #666;                /* 中灰文字，表示购买数量 */
  font-size: 13px;            /* 中等字号 */
  margin: 0 0 10px 0;         /* 下边距较大，与下一个商品或总价分隔 */
}

.real-pay {
  font-weight: bold;          /* 加粗，突出实付金额 */
  font-size: 16px;            /* 大字号，吸引注意 */
  color: #ff5000;             /* 同样使用醒目橙红色，强调支付金额 */
  margin: 0 0 5px 0;          /* 下边距，与运费分隔 */
}

.post-fee {
  color: #999;                /* 浅灰文字，表示辅助费用信息 */
  font-size: 12px;            /* 小字号 */
  margin: 5px 0;                  /* 无边距，紧贴上方 */
}

/* 操作按钮区（最右侧） */
.operation-btns {
  width: 100px;               /* 固定宽度，确保按钮区域不会挤压其他内容 */
  display: flex;
  flex-direction: column;     /* 按钮垂直排列，适合多个操作 */
  gap: 10px;                  /* 按钮之间纵向间距，避免误触 */
  align-items: flex-end;      /* 按钮右对齐，与价格区视觉对齐 */
  flex-shrink: 0;             /* 禁止压缩，保持固定宽度 */
}

/* 分页器样式 */
.el-pagination {
  padding: 12px 0 !important; /* 强制统一上下内边距，覆盖 Element UI 默认样式 */
  background: #fff;           /* 白色背景，突出分页器 */
  border-radius: 6px;         /* 圆角，与卡片风格统一 */
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05); /* 轻微阴影，提升层级感 */
  margin-top: 20px;           /* 与最后一个订单卡片保持间距，避免粘连 */
}
</style>
