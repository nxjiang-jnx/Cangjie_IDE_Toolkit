<template>
  <el-header class="top-bar">
    <div class="left-section">
      <img src="@/assets/logo.svg" alt="logo" class="logo" />
      <span class="title">仓颉代码处理工具</span>
    </div>
  </el-header>
</template>

<script lang="ts" setup>

</script>

<style scoped>
.top-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 40px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.left-section {
  display: flex;
  align-items: center;
  gap: 12px;
}

.logo {
  width: 40px;
  height: 40px;
}

.title {
  font-size: 18px;
  font-weight: 600;
}
</style>