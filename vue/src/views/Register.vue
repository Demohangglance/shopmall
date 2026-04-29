<template>
  <div class="container">
    <div class="content">
      <div class="content-left">
        <img src="@/assets/bg.jpeg" >
      </div>
      <div class="content-right">
        <el-form :model="user" class="content-right-form" :rules="rules" ref="registerRef">
          <div class="content-right-form-title">欢迎注册</div>
          <el-form-item prop="username">
            <el-input prefix-icon="el-icon-user" size="medium" placeholder="请输入账号" v-model="user.username"></el-input>
          </el-form-item>
          <el-form-item prop="password">
            <el-input prefix-icon="el-icon-lock" size="medium" show-password placeholder="请输入密码" v-model="user.password"></el-input>
          </el-form-item>
          <el-form-item prop="confirmPass">
            <el-input prefix-icon="el-icon-lock" size="medium" show-password placeholder="请确认密码" v-model="user.confirmPass"></el-input>
          </el-form-item>
          <el-form-item prop="role">
            <el-select v-model="user.role" placeholder="请选择角色">
              <el-option label="商家" value="SHOP"></el-option>
              <el-option label="用户" value="USER"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="info" @click="register">注 册</el-button>
          </el-form-item>
          <div class="links">
            <a href="/login">返回登录</a>
          </div>
          <div class="tip">
            * 温馨提示：建议使用谷歌、Microsoft Edge，版本 80 及以上浏览器，360浏览器请使用极速模式
          </div>
        </el-form>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: "Register",
  data() {
    // 验证码校验
    const validatePassword = (rule, confirmPass, callback) => {
      if (confirmPass === '') {
        callback(new Error('请确认密码'))
      } else if (confirmPass !== this.user.password) {
        callback(new Error('两次输入的密码不一致'))
      } else {
        callback()
      }
    }
    return {
      user: {
        username: '',
        password: '',
        confirmPass: ''
      },
      rules: {
        username: [
          { required: true, message: '请输入账号', trigger: 'blur' },
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
        ],
        confirmPass: [
          { validator: validatePassword, trigger: 'blur' }
        ],
        role: [
          { required: true, message: '请选择角色', trigger: 'blur' },
        ],
      }
    }
  },
  created() {

  },
  methods: {
    register() {
      this.$refs['registerRef'].validate((valid) => {
        if (valid) {
          // 验证通过
          this.$request.post('/register', this.user).then(res => {
            if (res.code === '200') {
              this.$router.push('/login')
              this.$notify.success({title: '成功', message: '注册成功', showClose: false, duration: 2000});
            } else {
              this.$notify.error({message: res.msg, showClose: false, duration: 2000});
            }
          })
        }
      })
    }
  }
}
</script>


<style scoped>
/* 整体容器：全屏居中布局，背景纹理 + 柔和色调 */
.container {
  height: 100vh;                    /* 占满视口高度 */
  background-image: url("@/assets/texture.png"); /* 纹理背景图，增强视觉层次 */
  background-color: rgba(238, 247, 242); /* 浅绿底色，柔和不刺眼 */
  overflow: hidden;                 /* 防止内容溢出产生滚动条 */
  display: flex;                    /* 使用 Flex 布局 */
  align-items: center;              /* 垂直居中 */
  justify-content: center;          /* 水平居中 */
  color: #666;                      /* 默认文字颜色：深灰，保持低调质感 */
}

/* 内容区域：左右两栏主体容器（白底圆角） */
.content {
  display: flex;                    /* 子元素水平排列 */
  width: 50%;                       /* 宽度适中，避免过宽压迫感 */
  background-color: white;          /* 白色背景，突出表单区域 */
  border-radius: 5px;               /* 圆角设计，提升现代感 */
  overflow: hidden;                 /* 避免子元素超出圆角边界 */
}

/* 左侧图片区：背景视觉主图 */
.content-left {
  flex: 1;                          /* 占据剩余空间，自适应宽度 */
  height: 500px;                    /* 固定高度，确保图片完整展示 */
}

.content-left img {
  width: 100%;                      /* 图片拉伸填满容器 */
  height: 100%;                     /* 同步高度 */
  object-fit: cover;                /* 关键：保持比例裁剪，避免变形 */
}

/* 右侧表单区：注册表单容器（居中对齐） */
.content-right {
  display: flex;
  align-items: center;              /* 垂直居中内部内容 */
  justify-content: center;          /* 水平居中 */
  width: 40%;                       /* 占比 40%，与左侧形成视觉平衡 */
}

/* 表单主体：控制表单内元素宽度，留白舒适 */
.content-right-form {
  width: 80%;                       /* 表单内容缩进，避免贴边，更优雅 */
}

/* 标题：欢迎注册文字样式 */
.content-right-form-title {
  font-size: 20px;                  /* 大字号，视觉焦点 */
  font-weight: bold;                /* 加粗强调 */
  text-align: center;               /* 居中对齐 */
  margin-bottom: 40px;              /* 下方间距，分离表单项 */
  color: mediumseagreen;         /* 主题色：深棕木色，品牌一致性 */
}

/* 返回链接：登录跳转入口 */
.links {
  display: flex;                    /* 水平排列多个链接 */
  justify-content: flex-end;        /* 👉 右对齐（修正：right → flex-end 更标准） */
  margin: 20px 0;                   /* 上下留白 */
  font-size: 14px;                  /* 小字号，弱化处理 */
  color: mediumseagreen;                   /* Element UI 主题蓝 */
}

.links a {
  margin: 0 10px;                   /* 链接间间距 */
  text-decoration: none;            /* 去除默认下划线 */
  color: mediumseagreen;                   /* 统一蓝色 */
}

.links a:hover {
  text-decoration: underline;       /* 悬停显示下划线，增强交互反馈 */
}

/* 温馨提示：浏览器兼容提示文本 */
.tip {
  font-size: 12px;                  /* 极小字号，不干扰主流程 */
  color: #999;                      /* 灰色辅助信息 */
  text-align: left;                 /* 左对齐，符合阅读习惯 */
  margin: 15px 0;                   /* 上下留白 */
}

/* 表单控件样式定制（Element UI 组件覆盖） */
/* 下拉选择框：强制占满表单项宽度 */
.el-form-item .el-select {
  width: 100%;
}

/* 注册按钮：全宽、主题色、高点击友好性 */
.el-form-item .el-button {
  width: 100%;                      /* 按钮占满父容器，提升点击体验 */
  background: mediumseagreen; /* 自定义主题蓝灰 */
  color: white;                     /* 白色文字，高对比度 */
  border: none;                     /* 去除默认边框 */
  border-radius: 4px;               /* 微圆角，提升质感 */
  padding: 10px;                    /* 增加点击区域 */
  font-size: 16px;                  /* 字号适中，易读 */
}

/* 按钮悬停效果：模拟按下动画 */
.el-form-item .el-button:hover {
  background-color: mediumseagreen !important; /* 深棕，产生按压感 */
  transform: translateY(-1px);      /* 轻微上移，模拟“按下” */
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); /* 微阴影，增加立体感 */
  transition: all 0.2s ease;        /* 平滑过渡动画（强烈建议添加） */
}
</style>
