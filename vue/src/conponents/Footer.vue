<template>
<!--  <div style="height: 70px; line-height: 30px; color: #666; text-align: center; margin-top: 50px">
    <div>美味分享 · 尽在食味 · 享受这一刻的幸福时光</div>
    <div>食味美食有限公司 备1101312328888号 网文[2014]0774-174号</div>
  </div>-->

  <div class="footer">
    <div class="footer-content">
      <div class="footer-column">
        <h3>购物指南</h3>
        <ul class="footer-links">
          <li><a href="#">购物流程</a></li>
          <li><a href="#">会员介绍</a></li>
          <li><a href="#">生活旅行</a></li>
          <li><a href="#">常见问题</a></li>
        </ul>
      </div>
      <div class="footer-column">
        <h3>配送方式</h3>
        <ul class="footer-links">
          <li><a href="#">免运费政策</a></li>
          <li><a href="#">海外配送</a></li>
          <li><a href="#">EMS</a></li>
          <li><a href="#">211限时达</a></li>
        </ul>
      </div>
      <div class="footer-column">
        <h3>支付方式</h3>
        <ul class="footer-links">
          <li><a href="#">货到付款</a></li>
          <li><a href="#">在线支付</a></li>
          <li><a href="#">分期付款</a></li>
          <li><a href="#">邮局汇款</a></li>
        </ul>
      </div>
      <div class="footer-column">
        <h3>售后服务</h3>
        <ul class="footer-links">
          <li><a href="#">售后政策</a></li>
          <li><a href="#">价格保护</a></li>
          <li><a href="#">退款说明</a></li>
          <li><a href="#">返修/退换货</a></li>
        </ul>
      </div>
    </div>
    <div class="copyright">
      <p>© 2023 购物商城 版权所有 | 京ICP备12345678号</p>
    </div>
  </div>
</template>


<style>
/* 页脚整体样式 */
.footer {
  background-color: #333;          /* 页脚背景色：深灰色 */
  color: #fff;                     /* 页脚默认文字色：白色 */
  padding: 40px 0 20px;            /* 内边距：上下40px、左右0，顶部留白多于底部 */
  margin-top: 20px;                /* 与上方内容间距：20px，避免紧贴内容 */
  flex-shrink: 0;                  /* 弹性布局属性：不压缩，保持自身高度（配合父容器flex使用） */
}

/* 页脚内容容器（控制内部布局） */
.footer-content {
  max-width: 1200px;               /* 内容最大宽度：1200px，避免宽屏时内容过散 */
  margin: 0 auto;                  /* 水平居中：左右自动margin，使容器居页面中间 */
  display: grid;                   /* 使用网格布局 */
  grid-template-columns: repeat(4, 1fr);  /* 网格列：平均分为4列，每列占1份空间 */
  gap: 30px;                       /* 网格间距：列与列之间间隔30px */
}

/* 页脚每列标题样式 */
.footer-column h3 {
  margin-bottom: 20px;             /* 标题下方间距：20px，与下方链接拉开距离 */
  font-size: 18px;                 /* 标题字体大小：18px */
}

/* 页脚链接列表（清除默认样式） */
.footer-links {
  list-style: none;                /* 移除列表默认项目符号（圆点） */
}

/* 链接列表项样式 */
.footer-links li {
  margin-bottom: 10px;             /* 列表项下方间距：10px，链接之间拉开距离 */
}

/* 链接文字基础样式 */
.footer-links a {
  color: #ccc;                     /* 链接默认色：浅灰色（降低视觉冲击） */
  text-decoration: none;           /* 移除链接默认下划线 */
  font-size: 14px;                 /* 链接字体大小：14px */
}

/* 链接鼠标悬停样式 */
.footer-links a:hover {
  color: #fff;                     /* 悬停时文字变白色，增强交互反馈 */
}

/* 版权信息区域样式 */
.copyright {
  text-align: center;              /* 文字居中对齐 */
  padding-top: 30px;               /* 顶部内边距：30px，与上方内容拉开距离 */
  margin-top: 30px;                /* 上方外边距：30px，配合内边距增加留白 */
  border-top: 1px solid #555;      /* 顶部边框：1px实线，颜色#555（区分区域） */
  font-size: 12px;                 /* 版权文字大小：12px（次要信息视觉层级） */
  color: #999;                     /* 版权文字色：深灰色（比链接色更暗） */
}
</style>
