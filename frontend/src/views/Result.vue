<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElCard } from 'element-plus'
import { useRouter } from 'vue-router'

const router = useRouter()
const result = ref(null)
const lineNumbersRef = ref(null)
const preElementRef = ref(null)

const resultLineCount = computed(() => (result.value || '').split('\n').length)

const syncScroll = () => {
  if (lineNumbersRef.value && preElementRef.value) {
    lineNumbersRef.value.scrollTop = preElementRef.value.scrollTop
  }
}

onMounted(() => {
  const storedResult = localStorage.getItem('CodeResult')
  if (storedResult) {
    result.value = JSON.parse(storedResult)
  } else {
    router.push('/')
  }
  localStorage.removeItem('CodeResult')
})
</script>

<template>
  <div>
    <el-card v-if="result">
      <template #header>
        <div class="result-header">
          <h2 class="result-title">
            代码结果
          </h2>
        </div>
      </template>

      <div class="code-container">
        <div class="line-numbers" ref="lineNumbersRef">
          <div v-for="n in resultLineCount" :key="n" class="line-number">{{ n }}</div>
        </div>
        <div class="result-content">
          <pre class="result-code" ref="preElementRef" @scroll="syncScroll">{{ result }}</pre>
        </div>
      </div>
    </el-card>
  </div>
</template>

<style scoped>
.result-header {
  display: flex;
  align-items: center;
  padding: 12px 16px;
  background-color: #f8f9fa;
  border-radius: 6px;
}

.result-title {
  font-size: 18px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0;
}

.code-container {
  display: flex;
  height: 610px;
  font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
  font-size: 14px;
  line-height: 20px;
}

.line-numbers {
  width: 50px;
  background-color: #f0f8ff;
  text-align: right;
  padding: 8px 0;
  overflow-y: hidden;
  user-select: none;
  border-right: 1px solid #e1f0fa;
  border-radius: 6px 0 0 6px;
}

.line-number {
  padding: 0 10px 0 0;
  color: #7ca8c2;
  font-size: 13px;
  line-height: 20px;
}

.result-content {
  flex: 1;
  overflow: hidden;
}

.result-code {
  white-space: pre;
  overflow: auto;
  padding: 8px 12px;
  margin: 0;
  font-family: inherit;
  font-size: inherit;
  line-height: 20px;
  color: #2c3e50;
  background-color: #ffffff;
  height: 100%;
  box-sizing: border-box;
}
</style>