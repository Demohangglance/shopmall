<template>
  <div>
    <!-- 表格内容 -->
    <el-card>
      <div style="margin-bottom: 10px">
        <el-input style="width: 200px;margin: 0 5px" placeholder="查询..." v-model="name"></el-input>
        <el-button type="success" plain @click="load(1)">查询</el-button>
        <el-button type="info" plain @click="reset">重置</el-button>
        <el-button type="primary" plain @click="handleAdd">新增</el-button>
      </div>
      <el-table :data="tableData" stripe>
        <el-table-column prop="id" label="序号" width="70" align="center">
          <template slot-scope='scope'>
            <span>{{ (pageNum - 1) * pageSize + (scope.$index + 1) }}</span>
          </template>
        </el-table-column>
        <el-table-column align="center" prop="name" label="名称" :show-overflow-tooltip="true"></el-table-column>
        <el-table-column align="center" prop="shopid" label="店铺" :show-overflow-tooltip="true">
          <template v-slot="scope">
            {{shops.find(v => v.id === scope.row.shopid).name}}
          </template>
        </el-table-column>
        <el-table-column align="center" prop="typeid" label="分类" :show-overflow-tooltip="true">
          <template v-slot="scope">
            {{types.find(v => v.id === scope.row.typeid).name}}
          </template>
        </el-table-column>
        <el-table-column align="center" prop="description" label="描述" :show-overflow-tooltip="true"></el-table-column>
        <el-table-column align="center" prop="content" label="商品详情">
          <template slot-scope="scope">
            <el-button plain type="success" @click="view(scope.row)" size="mini">预览</el-button>
          </template>
        </el-table-column>
        <el-table-column align="center" prop="code" label="商品编码"></el-table-column>
        <el-table-column align="center" prop="price" label="价格"></el-table-column>
        <el-table-column align="center" prop="discount" label="折扣"></el-table-column>
        <el-table-column align="center" prop="unit" label="单位"></el-table-column>
        <el-table-column align="center" label="图片">
          <template v-slot="scope">
            <el-image style="width: 50px; height: 50px" :src="scope.row.img" :preview-src-list="[scope.row.img]"></el-image>
          </template>
        </el-table-column>
        <el-table-column label="缩略图">
          <template v-slot="scope">
            <el-button type="primary" @click="viewImgs(scope.row.imgs)">缩略图</el-button>
          </template>
        </el-table-column>
        <el-table-column align="center" prop="nums" label="库存"></el-table-column>
        <el-table-column align="center" prop="sales" label="销量"></el-table-column>
        <el-table-column align="center" prop="time" label="上架日期" :show-overflow-tooltip="true"></el-table-column>
        <el-table-column align="center" prop="state" label="状态" width="200">
          <template v-slot="scope">
            <el-switch
                @change="(newState) => handleSwitchChange(scope.row, newState)"
                v-model="scope.row.state"
                active-text="上架"
                inactive-text="下架"
                active-value="0"
                inactive-value="1">
            </el-switch>
          </template>
        </el-table-column>
        <el-table-column align="center" prop="recommend" label="是否推荐"></el-table-column>

        <el-table-column label="操作" width="240" align="center">
          <template slot-scope="scope">
            <el-button plain type="success" @click="detail(scope.row)" size="mini">详情</el-button>
            <el-button plain type="primary" @click="handleEdit(scope.row)" size="mini">编辑</el-button>
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
    <el-dialog title="信息" :visible.sync="dialogFormVisible" width="60%" :close-on-click-modal="false">
      <el-form label-width="100px" style="padding-right: 40px" :model="form" :rules="rules" ref="ruleForm">
        <el-form-item prop="name" label="名称">
          <el-input v-model="form.name" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item prop="description" label="描述">
          <el-input v-model="form.description" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item prop="content" label="商品详情">
          <div id="editor"></div>
        </el-form-item>
        <el-form-item prop="typeid" label="分类">
          <el-select v-model="form.typeid" placeholder="请选择分类">
            <el-option v-for="item in types" :key="item.id" :label="item.name" :value="item.id"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item prop="code" label="商品编码">
          <el-input v-model="form.code" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item prop="price" label="价格">
          <el-input v-model="form.price" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item prop="discount" label="折扣">
          <el-input v-model="form.discount" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item prop="unit" label="单位">
          <el-input v-model="form.unit" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item prop="img" label="商品图片">
          <el-upload :action="$baseUrl +'/file/upload'" :headers="{ token: user.token }" ref="img" :on-success="handleImgUploadSuccess">
            <el-button size="small" type="primary">点击上传</el-button>
          </el-upload>
        </el-form-item>
        <el-form-item prop="imgs" label="缩略图">
          <el-upload
              multiple
              ref="file"
              class="upload-demo"
              :action="$baseUrl + '/file/mulUpload'"
              :headers="{ token: user.token }"
              :on-success="handleFileUploadSuccess2"
              :on-preview="handlePreview"
              :on-remove="handleRemove"
              :before-upload="beforeAvatarUpload"
              :file-list="fileList"
              list-type="picture">
            <el-button size="small" type="primary">点击上传</el-button>
            <div slot="tip" class="el-upload__tip">只能上传jpg/png文件，且不超过5M</div>
          </el-upload>
        </el-form-item>
        <el-form-item prop="nums" label="库存">
          <el-input v-model="form.nums" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item prop="time" label="上架日期">
          <el-date-picker style='width:100%' v-model="form.time" type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="选择日期时间"></el-date-picker>
        </el-form-item>
        <el-form-item prop="recommend" label="是否推荐">
          <el-radio-group v-model="form.recommend">
            <el-radio-button label="是"></el-radio-button>
            <el-radio-button label="否"></el-radio-button>
          </el-radio-group>
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
          <el-form-item prop="name" label="名称">
            <div>{{ form.name }}</div>
          </el-form-item>
          <el-form-item prop="description" label="描述">
            <div>{{ form.description }}</div>
          </el-form-item>
          <el-form-item prop="content" label="商品详情">
            <div v-html="form.content"></div>
          </el-form-item>
          <el-form-item prop="code" label="商品编码">
            <div v-html="form.code"></div>
          </el-form-item>
          <el-form-item prop="price" label="价格">
            <div>{{ form.price }}</div>
          </el-form-item>
          <el-form-item prop="unit" label="单位">
            <div>{{ form.unit }}</div>
          </el-form-item>
          <el-form-item prop="img" label="商品图片">
            <div>
              <el-image style="width: 50px; height: 50px" :src="form.img" :preview-src-list="[form.img]"></el-image>
            </div>
          </el-form-item>
          <el-form-item prop="nums" label="库存">
            <div>{{ form.nums }}</div>
          </el-form-item>
          <el-form-item prop="sales" label="销量">
            <div>{{ form.sales }}</div>
          </el-form-item>
          <el-form-item prop="time" label="上架日期">
            <div>{{ form.time }}</div>
          </el-form-item>
          <el-form-item prop="state" label="状态">
            <div v-if="form.state == 0">上架</div>
            <div v-else>下架</div>
          </el-form-item>
          <el-form-item prop="typeid" label="分类">
            <div>{{ types.find(v => v.id === form.typeid)?.name || "未知类型" }}</div>
          </el-form-item>
          <el-form-item prop="discount" label="折扣">
            <div>{{ form.discount }}</div>
          </el-form-item>
          <el-form-item prop="recommend" label="是否推荐">
            <div>{{ form.recommend }}</div>
          </el-form-item>
        </el-form>
      </div>

      <!-- 抽屉底部 -->
      <div class="drawer-footer">
        <el-button @click="drawerFormVisible = false">关闭</el-button>
      </div>
    </el-drawer>

    <el-dialog title="商品详情" :visible.sync="dialogFormVisible1" width="60%">
      <div class="w-e-text" v-html="content"></div>
    </el-dialog>

    <el-dialog title="缩略图" :visible.sync="dialogFormVisible2" width="30%" :close-on-click-modal="false">
      <el-carousel  :interval="10000">
        <!-- 最多展示五个 -->
        <el-carousel-item v-for="(item,index) in files" v-if="index < 5" :key="item.id">
          <el-image style="width: 100%; height: 100%" :src="item.url" fit="contain"></el-image>
        </el-carousel-item>
      </el-carousel>
    </el-dialog>
  </div>
</template>

<script>
import E from "wangeditor"

export default {
  name: "Goods",
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
      dialogFormVisible1: false,
      dialogFormVisible2: false,
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {},
      rules: {
        name: [
          {required: true, message: '请输入必填项', trigger: 'blur'}
        ],
      },
      editor: null,
      content: '',
      isFullscreen: false,
      drawerWidth: '50%', // 默认抽屉宽度
      drawerPosition: 'right', // 默认抽屉位置
      fileList: [],
      files: [],
      files2: [],
      types: [],
      state: 0,
      shops: []
    }
  },
  created() {
    this.load()
  },
  methods: {
    handleSwitchChange(data,value){
      console.log(data)
      console.log(value)
      data.state = value
      this.$request({
        method: 'PUT',
        url: "/goods",
        data: data
      }).then(res => {
        if (res.code === '200') {
          this.$notify.success({title: '成功', message: '操作成功', showClose: false, duration: 2000});
          this.dialogFormVisible = false
          this.load()
        } else {
          this.$notify.success({title: '成功', message: res.msg, showClose: false, duration: 2000});
        }
      })
    },
    beforeAvatarUpload (file) {
      var isJPG = false
      if (file.type === 'image/jpeg' || file.type === 'image/png') {
        isJPG = true
      }
      const isLt2M = file.size / 1024  < 5000
      if (!isJPG) {
        this.$message.error('上传图片只能是 JPG/PNG 格式!')
      }
      if (!isLt2M) {
        this.$message.error('上传图片大小不能超过 5M!')
      }
      return isJPG && isLt2M
    },
    handleRemove(file, fileList) {
      console.log(file, fileList);
    },
    handlePreview(file) {
      console.log("111111"+ file);
    },
    handleFileUploadSuccess2(res) {
      for (var i = 0;i<res.length;i++){
        this.files2.push(res[i])
      }
      console.log(this.files2)
      this.form.imgs = JSON.stringify(this.files2)
    },
    viewImgs(data) {
      this.files = JSON.parse(data);
      this.dialogFormVisible2 = true;
    },
    setEditor() {
      this.$nextTick(() => {
        this.editor = new E(`#editor`)
        this.editor.config.uploadImgHeaders = {
          token: this.user.token
        }
        this.editor.config.uploadImgServer = 'http://localhost:9999/file/editor/upload'
        this.editor.config.uploadFileName = 'file'
        this.editor.config.uploadImgHeaders = {
          token: this.user.token
        }
        this.editor.config.uploadVideoServer = 'http://localhost:9999/file/editor/uploadVideo'
        this.editor.config.uploadVideoName = 'file'
        this.editor.config.uploadVideoHeaders = {
          token: this.user.token
        }
        this.editor.create()
      })
    },
    view(row) {
      this.content = row.content
      this.dialogFormVisible1 = true
    },
    destroy() {
      this.editor.destroy()
      this.editor = null
    },
    load() {
      this.$request.get("/goods/page", {
        params: {
          pageNum: this.pageNum,
          pageSize: 10,
          name: this.name,
        }
      }).then(res => {
        this.tableData = res.data?.records
        this.total = res.data?.total
      })

      this.$request.get("/type").then(res => {
        this.types = res.data
      })

      this.$request.get("/user/selectAll").then(res => {
        this.shops = res.data
      })
    },
    save() {
      this.$refs['ruleForm'].validate((valid) => {
        if (valid) {
          this.form.content = this.editor.txt.html()
          this.$request({
            method: this.form.id ? 'PUT' : 'POST',
            url: "/goods",
            data: this.form
          }).then(res => {
            if (res.code === '200') {
              this.$notify.success({title: '成功', message: '操作成功', showClose: false, duration: 2000});
              this.dialogFormVisible = false
              this.load()
              this.destroy()
              this.files2 = []
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
      // 设置富文本
      this.setEditor()
      this.$nextTick(() => {
        if (this.$refs.img) {
          this.$refs.img.clearFiles();
        }
        if (this.$refs.file) {
          this.$refs.file.clearFiles();
        }
      })
    },
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row))
      this.dialogFormVisible = true
      // 设置富文本
      this.setEditor()
      setTimeout(() => {
        this.editor.txt.html(row.content) //设置内容
      }, 0)
      this.$nextTick(() => {
        if (this.$refs.img) {
          this.$refs.img.clearFiles();
        }
        if (this.$refs.file) {
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
        this.$request.delete("/goods/" + id).then(res => {
          if (res.code === '200') {
            this.$notify.success({title: '成功', message: '操作成功', showClose: false, duration: 2000});
            this.load()
          } else {
            this.$notify.error({title: '成功', message: res.msg, showClose: false, duration: 2000});
          }
        })
      }).catch(() => {
      })
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
