//
//  File.swift
//  
//
//  Created by 顾艳华 on 2023/6/16.
//

import Foundation

public protocol Tool {
    // Interface LLMKit tools must implement.
    
    func name() -> String
    // The unique name of the tool that clearly communicates its purpose.
    func description() -> String
    
    func execute(args: String) async throws -> String
}
open class BaseTool: NSObject, Tool {
    static let toolRequestId = "tool_req_id"
    static let toolCostKey = "cost"
    static let toolNameKey = "toolName"
    let callbacks: [BaseCallbackHandler]
    
    public init(callbacks: [BaseCallbackHandler] = []) {
        var cbs: [BaseCallbackHandler] = callbacks
        if LC.addTraceCallbak() && !cbs.contains(where: { item in item is TraceCallbackHandler}) {
            cbs.append(TraceCallbackHandler())
        }
        self.callbacks = cbs
    }

    func callStart(tool: BaseTool, input: String, reqId: String) {
        do {
            for callback in callbacks {
                try callback.on_tool_start(tool: tool, input: input, metadata: [BaseTool.toolRequestId: reqId, BaseTool.toolNameKey: tool.name()])
            }
        } catch {
            
        }
    }
    
    func callEnd(tool: BaseTool, output: String, reqId: String, cost: Double) {
        do {
            for callback in callbacks {
                try callback.on_tool_end(tool: tool, output: output, metadata: [BaseTool.toolRequestId: reqId, BaseTool.toolCostKey: "\(cost)", BaseTool.toolNameKey: tool.name()])
            }
        } catch {
            
        }
    }
    
    open func name() -> String {
        ""
    }
    
    open func description() -> String {
        ""
    }
    
    open func execute(args: String) async throws -> String {
        ""
    }
    
    open func run(args: String) async throws -> String {
        let reqId = UUID().uuidString
        var cost = 0.0
        let now = Date.now.timeIntervalSince1970
        callStart(tool: self, input: args, reqId: reqId)
        let result = try await execute(args: args)
        cost = Date.now.timeIntervalSince1970 - now
        callEnd(tool: self, output: result, reqId: reqId, cost: cost)
        return result
    }
    
}
