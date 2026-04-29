import Vue from 'vue'
import VueRouter from 'vue-router'

// 解决Vue Router 3.x版本中，频繁点击相同路由导致的控制台报错问题
// 重写push方法，捕获异常并不做处理（避免错误提示）
const originalPush = VueRouter.prototype.push
VueRouter.prototype.push = function push(location) {
  return originalPush.call(this, location).catch(err => err)
}

// 注册路由插件
Vue.use(VueRouter)

// 路由配置数组
const routes = [
  {
    path: '/', // 根路径
    name: 'Manager', // 路由名称
    component: () => import('../views/Manager.vue'), // 懒加载管理员布局组件
    redirect: '/home',  // 访问根路径时自动重定向到首页
    children: [ // 嵌套路由（管理员后台页面）
      { path: '403', name: 'Auth', meta: { name: '无权限' }, component: () => import('../views/manager/Auth.vue') },
      { path: 'home', name: 'Home', meta: { name: '系统首页' }, component: () => import('../views/manager/Home.vue') },
      { path: 'admin', name: 'Admin', meta: { name: '管理员信息' }, component: () => import('../views/manager/Admin.vue') },
      { path: 'shop', name: 'Shop', meta: { name: '商家信息' }, component: () => import('../views/manager/Shop.vue') },
      { path: 'user', name: 'User', meta: { name: '用户信息' }, component: () => import('../views/manager/User.vue') },
      { path: 'person', name: 'Person', meta: { name: '个人信息' }, component: () => import('../views/manager/Person.vue') },
      { path: 'notice', name: 'Notice', meta: { name: '公告信息' }, component: () => import('../views/manager/Notice.vue') },
      { path: 'type', name: 'Type', meta: { name: '类别信息' }, component: () => import('../views/manager/Type.vue') },
      { path: 'goods', name: 'Goods', meta: { name: '商品信息' }, component: () => import('../views/manager/Goods.vue') },
      { path: 'orders', name: 'Orders', meta: { name: '订单信息' }, component: () => import('../views/manager/Orders.vue') },
      { path: 'ordersitem', name: 'Ordersitem', meta: { name: '订单详情信息' }, component: () => import('../views/manager/Ordersitem.vue') },
      { path: 'address', name: 'Address', meta: { name: '地址信息' }, component: () => import('../views/manager/Address.vue') },
      { path: 'collect', name: 'Collect', meta: { name: '收藏信息' }, component: () => import('../views/manager/Collect.vue') },
      { path: 'questions', name: 'Questions', meta: { name: '商品问答信息' }, component: () => import('../views/manager/Questions.vue') },
      { path: 'carousel', name: 'Carousel', meta: { name: '轮播图信息' }, component: () => import('../views/manager/Carousel.vue') },
      { path: 'echarts', name: 'Echarts', meta: { name: '数据统计' }, component: () => import('../views/manager/Echarts.vue') },
    ]
  },
  {
    path: '/front', // 前端用户页面根路径
    name: 'Front', // 路由名称
    component: () => import('../views/front/Front.vue'), // 懒加载前端布局组件
    redirect: '/front/home',  // 访问/front时重定向到前端首页
    children: [ // 嵌套路由（前端用户页面）
      { path: 'home', name: 'Home', meta: { name: '首页信息' }, component: () => import('../views/front/Home.vue') },
      { path: 'goods', name: 'Goods', meta: { name: '商品信息' }, component: () => import('../views/front/Goods.vue') },
      { path: 'goodsDetail', name: 'GoodsDetail', meta: { name: '商品详情信息' }, component: () => import('../views/front/GoodsDetail.vue') },
      { path: 'confirmOrder', name: 'ConfirmOrder', meta: { name: '订单确认信息' }, component: () => import('../views/front/ConfirmOrder.vue') },
      { path: 'cart', name: 'Cart', meta: { name: '购物车信息' }, component: () => import('../views/front/Cart.vue') },
      { path: 'orders', name: 'Orders', meta: { name: '订单信息' }, component: () => import('../views/front/Orders.vue') },
      { path: 'address', name: 'Address', meta: { name: '地址信息' }, component: () => import('../views/front/Address.vue') },
      { path: 'collect', name: 'Collect', meta: { name: '收藏信息' }, component: () => import('../views/front/Collect.vue') },
      { path: 'search', name: 'Search', meta: { name: '商品搜索' }, component: () => import('../views/front/Search.vue') },
      { path: 'shop', name: 'Shop', meta: { name: '店铺信息' }, component: () => import('../views/front/Shop.vue') },
      { path: 'person', name: 'Person', meta: { name: '个人信息' }, component: () => import('../views/front/Person.vue') },
      { path: 'password', name: 'Password', meta: { name: '修改密码' }, component: () => import('../views/front/Password.vue') },
    ]
  },
  { path: '/login', name: 'Login', meta: { name: '登录' }, component: () => import('../views/Login.vue') },
  { path: '/register', name: 'Register', meta: { name: '注册' }, component: () => import('../views/Register.vue') },
  { path: '*', name: '404', meta: { name: '无法访问' }, component: () => import('../views/404.vue') },
]

// 创建路由实例
const router = new VueRouter({
  mode: 'history', // 路由模式：history模式（无#号），需后端配合配置
  base: process.env.BASE_URL, // 应用的基路径，从环境变量获取
  routes // 路由配置
})

// 全局前置守卫（路由跳转前执行）
router.beforeEach((to, from, next) => {
  const user = JSON.parse(localStorage.getItem('user') || '{}')
  if (to.path === '/'){
    if (user.role){
      if (user.role === 'ADMIN' || user.role === 'SHOP'){
        next('/home')
      } else {
        next('/front/home')
      }
    } else {
      next('/login')
    }
  } else {
    if (to.matched.length === 0){
      next('/404')
      return
    } else {
      next()
    }
  }
})

// 导出路由实例
export default router
