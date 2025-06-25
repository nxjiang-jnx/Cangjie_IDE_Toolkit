package FINAL

import std.fs.File
import std.io.StringReader
import net.http.*
import encoding.json.*
import std.sync.*

class HttpServer {
    let server: Server
    public init(ip: String, port: UInt16) {
        server = ServerBuilder().addr(ip).port(port).build()
        println("Server started at http://${ip}:${port}")
    }

    public func route(route: String,
        callback: (req: HttpRequest, res: HttpResponseBuilder) -> Unit) {
            server.distributor.register(route, { context => 
            callback(context.request, context.responseBuilder)
        })
    }

    public func start() {
        server.serve()
    }
}

main() {
    let server = HttpServer("127.0.0.1", 8080)

    // 处理生成代码签名
    server.route("/GenerateCodeSignature", { req, res => 
        handleRequest(req, res, { json =>
            let code = json.get("code").getOrThrow().asString().getValue()

            println("Received code:")
            println(code)

            let future = spawn { =>
                println("Executing generateCodeSignature in a new thread")
                let temp = CJCodeTool.generateCodeSignature(code)
                return temp
            }

            var response = ""
            response = future.get()
            println(response)

            let jsonData = JsonObject()
            jsonData.put("response", JsonString(response))
            return jsonData
        })
    })

    // 处理变量重构
    server.route("/RefactorVariable", { req, res => 
        handleRequest(req, res, { json =>
            let code = json.get("code").getOrThrow().asString().getValue()
            let path = json.get("path").getOrThrow().asString().getValue()
            let oldName = json.get("oldName").getOrThrow().asString().getValue()
            let newName = json.get("newName").getOrThrow().asString().getValue()

            let future = spawn { =>
                println("Executing refactorVariable in a new thread")
                return CJCodeTool.refactorVariable(code, path, oldName, newName)
            }

            var response = ""
            response = future.get()
            println(response)

            let jsonData = JsonObject()
            jsonData.put("response", JsonString(response))
            return jsonData
        })
    })

    // 处理文档生成
    server.route("/GenerateDocument", { req, res => 
        handleRequest(req, res, { json =>
            let code = json.get("code").getOrThrow().asString().getValue()
            let path = json.get("path").getOrThrow().asString().getValue()

            let future = spawn { =>
                println("Executing generateDocument in a new thread")
                return CJCodeTool.generateDocument(code, path)
            }
            
            var response = ""
            response = future.get()
            println(response)

            let jsonData = JsonObject()
            jsonData.put("response", JsonString(response))
            return jsonData
        })
    })

    // 处理常量折叠
    server.route("/FoldConstant", { req, res => 
        handleRequest(req, res, { json =>
            let code = json.get("code").getOrThrow().asString().getValue()
            let future = spawn { =>
                println("Executing foldConstant in a new thread")
                return CJCodeTool.foldConstant(code)
            }

            var response = ""
            response = future.get()
            println(response)

            let jsonData = JsonObject()
            jsonData.put("response", JsonString(response))
            return jsonData
        })
    })

    server.start()
}

// 统一请求处理函数
func handleRequest(req: HttpRequest, res: HttpResponseBuilder,
    handler: (JsonObject) -> JsonObject) {

    let headers = HttpHeaders()
    headers.add("Content-Type", "application/json;charset=utf-8")
    headers.add("Access-Control-Allow-Origin", "*")
    headers.add("Access-Control-Allow-Methods", "POST, OPTIONS")
    headers.add("Access-Control-Allow-Headers", "Content-Type")
    
    if (req.method == "OPTIONS") {
        res.status(200).setHeaders(headers).body("")
        return
    }
    
    if (req.method != "POST") {
        sendErrorResponse(res, 405, "Method Not Allowed")
        return
    }

    try {
        let content = StringReader(req.body).readToEnd()
        let json = JsonValue.fromStr(content).asObject()
        let response = handler(json)
        res.status(200).setHeaders(headers).body(response.toJsonString())
    } catch (e: Exception) {
        sendErrorResponse(res, 400, "Bad Request: ${e.toString()}")
    }
}

// 错误响应发送函数
func sendErrorResponse(res: HttpResponseBuilder, status: Int, message: String) {
    let headers = HttpHeaders()
    headers.add("Content-Type", "application/json;charset=utf-8")
    headers.add("Access-Control-Allow-Origin", "*")
    headers.add("Access-Control-Allow-Methods", "POST, OPTIONS")
    headers.add("Access-Control-Allow-Headers", "Content-Type")
    
    let error = JsonObject()
        
    error.put("code", JsonInt(status))
    error.put("message", JsonString(message))

    println("sendErrorResponse: ${status}, ${message}")
    
    res.status(UInt16(status))
        .setHeaders(headers)
        .body(error.toJsonString())
}