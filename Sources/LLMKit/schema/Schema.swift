//
//  File.swift
//  
//
//  Created by 顾艳华 on 2023/8/31.
//

import Foundation
import OpenAIKit
// TODO - remove OpenAIKit

public class LLMResult {
    init(llmOutput: String? = nil, stream: Bool = false) {
        self.llmOutput = llmOutput
        self.stream = stream
    }
    
    public var llmOutput: String?
    
    public var stream: Bool
    
    public func setOutput() async throws {
        
    }
    public func getGeneration() -> AsyncThrowingStream<String?, Error>? {
        nil
    }
}

public class OpenAIResult: LLMResult {
    public let generation: AsyncThrowingStream<ChatStream, Error>?

    init(generation: AsyncThrowingStream<ChatStream, Error>? = nil, llmOutput: String? = nil) {
        self.generation = generation
        super.init(llmOutput: llmOutput, stream: generation != nil && llmOutput == nil)
    }
    
    public override func setOutput() async throws {
        if stream {
            llmOutput = ""
            for try await c in generation! {
                if let message = c.choices.first?.delta.content {
                    llmOutput! += message
                }
            }
        }
    }
    
    public override func getGeneration() -> AsyncThrowingStream<String?, Error> {
        return AsyncThrowingStream { continuation in    
            Task {
                do {
                    for try await c in generation! {
                        if let message = c.choices.first?.delta.content {
                            continuation.yield(message)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            
        }
    }
}
