//
//  ChannelInterator.swift
//  Agora
//
//  Created by donny on 4/24/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import Foundation
import AgoraRtcKit

class ChannelInteractor: NSObject, PresenterToInteractorChannelProtocol{
    
    private let agoraManager = AgoraRtcManager.defaultInstance
    var presenter: InteractorToPresenterChannelProtocol?
 
 
    func videoBroadcast(account:Account) {
        agoraManager.joinChannel(
            account: account,
            localVideoCallBack: {
                (remoteStatus, aryVideoSession) in
                self.presenter?.localVideo(remoteStatus, aryVideoSession: aryVideoSession)
        },
            remoteVideoCallBack:{
                (remoteStatus, aryVideoSession) in
                self.presenter?.remoteVideo(remoteStatus, aryVideoSession: aryVideoSession)
        }, muteAudioCallBack: {
             (remoteStatus, muted) in
            self.presenter?.muteAudio(remoteStatus, muted:muted)
        })
    }
    
    func muteLocalAudioStream(isMuted:Bool) {
        agoraManager.muteLocalAudioStream(isMuted: isMuted)
    }
    func switchLocalVideoCamera() {
        agoraManager.switchLocalVideoCamera()
    }
    
    func exitVideoBroadcast() {
        agoraManager.leaveChannel()
    }
}


