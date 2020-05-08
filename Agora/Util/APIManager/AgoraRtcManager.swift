//
//  AgoraManager.swift
//  Agora
//
//  Created by donny on 4/25/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import Foundation
import AgoraRtcKit


final class AgoraRtcManager : NSObject{
    private static var agoraRtcManager:AgoraRtcManager!
    internal static let defaultInstance:AgoraRtcManager = {
        agoraRtcManager = AgoraRtcManager()
        return agoraRtcManager
    }()
    
    typealias LocalVideoCallBack = ((RemotStatus, [VideoSession]) -> Void)
    typealias RemoteVideoCallBack = ((RemotStatus, [VideoSession]) -> Void)
    typealias MuteAudioCallBack = ((RemotStatus, Bool) -> Void)
    
    private let AppID: String = "4f963ceffccc48eb9da641572481258c"
    private let Token: String? = nil
    private var agoraRtcKit: AgoraRtcEngineKit!
    
    private(set) var isRemoteVideoRender: Bool = true
    private(set) var isLocalVideoRender: Bool = false
    private(set) var isStartCalling: Bool = true
    private let maxVideoSession = 4
    
    private(set) var account:Account?
    private var localVideoCallBack:LocalVideoCallBack?
    private var remoteVideoCallBack:RemoteVideoCallBack?
    private var muteAudioCallBack:MuteAudioCallBack?
    
    private var videoSessions = [VideoSession]() {
        didSet {
    
        }
    }
    
    override init() {
        super.init()
        initializeAgoraEngine()
    }
    
    
    func joinChannel(account:Account,
                  localVideoCallBack:@escaping LocalVideoCallBack,
                  remoteVideoCallBack:@escaping RemoteVideoCallBack,
                  muteAudioCallBack:@escaping MuteAudioCallBack) {
        self.account = account
        self.localVideoCallBack = localVideoCallBack
        self.remoteVideoCallBack = remoteVideoCallBack
        self.muteAudioCallBack = muteAudioCallBack
        setupVideo()
        addLocalSession()
        joinChannel()
    }
    
    func muteLocalAudioStream(isMuted:Bool) {
        agoraRtcKit.muteLocalAudioStream(isMuted)
    }
    
    func switchLocalVideoCamera() {
        agoraRtcKit.switchCamera()
    }

    func addLocalSession() {
        let localSession = VideoSession.localSession()
        videoSessions.append(localSession)
        agoraRtcKit.setupLocalVideo(localSession.canvas)
    }
    
     private func initializeAgoraEngine() {
         agoraRtcKit = AgoraRtcEngineKit.sharedEngine(withAppId: AppID, delegate: self)
     }
     
     private func setupVideo() {
         agoraRtcKit.enableVideo()
         agoraRtcKit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(
             size: AgoraVideoDimension640x360,
             frameRate: .fps15,
             bitrate: AgoraVideoBitrateStandard,
             orientationMode: .adaptative))
     }
     
     private func joinChannel() {
        agoraRtcKit.setDefaultAudioRouteToSpeakerphone(true)
        print(account!.channelName!)
        agoraRtcKit.joinChannel(byToken: Token, channelId: account!.channelName!, info: nil, uid: 0) { [unowned self] (channel, uid, elapsed) -> Void in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.isLocalVideoRender = true
                strongSelf.localVideoCallBack!(.success, strongSelf.videoSessions)
            }
        }
         isStartCalling = true
         UIApplication.shared.isIdleTimerDisabled = true
        
     }
    
    func leaveChannel() {
        agoraRtcKit.setupLocalVideo(nil)
        agoraRtcKit.leaveChannel(nil)
        videoSessions.removeAll()
        UIApplication.shared.isIdleTimerDisabled = false
    }

    
    func videoSession(of uid: UInt) -> VideoSession {
        if let fetchedSession = getSession(of: uid) {
            return fetchedSession
        } else {
            let newSession = VideoSession(uid: uid)
            videoSessions.append(newSession)
            return newSession
        }
    }
    
    func getSession(of uid: UInt) -> VideoSession? {
        for session in videoSessions {
            if session.uid == uid {
                return session
            }
        }
        return nil
    }
}


extension AgoraRtcManager:  AgoraRtcEngineDelegate {

   
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStateChangedOfUid uid: UInt, state: AgoraVideoRemoteState, reason: AgoraVideoRemoteStateReason, elapsed: Int) {
        
        print("state \(state)")
        let remoteSession = videoSession(of: uid)
        agoraRtcKit.setupRemoteVideo(remoteSession.canvas)
        remoteVideoCallBack!(.success ,videoSessions)
    }
    
    
    // user offline
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        var indexToDelete: Int?
        for (index, session) in videoSessions.enumerated() where session.uid == uid {
            indexToDelete = index
            break
        }
        
        if let indexToDelete = indexToDelete {
            let deletedSession = videoSessions.remove(at: indexToDelete)
            deletedSession.hostingView.removeFromSuperview()
            deletedSession.canvas.view = nil
            remoteVideoCallBack!(.success ,videoSessions)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
        isRemoteVideoRender = !muted
        muteAudioCallBack!(.success, muted)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        print("did occur warning, code: \(warningCode.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("did occur error, code: \(errorCode.rawValue)")
        if errorCode.rawValue != 0 {
            //didOccurErrorSubject.onNext(errorCode)
        }
    }
}
