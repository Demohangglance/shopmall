<template>
  <div>
    <el-row :gutter="24">
<!--      <el-col :span="12">
        <el-card style="margin: 10px 0">
          <div slot="header" style="font-size: 20px;font-weight: bold">
            <span>联系信息</span>
          </div>
          <div>
            <div>欢迎您使用本系统，如果觉着系统对您有帮助，请关注B站Up<span style="color: orangered;font-weight: bold"><a href="https://space.bilibili.com/404015503" target="_blank">叫我阿宸吧</a></span>。</div>
            <div style="margin-top: 10px">
              后续会带来更多优质的系统功能源码分享和项目教学。欢迎小伙伴们提出宝贵的建议。
            </div>
          </div>
          <div style="margin-top: 10px">
            <div>如果您有什么疑问，可以联系我的微信：<span style="color: orangered;font-weight: bold">achen52166_</span></div>
            <div style="margin-top: 10px">
              <el-tag style="font-size: 12px">点击图片放大</el-tag>
            </div>
            <div>
              <el-image
                  style="width: 300px; height: 300px"
                  :src="wechat"
                  :preview-src-list="wechatList">
              </el-image>
            </div>
          </div>
        </el-card>
      </el-col>-->

      <el-col :span="24">
        <el-card style="margin: 10px 0">
          <div style="font-size: 20px;font-weight: bold">大家好，欢迎登录本系统！</div>
        </el-card>
      </el-col>

      <el-col :span="24">
        <el-card style="margin: 10px 0">
          <div style="padding-bottom: 20px;font-size: 20px;font-weight: bold">系统公告</div>
          <el-collapse accordion v-model="activeNames" v-for="(item,index) in notices" :key="index + ''">
            <el-collapse-item :name="index + ''" >
              <template slot="title">
                <span style="font-size: 18px;font-weight: bold;color: orangered">{{ item.name }}</span>
              </template>
              <div v-html="item.content"></div>
            </el-collapse-item>
          </el-collapse>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: "Home",
  data() {
    return {
      user: JSON.parse(localStorage.getItem('user') || '{}'),
      activeNames: "0",
      notices: [],
      wechat: require('../../assets/wechat.png'),
      wechatList: [
        require('../../assets/wechat.png')
      ]
    }
  },
  created() {
    this.$request.get("/notice").then(res => {
      this.notices = res.data?.splice(0, 5)
    })
  },
  methods: {}
}
</script>

<style scoped>
/deep/.el-popover__reference {
  cursor: default;
}
</style>
