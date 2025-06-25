package FINAL

import std.ast.*
import std.collection.*
import std.core.*
import std.io.StringReader
import std.time.Duration
import encoding.json.*
import net.http.*
import net.tls.*
import std.math.*
import std.math.numeric.*

class CJCodeTool {
    public init() {
        /********** generateCodeSignature test by wcr **********/
        // println(generateCodeSignature("func test1(a: Int64, b: String) { \n let a = 1 \n let b = 2 \n } \n private func test2(): Int64 {\n let a = 1 \n let b = 2 \n return a + b \n}"))
        // println(generateCodeSignature("private func test2(): Int64 { let a = 1 \n let b = 2 \n return a + b }"))
        // println(generateCodeSignature("class c <: I { \n private let a = 1 \n public var b = 2 \n public func test1(a: Int64, b: String) { \n let a = 1 \n let b = 2 \n } \n private func test2(): Int64 {\n let a = 1 \n let b = 2 \n return a + b \n} \n}"))
        // println(generateCodeSignature("interface I1 {\n    mut prop size: Int64\n}\n\nclass C <: I1 {\n    private var mySize = 0\n\n    public mut prop size: Int64 {\n        get() {\n            mySize\n        }\n        set(value) {\n            mySize = value\n        }\n    }\n\n    public func getSize() {\n        mySize\n    }\n}\n\npublic func testC() {\n    let a: I1 = C()\n    a.size = 5\n    println(a.size)\n}"))
        // println(generateCodeSignature("interface I <: I1 & I2 {\n    mut prop size: Int64\n}\n"))
        // println(generateCodeSignature("class MyInt <: Addable & Subtractable {var value = 0 \n public func add(other: Int64): Int64 { \n value + other \n }\n public func sub(other: Int64): Int64 { \n value - other\n }\n}"))
        // println(generateCodeSignature("class Rectangle { \n let width: Int64 \n public init(width: Int64) {\n this.width = width\n}}"))

        /********** generateDocument test by jnx **********/
        // 函数名
        // println(generateDocument("func test1(a: Int64, b: String) {\n\tlet a = 1\n\tlet b = 2\n}\nprivate func test2(): Int64 {\n\tlet a = 1\n\tlet b = 2\n\treturn a + b\n}","test2"))
        // 类名
        // println(generateDocument("class c <: I {\n\tprivate let a = 1\n\tpublic var b = 2\n\tpublic func test1(a: Int64, b: String) {\n\t\tlet a = 1\n\t\tlet b = 2\n\t}\n\tprivate func test2(): Int64 {\n\t\tlet a = 1\n\t\tlet b = 2\n\t\treturn a + b\n\t}\n}","c"))
        // 类名.函数名
        // println(generateDocument("class c <: I {\n\tprivate let a = 1\n\tpublic var b = 2\n\tpublic func test1(a: Int64, b: String) {\n\t\tlet a = 1\n\t\tlet b = 2\n\t}\n\tprivate func test2(): Int64 {\n\t\tlet a = 1\n\t\tlet b = 2\n\t\treturn a + b\n\t}\n}","c.test2"))
        // ILLEGAL INPUT
        // println(generateDocument("class c <: I {\n\tprivate let a = 1\n\tpublic var b = 2\n\tpublic func test1(a: Int64, b: String) {\n\t\tlet a = 1\n\t\tlet b = 2\n\t}\n\tprivate func test2(): Int64 {\n\t\tlet a = 1\n\t\tlet b = 2\n\t\treturn a + b\n\t}\n}","c.test3"))
    
        /********** refactorVariable test by wcr **********/
        //println(refactorVariable("func test1(a: Int64, b: String) { \n let a = 1 \n let b = 2 \n } \n private func test2(): Int64 {\n let a = 1 \n let b = 2 \n return a + b \n}","test1","a","c"))
        // println(refactorVariable("class test {\n private let a = 1 \n private func add():Int64 {\n var b = 0\n return a + b \n } \n } \n private func test2(): Int64 {\n let a = 1 \n let b = 2 \n return a + b \n}","test.add","a","c"))
        // println(refactorVariable("class test {\n private let a = 1 \n private func add():Int64 {\n var b = 0\n return a + b \n } \n } \n private func test2(): Int64 {\n let a = 1 \n let b = 2 \n return a + b \n}","test","a","c"))
        // println(refactorVariable("class test {\n private let a = 1 \n private func add():Int64 {\n var b = 0\n return a + b \n } \n } \n private func test2(): Int64 {\n let a = 1 \n let b = 2 \n return a + b \n}","test2","a","c"))
    
        /********** foldConstant test by jnx **********/
        // println(foldConstant("func test1(a: Int64, b: String) {\n\tlet a = 1+2\n}"))
        // println(foldConstant("func test1(a: Int64, b: String) {\n\tlet a = 1+2+3*2\n\tvar b = 2\n}\n"))
        // println(foldConstant("let a = 1 + 1"))
        // println(foldConstant("class test {\n private let a = 1 + 2 \n private func add():Int64 {\n var b = 0.1 + 0.6\n return a + b \n } \n } \n private func test2(): Int64 {\n let a = 1 \n let b = 2 \n return a + b \n}"))
    }

    static func generateCodeSignature(code: String): String {
        let declTokens = cangjieLex(code)
        var res = ""
        var decl : Decl
        var index : Int64 = 0
        do {
            try {
                (decl, index) = parseDeclFragment(declTokens, startFrom: index)
                if (decl is FuncDecl) {
                    res += generateFuncSignature(decl)
                    res += "\n\n"
                }
                else if (decl is ClassDecl) {
                    res += generateClassSignature(decl)
                    res += "\n\n" 
                }   
                else if (decl is InterfaceDecl) {
                    res += generateInterfaceSignature(decl)
                    res += "\n\n"
                }
            }
            catch (e: ParseASTException){
                return "ILLEGAL INPUT"
            }
        } while (index < declTokens.size)
        
        return res
    }

    static func refactorVariable(code: String, path: String, oldName: String, newName: String): String {
        let declTokens = cangjieLex(code)
        var decl : Decl
        var index : Int64 = 0
        var found = false
        var res : Tokens = quote()

        // 先寻找目标声明
        do {
            try {
                (decl, index) = parseDeclFragment(declTokens, startFrom: index)
                if (found) {
                    res += decl.toTokens()
                    continue
                }
                if (decl is FuncDecl) {
                    if (decl.identifier.toTokens().toString() == path) {
                        // 函数名
                        res += alternateFuncIdentifier(FuncDecl(decl.toTokens()), oldName, newName)
                        found = true
                        continue
                    }
                    else {
                        res += decl.toTokens()
                    }
                } else if (decl is ClassDecl) {
                    if (decl.identifier.toTokens().toString() == path) {
                        // 类名
                        res += alternateClassIdentifier(ClassDecl(decl.toTokens()), oldName, newName)
                        found = true
                        continue
                    }
                    if (ClassDecl(decl.toTokens()).superTypes.size > 0) {
                        res.append(quote($(decl.keyword) $(decl.identifier) <: $(ClassDecl(decl.toTokens()).superTypes){))
                    }
                    else {
                        res.append(quote($(decl.keyword) $(decl.identifier){))
                    }
                    for (i in 0 .. ClassDecl(decl.toTokens()).body.decls.size) {
                        let subDecl = ClassDecl(decl.toTokens()).body.decls[i]
                        if (subDecl is FuncDecl) {
                            let fullPath = decl.identifier.toTokens().toString() + "." + subDecl.identifier.toTokens().toString()
                            if (fullPath == path) {
                                // 类名.函数名
                                res += alternateFuncIdentifier(FuncDecl(subDecl.toTokens()), oldName, newName)
                                found = true
                            }
                            else {
                                res += subDecl.toTokens()
                            }
                            continue
                        }
                        res += subDecl.toTokens()
                    }
                    res.append(quote(}))
                } else {
                    res += decl.toTokens()
                }
            } catch (e: ParseASTException){
                return "ILLEGAL INPUT"
            }
        } while (index < declTokens.size)

        if (!found) {
            return "ILLEGAL INPUT" 
        }

        index = 0
        var resString = ""
        do {
            (decl, index) = parseDeclFragment(res, startFrom: index)
            resString += decl.toTokens().toString()
        } while (index < res.size)

        return resString
    }

    static func generateDocument(code: String, path: String): String {
        let declTokens = cangjieLex(code)
        var decl : Decl
        var targetDecl : Decl = FuncDecl()
        var index : Int64 = 0
        var found = false
        var lines = ArrayList<String>(code.split("\n"))

        // 先寻找目标声明
        do {
            try {
                (decl, index) = parseDeclFragment(declTokens, startFrom: index)
                if (decl is FuncDecl && decl.identifier.toTokens().toString() == path) {
                    // 函数名
                    targetDecl = decl
                    found = true
                    break
                } else if (decl is ClassDecl) {
                    if (decl.identifier.toTokens().toString() == path) {
                        // 类名
                        targetDecl = decl
                        found = true
                        break
                    }

                    for (i in 0 .. ClassDecl(decl.toTokens()).body.decls.size) {
                        let subDecl = ClassDecl(decl.toTokens()).body.decls[i]
                        if (subDecl is FuncDecl) {
                            let fullPath = decl.identifier.toTokens().toString() + "." + subDecl.identifier.toTokens().toString()
                            if (fullPath == path) {
                                // 类名.函数名
                                targetDecl = subDecl
                                found = true
                                break
                            }
                        }
                    }
                }
            } catch (e: ParseASTException){
                return "ILLEGAL INPUT"
            }
        } while (index < declTokens.size)

        if (!found) {
            return "ILLEGAL INPUT"
        }

        // 获取插入行号
        let lineNumber = Int64(targetDecl.beginPos.line)
        // 设置缩进
        let originalLine = lines[lineNumber]
        var indent = ""
        for (ch in originalLine) {
            if (ch == 32) {
                indent += " "
            } else if (ch == 9) {
                indent += "\t"
            } else {
                break
            }
        }

        // 调用 DeepSeek API 生成文档
        let doc = callLLM(path, targetDecl.toTokens().toString())

        // 生成块注释
        let docLines = doc.split("\n")
        var commentLines = ArrayList<String>()
        commentLines.append(indent + "/*")
        for (line in docLines) {
            commentLines.append(indent + line)
        }
        commentLines.append(indent + "*/")

        // 直接插入注释
        for (i in 0 .. commentLines.size) {
            lines.insert(lineNumber + i, commentLines[i])
        }
        // 重新拼接代码
        var result = ""
        for (line in lines) {
            result += line + "\n"
        }
        
        return result
    }

    static func foldConstant(code: String): String {
        let declTokens = cangjieLex(code)
        var decl : Decl
        var index : Int64 = 0
        var res : Tokens = quote()

        do {
            try {
                (decl, index) = parseDeclFragment(declTokens, startFrom: index)
                if (decl is FuncDecl) {
                    res += foldFuncDecl(FuncDecl(decl.toTokens())).toTokens()
                } else if (decl is ClassDecl) {
                    var res1 = quote()
                    if (ClassDecl(decl.toTokens()).superTypes.size > 0) {
                        res1.append(quote($(decl.keyword) $(decl.identifier) <: $(ClassDecl(decl.toTokens()).superTypes){))
                    }
                    else {
                        res1.append(quote($(decl.keyword) $(decl.identifier){))
                    }
                    for (i in 0 .. ClassDecl(decl.toTokens()).body.decls.size) {
                        let subDecl = ClassDecl(decl.toTokens()).body.decls[i]
                        if (subDecl is FuncDecl) {
                            res1 += foldFuncDecl(FuncDecl(subDecl.toTokens())).toTokens()
                        } else if (subDecl is VarDecl) {
                            res1 += foldVarDecl(VarDecl(subDecl.toTokens())).toTokens()
                        } else {
                            res1 += subDecl.toTokens()
                        }
                    }
                    res1.append(quote(}))
                    res.append(ClassDecl(res1).toTokens())
                } else if (decl is VarDecl) {
                    res += foldVarDecl(VarDecl(decl.toTokens())).toTokens()
                } else {
                    res += decl.toTokens()
                }
            } catch (e: ParseASTException) {
                return "ILLEGAL INPUT"
            }
        } while (index < declTokens.size)

        return res.toString()
    }

    // for generateCodeSignature by wcr
    static func generateFuncSignature(code: Decl): String {
        let declTokens = code.toTokens()
        let funcDecl = FuncDecl(declTokens)
        let results = ArrayList<Tokens>()

        //构造函数签名
        if (funcDecl.keyword.toTokens().toString() == "init") {
            results.append(quote($(funcDecl.modifiers) $(funcDecl.keyword) ($(funcDecl.funcParams)) {))
        }
        else {
            results.append(quote($(funcDecl.modifiers) $(funcDecl.keyword) $(funcDecl.identifier) ($(funcDecl.funcParams))))
        }
        try {
            results.append(quote(: $(funcDecl.declType)))
        }
        catch (e: ASTException){
            
        }

        var res : String = ""
        for (result in results) {
            res += result.toString()
        }

        return res
    }

    static func generateVarSignature(code: Decl): String{
        let declTokens = code.toTokens()
        let varDecl = VarDecl(declTokens)
        let results = ArrayList<Tokens>()

        
        try {
            results.append(quote($(varDecl.modifiers) $(varDecl.keyword) $(varDecl.identifier): $(varDecl.declType)))
        }
        catch (e: ASTException){
            results.append(quote($(varDecl.modifiers) $(varDecl.keyword) $(varDecl.identifier)))
        }

        var res = ""
        for (result in results) {
            res += result.toString()
        }
        return res;
    }

    static func generatePropSignature(code: Decl): String{
        let declTokens = code.toTokens()
        let propDecl = PropDecl(declTokens)
        let results = ArrayList<Tokens>() 

        
        try {
            results.append(quote($(propDecl.modifiers) $(propDecl.keyword) $(propDecl.identifier): $(propDecl.declType)))
        }
        catch (e: ASTException){
            results.append(quote($(propDecl.modifiers) $(propDecl.keyword) $(propDecl.identifier)))
        }

        var res = ""
        for (result in results) {
            res += result.toString() 
        }
        return res
    }

    static func generateClassSignature(code: Decl): String{
        let declTokens = code.toTokens()
        let classDecl = ClassDecl(declTokens)
        let results = ArrayList<Tokens>()

        if (classDecl.superTypes.size > 0) {
            results.append(quote($(classDecl.keyword) $(classDecl.identifier) <: $(classDecl.superTypes){))
        }
        else{
            results.append(quote($(classDecl.keyword) $(classDecl.identifier){))
        }
        for (i in 0..classDecl.body.decls.size){
            if (classDecl.body.decls[i] is FuncDecl){
                results.append(cangjieLex(generateFuncSignature(classDecl.body.decls[i])))
            }
            else if (classDecl.body.decls[i] is VarDecl){
                results.append(cangjieLex(generateVarSignature(classDecl.body.decls[i])))
            }
            else if (classDecl.body.decls[i] is PropDecl){
                results.append(cangjieLex(generatePropSignature(classDecl.body.decls[i])))
            }
        }
        
        var res = ""
        var flag = 0
        for (result in results) {
            if (flag == 0) {
                flag++
                res += result.toString()
                res += "\n"
                continue
            }
            else if (flag == results.size - 1){
                flag++
                res += "    "
                res += result.toString()
                res += "\n"
                res += "}"
                continue
            }
            else {
                flag++
                res += "    "
                res += result.toString()
                res += "\n\n"
            }
        }
        return res
    }

    static func generateInterfaceSignature(code: Decl): String{
        let declTokens = code.toTokens()
        let interfaceDecl = InterfaceDecl(declTokens)
        let results = ArrayList<Tokens>()

        if (interfaceDecl.superTypes.size == 0){
            results.append(quote($(interfaceDecl.keyword) $(interfaceDecl.identifier){))
        }
        else {
            results.append(quote($(interfaceDecl.keyword) $(interfaceDecl.identifier) <: $(interfaceDecl.superTypes){))
        }
        for (i in 0..interfaceDecl.body.decls.size){
            results.append(interfaceDecl.body.decls[i].toTokens())
        }
        
        var res = ""
        var flag = 0
        for (result in results) {
            if (flag == 0) {
                flag++
                res += result.toString()
                res += "\n"
                continue
            }
            else if (flag == results.size - 1){
                flag++
                res += "    "
                res += result.toString()
                res += "\n"
                res += "}"
                continue
            }
            else {
                flag++
                res += "    "
                res += result.toString()
                res += "\n\n"
            }
        }
        return res
    }

    // for generateDocument by jnx
    static func callLLM(name: String, content: String): String {
        let llm = LLM(
            url: "https://api.siliconflow.cn/v1/chat/completions",
            key: "sk-ujrvulmnsdiolckgtjklhqbwbkfudgeglrkxxbzljagbtrnk",
            model: "deepseek-ai/DeepSeek-V2.5",
            context: false // 此处关闭上下文记忆，避免交叉污染
        )

        let prompt = "请帮我为下面的仓颉语言函数/类 \"${name}\" 生成简洁明了的功能说明，使用中文输出，并以 3 行左右文本完成：\n\n${content}"
        let output = llm.chat(input: prompt)
        return output.toString()
    }

    // for foldConstant by jnx
    static func foldFuncDecl(funcDecl: FuncDecl) : Decl {
        for (i in 0 .. funcDecl.block.nodes.size) {
            let node = funcDecl.block.nodes[i]
            if (node is VarDecl) {
                let newDecl = foldVarDecl(VarDecl(node.toTokens()))
                funcDecl.block.nodes[i] = newDecl
            } else if (node is ReturnExpr) {
                let newRet = foldReturn(ReturnExpr(node.toTokens()))
                funcDecl.block.nodes[i] = newRet
            }
        }
        return funcDecl
    }

    static func foldVarDecl(decl: VarDecl) : Decl{
        decl.expr = foldExpr(decl.expr)
        return decl 
    }

    static func foldReturn(ret: ReturnExpr) : Expr{
        ret.expr = foldExpr(ret.expr)
        return ret
    }

    static func foldExpr(expr: Expr): Expr {
        if (expr is BinaryExpr) {
            return foldBinary(BinaryExpr(expr.toTokens()))
        } else if (expr is UnaryExpr) {
            return foldUnary(UnaryExpr(expr.toTokens()))
        } else if (expr is ParenExpr) {
            let inner = foldExpr(ParenExpr(expr.toTokens()))
            return ParenExpr(inner.toTokens())
        } else {
            return expr // 直接返回常量或变量引用
        }
    }

    static func foldBinary(expr: BinaryExpr): Expr {
        // 折叠二元表达式
        let left = foldExpr(expr.leftExpr)
        let right = foldExpr(expr.rightExpr)

        if (!(left is LitConstExpr) || !(right is LitConstExpr)) {
            // 至少一边不是常量，直接返回原表达式
            return BinaryExpr(quote($(left) $(expr.op) $(right))) 
        }

        let lval = LitConstExpr(left.toTokens())
        let rval = LitConstExpr(right.toTokens())

        let result = computeBinary(lval, rval, expr.op)
        return LitConstExpr(result)
    }

    static func foldUnary(expr: UnaryExpr): Expr {
        let inner = foldExpr(expr.expr)
        if (!(inner is LitConstExpr)) {
            return UnaryExpr(quote($(expr.op) $(inner)))
        }

        let val = LitConstExpr(inner.toTokens())
        let result = computeUnary(val, expr.op)
        return LitConstExpr(result)
    }

    static func computeBinary(lv: LitConstExpr, rv: LitConstExpr, op: Token): Tokens {
        var typ = lv.literal.kind
        var opr = op.toTokens().toString()

        if (typ == TokenKind.INTEGER_LITERAL) {
            var l = Decimal(lv.literal.value).toInt64()
            var r = Decimal(rv.literal.value).toInt64()

            if (opr == "+") { 
                return (l + r).toTokens()
            } else if (opr == "-") {
                return (l - r).toTokens()
            } else if (opr == "*") {
                return (l * r).toTokens()
            } else if (opr == "/") {
                return (l / r).toTokens()
            } else if (opr == "%") {
                return (l % r).toTokens()
            } else {
                return "".toTokens()
            }
        } else if (typ == TokenKind.FLOAT_LITERAL) {
            var l = Decimal(lv.literal.value).toFloat64()
            var r = Decimal(rv.literal.value).toFloat64()

            if (opr == "+") { 
                return (l + r).toTokens()
            } else if (opr == "-") {
                return (l - r).toTokens()
            } else if (opr == "*") {
                return (l * r).toTokens()
            } else if (opr == "/") {
                return (l / r).toTokens()
            } else {
                return "".toTokens()
            }
        } else {
            return "".toTokens()
        }
    }

    static func computeUnary(v: LitConstExpr, op: Token): Tokens {
        let typ = v.literal.kind
        let opr = op.toTokens().toString()

        if (opr != "-") {
            return "".toTokens()
        }

        if (typ == TokenKind.INTEGER_LITERAL) {
            let val = Decimal(v.literal.value).toInt64()
            return (-val).toTokens()
        } else if (typ == TokenKind.FLOAT_LITERAL) {
            let val = Decimal(v.literal.value).toFloat64()
            return (-val).toTokens()
        } else {
            return "".toTokens()
        }
    }

    // added by wcr, used to refactor variable name
    static func alternateFuncIdentifier(funcDecl : FuncDecl, oldName: String, newName: String): Tokens {
        // 遍历函数体中的所有标识符
        var res : Tokens = quote()
        for ( t in funcDecl.toTokens()) {
            if (t.kind == TokenKind.IDENTIFIER && t.toTokens().toString() == oldName) {
                // 替换标识符
                res += cangjieLex(newName, true).toTokens()
            } else {
                res += t.toTokens()
            }
                
        }
        return FuncDecl(res).toTokens()
    }

    static func alternateClassIdentifier(classDecl : ClassDecl, oldName: String, newName: String): Tokens {
        // 遍历函数体中的所有标识符
        var res : Tokens = quote() 
        for ( t in classDecl.toTokens()) {
            if (t.kind == TokenKind.IDENTIFIER && t.toTokens().toString() == oldName) {
                // 替换标识符
                res += cangjieLex(newName, true).toTokens() 
            } 
            else {
                res += t.toTokens()
            }
        }
        return ClassDecl(res).toTokens()
    }
}

enum Role <: ToString {
    I | AI | System
    public func toString() {
        match (this) {
            case I => 'user'
            case AI => 'assistant'
            case System => 'system'
        }
    }
}

// added by jnx, used to call LLM API
class LLM {
    let client: Client
    let history = StringBuilder()
    public LLM(let url!: String, let key!: String, let model!: String,
        let context!: Bool = false) {
        var config = TlsClientConfig()
        config.verifyMode = TrustAll
        client = ClientBuilder()
            .tlsConfig(config)
            .readTimeout(Duration.Max) // AI 服务响应有时候比较慢，这里设置为无限等待
            .build()
    }

    func encode(role: Role, content: String) {
        '{"role":"${role}","content":${JsonString(content)}}'
    }

    func send(input: String, stream!: Bool = false) {
        let message = encode(I, input)
        let content =
            '{"model":"${model}","messages":[${history}${message}],"stream":${stream}}'
        if (context) { history.append(message) }
        let request = HttpRequestBuilder()
            .url(url)
            .header('Authorization', 'Bearer ${key}')
            .header('Content-Type', 'application/json')
            .header('Accept', if (stream) {
                'text/event-stream'
            } else {
                'application/json'
            })
            .body(content)
            .post()
            .build()
        client.send(request)
    }

    func parse(text: String, stream!: Bool = false) {
        let json = JsonValue.fromStr(text).asObject()
        let choices = json.getFields()['choices'].asArray()
        // 流式和非流式情况下，这个字段名称不同
        let key = if (stream) { 'delta' } else { 'message' }
        let message = choices[0].asObject().getFields()[key].asObject()
        let content = message.getFields()['content'].asString().getValue()
        return content
    }

    // 流式对话
    public func chat(input: String, task!: (String) -> Unit = {o => print(o)}) {
        let response = send(input, stream: true)
        let output = StringBuilder()
        let buffer = Array<Byte>(1024 * 8, item: 0)
        var length = response.body.read(buffer)
        while (length != 0) {
            let text = String.fromUtf8(buffer[..length])
            const INDEX = 6
            for (line in text.split('\n', removeEmpty: true)) {
                if (line.size > INDEX && line[INDEX] == b'{') {
                    let json = line[INDEX..line.size]
                    let slice = parse(json, stream: true)
                    if (context) { output.append(slice) }
                    task(slice)
                }
            }
            length = response.body.read(buffer)
        }
        if (context) {
            history.append(',${encode(AI, output.toString())},')
        }
    }

    // 非流式
    public func chat(input!: String) {
        let response = send(input)
        let output = StringReader(response.body).readToEnd() |> parse
        if (context) {
            history.append(',${encode(AI, output)},')
        }
        return output
    }

    public func preset(context: Array<(Role, String)>) {
        history.reset()
        for ((role, message) in context) {
            history.append(encode(role, message) + ',')
        }
    }

    public func reset() {
        history.reset()
    }
}

