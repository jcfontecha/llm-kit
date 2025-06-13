//
//  File.swift
//  
//
//  Created by 顾艳华 on 2023/9/6.
//

import Foundation
public class SequentialChain: DefaultChain {
    let chains: [DefaultChain]
    public init(chains: [DefaultChain], memory: BaseMemory? = nil, outputKey: String = "output", inputKey: String = "input", callbacks: [BaseCallbackHandler] = []) {
        self.chains = chains
        super.init(memory: memory, outputKey: outputKey, inputKey: inputKey, callbacks: callbacks)
    }
    public func predict(args: String) async throws -> [String: String] {
        var result: [String: String] = [:]
        var input: LLMResult? = LLMResult(llmOutput: args)
        for chain in self.chains {
//            assert(chain.outputKey != nil, "chain.outputKey must not be nil")
            if input != nil {
                input = await chain.execute(args: input!.llmOutput!).0
                result.updateValue(input!.llmOutput!, forKey: chain.outputKey)
            } else {
                print("A chain of SequentialChain fail")
            }
        }
        return result
    }
}
