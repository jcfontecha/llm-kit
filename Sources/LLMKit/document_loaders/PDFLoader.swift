//
//  File.swift
//  
//
//  Created by 顾艳华 on 2023/7/28.
//

import Foundation

#if os(macOS) || os(iOS) || os(visionOS)
import PDFKit


public class PDFLoader: BaseLoader {
    let filePath: URL
    
    public init(filePath: URL, callbacks: [BaseCallbackHandler] = []) {
        self.filePath = filePath
        super.init(callbacks: callbacks)
    }
    
    public override func loadDocuments() async throws -> [Document] {
//        let nameAndExt = self.filePath.split(separator: ".")
//        let name = "\(nameAndExt[0])"
//        let ext = "\(nameAndExt[1])"
//        if let url = Bundle.main.url(forResource: name, withExtension: ext) {
        if let pdfDocument = PDFDocument(url: filePath) {
                var extractedText = ""
            let metadata = ["source": filePath.absoluteString]
                for pageIndex in 0 ..< pdfDocument.pageCount {
                    if let pdfPage = pdfDocument.page(at: pageIndex) {
                        if let pageContent = pdfPage.attributedString {
                            let pageString = pageContent.string
                            extractedText += "\n\(pageString)"
//                            print("💼\(pageContent)")
//                            print("🖥️\(pageString)")
                        }
                    }
                }
                
    //            print(extractedText)
                return [Document(pageContent: extractedText, metadata: metadata)]
            } else{
                throw LLMKitError.LoaderError("Parse PDF file fail.")
            }
//        } else {
//            throw LLMKitError.LoaderError("PDF not exist")
//        }
    }
    
    override func type() -> String {
        "PDF"
    }
}
#endif
