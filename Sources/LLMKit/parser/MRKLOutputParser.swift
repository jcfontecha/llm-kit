//
//  File.swift
//  
//
//  Created by 顾艳华 on 2023/6/21.
//

import Foundation

public struct MRKLOutputParser: BaseOutputParser {
    public init() {}
    public func parse(text: String) -> Parsed {
        print(text.uppercased())
        if text.uppercased().contains(FINAL_ANSWER_ACTION) {
            return Parsed.finish(AgentFinish(final: text))
        }
        let pattern = "Action\\s*:[\\s]*(.*)[\\s]*Action\\s*Input\\s*:[\\s]*(.*)"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            print("❌ Invalid regex pattern: \(pattern)")
            return Parsed.error
        }
        
        if let match = regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
            
            let firstCaptureGroup = Range(match.range(at: 1), in: text).map { String(text[$0]) }
//            print(firstCaptureGroup!)
            
            
            let secondCaptureGroup = Range(match.range(at: 2), in: text).map { String(text[$0]) }
//            print(secondCaptureGroup!)
            guard let action = firstCaptureGroup, let input = secondCaptureGroup else {
                print("❌ Failed to extract action or input from match")
                return Parsed.error
            }
            return Parsed.action(AgentAction(action: action, input: input, log: text))
        } else {
            return Parsed.error
        }
    }
}
