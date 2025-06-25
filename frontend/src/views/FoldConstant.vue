<script setup>
import { ref, watch } from 'vue'
import Tip from '../components/Tip.vue'
import CodeEdit from '../components/CodeEdit.vue'
import { ElSteps, ElStep, ElButton, ElMessage, ElRow, ElCol } from 'element-plus'
import axios from 'axios'
import { useRouter } from 'vue-router'

const router = useRouter()
const activeStep = ref(1)
const code = ref('')
const loading = ref(false)

watch(code, (newValue) => {
  activeStep.value = newValue ? 2 : 1
})

const submitCode = async () => {
  loading.value = true
  // 等待1秒
  await new Promise(resolve => setTimeout(resolve, 1000))
  try {
    const response = await axios.post('http://127.0.0.1:8080/FoldConstant', {
      code: code.value
    }, {
      headers: {
        'Content-Type': 'application/json'
      }
    })
    console.log(response)
    const responseData = response.data.response
    if (responseData === 'ILLEGAL INPUT' || responseData === '') {
      ElMessage.error('非法输入，请检查您的代码')
    } else {
      // 存储结果到本地存储或vuex/pinia，以便在结果页面访问
      localStorage.setItem('CodeResult', JSON.stringify(responseData))
      // 跳转到结果页面
      await router.push('/result')
      ElMessage.success('常量折叠生成成功')
    }
  } catch (error) {
    ElMessage.error('提交失败，请检查网络连接或服务器状态')
    console.error('提交代码失败:', error)
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div>
    <Tip>
      <p> 常量折叠：对代码中的常量表达式进行计算和折叠，优化代码的执行效率。</p>
      <p> 你需要填写的参数有：Code。</p>
    </Tip>

    <el-row :gutter="20" class="control-row" align="middle">
      <el-col :span="12">
        <el-steps :active="activeStep" align-center>
          <el-step title="Step 1" description="请输入参数 Code" />
          <el-step title="Step 2" description="已准备好进行常量折叠" />
        </el-steps>
      </el-col>
      <el-col :span="12" class="submit-col">
        <el-button
            type="primary"
            :disabled="activeStep !== 2"
            :loading="loading"
            @click="submitCode"
            size="large">
          提交
        </el-button>
      </el-col>
    </el-row>

    <CodeEdit v-model="code" />
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
</style>
