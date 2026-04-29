<template>
  <div>
    <!-- 近30天商品销售额趋势图 -->
    <el-row>
      <el-col :span="24" style="padding: 5px">
        <el-card>
          <div id="main" style="width: 100%; height: 450px"></div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 商品销量统计 -->
    <el-row>
      <el-col :span="24" style="padding: 5px">
        <el-card>
          <div id="pie1" style="width: 100%; height: 450px"></div>
        </el-card>
      </el-col>

      <!-- 分类商品统计 -->
      <el-col :span="24" style="padding: 5px">
        <el-card>
          <div id="pie2" style="width: 100%; height: 450px"></div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import * as echarts from 'echarts'

export default {
  name: "Home",
  data() {
    return {

    }
  },
  mounted() {  // 页面元素渲染之后再触发
    const option = {
      title: {
        text: '近30天商品销售额趋势图',
        left: 'center'
      },
      tooltip: {
        trigger: 'item'
      },
      xAxis: {
        type: 'category',
        data: []
      },
      yAxis: {
        type: 'value'
      },
      series: [
        {
          data: [],
          type: 'line',
          smooth: true
        },
      ]
    };

    const pieOption1 = {
      title: {
        text: '商品销量统计',
        left: 'center',
        textStyle: {
          fontSize: 18,
          color: '#333',
          fontWeight: 'bold'
        },
        subtextStyle: {
          fontSize: 12,
          color: '#666'
        }
      },
      // Tooltip：居中显示 + 内容丰富 + 美化样式
      tooltip: {
        trigger: 'item',
        position: ['50%', '50%'], // 强制居中，视觉焦点集中
        backgroundColor: 'rgba(255, 255, 255, 0.95)',
        borderColor: '#ddd',
        borderWidth: 1,
        borderRadius: 6,
        padding: [14, 18],
        textStyle: {
          color: '#333',
          fontSize: 13,
          align: 'left'
        },
        formatter: function(params) {
          return `<div style="text-align:left">
                    <strong>${params.name}</strong><br/>
                            销量：${params.value} 件<br/>
                            占比：${params.percent.toFixed(1)}%
                  </div>`;
        },
        enterable: true, // 允许鼠标进入 tooltip 区域
        confine: true // 防止溢出容器
      },
      // Legend：完整显示、支持滚动、悬停查看全名
      legend: {
        type: 'scroll', // 保留滚动，避免撑爆页面
        orient: 'vertical',
        right: 10,
        top: 'center',
        bottom: 20,
        maxHeight: 300, // 控制最大高度，超出自动滚动
        // 文字处理：过长自动截断
        formatter: function(name) {
          // 超过8个字符显示省略号
          if (name.length > 8) {
            return name.substring(0, 8) + '...';
          }
          return name;
        },
        itemWidth: 14,
        itemHeight: 14,
        textStyle: {
          fontSize: 12,
          color: '#555',
          lineHeight: 22 // 行高控制，防止重叠
        },
        // 悬停图例时显示完整名称（防误触）
        tooltip: {
          show: true,
          formatter: function(params) {
            return params.name; // 完整名称
          },
          backgroundColor: '#333',
          textStyle: { color: '#fff', fontSize: 12 },
          padding: [8, 12]
        }
      },
      // Series：标签 + 连线 + 样式全面增强
      series: [
        {
          name: '商品名称',
          type: 'pie',
          radius: ['40%', '70%'],
          avoidLabelOverlap: false,
          // 标签：显示【名称 + 数量 + 百分比】，更直观
          label: {
            show: true,
            position: 'outside', // 外部放置，避免遮挡
            formatter: '{b}\n{c}件\n({d}%)', // 换行展示，清晰易读
            fontSize: 11,
            color: '#333',
            lineHeight: 16,
            rich: {
              // 可选：富文本加粗名称
              name: {
                fontWeight: 'bold',
                fontSize: 12
              }
            }
          },
          // 悬停强调：放大 + 加粗
          emphasis: {
            label: {
              show: true,
              fontSize: 14,
              fontWeight: 'bold',
              color: '#222',
              formatter: '{b}\n{c}件\n({d}%)'
            }
          },
          // 标签连线：必须开启！否则标签像“漂浮”
          labelLine: {
            show: true,
            length: 25,     // 第一段长度（从扇区到折点）
            length2: 40,     // 第二段长度（折点到标签）
            lineStyle: {
              width: 1,
              type: 'solid',
              color: '#aaa'
            }
          },
          data: [] // 你的数据在这里填充
        }
      ]
    };
    const pieOption2 = {
      title: {
        text: '分类商品统计',
        left: 'center',
        textStyle: {
          fontSize: 18,
          color: '#333',
          fontWeight: 'bold'
        },
        subtextStyle: {
          fontSize: 12,
          color: '#666'
        }
      },
      // Tooltip：居中显示 + 内容丰富 + 美化样式
      tooltip: {
        trigger: 'item',
        position: ['50%', '50%'], // 强制居中，视觉焦点集中
        backgroundColor: 'rgba(255, 255, 255, 0.95)',
        borderColor: '#ddd',
        borderWidth: 1,
        borderRadius: 6,
        padding: [14, 18],
        textStyle: {
          color: '#333',
          fontSize: 13,
          align: 'left'
        },
        formatter: function(params) {
          return `<div style="text-align:left">
                    <strong>${params.name}</strong><br/>
                            销量：${params.value} 件<br/>
                            占比：${params.percent.toFixed(1)}%
                  </div>`;
        },
        enterable: true, // 允许鼠标进入 tooltip 区域
        confine: true // 防止溢出容器
      },
      // Legend：完整显示、支持滚动、悬停查看全名
      legend: {
        type: 'scroll', // 保留滚动，避免撑爆页面
        orient: 'vertical',
        right: 10,
        top: 'center',
        bottom: 20,
        maxHeight: 300, // 控制最大高度，超出自动滚动
        // 文字处理：过长自动截断
        formatter: function(name) {
          // 超过8个字符显示省略号
          if (name.length > 8) {
            return name.substring(0, 8) + '...';
          }
          return name;
        },
        itemWidth: 14,
        itemHeight: 14,
        textStyle: {
          fontSize: 12,
          color: '#555',
          lineHeight: 22 // 行高控制，防止重叠
        },
        // 悬停图例时显示完整名称（防误触）
        tooltip: {
          show: true,
          formatter: function(params) {
            return params.name; // 完整名称
          },
          backgroundColor: '#333',
          textStyle: { color: '#fff', fontSize: 12 },
          padding: [8, 12]
        }
      },

      // Series：标签 + 连线 + 样式全面增强
      series: [
        {
          name: '商品名称',
          type: 'pie',
          radius: ['40%', '70%'],
          avoidLabelOverlap: false,
          // 标签：显示【名称 + 数量 + 百分比】，更直观
          label: {
            show: true,
            position: 'outside', // 外部放置，避免遮挡
            formatter: '{b}\n{c}件\n({d}%)', // 换行展示，清晰易读
            fontSize: 11,
            color: '#333',
            lineHeight: 16,
            rich: {
              // 可选：富文本加粗名称
              name: {
                fontWeight: 'bold',
                fontSize: 12
              }
            }
          },
          // 悬停强调：放大 + 加粗
          emphasis: {
            label: {
              show: true,
              fontSize: 14,
              fontWeight: 'bold',
              color: '#222',
              formatter: '{b}\n{c}件\n({d}%)'
            }
          },
          // 标签连线：必须开启！否则标签像“漂浮”
          labelLine: {
            show: true,
            length: 25,     // 第一段长度（从扇区到折点）
            length2: 40,     // 第二段长度（折点到标签）
            lineStyle: {
              width: 1,
              type: 'solid',
              color: '#aaa'
            }
          },
          data: [] // 你的数据在这里填充
        }
      ]
    };

    // 折线图
    const  chartDom = document.getElementById('main');
    const  myChart = echarts.init(chartDom);
    this.$request.get("/goods/orderEcharts").then(res => {
      // 填空
      option.xAxis.data = res.data.x
      option.series[0].data = res.data.y
      // 数据准备完毕之后再set
      myChart.setOption(option);
    })

    // 饼图
    const  pieChartDom1 = document.getElementById('pie1');
    const  pieChart1 = echarts.init(pieChartDom1);
    this.$request.get("/goods/goodsSaleEcharts").then(res => {
      // 填空
      pieOption1.series[0].data = res.data
      // 数据准备完毕之后再set
      pieChart1.setOption(pieOption1);
    })

    // 饼图
    const  pieChartDom2 = document.getElementById('pie2');
    const  pieChart2 = echarts.init(pieChartDom2);
    this.$request.get("/goods/goodsStoreEcharts").then(res => {
      // 填空
      pieOption2.series[0].data = res.data
      // 数据准备完毕之后再set
      pieChart2.setOption(pieOption2);
    })
  }
}
</script>

<style scoped>

</style>
