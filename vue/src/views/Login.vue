<template>
  <div class="container">
    <div class="content">
      <div class="content-left">
        <img src="@/assets/bg.jpeg">
      </div>

      <div class="content-right">
        <el-form :model="user" :rules="rules" ref="loginRef" class="content-right-form">
          <div class="content-right-form-title">欢迎登录</div>
          <el-form-item prop="username">
            <el-input prefix-icon="el-icon-user" size="medium" placeholder="请输入账号" v-model="user.username"></el-input>
          </el-form-item>
          <el-form-item prop="password">
            <el-input prefix-icon="el-icon-lock" size="medium" show-password placeholder="请输入密码" v-model="user.password"></el-input>
          </el-form-item>
          <el-form-item prop="role">
            <el-select v-model="user.role" placeholder="请选择角色">
              <el-option label="管理员" value="ADMIN"></el-option>
              <el-option label="商家" value="SHOP"></el-option>
              <el-option label="用户" value="USER"></el-option>
            </el-select>
          </el-form-item>
<!--          <el-form-item prop="code">
            <div style="display: flex">
              <el-input placeholder="请输入验证码" prefix-icon="el-icon-circle-check" size="medium" style="flex: 1" v-model="user.code"></el-input>
              <div style="flex: 1; height: 36px">
                <valid-code @update:value="getCode" />
              </div>
            </div>
          </el-form-item>-->
          <el-form-item>
            <el-button type="primary" @click="login">登 录</el-button>
          </el-form-item>

          <div class="links">
            <a href="#" @click.prevent="handleForgetPass">找回密码</a> |
            <a href="/register">注册账号</a>
          </div>

          <div class="tip">
            * 温馨提示：建议使用谷歌、Microsoft Edge，版本 80 及以上浏览器，360浏览器请使用极速模式
          </div>

          <div class="divider">
            <span>或</span>
          </div>

          <div class="social-login">
            <el-button type="info" plain size="small" @click="otherLogin">
              <i class="el-icon-search"></i> 企微
            </el-button>
            <el-button type="info" plain size="small" @click="otherLogin">
              <i class="el-icon-message"></i> 钉钉
            </el-button>
          </div>
        </el-form>
      </div>
    </div>

    <el-dialog title="忘记密码" :visible.sync="forgetPassDialogVis" width="30%">
      <el-form :model="forgetUserForm" label-width="80px">
        <el-form-item label="用户名">
          <el-input v-model="forgetUserForm.username" autocomplete="off" placeholder="请输入用户名"></el-input>
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="forgetUserForm.phone" autocomplete="off" placeholder="请输入手机号"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="forgetPassDialogVis = false">取 消</el-button>
        <el-button type="primary" @click="resetPassword">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import ValidCode from "@/conponents/ValidCode";

export default {
  name: "Login",
  components: {
    ValidCode
  },
  data() {

    // 验证码校验
    const validateCode = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请输入验证码'))
      } else if (value.toLowerCase() !== this.code) {
        callback(new Error('验证码错误'))
      } else {
        callback()
      }
    }

    return {
      forgetUserForm: {},   // 忘记密码的表单数据
      forgetPassDialogVis: false,
      code: '',  // 验证码组件传递过来的code
      user: {
        code: '',   // 表单里用户输入的code 验证码
        username: '',
        password: ''
      },
      rules: {
        username: [
          { required: true, message: '请输入账号', trigger: 'blur' },
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
        ],
        role: [
          { required: true, message: '请选择角色', trigger: 'blur' },
        ],
        // code: [
        //   { validator: validateCode, trigger: 'blur' }
        // ],
      }
    }
  },
  created() {

  },
  methods: {
    otherLogin(){
      this.$notify.warning({title:'警告',message: '功能未开发', showClose: true, duration: 2000});
    },
    handleForgetPass() {   //  初始化表单的数据
      this.forgetUserForm = {}
      this.forgetPassDialogVis = true
    },
    resetPassword() {
      this.$request.put('/password', this.forgetUserForm).then(res => {
        if (res.code === '200') {
          this.$message.success('重置成功')
          this.forgetPassDialogVis = false
        } else {
          this.$notify.error({title: '成功', message: res.msg, showClose: false, duration: 2000});
        }
      })
    },
    getCode(code) {
      this.code = code.toLowerCase()
    },
    login() {
      this.$refs['loginRef'].validate((valid) => {
        if (valid) {
          // 验证通过
          this.$request.post('/login', this.user).then(res => {
            if (res.code === '200') {
              if (this.user.role === 'ADMIN' || this.user.role === 'SHOP'){
                localStorage.setItem("user", JSON.stringify(res.data))  // 存储用户数据
                this.$router.push('/home')
              } else {
                localStorage.setItem("user", JSON.stringify(res.data))  // 存储用户数据
                this.$router.push('/front/home')
              }
              this.$notify.success({title: '成功', message: '登录成功', showClose: false, duration: 1000});
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
/* ==================== 🌍 全局容器：登录页背景与居中布局 ==================== */
.container {
  height: 100vh;                    /* 占满整个视口高度 */
  background-color: rgba(238, 247, 242); /* 浅绿色底色，营造清新氛围 */
  background-image: url("@/assets/texture.png"); /* 添加细腻纹理，增强设计层次 */
  background-repeat: repeat;        /* 确保纹理平铺不缺失 */
  overflow: hidden;                 /* 防止子元素溢出导致滚动条 */
  display: flex;                    /* 使用 Flex 实现垂直水平居中 */
  align-items: center;              /* 垂直居中对齐内容 */
  justify-content: center;          /* 水平居中对齐内容 */
  color: #666;                      /* 默认文字颜色，统一视觉基调 */
}

/* ==================== 📦 主内容区域：左右分栏容器 ==================== */
.content {
  display: flex;                    /* 左右两栏横向布局 */
  background-color: white;          /* 白色背景，突出登录表单主体 */
  width: 50%;                       /* 控制整体宽度，适配主流屏幕 */
  border-radius: 5px;               /* 圆角边框，提升现代感与柔和度 */
  overflow: hidden;                 /* 防止子元素（如图片）超出圆角范围 */
}

/* ==================== 🖼️ 左侧背景图区域：占 60% 宽度 ==================== */
.content-left {
  flex: 1;                          /* 占据左侧空间比例（配合 content-right 的 40%） */
  height: 500px;                    /* 固定高度，匹配设计稿尺寸 */
  width: 60%;                       /* 明确宽度占比，确保布局稳定 */
}

.content-left img {
  width: 100%;                      /* 图片拉伸填满容器宽度 */
  height: 100%;                     /* 图片拉伸填满容器高度 */
  object-fit: cover;                /* 保持原始比例裁剪，避免变形 */
}

/* ==================== 📝 右侧登录表单区域：居中对齐容器 ==================== */
.content-right {
  display: flex;                    /* 内部使用 Flex 布局 */
  align-items: center;              /* 垂直居中对齐表单内容 */
  justify-content: center;          /* 水平居中对齐表单内容 */
  width: 40%;                       /* 固定宽度占比，与左侧形成视觉平衡 */
}

/* ==================== 📐 登录表单内部容器：控制表单宽度 ==================== */
.content-right-form {
  width: 80%;                       /* 表单在右侧区域内居中显示，留出两侧间距 */
}

/* ==================== 🎯 登录标题：欢迎语样式 ==================== */
.content-right-form-title {
  font-size: 20px;                  /* 标题字号 */
  font-weight: bold;                /* 加粗强调 */
  text-align: center;               /* 居中对齐 */
  margin-bottom: 40px;              /* 下边距，与表单项形成呼吸空间 */
  color: rgba(53, 139, 255, 1);         /* 主题蓝灰色，传递专业与信任感 */
}

/* ==================== 🔗 底部链接区：找回密码 & 注册 ==================== */
.links {
  display: flex;                    /* 横向排列两个链接 */
  justify-content: right;           /* 右对齐，符合阅读习惯 */
  margin: 20px 0;                   /* 上下留白 */
  font-size: 14px;                  /* 小字号，弱化处理 */
  color: rgba(53, 139, 255, 1);                   /* 蓝色链接，符合 Element UI 主题 */
}

.links a {
  margin: 0 10px;                   /* 链接之间留出间距 */
  text-decoration: none;            /* 去除默认下划线 */
  color: rgba(53, 139, 255, 1);                   /* 统一链接颜色 */
}

.links a:hover {
  text-decoration: underline;       /* 悬停时显示下划线，增强交互反馈 */
}

/* ==================== 💬 温馨提示文本：低优先级提示信息 ==================== */
.tip {
  font-size: 12px;                  /* 小字号，降低视觉权重 */
  color: #999;                      /* 灰色文字，不喧宾夺主 */
  text-align: left;                 /* 左对齐，符合阅读流 */
  margin: 15px 0;                   /* 上下留白 */
}

/* ==================== ➖ 分隔线：中间“或”字装饰线 ==================== */
.divider {
  width: 100%;                      /* 占满父容器 */
  display: flex;                    /* 居中对齐 span */
  justify-content: center;          /* 水平居中 */
  align-items: center;              /* 垂直居中 */
  margin: 20px 0;                   /* 上下间距 */
  position: relative;               /* 为伪元素定位提供参考点 */
}

.divider::before {
  content: '';                      /* 生成左侧水平线 */
  position: absolute;               /* 脱离文档流 */
  width: 50%;                       /* 占据左半部分宽度 */
  height: 1px;                      /* 线条高度 */
  background-color: #ddd;           /* 灰色线条，低调不抢眼 */
  top: 50%;                         /* 定位到垂直中心 */
  transform: translateY(-50%);      /* 抬升 50%，精准居中 */
}

.divider::after {
  content: '';                      /* 生成右侧水平线 */
  position: absolute;               /* 脱离文档流 */
  width: 50%;                       /* 占据右半部分宽度 */
  height: 1px;                      /* 线条高度 */
  background-color: #ddd;           /* 灰色线条，低调不抢眼 */
  top: 50%;                         /* 定位到垂直中心 */
  transform: translateY(-50%);      /* 抬升 50%，精准居中 */
}

.divider span {
  position: relative;               /* 提升层级，覆盖线条 */
  padding: 0 15px;                  /* 左右留白，避免文字贴边 */
  color: #999;                      /* 灰色文字，与线条同色系 */
  font-size: 14px;                  /* 与线条协调 */
  background-color: white;          /* 覆盖背景，防止线条穿透 */
}

/* ==================== 🤝 社交登录按钮组：企微 & 钉钉 ==================== */
.social-login {
  display: flex;                    /* 横向排列两个按钮 */
  gap: 15px;                        /* 按钮间间距 */
  margin-top: 20px;                 /* 上边距，与分隔线形成层次 */
}

.social-login .el-button {
  width: 50%;                       /* 每个按钮占父容器一半宽度 */
  padding: 8px 16px;                /* 内边距控制按钮大小 */
  border-radius: 6px;               /* 圆角按钮，现代风格 */
  font-size: 14px;                  /* 字号适中，易读 */
}

/* ==================== 🚀 登录按钮：主操作按钮样式 ==================== */
.el-form-item .el-button {
  width: 100%;                      /* 按钮撑满表单项 */
  background: linear-gradient(90deg, rgba(53, 139, 255, 1)  0%, rgba(77, 179, 254, 1) 100%); /* 自定义主题蓝灰 */
  color: white;                     /* 白色文字，高对比度 */
  border: none;                     /* 移除默认边框 */
  font-size: 16px;                  /* 字号适中，易读 */
}

.el-form-item .el-button:hover {
  background-color: #72a1c2;        /* 悬停变色，增强交互反馈 */
}

/* ==================== 📋 角色选择框：下拉菜单宽度控制 ==================== */
.el-form-item .el-select {
  width: 100%;                      /* 下拉框占满表单项，保持对齐 */
}

/* ==================== 📄 忘记密码弹窗内表单：内边距优化 ==================== */
.el-dialog .el-form {
  padding-right: 20px;              /* 右内边距，避免内容紧贴边缘 */
}
</style>
