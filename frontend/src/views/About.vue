<template>
    <!-- 前面的浏览器信息部分 -->
  <div class="about-container">
    <div class="info-card" style="max-width: 850px">
      <img
          src="@/assets/vue.svg"
          alt="科技图标"
          class="sci-fi-icon"
      />
      <div class="browser-info">
        <p class="info-line">版本: {{ version }}</p>
        <p class="info-line">浏览器: {{ browser }}</p>
        <p class="info-line">操作系统: {{ os }}</p>
        <p class="info-line">渲染时间: {{ renderTime }}</p>
      </div>
    </div>
    <!-- 事项说明部分 -->
    <div style="max-width: 900px">
      <el-alert
          title="版本更新说明"
          type="info"
          :description="`我们会定期推出更新的版本来提升你的使用体验。如果你刷新本页面后发现版本号发生了变化，说明你的浏览器可能正在使用缓存内容渲染本 app。通常来说，缓存会在一段时间后自动更新。如果需要，请手动清理浏览器的缓存。`"
          :closable="false"
      />
      <el-alert
          title="项目开源说明"
          type="warning"
          description="本项目的诞生离不开包括 Vue 、 Node.js 和 Element Plus 在内的众多开源项目。"
          :closable="false"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { version as pkgVersion } from '../../package.json'

const version = ref(pkgVersion)
const browser = ref('')
const os = ref('')
const renderTime = ref('')

onMounted(() => {
  // 获取浏览器版本等信息
  const userAgent = navigator.userAgent
  const browserMatch = userAgent.match(/(Chrome|Firefox|Safari|Edge)[\/\s](\d+(\.\d+)*)/)
  if (browserMatch) {
    browser.value = `${browserMatch[1]} ${browserMatch[2]}`
  }
  // 获取操作系统信息
  if (navigator.platform.indexOf('Win')!== -1) {
    os.value = 'Windows'
  } else if (navigator.platform.indexOf('Mac')!== -1) {
    os.value = 'MacOS'
  } else if (navigator.platform.indexOf('Linux')!== -1) {
    os.value = 'Linux'
  }
  // 模拟渲染时间
  renderTime.value = new Date().toLocaleString()
})
</script>

<style scoped>
.about-container {
  padding: 2rem;
}

.info-card {
  display: flex;
  align-items: center;
  gap: 2rem;
  padding: 1.5rem;
  background: #ffffff;
  border-radius: 6px;
  border: 1px solid #ebeef5;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

.info-line {
  font-size: 1.1rem;
  color: #303133;
  margin: 0.8rem 0;
  letter-spacing: 0.05em;
  font-weight: 450;
}

.info-line:nth-child(odd) {
  color: #606266;
}

.sci-fi-icon {
  width: 140px;
  height: 140px;
  filter: drop-shadow(0 0 6px rgba(0, 150, 255, 0.3));
}
</style>