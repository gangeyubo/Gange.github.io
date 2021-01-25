<template>
  <div class="dashboard-container" style="width:100%; height:100%">
    <div class="dashboard-editor-container">
      <div style="padding:0px; margin:0px;border-bottom: 20px solid rgb(240, 242, 245);">
        <el-card class="box-card" style="height: 80px; margin: 0px;">
          <el-form :inline="true" class="demo-form-inline">
            <el-form-item label="应用名称：">
              <el-select v-model="pageSearch.index" placeholder="" style="width: 200px" class="filter-item" 
                @input="change">
                <el-option v-for="(item, index) in appList" :key="item.label" :label="item.label" :value="index" />
              </el-select>
            </el-form-item>
            <el-form-item label="应用版本：">
              <el-select v-model="pageSearch.app_version" placeholder="" style="width: 200px" class="filter-item"
                @change="selectApp">
                <el-option v-for="item in app_versions" :key="item.id" :label="item" :value="item" />
              </el-select>
            </el-form-item>
          </el-form>
        </el-card>
      </div>

      <!-- 业务测试缺陷统计 -->
      <div style="padding:0px; margin:0px;border-bottom: 20px solid rgb(240, 242, 245);">
        <el-card style="padding: 0px; margin: 0px;">
          <div slot="header" class="clearfix">
            <span>业务测试数据</span>
          </div>
          <!-- 业务测试全部数据数据 -->
          <DashboardBizTest v-bind:app_id="pageSearch.app_id" v-bind:app_version="pageSearch.app_version" > 
          </DashboardBizTest>
        </el-card>
      </div>

      <!--  稳定性数据-->
      <div style="padding:0px; margin:0px;border-bottom: 20px solid rgb(240, 242, 245);"
        v-show=" pageSearch.app_name == '哔哩哔哩粉版Android' || pageSearch.app_name == '哔哩哔哩粉版iOS'">
        <el-card style="padding: 0px; margin: 0px;">
          <div slot="header" class="clearfix">
            <span>稳定性数据</span>
          </div>
          <!-- 适配测试数据 -->
          <DashboardAdaptation v-bind:app_id="pageSearch.app_id" v-bind:app_version="pageSearch.app_version" 
          v-show=" pageSearch.app_name == '哔哩哔哩粉版Android' ">
          </DashboardAdaptation>

          <!-- crash 数据 -->
          <BugFixed v-bind:app_id="pageSearch.app_id" v-bind:app_version="pageSearch.app_version" 
          v-show=" pageSearch.app_name == '哔哩哔哩粉版Android' || pageSearch.app_name == '哔哩哔哩粉版iOS'">
          </BugFixed>
        </el-card>
      </div>

      <!-- 性能数据 -->
      <div style="padding:0px; margin:0px;border-bottom: 20px solid rgb(240, 242, 245);"
        v-show=" pageSearch.app_name == '哔哩哔哩粉版Android' || pageSearch.app_name == '哔哩哔哩粉版iOS'">
        <el-card style="padding: 0px;margin:0px">
          <div slot="header" class="clearfix">
            <span>性能数据</span>
          </div>
          <!-- 过度绘制数据 -->
          <DashboardOverdraw v-bind:app_id="pageSearch.app_id" v-bind:app_version="pageSearch.app_version"
          v-show=" pageSearch.app_name == '哔哩哔哩粉版Android' ">
          </DashboardOverdraw>

          <!-- 耗电量数据 -->
          <DashboardBattery v-bind:app_id="pageSearch.app_id" v-bind:app_version="pageSearch.app_version"
          v-show=" pageSearch.app_name == '哔哩哔哩粉版Android' ">
          </DashboardBattery>

          <!-- 基础性能数据 -->
          <PerfData v-bind:app_id="pageSearch.app_id" v-bind:app_version="pageSearch.app_version"
          v-show=" pageSearch.app_name == '哔哩哔哩粉版Android' ">
          </PerfData>

          <!-- 启动+首页加载耗时 -->
          <MirrorData v-bind:app_id="pageSearch.app_id" v-bind:app_version="pageSearch.app_version"
          v-show=" pageSearch.app_name == '哔哩哔哩粉版Android' || pageSearch.app_name == '哔哩哔哩粉版iOS'">
          </MirrorData>
        </el-card>
      </div>
    </div>
  </div>
</template>
</div>
</template>

<script>
  import {
    getDashboardAdaptationVersions
  } from '@/api/adaptation'
  import permission from '@/directive/permission/index.js' // 权限判断指令
  import Pagination from '@/components/Pagination'
  import DashboardBizTest from './component/DashboardBizTest'
  import DashboardAdaptation from './component/DashboardAdaptation'
  import BugFixed from './component/BugFixed'
  import DashboardOverdraw from './component/DashboardOverdraw'
  import DashboardBattery from './component/DashboardBattery'
  import PerfData from './component/PerfData'
  import MirrorData from './component/MirrorData'

  export default {
    directives: {
      permission
    },
    components: {
      Pagination,
      DashboardBizTest,
      DashboardAdaptation,
      BugFixed,
      DashboardOverdraw,
      DashboardBattery,
      PerfData,
      MirrorData
    },
    data() {
      return {
        app_versions: [],
        appList: [{
          label: "哔哩哔哩粉版Android",
          value: "tv.danmaku.bili",
        }, {
          label: "哔哩哔哩粉版iOS",
          value: "com.bilibili.bilianime",
        }, {
          label: "哔哩哔哩粉版iOS HD",
          value: "tv.danmaku.bilibilihd",
        }],
      
        pageSearch: {
          app_id: "tv.danmaku.bili",
          app_name: "哔哩哔哩粉版Android",
          app_key: 'android',
          app_version: '6.18.0',
          count: 3,
          operator: "ep",
          pageIndex: 1,
          pageSize: 10,
          scene: "",
          biz_line: "",
          perf_type: "mem",
          device_rank: '中端机',
          bug_tag: 'Monkey',
          cate: 'crash',
          // index为了依据下拉框同步pageSearch中的app_id, app_name，是appList中的索引值
          index: '哔哩哔哩粉版Android',
        },
        responseBizBugFalg: false,
        responseBizProgressFalg: false,
        responseAdaptationFalg: false,
        responseBugFalg: false,
        responseOverdrawFalg: false,
        responseMirrorFalg: false,
      }
    },
    created() {
      this.fetchData()
    },
    methods: {
      change(index) {
        this.responseBizBugFalg = false
        this.responseBizProgressFalg = false
        this.responseAdaptationFalg = false
        this.responseOverdrawFalg = false
        this.responseBugFalg = false
        this.responseMirrorFalg = false

        this.pageSearch.app_id = this.appList[index].value
        this.pageSearch.app_name = this.appList[index].label
        // 不通的应用对应的版本不一致，故每次需要重新获取版本
        getDashboardAdaptationVersions(this.pageSearch).then(response => {
          this.app_versions = response.data
          this.pageSearch.app_version = response.data[0]
        })
      },

      fetchData() {
        getDashboardAdaptationVersions(this.pageSearch).then(response => {
          this.app_versions = response.data
          this.pageSearch.app_version = response.data[0]
        })
      },
      selectApp(id) {
        this.responseBizBugFalg = false
        this.responseBizProgressFalg = false
        this.responseAdaptationFalg = false
        this.responseOverdrawFalg = false
        this.responseBugFalg = false
        this.responseMirrorFalg = false
      },
    }
  }

</script>

<style lang="scss" scoped>
  .dashboard-editor-container {
    padding: 0px;
    // margin: 20px;
    border: 20px;
    border-style: solid;
    border-color: rgb(240, 242, 245);
    background-color: rgb(240, 242, 245);
    position: relative;
    width: 100%;
    height: 100%;

    .github-corner {
      position: absolute;
      top: 0px;
      border: 0;
      right: 0;
    }

    .chart-wrapper {
      background: rgb(187, 185, 185);
      padding: 16px 16px 0;
      margin-bottom: 32px;
    }
  }

  .dashboard-editor-container1 sub {
    padding: 0px;
    margin: 5px;
    background-color: rgb(240, 242, 245);
    position: relative;

    .github-corner {
      position: absolute;
      top: 0px;
      border: 0;
      right: 0;
    }

    .chart-wrapper {
      background: rgb(152, 243, 149);
      padding: 16px 16px 0;
      margin-bottom: 32px;
    }
  }

</style>
<style lang="scss">

  .el-header style {
    padding-top: 2px;
    padding-bottom: 2px;
    padding-left: 2px;
    font-size: 400px;
    font-weight: 900;
  }

  .el-form-item__label{
    font-size: 15px;
  }

  // .el-row {
  //   margin-bottom: 20px;

  //   &:last-child {
  //     margin-bottom: 0;
  //   }
  // }

  // .el-col {
  //   border-radius: 4px;
  // }

  // .bg-purple-dark {
  //   background: #99a9bf;
  // }

  // .bg-purple {
  //   background: white;
  //   ;
  // }

  // .bg-purple-light {
  //   background: #e5e9f2;
  // }

  // .grid-content {
  //   border-radius: 4px;
  //   min-height: 320px;
  // }

  // .row-bg {
  //   padding: 10px 0;
  //   background-color: #f9fafc;
  // }

  // .col-style {
  //   width: 260px;
  //   height: 360px;
  //   margin-top: 20px;
  // }


  // .list {
  //   max-width: 1500px;
  // }

</style>
