<template>
  <div>
    <!-- 表格内容 -->
    <el-card>
      <div style="margin-bottom: 10px">
        <el-input style="width: 200px;margin: 0 5px" placeholder="查询..." v-model="name"></el-input>
        <el-button type="success" plain @click="load(1)">查询</el-button>
        <el-button type="info" plain @click="reset">重置</el-button>
      </div>
      <el-table :data="tableData" stripe>
        <el-table-column prop="id" label="序号" width="70" align="center" >
          <template slot-scope='scope'>
            <span>{{ (pageNum - 1) * pageSize + (scope.$index + 1) }}</span>
          </template>
        </el-table-column>
        <el-table-column align="center" prop="name" label="收货人"></el-table-column>
        <el-table-column align="center" prop="address" label="收货地址"></el-table-column>
        <el-table-column align="center" prop="phone" label="联系方式"></el-table-column>
        <el-table-column align="center" prop="userid" label="创建人">
          <template slot-scope='scope'>
            {{ users.find(v => v.id == scope.row.userid)?.name}}
          </template>
        </el-table-column>

        <el-table-column label="操作" width="240" align="center">
          <template slot-scope="scope">
            <el-button plain type="success" @click="detail(scope.row)" size="mini">详情</el-button>
            <el-button plain type="danger" size="mini" @click=del(scope.row.id)>删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div style="margin: 10px 0">
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
    </el-card>

    <!-- 新增 | 编辑弹框 -->
    <el-dialog title="信息" :visible.sync="dialogFormVisible" width="30%" :close-on-click-modal="false">
      <el-form label-width="100px" style="padding-right: 40px" :model="form" :rules="rules" ref="ruleForm">
        <el-form-item prop="name" label="收货人">
          <el-input v-model="form.name" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item prop="address" label="收货地址">
          <el-input v-model="form.address" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item prop="phone" label="联系方式">
          <el-input v-model="form.phone" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item prop="userid" label="创建人id">
          <el-input v-model="form.userid" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="save">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 详情内容 -->
    <el-drawer :visible.sync="drawerFormVisible" title="详情" :with-header="false">
      <div class="drawer-header">
        <span class="drawer-title">详情</span>
        <div class="drawer-actions">
          <el-tooltip placement="top" :content="isFullscreen ? '退出全屏' : '全屏'">
            <el-button icon="el-icon-full-screen" size="mini" circle @click="toggleFullscreen"/>
          </el-tooltip>
          <el-button icon="el-icon-close" size="mini" circle @click="drawerFormVisible = false"/>
        </div>
      </div>
      <!-- 抽屉内容 -->
      <div class="drawer-content" ref="drawerContent">
        <el-form label-width="100px" style="padding-right: 40px" :model="form">
          <el-form-item prop="name" label="收货人">
            <div>{{form.name}}</div>
          </el-form-item>
          <el-form-item prop="address" label="收货地址">
            <div>{{form.address}}</div>
          </el-form-item>
          <el-form-item prop="phone" label="联系方式">
            <div>{{form.phone}}</div>
          </el-form-item>
          <el-form-item prop="userid" label="创建人">
            <div>{{ users.find(v => v.id == form.userid)?.name}}</div>
          </el-form-item>
        </el-form>
      </div>
      <!-- 抽屉底部 -->
      <div class="drawer-footer">
        <el-button @click="drawerFormVisible = false">关闭</el-button>
      </div>
    </el-drawer>
  </div>
</template>

<script>
export default {
  name: "Address",
  data() {
    return {
      tableData: [],
      total: 0,
      pageNum: 1,
      pageSize: 10,
      name: "",
      form: {},
      dialogFormVisible: false,
      drawerFormVisible: false,
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {},
      rules: {
        name: [
          { required: true, message: '请输入必填项', trigger: 'blur'}
        ],
      },
      isFullscreen: false,
      drawerWidth: '50%', // 默认抽屉宽度
      drawerPosition: 'right', // 默认抽屉位置
      users: []
    }
  },
  created() {
    this.load()
  },
  methods: {
    load() {
      this.$request.get("/address/page", {
        params: {
          pageNum: this.pageNum,
          pageSize: 10,
          name: this.name,
        }
      }).then(res => {
        this.tableData = res.data?.records
        this.total = res.data?.total
      })

      this.$request.get("/user/selectAll").then(res => {
        this.users = res.data
      })
    },
    save() {
      this.$refs['ruleForm'].validate((valid) => {
        if (valid) {
         this.$request({
           method: this.form.id ? 'PUT' : 'POST',
           url: "/address",
           data: this.form
         }).then(res => {
            if (res.code === '200') {
              this.$notify.success({title: '成功', message: '操作成功', showClose: false, duration: 2000});
              this.dialogFormVisible = false
              this.load()
            } else {
              this.$notify.error({title: '成功', message: res.msg, showClose: false, duration: 2000});
            }
          })
        }
      })
    },
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
    detail(row) {
      this.form = JSON.parse(JSON.stringify(row))
      this.drawerFormVisible = true
    },
    del(id) {
      this.$confirm('您确认删除这些数据吗？', '确认删除', {type: "warning"}).then(response => {
       this.$request.delete("/address/" + id).then(res => {
          if (res.code === '200') {
            this.$notify.success({title: '成功', message: '操作成功', showClose: false, duration: 2000});
            this.load()
          } else {
            this.$notify.error({title: '成功', message: res.msg, showClose: false, duration: 2000});
          }
        })
      }).catch(() => {})
    },
    reset() {
      this.name = ""
      this.load()
    },
    handleCurrentChange(pageNum) {
      this.pageNum = pageNum
      this.load()
    },
    handleFileUploadSuccess(res) {
      this.form.file = res.data
    },
    handleImgUploadSuccess(res) {
      this.form.img = res.data
    },
    handleFullscreenChange() {
      // 如果用户通过ESC键退出全屏，同步更新状态
      if (!document.fullscreenElement && this.isFullscreen) {
        this.isFullscreen = false;
        this.drawerWidth = this.originalWidth;
        this.drawerPosition = this.originalPosition;
      }
    },
    toggleFullscreen() {
      if (!this.isFullscreen) {
        // 保存当前抽屉状态以便退出全屏时恢复
        this.originalWidth = this.drawerWidth;
        this.originalPosition = this.drawerPosition;

        // 进入全屏模式
        this.isFullscreen = true;
        this.drawerWidth = '100%';
        this.drawerPosition = 'bottom';

        // 延迟执行全屏请求，确保DOM已更新
        this.$nextTick(() => {
          this.requestFullscreen(this.$refs.drawerContent);
        });
      } else {
        // 退出全屏模式
        this.isFullscreen = false;
        this.drawerWidth = this.originalWidth;
        this.drawerPosition = this.originalPosition;

        this.exitFullscreen();
      }
    },
    // 全屏API相关方法
    requestFullscreen(element) {
      if (element.requestFullscreen) {
        element.requestFullscreen();
      } else if (element.webkitRequestFullscreen) {
        element.webkitRequestFullscreen();
      } else if (element.mozRequestFullScreen) {
        element.mozRequestFullScreen();
      } else if (element.msRequestFullscreen) {
        element.msRequestFullscreen();
      }
    },

    exitFullscreen() {
      if (document.exitFullscreen) {
        document.exitFullscreen();
      } else if (document.webkitExitFullscreen) {
        document.webkitExitFullscreen();
      } else if (document.mozCancelFullScreen) {
        document.mozCancelFullScreen();
      } else if (document.msExitFullscreen) {
        document.msExitFullscreen();
      }
    }
  },
  // 监听全屏状态变化
  mounted() {
    document.addEventListener('fullscreenchange', this.handleFullscreenChange);
    document.addEventListener('webkitfullscreenchange', this.handleFullscreenChange);
    document.addEventListener('mozfullscreenchange', this.handleFullscreenChange);
    document.addEventListener('MSFullscreenChange', this.handleFullscreenChange);
  },
  beforeDestroy() {
    document.removeEventListener('fullscreenchange', this.handleFullscreenChange);
    document.removeEventListener('webkitfullscreenchange', this.handleFullscreenChange);
    document.removeEventListener('mozfullscreenchange', this.handleFullscreenChange);
    document.removeEventListener('MSFullscreenChange', this.handleFullscreenChange);
  },
}
</script>


<style scoped>

</style>
