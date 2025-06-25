<template>
  <div class="code-editor-wrapper">
    <div class="code-editor-header">
      <span class="code-editor-title">Code</span>
    </div>
    <div class="code-editor-container">
      <div class="line-numbers">
        <div v-for="n in lineCount" :key="n" class="line-number">{{ n }}</div>
      </div>
      <textarea
          class="code-area"
          :value="modelValue"
          @input="updateCode"
          @scroll="syncScroll"
          @keydown="handleTabKey"
          ref="codeArea"
          spellcheck="false"
          placeholder="在此输入Code..."
      ></textarea>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CodeEditor',
  props: {
    modelValue: {
      type: String,
      default: ''
    }
  },
  emits: ['update:modelValue'],
  data() {
    return {
      lineCount: 1
    }
  },
  methods: {
    updateCode(e) {
      this.$emit('update:modelValue', e.target.value);
      this.updateLineCount(e.target.value);
    },
    updateLineCount(text) {
      this.lineCount = (text || '').split('\n').length;
    },
    syncScroll(e) {
      const lineNumbers = this.$el.querySelector('.line-numbers');
      lineNumbers.scrollTop = e.target.scrollTop;
    },
    handleTabKey(e) {
      if (e.key === 'Tab') {
        e.preventDefault();

        const textarea = this.$refs.codeArea;
        const start = textarea.selectionStart;
        const end = textarea.selectionEnd;

        // 使用四个空格作为Tab
        const indent = '    ';

        // 获取当前值
        const currentValue = textarea.value;

        // 插入Tab到光标位置
        const newValue = currentValue.substring(0, start) + indent + currentValue.substring(end);

        // 发出更新事件
        this.$emit('update:modelValue', newValue);

        // 移动光标到插入后的位置
        this.$nextTick(() => {
          textarea.selectionStart = textarea.selectionEnd = start + indent.length;
        });
      }
    }
  },
  mounted() {
    this.updateLineCount(this.modelValue);
  }
}
</script>

<style scoped>
.code-editor-wrapper {
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 6px 16px rgba(0, 149, 211, 0.12);
  font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
  font-size: 14px;
  line-height: 20px;
  background-color: #f8f9fa;
  border: 1px solid #d0e8f2;
  transition: box-shadow 0.2s ease;
}

.code-editor-wrapper:hover {
  box-shadow: 0 8px 20px rgba(0, 149, 211, 0.16);
}

.code-editor-header {
  display: flex;
  align-items: center;
  padding: 12px 16px;
  background: linear-gradient(135deg, #4fc3f7, #00b0ff);
  color: white;
}

.code-editor-title {
  font-weight: 600;
  letter-spacing: 0.5px;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

.code-editor-container {
  display: flex;
  height: 400px;
  overflow: hidden;
  background-color: #ffffff;
}

.line-numbers {
  width: 50px;
  background-color: #f0f8ff;
  text-align: right;
  padding: 8px 0;
  overflow-y: hidden;
  user-select: none;
  border-right: 1px solid #e1f0fa;
}

.line-number {
  padding: 0 10px 0 0;
  color: #7ca8c2;
  font-size: 13px;
}

.code-area {
  flex: 1;
  resize: none;
  border: none;
  padding: 8px 12px;
  overflow-y: auto;
  white-space: pre;
  tab-size: 4;
  color: #2c3e50;
  background-color: #ffffff;
  font-family: inherit;
  font-size: inherit;
  line-height: inherit;
  transition: background-color 0.2s ease;
}

.code-area:focus {
  outline: none;
  background-color: #f9fdff;
}

.code-area::placeholder {
  color: #a0c6e0;
}
</style>
