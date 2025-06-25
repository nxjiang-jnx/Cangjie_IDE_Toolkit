<template>
  <div class="container">
    <Tip>
      <p> 变量重命名：根据指定的作用域，对代码中的变量进行安全的重命名操作，确保代码的语义不变。</p>
      <p> 你需要填写的参数有：Code、Path、OldName、NewName。</p>
    </Tip>

    <el-row :gutter="20" class="control-row" align="middle">
      <el-col :span="12">
        <el-steps :active="activeStep" align-center>
          <el-step title="Step 1" description="请输入参数 Code" />
          <el-step title="Step 2" description="请输入参数 Path" />
          <el-step title="Step 3" description="请输入参数 OldName" />
          <el-step title="Step 4" description="请输入参数 NewName" />
          <el-step title="Step 5" description="已准备好进行变量重命名" />
        </el-steps>
      </el-col>
      <el-col :span="12" class="submit-col">
        <el-button
            type="primary"
            :disabled="activeStep !== 5"
            :loading="loading"
            @click="submitRefactor"
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

        <div class="old-name-section">
          <h3 class="old-name-title">OldName</h3>
          <el-input
              v-model="oldName"
              placeholder="在此输入OldName..."
              size="large"
          />
        </div>

        <div class="new-name-section">
          <h3 class="new-name-title">NewName</h3>
          <el-input
              v-model="newName"
              placeholder="在此输入NewName..."
              size="large"
          />
        </div>
      </el-col>
    </el-row>
  </div>
</template>

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
const oldName = ref('')
const newName = ref('')
const loading = ref(false)

watch([code, path, oldName, newName], ([newCode, newPath, newOldName, newNewName]) => {
  if (newCode && newPath && newOldName && newNewName) {
    activeStep.value = 5
  } else if (newCode && newPath && newOldName) {
    activeStep.value = 4
  } else if (newCode && newPath) {
    activeStep.value = 3
  } else if (newCode) {
    activeStep.value = 2
  } else {
    activeStep.value = 1
  }
})

const submitRefactor = async () => {
  loading.value = true
  await new Promise(resolve => setTimeout(resolve, 1000))
  try {
    const response = await axios.post('http://localhost:8080/RefactorVariable', {
      code: code.value,
      path: path.value,
      oldName: oldName.value,
      newName: newName.value
    }, {
      headers: {
        'Content-Type': 'application/json'
      }
    })
    console.log(response.data)
    const responseData = response.data.response
    if (responseData === 'ILLEGAL INPUT' || responseData === '') {
      ElMessage.error('非法输入，请检查您的代码、路径、旧名称和新名称')
    } else {
      localStorage.setItem('CodeResult', JSON.stringify(responseData))
      await router.push('/result')
      ElMessage.success('变量重命名成功')
    }
  } catch (error) {
    ElMessage.error('提交失败，请检查网络连接或服务器状态')
    console.error('提交失败:', error)
  } finally {
    loading.value = false
  }
}
</script>

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

.old-name-section {
  margin-top: 20px;
}

.new-name-section {
  margin-top: 20px;
}

.path-title,
.old-name-title,
.new-name-title {
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