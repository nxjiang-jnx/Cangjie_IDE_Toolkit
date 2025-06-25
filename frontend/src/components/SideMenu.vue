<template>
  <div class="side-menu-container">
    <el-radio-group v-model="isCollapse" class="collapse-toggle">
      <el-radio-button :value="false" @click="open1">
        <img src="@/assets/折叠2.svg" alt="fold" class="fold" />
        展开
      </el-radio-button>
      <el-radio-button :value="true" @click="open2">
        <img src="@/assets/折叠1.svg" alt="fold" class="fold" />
        折叠
      </el-radio-button>
    </el-radio-group>

    <el-menu
        :default-active="$route.path"
        class="el-menu-vertical-demo"
        :collapse="isCollapse"
        @open="handleOpen"
        @close="handleClose"
    >
      <el-sub-menu>
        <template #title>
          <el-icon><tools /></el-icon>
          <span>代码编辑工具</span>
        </template>
          <el-menu-item index="/generateCodeSignature" @click="handleGenerateCodeSignature">生成代码签名</el-menu-item>
          <el-menu-item index="/refactorVariable" @click="handleRefactorVariable">变量重命名</el-menu-item>
          <el-menu-item index="/generateDocument" @click="handleGenerateDocument">生成文档</el-menu-item>
          <el-menu-item index="/foldConstant" @click="handleFoldConstant">常量折叠</el-menu-item>
      </el-sub-menu>
      <el-menu-item index="/about" @click="handleAboutClick">
        <el-icon><icon-menu /></el-icon>
        <template #title>关于</template>
      </el-menu-item>
    </el-menu>

    <div class="clock-container">
      <el-card shadow="never">
        <el-countdown
            format="HH:mm:ss"
            :value="new Date().setHours(24, 0, 0, 0)"
            title="当前时间"
            class="menu-clock"
        >
          <template #title>
            <div class="clock-title">
              <el-icon><clock /></el-icon>
              <span style="margin-left: 8px">距离明天还剩</span>
            </div>
          </template>
        </el-countdown>
        <div class="clock-date">
          {{ currentDate.format('YYYY-MM-DD dddd') }}
        </div>
      </el-card>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { ref } from 'vue'
import { Menu as IconMenu, Tools } from '@element-plus/icons-vue'
import { ElNotification } from 'element-plus'

import { Clock } from '@element-plus/icons-vue'
import dayjs from 'dayjs'
import 'dayjs/locale/zh-cn'

dayjs.locale('zh-cn') // 设置中文周显示
const currentDate = ref(dayjs())

const isCollapse = ref(true)

const open1 = () => {
  ElNotification({
    title: '操作',
    message: '侧边栏展开',
    type: 'success',
  })
}

const open2 = () => {
  ElNotification({
    title: '操作',
    message: '侧边栏折叠',
    type: 'success',
  })
}

const open4 = () => {
  ElNotification({
    title: '跳转',
    message: '欢迎来到关于页面',
    type: 'success',
  })
}

const open5 = () => {
  ElNotification({
    title: '跳转',
    message: '欢迎使用生成代码签名功能',
    type: 'success',
  })
}

const open6 = () => {
  ElNotification({
    title: '跳转',
    message: '欢迎使用变量重命名功能',
    type: 'success',
  })
}

const open7 = () => {
  ElNotification({
    title: '跳转',
    message: '欢迎使用生成文档功能',
    type: 'success',
  })
}

const open8 = () => {
  ElNotification({
    title: '跳转',
    message: '欢迎使用常量折叠功能',
    type: 'success',
  })
}

const handleAboutClick = () => {
  navigateTo('/about')
  open4()
}

const handleGenerateCodeSignature = () => {
  navigateTo('/generateCodeSignature')
  open5()
}

const handleRefactorVariable = () => {
  navigateTo('/refactorVariable')
  open6()
}

const handleGenerateDocument = () => {
  navigateTo('/generateDocument')
  open7()
}

const handleFoldConstant = () => {
  navigateTo('/foldConstant')
  open8()
}

const handleOpen = (key: string, keyPath: string[]) => {
  console.log('Menu opened:', key, keyPath)
}

const handleClose = (key: string, keyPath: string[]) => {
  console.log('Menu closed:', key, keyPath)
}

import { useRouter } from 'vue-router'

const router = useRouter()

const navigateTo = (path: string) => {
  router.push(path)
}
</script>

<style scoped>
.fold {
  height: 17px;
  vertical-align: middle;
}

.side-menu-container {
  padding: 20px;
}

.collapse-toggle {
  margin-bottom: 20px;
}

.el-menu-vertical-demo:not(.el-menu--collapse) {
  width: 250px;
}

.clock-container {
  position: fixed;
  bottom: 20px;
  left: 40px;
}

.menu-clock {
  font-size: 18px;
  font-family: monospace;
  text-align: center;
}

.clock-date {
  margin-top: 8px;
  font-size: 12px;
  color: #666;
  text-align: center;
}

.clock-title {
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
}
</style>