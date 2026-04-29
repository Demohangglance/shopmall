<template>
  <div id="app">
    <!-- 顶部导航 -->
    <div class="top-nav">
      <div class="top-nav-content">
        <div class="top-nav-left"><i class="el-icon-bell" style="margin-right: 2px"></i>公告：<span v-html="top"></span></div>
        <div class="top-nav-right" v-if="!user.username">
          <a href="/login">亲，请登录</a>
          <a href="/register">免费注册</a>
        </div>
      </div>
    </div>
    <!--头部-->
    <div style="box-shadow: 0 2px 4px rgba(0,0,0,.08)">
      <div class="front-header">
        <a href="/front/home">
          <div class="front-header-left">
            <img src="@/assets/logo.svg" alt="">
            <div class="title">京东超市购物商城</div>
          </div>
        </a>
        <div class="front-header-center">
          <div class="search-box">
            <input v-model="name" type="text" placeholder="搜索商品..." class="search-input" @keyup.enter="search"/>
            <el-button class="search-btn" @click="search" style="background-color: #f59300; border-color: #f59300; color: #fff">
              <i class="search-icon">🔍</i>
            </el-button>
          </div>
        </div>
        <div class="front-header-right">
<!--          <div v-if="!user.username">
            <el-button @click="$router.push('/login')">登录</el-button>
            <el-button @click="$router.push('/register')">注册</el-button>
          </div>-->
          <div v-if="user.username">
            <el-dropdown>
              <div class="front-header-dropdown">
                <img :src="user.avatar" alt="">
              </div>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item>
                  <div style="color: #333">{{user.name}}</div>
                </el-dropdown-item>
                <el-dropdown-item>
                  <a style="color: #333" href="/front/person"><div>个人信息</div></a>
                </el-dropdown-item>
                <el-dropdown-item>
                  <div @click="logout">退出</div>
                </el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </div>
        </div>
      </div>
    </div>

    <!--主体-->
    <div class="main-body">
      <router-view ref="child" @update:user="updateUser" />
    </div>

    <div class="right-side-card">
      <div class="card-item" v-for="(item, index) in menuList" :key="index" @mouseenter="handleMouseEnter(index)" @mouseleave="handleMouseLeave(index)" @click="goDetail(item.path)">
        <img :src="item.icon" alt="icon" class="item-icon" />
        <span class="item-text">{{ item.text }}</span>
      </div>
    </div>

    <!-- 底部 -->
    <Footer />
  </div>
</template>

<script>

import Footer from "@/conponents/Footer.vue";

export default {
  name: "FrontLayout",
  components: {Footer},
  data () {
    return {
      name: this.$route.query.name || '',
      top: '',
      notice: [],
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {},
      menuList: [
        {icon: require('@/assets/首页icon.png'), text: "首页", isHover: false, path: '/front/home'},
        {icon: require('@/assets/购物车icon.png'), text: "购物车", isHover: false, path: '/front/cart'},
        {icon: require('@/assets/订单icon.png'), text: "我的订单", isHover: false, path: '/front/orders'},
        {icon: require('@/assets/地址icon.png'), text: "我的地址", isHover: false, path: '/front/address'},
        {icon: require('@/assets/收藏icon.png'), text: "我的收藏", isHover: false, path: '/front/collect'},
      ],
    }
  },
  created() {
    this.loadNotice()
  },
  methods: {
    goDetail(path) {
      location.href = path
    },
    handleMouseEnter(index) {
      this.menuList[index].isHover = true;
    },
    handleMouseLeave(index) {
      this.menuList[index].isHover = false;
    },
    search() {
      location.href = '/front/search?name=' + this.name
    },
    loadNotice() {
      this.$request.get('/notice').then(res => {
        this.notice = res.data
        let i = 0
        if (this.notice && this.notice.length) {
          this.top = this.notice[0].name
          setInterval(() => {
            this.top = this.notice[i].name
            i++
            if (i === this.notice.length) {
              i = 0
            }
          }, 2500)
        }
      })
    },
    updateUser() {
      this.user = JSON.parse(localStorage.getItem('user') || '{}')   // 重新获取下用户的最新信息
    },
    // 退出登录
    logout() {
      localStorage.removeItem("user");
      location.href = '/front/home'
    }
  }
}
</script>

<style scoped>
/* 全局引入基础样式 */
@import "@/assets/css/front.css";

/* 顶部导航条容器 */
.top-nav {
  background-color: #f5f5f5;           /* 浅灰色背景 */
  height: 36px;                        /* 固定高度 */
  line-height: 36px;                   /* 文字垂直居中 */
  font-size: 12px;                     /* 小字号，适合辅助信息 */
  border-bottom: 1px solid #eee;       /* 底部细边框，与主体分隔 */
}

/* 顶部导航内容区：限制宽度并水平居中 */
.top-nav-content {
  width: 90%;                       /* 固定宽度 */
  margin: 0 auto;                      /* 水平居中 */
  display: flex;                       /* 弹性布局 */
  justify-content: space-between;      /* 左右两端对齐 */
  padding-left: 30px;
}

/* 顶部导航左侧/右侧链接通用样式 */
.top-nav-left a,
.top-nav-right a {
  color: #6c6c6c;                      /* 灰色文字 */
  text-decoration: none;               /* 去掉下划线 */
  margin-right: 15px;                  /* 链接间距 */
}

/* 顶部导航链接悬停效果 */
.top-nav-left a:hover,
.top-nav-right a:hover {
  color: #ff4400;                      /* 京东红，增强交互 */
}

/* ==================== 右侧悬浮功能卡片 ==================== */
/* 固定在右侧中部的悬浮卡片容器 */
.right-side-card {
  position: fixed;                     /* 固定定位 */
  right: 20px;                         /* 距离右侧20px */
  top: 50%;                            /* 顶部50%，配合transform垂直居中 */
  transform: translateY(-50%);         /* 垂直居中修正 */
  display: flex;                       /* 弹性布局（竖向） */
  flex-direction: column;              /* 子项竖向排列 */
  align-items: center;                 /* 子项水平居中 */
  background-color: #fff;              /* 白色背景 */
  border: 1px solid #ebeef5;           /* 浅色边框 */
  border-radius: 12px;                 /* 大圆角，更柔和 */
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08); /* 柔和阴影，提升立体感 */
  padding: 12px 8px;                   /* 内边距 */
}

/* 单个功能卡片项 */
.card-item {
  display: flex;                       /* 弹性布局（竖向） */
  flex-direction: column;              /* 图标+文字竖向排列 */
  align-items: center;                 /* 内容水平居中 */
  width: 48px;                         /* 固定宽度 */
  margin-bottom: 6px;                  /* 卡片间距 */
  cursor: pointer;                     /* 鼠标悬停手型 */
  transition: all 0.2s ease;           /* 平滑过渡动画 */
  border-radius: 8px;                  /* 内部圆角 */
  padding: 8px 0;                      /* 上下内边距 */
}

/* 最后一个卡片项，移除下边距 */
.card-item:last-child {
  margin-bottom: 0;
}

/* 功能卡片悬停或激活状态 */
.card-item:hover,
.card-item.is-hover {
  background-color: #f5f5f5;           /* 浅灰背景，表示可交互 */
}

/* 功能卡片图标样式 */
.item-icon {
  width: 24px;                         /* 图标宽度 */
  height: 24px;                        /* 图标高度 */
  margin-bottom: 4px;                  /* 与文字间距 */
}

/* 功能卡片文字样式 */
.item-text {
  font-size: 12px;                     /* 小字号 */
  color: #333;                         /* 深灰文字 */
  line-height: 1;                      /* 行高紧凑 */
}

/* ==================== 搜索框区域 ==================== */
/* 搜索框容器（虽然模板中未直接使用此class，保留以备扩展） */
search-box {
  display: flex;                       /* 弹性布局 */
  margin-bottom: 20px;                 /* 下边距 */
  max-width: 600px;                    /* 最大宽度限制 */
}

/* 搜索输入框 */
.search-input {
  flex: 1;                             /* 占据剩余空间 */
  padding: 14px 20px;                  /* 内边距 */
  border: none;                        /* 无边框 */
  border-radius: 25px 0 0 25px;        /* 左侧大圆角 */
  font-size: 16px;                     /* 字号 */
  outline: none;                       /* 去掉焦点框 */
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); /* 轻微阴影 */
}

/* 搜索按钮 */
.search-btn {
  padding: 14px 25px;                  /* 内边距 */
  background: #ff6b35;                 /* 京东红背景 */
  color: white;                        /* 白字 */
  border: none;                        /* 无边框 */
  border-radius: 0 25px 25px 0;        /* 右侧大圆角 */
  cursor: pointer;                     /* 手型光标 */
  transition: background 0.3s;         /* 背景色平滑过渡 */
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); /* 轻微阴影 */
}

/* 搜索按钮悬停效果 */
.search-btn:hover {
  background: #e55a2b;                 /* 稍暗红色，增强反馈 */
}

/* 搜索图标样式 */
.search-icon {
  font-size: 18px;                     /* 图标大小 */
}
</style>
