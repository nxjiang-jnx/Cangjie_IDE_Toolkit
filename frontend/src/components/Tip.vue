<template>
  <div class="tip">
    <div class="tip-title">
      <el-icon class="tip-icon"><info-filled /></el-icon>
      <span>TIP</span>
    </div>
    <div class="tip-content">
      <slot></slot>
    </div>
  </div>
</template>

<script setup>
import { InfoFilled } from '@element-plus/icons-vue'
</script>

<style scoped>
.tip {
  background: linear-gradient(145deg, #f8fdff, #e3f6ff);
  padding: 15px 20px;
  margin: 20px 0;
  border-left: 4px solid #409eff;
  border-radius: 8px;
  box-shadow: 0 4px 6px -1px rgba(0, 114, 255, 0.1);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  position: relative;
  overflow: hidden;
}

.tip:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px -1px rgba(0, 114, 255, 0.15);
}

.tip:before {
  content: "";
  position: absolute;
  left: -4px;
  top: 0;
  height: 100%;
  width: 4px;
  background: linear-gradient(to bottom, #409eff, #79bbff);
  animation: borderGlow 2s infinite;
}

.tip-title {
  font-weight: 600;
  color: #409eff;
  font-size: 1.1em;
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.tip-icon {
  font-size: 1.3em;
  margin-right: 10px;
  filter: drop-shadow(0 2px 4px rgba(64, 158, 255, 0.2));
}

.tip-content {
  color: #2c3e50;
  font-size: 0.95em;
  line-height: 1.6;
  padding-left: 32px;
}

@keyframes borderGlow {
  0% { opacity: 0.8; }
  50% { opacity: 1; }
  100% { opacity: 0.8; }
}
</style>