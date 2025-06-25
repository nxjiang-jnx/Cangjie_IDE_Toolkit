<script setup>
import { ref, watch } from 'vue'
import Tip from '../components/Tip.vue'
import CodeEdit from '../components/CodeEdit.vue'
import { ElInput, ElButton, ElMessage, ElRow, ElCol, ElSteps, ElStep } from 'element-plus'
import axios from 'axios'
import { useRouter } from 'vue-router'

const router = useRouter()
const activeStep = ref(1)
const code = ref('')
const path = ref('')
const loading = ref(false)

watch([code, path], ([newCode, newPath]) => {
  if (newCode && newPath) {
    activeStep.value = 3
  } else if (newCode) {
    activeStep.value = 2
  } else {
    activeStep.value = 1
  }
})

const submitDocument = async () => {
  loading.value = true
  await new Promise(resolve => setTimeout(resolve, 1000))
  try {
    const response = await axios.post('http://localhost:8080/GenerateDocument', {
      code: code.value,
      path: path.value
    }, {
      headers: {
        'Content-Type': 'application/json'
      }
    })
    console.log(response)
    const responseData = response.data.response
    if (responseData === 'ILLEGAL INPUT' || responseData === '') {
      ElMessage.error('非法输入，请检查您的代码和路径')
    } else {
      localStorage.setItem('CodeResult', JSON.stringify(responseData))
      await router.push('/result')
      ElMessage.success('文档生成成功')
    }
  } catch (error) {
    ElMessage.error('提交失败，请检查网络连接或服务器状态')
    console.error('提交失败:', error)
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="container">
    <Tip>
      <p> 生成文档：通过调用大语言模型（LLM）API，为指定的函数或类生成解释性文档，并以块注释的形式插入到代码中。</p>
      <p> 你需要提交的参数有：Code、Path。</p>
    </Tip>

    <el-row :gutter="20" class="control-row" align="middle">
      <el-col :span="12">
        <el-steps :active="activeStep" align-center>
          <el-step title="Step 1" description="请输入参数 Code" />
          <el-step title="Step 2" description="请输入参数 Path" />
          <el-step title="Step 3" description="已准备好生成文档" />
        </el-steps>
      </el-col>
      <el-col :span="12" class="submit-col">
        <el-button
            type="primary"
            :disabled="activeStep !== 3"
            :loading="loading"
            @click="submitDocument"
            size="large">
          提交
        </el-button>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :span="24">
        <CodeEdit v-model="code" />

        <div class="path-section">
          <h3 class="path-title">Path</h3>
          <el-input
              v-model="path"
              placeholder="在此输入Path..."
              size="large"
          />
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<style scoped>
.control-row {
  margin-top: 20px;
  margin-bottom: 20px;
}

.submit-col {
  display: flex;
  justify-content: center;
  align-items: center;
}

.path-section {
  margin-top: 20px;
}

.path-title {
  background: linear-gradient(135deg, #4fc3f7, #00b0ff);
  color: white;
  letter-spacing: 0.5px;
  font-size: 16px;
  font-weight: 470;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
  padding: 8px 15px;
  margin-bottom: 0;
  border-radius: 8px 8px 0 0;
}

.container {
  height: 800px;
  overflow-y: auto;
  padding: 0 20px;
}
</style>