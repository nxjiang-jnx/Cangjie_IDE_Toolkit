# 📦 Cangjie IDE Toolkit (仓颉语言代码分析工具)

🚀 本项目目标是仿照现代 IDE 功能，使用 **仓颉语言** 构建一个支持语法分析、语义处理与代码优化的后端工具，并搭配一个前端网页实现代码可视交互与分析操作。

---

## 📚 项目简介

本项目基于 [仓颉语言 std.ast 库](https://cangjie-lang.cn/docs) 提供的抽象语法树（AST）解析能力，实现了类似 IDE 的四大核心功能：

- ✍️ **代码签名提取**（`generateCodeSignature`）
- 🔁 **变量重命名重构**（`refactorVariable`）
- 🧾 **自动文档生成（结合 LLM）**（`generateDocument`）
- 🧮 **常量表达式折叠优化**（`foldConstant`）

并通过仓颉语言自建 HTTP 服务接口，为前端提供访问 API，最终在网页端实现一键调用功能。

---

## 🧩 功能概览

### 🧾 generateCodeSignature

- **功能**：提取所有函数、类、接口签名（包括内部成员）
- **技术要点**：
  - 解析 `FuncDecl`、`ClassDecl`、`InterfaceDecl` 结构
  - 自动处理继承关系、构造函数、返回类型等
  - 格式美观，按缩进与换行组织

---

### 🛠️ refactorVariable

- **功能**：安全地重命名某作用域下的变量标识符
- **支持路径**：
  - 顶层函数名 `funcName`
  - 类名 `ClassName`
  - 类中函数名 `ClassName.funcName`
- **技术要点**：
  - 识别变量引用语法树中的 `TokenKind.IDENTIFIER`
  - 确保不跨越作用域、不更改语义
  - 使用 AST + Token 替换方式进行

---

### 📄 generateDocument

- **功能**：为指定函数或类自动生成块注释文档
- **实现方式**：
  - 使用 DeepSeek V3 大模型 API 自动生成中文注释（约三行）
  - 通过语法树定位目标行，计算缩进
  - 直接在字符串层插入注释（仓颉语法树不支持注释节点）

📦 Prompt 示例：

```cangjie
"请帮我为下面的仓颉语言函数/类 \"${name}\" 生成简洁明了的功能说明，使用中文输出，并以 3 行左右文本完成：${content}"
```

### 🔬 foldConstant

功能：对 AST 中可计算的常量表达式进行折叠（优化）

技术要点：

使用递归下降方式重写 Expr 子树

支持加减乘除模和取负

保证原缩进结构，保留原始声明关键字与变量名

🧠 折叠示例：

```c
let a = 3 + 2 + 4   -->   let a = 9
let b = (1 + (2 * 3)) * 2   -->   let b = 14
```

## 🌐 项目架构

```bash
📁 src/
├── main.cj               # 主函数，启动 HTTP 服务
├── CJCodeTool.cj         # 四大核心函数实现
├── HttpServer.cj         # HTTP 路由与跨域处理封装
└── util/                 # 工具类与接口封装
```

HTTP 服务端口：127.0.0.1:8080

## 💻 前端界面

📄 页面采用 HTML + JavaScript 实现，核心结构：

✍️ 文本输入框：输入代码与调用指令

🧠 API 调用：向后端发送 POST 请求

📤 输出展示区：展示处理后的代码结果

## 🧪 测试与样例输入

每个函数均设计了全面测试样例，包括正常输入与非法输入（应返回 "ILLEGAL INPUT"）。测试覆盖：

✅ 作用域合法性

✅ 类型覆盖完整性

✅ 多层嵌套解析情况

✅ 各类语法边界条件

## 🧠 Bonus：Qwen3-1.7B 仓颉微调版 🤖

我们还额外完成了 自定义大模型微调任务，训练一个更熟悉仓颉语法的 LLM —— Qwen3-1.7B-cangjie：

### 📚 数据合成流程

整合 API 文档、官方教程、GitCode 示例

自动生成 QA 对话对、注释示例与语法结构转换

### 🔧 微调方式

使用 LoRA 技术对 Qwen3-1.7B 模型进行轻量微调

效果远优于 DeepSeek 默认模型，仓颉语法识别正确率更高

🎉 对比示例：

| DeepSeek 错误示例      | Qwen3-Cangjie 正确示例         |
| ---------------------- | ------------------------------ |
| `func a -> Int64 {}` ❌ | `func a(): Int64 {}` ✅         |
| 不识别编译方式 ❌       | 正确返回 `build.sh` 编译命令 ✅ |

## 👨‍💻 团队成员

| 姓名   | 学号     | 负责模块                                      |
| ------ | -------- | --------------------------------------------- |
| 程浚航 | 23230617 | 前端设计、后端通信、LLM 微调                  |
| 吴承儒 | 23230618 | generateCodeSignature、refactorVariable、测试 |
| 姜楠翔 | 23230610 | generateDocument、foldConstant、测试          |

## 📦 技术栈

🧠 仓颉语言（AST语法树分析）

🔗 HTTP 后端框架（自定义路由封装）

🌐 HTML + JS 前端调用

🤖 LLM：DeepSeek V3，Qwen3 LoRA 微调

🧪 自动测试：dump() + 多样样例集成测试

## 🛠️ 如何运行

1. 安装仓颉语言编译器与运行环境
2. 在 `src/` 目录中运行 `main.cj`：

```bash
cj run src/main.cj
```

3. 打开浏览器访问 http://127.0.0.1:8080

4. 粘贴代码与指令，点击提交即可使用工具！

## 📄 参考资料

- [仓颉语言文档](https://cangjie-lang.cn/docs)
- std.ast 包文档
- [抽象语法树 AST](https://zh.wikipedia.org/wiki/抽象语法树)
- [常量折叠 Wiki](https://zh.wikipedia.org/wiki/常量折叠)
- [DeepSeek 官方文档](https://www.deepseek.com/)

⭐ 如果你也对编译原理、语言设计、智能代码分析感兴趣，欢迎 star 本项目，关注更多相关仓颉语言实践案例！
