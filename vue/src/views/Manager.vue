<template>
  <div class="manager-container">
    <!--  头部  -->
    <div class="manager-header">
      <div class="manager-header-left clickable" @click="$router.push('/home')">
        <img src="@/assets/logo.svg" />
        <div class="title">后台管理系统</div>
      </div>

      <div class="manager-header-center">
        <el-breadcrumb separator-class="el-icon-arrow-right">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item :to="{ path: $route.path }">{{ $route.meta.name }}</el-breadcrumb-item>
        </el-breadcrumb>
      </div>

      <div class="manager-header-right">
        <el-dropdown placement="bottom">
          <div class="avatar">
            <img :src="user.avatar || 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'" />
            <div style="cursor: pointer;font-weight: bold">{{ user.name ||  '管理员' }}<!--<i class="el-icon-arrow-down" style="margin-left: 5px"></i>--></div>
          </div>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item @click.native="$router.push('/person')">个人信息</el-dropdown-item>
            <el-dropdown-item @click.native="logout">退出登录</el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </div>
    </div>

    <!--  主体  -->
    <div class="manager-main">
      <!--  侧边栏  -->
      <div class="manager-main-left">
        <el-menu :default-openeds="['info', 'user', 'system']" router style="border: none" :default-active="$route.path">
          <el-menu-item index="/home">
            <i class="el-icon-s-home"></i>
            <span slot="title">首页</span>
          </el-menu-item>
          <el-menu-item index="/echarts" v-if="user.role === 'ADMIN'">
            <i class="el-icon-s-marketing"></i>
            <span slot="title">数据统计</span>
          </el-menu-item>
          <el-submenu index="user" v-if="user.role === 'ADMIN'">
            <template slot="title">
              <i class="el-icon-s-custom"></i>
              <span>用户管理</span>
            </template>
            <el-menu-item index="/admin"><i class="el-icon-user-solid"></i><span>管理员信息</span></el-menu-item>
            <el-menu-item index="/shop"><i class="el-icon-user"></i><span>商家信息</span></el-menu-item>
            <el-menu-item index="/user"><i class="el-icon-user"></i><span>用户信息</span></el-menu-item>
          </el-submenu>
          <el-submenu index="info">
            <template slot="title">
              <i class="el-icon-s-data"></i><span>信息管理</span>
            </template>
            <el-menu-item index="/notice" v-if="user.role === 'ADMIN'"><i class="el-icon-menu"></i><span>公告信息</span></el-menu-item>
            <el-menu-item index="/type" v-if="user.role === 'ADMIN'"><i class="el-icon-menu"></i><span>商品分类信息</span></el-menu-item>
            <el-menu-item index="/goods"><i class="el-icon-menu"></i><span>商品信息</span></el-menu-item>
            <el-menu-item index="/orders"><i class="el-icon-menu"></i><span>订单信息</span></el-menu-item>
            <el-menu-item index="/questions" v-if="user.role === 'ADMIN'"><i class="el-icon-menu"></i><span>商品问答信息</span></el-menu-item>
            <el-menu-item index="/collect" v-if="user.role === 'ADMIN'"><i class="el-icon-menu"></i><span>收藏信息</span></el-menu-item>
            <el-menu-item index="/address" v-if="user.role === 'ADMIN'"><i class="el-icon-menu"></i><span>地址信息</span></el-menu-item>
            <el-menu-item index="/carousel" v-if="user.role === 'ADMIN'"><i class="el-icon-menu"></i><span>轮播图信息</span></el-menu-item>
          </el-submenu>
          <el-submenu index="system">
            <template slot="title">
              <i class="el-icon-s-tools"></i>
              <span>系统管理</span>
            </template>
            <el-menu-item index="/person">
              <i class="el-icon-s-custom"></i>
              <span slot="title">个人信息</span>
            </el-menu-item>
          </el-submenu>
        </el-menu>
      </div>

      <!--  数据表格  -->
      <div class="manager-main-right">
        <router-view @update:user="updateUser" />
      </div>
    </div>
  </div>
</template>
<script>

export default {
  name: 'HomeView',
  data() {
    return {
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {},
    }
  },
  // mounted() {   // 页面加载完成之后触发
  //   if (!this.user.id) {   // 当前的浏览器没有用户信息
  //     this.$router.push('/login')
  //   }
  // },
  methods: {
    updateUser(user) {   // 获取子组件传过来的数据  更新当前页面的数据
      this.user = JSON.parse(JSON.stringify(user))  // 让父级的对象跟子级的对象毫无关联
    },
    logout() {
      localStorage.removeItem('user')  // 清除当前的token和用户数据
      this.$router.push('/login')
    },
  }
}
</script>

<style>
@import "@/assets/css/manager.css";

/* 手型光标 */
.clickable {
  cursor: pointer;
}
</style>
