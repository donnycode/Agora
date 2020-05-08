//
//  VideoSession.swift
//  Agora
//
//  Created by donny on 4/27/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import Foundation
import AgoraRtcKit

class VideoSession: NSObject {
    enum SessionType {
        case local, remote
        
        var isLocal: Bool {
            switch self {
            case .local:  return true
            case .remote: return false
            }
        }
    }
    
    var uid: UInt
    var hostingView: VideoView!
    var canvas: AgoraRtcVideoCanvas
    var type: SessionType
    init(uid: UInt, type: SessionType = .remote) {
        self.uid = uid
        self.type = type
        
        hostingView = VideoView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        
        canvas = AgoraRtcVideoCanvas()
        canvas.uid = uid
        canvas.view = hostingView.videoView
        canvas.renderMode = .hidden

    }
}

extension VideoSession {
    static func localSession() -> VideoSession {
        return VideoSession(uid: 0, type: .local)
    }
    
    func updateInfo(resolution: CGSize? = nil, fps: Int? = nil, txQuality: AgoraNetworkQuality? = nil, rxQuality: AgoraNetworkQuality? = nil) {
    }
    
    func updateChannelStats(_ stats: AgoraChannelStats) {
        guard self.type.isLocal else {
            return
        }
    }
    
    func updateVideoStats(_ stats: AgoraRtcRemoteVideoStats) {
        guard !self.type.isLocal else {
            return
        }
    }
    
    func updateAudioStats(_ stats: AgoraRtcRemoteAudioStats) {
        guard !self.type.isLocal else {
            return
        }
    }
}


struct SearchRepositoriesResponse {
    let items: [VideoSession]
}
