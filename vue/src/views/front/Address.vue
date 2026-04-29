<template>
  <div class="address-container">
    <div class="content-container">
      <div class="address-section">
        <div class="section-title">
          <i class="el-icon-location"></i>
          <span>收货地址</span>
        </div>
        <div class="address-content">
          <div class="address-card"
               v-for="address in addressList" :key="address.id"
               >
            <div class="address-default" v-if="address.isdefault == '是'">默认地址</div>
            <div class="address-info">
              <p class="address-name">{{ address.name }} {{ address.phone }}</p>
              <p class="address-detail">{{ address.address }}</p>
              <el-button class="address-detail-default" type="text" @click="setDefault(address)" v-if="address.isdefault != '是'">设为默认</el-button>
            </div>
            <div class="address-operate">
              <i class="el-icon-edit-outline" @click="handleEdit(address)"></i>
            </div>
          </div>
          <div class="add-new-address" @click="handleAdd">
            <i class="el-icon-plus"></i>
            <span>添加新地址</span>
          </div>
        </div>
      </div>
    </div>

    <el-dialog title="收货地址" :visible.sync="dialogFormVisible" width="30%" :close-on-click-modal="false">
      <el-form label-width="100px" style="padding-right: 40px" :model="form">
        <el-form-item prop="name" label="收货人">
          <el-input v-model="form.name" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item prop="address" label="收货地址">
          <el-input v-model="form.address" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item prop="phone" label="联系方式">
          <el-input v-model="form.phone" autocomplete="off"></el-input>
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
  name: 'Address',
  data() {
    return {
      id: this.$route.query.id,
      addressList: [],
      form: {},
      dialogFormVisible: false,
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {},
    }
  },
  created() {
    this.loadAddress()
  },
  methods: {
    // 新增|更新数据
    save() {
      this.$request({
        method: this.form.id ? 'PUT' : 'POST',
        url: "/address",
        data: this.form
      }).then(res => {
        if (res.code === '200') {
          this.$notify.success({title: '成功', message: '操作成功', showClose: false, duration: 2000});
          this.dialogFormVisible = false
          this.loadAddress()
        } else {
          this.$notify.error({title: '成功', message: res.msg, showClose: false, duration: 2000});
        }
      })
    },
    // 新增弹窗
    handleAdd() {
      this.dialogFormVisible = true
      this.form = {}
      this.$nextTick(() => {
        if(this.$refs.img) {
          this.$refs.img.clearFiles();
        }
        if(this.$refs.file) {
          this.$refs.file.clearFiles();
        }
      })
    },
    // 编辑弹窗
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row))
      this.dialogFormVisible = true
      this.$nextTick(() => {
        if(this.$refs.img) {
          this.$refs.img.clearFiles();
        }
        if(this.$refs.file) {
          this.$refs.file.clearFiles();
        }
      })
    },
    // 加载地址数据
    loadAddress() {
      if (typeof this.user.name === 'undefined'){
        this.$notify.warning({title: '成功', message: '请登录', showClose: false, duration: 2000});
        this.$router.push('/login')
        return;
      }
      this.$request.get("/address").then(res => {
        this.addressList = res.data || {}
      })
    },
    // 设置默认地址
    setDefault(data){
      data.isdefault = '是'
      this.$request({
        method: 'PUT',
        url: "/address/setDefault",
        data: data
      }).then(res => {
        if (res.code === '200') {
          this.$notify.success({title: '成功', message: '设置成功', showClose: false, duration: 2000});
          this.dialogFormVisible = false
        } else {
          this.$notify.error({title: '成功', message: res.msg, showClose: false, duration: 2000});
        }
        this.loadAddress()
      })
    },
  }
}
</script>

<style scoped>
/* 整体容器：背景色、内边距、字体 */
.address-container {
  background-color: #f5f5f5 !important; /* 浅灰色背景，强制应用 */
  padding-bottom: 100px;                /* 底部留白，避免内容贴底 */
  font-family: "Microsoft YaHei", sans-serif; /* 使用微软雅黑字体，无则用系统无衬线字体 */
  padding-top: 5px;                     /* 顶部微调间距 */
}

/* 主内容区容器：居中、最大宽度限制、最小高度 */
.content-container {
  width: 100%;                          /* 占满父容器宽度 */
  max-width: 1000px;                    /* 最大宽度限制，适配大屏 */
  margin: 20px auto;                    /* 上下20px外边距，水平居中 */
  min-height: 80vh;                     /* 最小高度为视口高度的80%，避免内容过少时页面太短 */
}

/* 通用区块样式：白色背景、圆角、阴影、外边距 */
.address-section {
  background-color: #fff;               /* 白色背景 */
  border-radius: 4px;                   /* 圆角边框 */
  margin-bottom: 15px;                  /* 与其他区块间隔 */
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05); /* 轻微阴影，提升层次感 */
}

/* 区块标题：内边距、底边线、字体大小、颜色、弹性布局对齐图标 */
.section-title {
  padding: 15px 20px;                   /* 内边距 */
  border-bottom: 1px solid #f5f5f5;     /* 底部浅灰分隔线 */
  font-size: 16px;                      /* 标题字体大小 */
  color: #333;                          /* 深灰色文字 */
  display: flex;                        /* 弹性布局，使图标和文字水平对齐 */
  align-items: center;                  /* 垂直居中对齐 */
}

/* 标题图标样式：右边距、强调色 */
.section-title i {
  margin-right: 8px;                    /* 图标与文字间距 */
  color: #ff4400;                       /* 醒目的橙红色，用于强调 */
}

/* 地址内容区：内边距、弹性布局换行、项目间距 */
.address-content {
  padding: 33px;                        /* 内容区内边距 */
  display: flex;                        /* 弹性布局 */
  flex-wrap: wrap;                      /* 允许换行 */
  gap: 15px;                            /* 子元素之间间距15px（现代浏览器支持） */
}

/* 单个地址卡片：固定宽高、内边距、边框、圆角、指针样式、相对定位（用于绝对定位子元素） */
.address-card {
  width: 300px;                         /* 固定宽度，适配移动端或卡片式布局 */
  height: 135px;                        /* 固定高度 */
  padding: 15px;                        /* 内边距 */
  border: 2px solid #f5f5f5;            /* 浅灰边框 */
  border-radius: 4px;                   /* 圆角 */
  cursor: pointer;                      /* 鼠标悬停显示手型，提示可点击 */
  position: relative;                   /* 相对定位，使内部绝对定位元素（如“默认地址”标签）基于此定位 */
}

/* “默认地址”标签：绝对定位在左上角、背景色、文字色、字体大小、内边距、圆角 */
.address-default {
  position: absolute;                   /* 绝对定位 */
  top: 0;                               /* 贴顶部 */
  left: 0;                              /* 贴左边 */
  background-color: #ff4400;            /* 橙红色背景 */
  color: #fff;                          /* 白色文字 */
  font-size: 12px;                      /* 小号字体 */
  padding: 2px 8px;                     /* 内边距 */
  border-radius: 0 0 4px 0;             /* 只圆右下角，形成小标签效果 */
}

/* 地址信息容器：顶部外边距 */
.address-info {
  margin-top: 10px;                     /* 与顶部图标/标签保持距离 */
}

/* 收货人姓名和电话：加粗、上下外边距 */
.address-name {
  font-weight: bold;                    /* 加粗显示 */
  margin-bottom: 5px;                   /* 与下一行间距 */
  margin-top: 25px;                     /* 与顶部（如默认标签）保持距离，避免重叠 */
}

/* 详细地址文字：灰色、小字号、行高 */
.address-detail {
  color: #666;                          /* 灰色文字 */
  font-size: 14px;                      /* 标准字号 */
  line-height: 1.5;                     /* 行高1.5倍，提升可读性 */
}

/* “设为默认”按钮文字样式：灰色、更小字号、上下外边距 */
.address-detail-default {
  color: #666;                          /* 灰色 */
  font-size: 11px;                      /* 更小字号，作为辅助操作 */
  margin: 10px 0 5px 0;                 /* 上10px，下5px，左右0 */
}

/* 地址操作图标（编辑）：绝对定位在右上角、灰色、字号 */
.address-operate {
  position: absolute;                   /* 绝对定位 */
  right: 10px;                          /* 距离右边10px */
  top: 10px;                            /* 距离顶部10px */
  color: #999;                          /* 灰色图标 */
  font-size: 16px;                      /* 图标大小 */
}

/* “添加新地址”按钮区域：固定宽高、虚线边框、圆角、弹性居中、文字色、指针 */
.add-new-address {
  width: 300px;                         /* 与地址卡片同宽 */
  height: 135px;                        /* 与地址卡片同高 */
  border: 2px dashed #e5e5e5;           /* 虚线边框，提示“可添加” */
  border-radius: 4px;                   /* 圆角 */
  display: flex;                        /* 弹性布局 */
  align-items: center;                  /* 垂直居中 */
  justify-content: center;              /* 水平居中 */
  color: #666;                          /* 灰色文字 */
  cursor: pointer;                      /* 鼠标悬停手型 */
}

/* “添加”图标：右边距 */
.add-new-address i {
  margin-right: 5px;                    /* 图标与文字间距 */
}
</style>
