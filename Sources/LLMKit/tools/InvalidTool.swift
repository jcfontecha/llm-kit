//
//  File.swift
//  
//
//  Created by 顾艳华 on 2023/6/23.
//

import Foundation



public class InvalidTool: BaseTool {
    let toolName: String
    
    public init(toolName: String) {
        self.toolName = toolName
    }
    
    public override func name() -> String {
        "invalid_tool"
    }
    
    public override func description() -> String {
        "Called when tool name is invalid."
    }
    
    public override func execute(args: String) async throws -> String {
        "\(toolName) is not a valid tool, try another one."
    }
    
    
}
