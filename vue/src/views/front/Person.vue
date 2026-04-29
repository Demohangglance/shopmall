<template>
  <!-- 外层容器：用于居中 -->
  <div class="form-container">
    <el-card class="form-card">
      <div class="card-header">个人信息</div>

      <el-form :model="user" label-width="80px" class="user-form">
        <!-- 头像上传区域 -->
        <div class="avatar-section">
          <el-upload
              class="avatar-uploader"
              action="http://localhost:9999/file/upload"
              :headers="{ token: user.token }"
              :show-file-list="false"
              :on-success="handleAvatarSuccess"
          >
            <img v-if="user.avatar" :src="user.avatar" class="avatar" />
            <i v-else class="el-icon-plus avatar-uploader-icon"></i>
          </el-upload>
        </div>

        <!-- 表单项 -->
        <el-form-item label="用户名" prop="username">
          <el-input v-model="user.username" placeholder="用户名" disabled />
        </el-form-item>
        <el-form-item label="姓名" prop="name">
          <el-input v-model="user.name" placeholder="姓名" />
        </el-form-item>
        <el-form-item label="电话" prop="phone">
          <el-input v-model="user.phone" placeholder="电话" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="user.email" placeholder="邮箱" />
        </el-form-item>
        <el-form-item label="地址" prop="address">
          <el-input type="textarea" v-model="user.address" placeholder="地址" />
        </el-form-item>
        <el-form-item label="性别" prop="sex">
          <el-radio v-model="user.sex" label="男">男</el-radio>
          <el-radio v-model="user.sex" label="女">女</el-radio>
        </el-form-item>
        <el-form-item label="年龄" prop="age">
          <el-input v-model="user.age" placeholder="年龄" />
        </el-form-item>
        <el-form-item label="个人介绍" prop="infos">
          <el-input type="textarea" v-model="user.infos" placeholder="个人介绍" />
        </el-form-item>
        <el-form-item label="账户余额" prop="account">
          <el-link type="primary" disabled>{{user.account}}</el-link>
        </el-form-item>
        <!-- 操作按钮组 -->
        <div class="form-actions">
          <el-button type="primary" @click="update">保 存</el-button>
          <el-button type="success" @click="$router.push('/front/password')">修改密码</el-button>
          <el-button type="primary" @click="handleOpen" class="custom-recharge-btn">充值</el-button>
        </div>
      </el-form>
    </el-card>

    <el-dialog title="信息" :visible.sync="dialogFormVisible" width="30%" :close-on-click-modal="false">
      <el-form label-width="100px" style="padding-right: 40px" :model="form" ref="ruleForm">
        <el-form-item prop="account" label="金额">
          <el-input v-model="form.account" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item prop="type" label="支付方式">
          <el-radio-group v-model="form.type" size="small">
            <el-radio-button label="微信支付"></el-radio-button>
            <el-radio-button label="支付宝支付"></el-radio-button>
          </el-radio-group>
        </el-form-item>

      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="account">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "Person",
  data() {
    return {
      user: JSON.parse(localStorage.getItem('user') || '{}'),
      dialogFormVisible: false,
      form: {
        account: 0,
        type: '微信支付'
      }
    }
  },
  methods: {
    update() {
      this.$request.put('/user/update', this.user).then(res => {
        if (res.code === '200') {
          this.$message.success('保存成功')
          localStorage.setItem('user', JSON.stringify(this.user))
          this.$emit('update:user', this.user)
        } else {
          this.$notify.error({title: '成功', message: res.msg, showClose: false, duration: 2000});
        }
      })
    },
    handleAvatarSuccess(response) {
      this.user.avatar = response.data
    },
    handleOpen(){
      this.dialogFormVisible = true
    },
    account() {
      this.user.account = Number(this.user.account) + Number(this.form.account)
      this.$request.put('/user/update', this.user).then(res => {
        if (res.code === '200') {
          this.$notify.success({title: '成功', message: '充值成功', showClose: false, duration: 2000});
          localStorage.setItem('user', JSON.stringify(this.user))
          this.$emit('update:user', this.user)
          this.dialogFormVisible = false
        } else {
          this.$notify.error({title: '成功', message: res.msg, showClose: false, duration: 2000});
        }
      })
    },
  }
}
</script>

<style scoped>
/* 外层容器：全屏居中 */
.form-container {
  display: flex;                            /* 弹性布局 */
  justify-content: center;                  /* 水平居中 */
  padding: 20px;                            /* 内边距 */
  box-sizing: border-box;                   /* 包含边框和内边距计算 */
}

/* 卡片容器：限制最大宽度，圆角阴影，响应式缩放 */
.form-card {
  width: 100%;                              /* 默认占满 */
  max-width: 1000px;                         /* 最大宽度600px */
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); /* 柔和阴影 */
  border-radius: 12px;                      /* 圆角 */
  transition: box-shadow 0.3s ease;         /* 阴影过渡 */
}

/* 卡片标题样式 - 增强视觉层次感 */
.card-header {
  font-size: 18px;            /* 标题字体大小18px */
  font-weight: 600;           /* 半粗体，突出标题 */
  color: #303133;             /* 深灰色文字，清晰可见 */
  padding: 16px 20px;         /* 内边距，控制标题区域大小 */
  border-bottom: 1px solid #f0f0f0; /* 底部边框，分隔标题与内容 */
  background-color: #fff;     /* 白色背景，与内容区一致 */
}

.form-card:hover {
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15); /* 悬停加深阴影 */
}

/* 表单容器：内边距控制 */
.user-form {
  padding: 20px 30px;                       /* 内边距，左右留白 */
}

/* 头像上传区域：居中 */
.avatar-section {
  text-align: center;                       /* 文字/元素居中 */
  margin: 20px 0;                           /* 上下外边距 */
}

/* 表单项标签加粗 */
:deep(.el-form-item__label) {
  font-weight: bold;                        /* 加粗标签 */
  color: #333;                              /* 深灰文字 */
}

/* 上传区域容器样式 */
:deep(.avatar-uploader .el-upload) {
  border: 1px dashed #d9d9d9;               /* 虚线边框 */
  cursor: pointer;                          /* 手型光标 */
  position: relative;                       /* 相对定位 */
  overflow: hidden;                         /* 隐藏溢出 */
  border-radius: 50%;                       /* 圆形 */
  width: 178px;                             /* 固定宽度 */
  height: 178px;                            /* 固定高度 */
  display: inline-block;                    /* 行内块，便于居中 */
  line-height: 178px;                       /* 垂直居中图标 */
  text-align: center;                       /* 水平居中 */
  transition: border-color 0.3s;            /* 边框色过渡 */
}

/* 默认上传图标样式 */
.avatar-uploader-icon {
  font-size: 28px;                          /* 图标大小 */
  color: #8c939d;                           /* 灰色图标 */
  width: 178px;                             /* 与容器同宽 */
  height: 178px;                            /* 与容器同高 */
  line-height: 178px;                       /* 垂直居中 */
  text-align: center;                       /* 水平居中 */
  border-radius: 50%;                       /* 圆形 */
  background-color: #f8f8f8;                /* 浅灰背景 */
}

/* 已上传头像样式 */
.avatar {
  width: 178px;                             /* 固定宽度 */
  height: 178px;                            /* 固定高度 */
  display: block;                           /* 块级元素 */
  border-radius: 50%;                       /* 圆形 */
  object-fit: cover;                        /* 裁剪填充 */
  transition: transform 0.3s ease;          /* 缩放过渡 */
}

/* 头像悬停轻微放大 */
.avatar:hover {
  transform: scale(1.05);                   /* 放大5% */
}

/* 操作按钮组：居中 + 间距 */
.form-actions {
  text-align: center;                       /* 按钮居中 */
  margin-top: 30px;                         /* 与表单间距 */
}

.form-actions .el-button {
  margin: 0 10px;                           /* 按钮左右间距 */
  min-width: 100px;                         /* 最小宽度 */
}

/* 自定义充值按钮样式 */
.custom-recharge-btn {
  background-color: #edbf37 !important;     /* 基础背景色 */
  border-color: #edbf37 !important;         /* 去掉默认边框 */
}

/* 悬停状态样式 */
.custom-recharge-btn:hover {
  background-color: #f4d782 !important;      /* 基础背景色 */
  border-color: #edbf37 !important;          /* 去掉默认边框 */
}
</style>
