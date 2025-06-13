//
//  File.swift
//  
//
//  Created by 顾艳华 on 2023/6/29.
//

import Foundation
import AsyncHTTPClient
import Foundation
import NIOPosix


public class YoutubeLoader: BaseLoader {
    let videoId: String
    let language: String
    public init(videoId: String, language: String, callbacks: [BaseCallbackHandler] = []) {
        self.videoId = videoId
        self.language = language
        super.init(callbacks: callbacks)
    }
    public override func loadDocuments() async throws -> [Document] {
        
        let eventLoopGroup = ThreadManager.thread

        let httpClient = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
        defer {
            // it's important to shutdown the httpClient after all requests are done, even if one failed. See: https://github.com/swift-server/async-http-client
            try? httpClient.syncShutdown()
        }
        
        let info = await YoutubeHackClient.info(videoId: videoId, httpClient: httpClient)
        let metadata = ["source": self.videoId,
                        "title": info!.title,
                        "desc": info!.description,
                        "thumbnail": info!.thumbnail]
        var transcript_list = await YoutubeHackClient.list_transcripts(videoId: self.videoId, httpClient: httpClient)
        if transcript_list == nil {
            throw LLMKitError.LoaderError("Subtitle not exist")
        }
        if transcript_list!.generated_transcripts.isEmpty && transcript_list!.manually_created_transcripts.isEmpty {
//            return [Document(pageContent: "Content is empty.", metadata: metadata)]
            throw LLMKitError.LoaderError("Subtitle not exist")
        }
        var transcript = transcript_list!.find_transcript(language_codes: [self.language])
        if transcript == nil {
            let en_transcript = transcript_list!.manually_created_transcripts.first!.value
            transcript = en_transcript.translate(language_code: self.language)
        }
        let transcript_pieces = await transcript!.fetch()
        
        let text = transcript_pieces!.map {$0["text"]!}.joined(separator: " ")
        
        return [Document(pageContent: text, metadata: metadata)]
    
    }
    
    override func type() -> String {
        "Youtube"
    }
}
