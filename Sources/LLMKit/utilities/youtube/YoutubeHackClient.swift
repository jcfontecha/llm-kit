//
//  File.swift
//  
//
//  Created by 顾艳华 on 2023/6/29.
//

import AsyncHTTPClient
import Foundation
import NIOPosix

public struct YoutubeHackClient {
    
    public static func list_transcripts(videoId: String, httpClient: HTTPClient) async -> TranscriptList? {
        return await TranscriptListFetcher(http_client: httpClient).fetch(videoId: videoId)
    }
    
    public static func info(videoId: String, httpClient: HTTPClient) async -> YoutubeInfo? {
        return await YoutubeInfoFetcher().fetch(http_client: httpClient, videoId: videoId)
    }
}
