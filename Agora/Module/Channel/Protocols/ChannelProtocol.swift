//
//  ChannelProtocol.swift
//  Agora
//
//  Created by donny on 4/24/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import Foundation

enum RemotStatus {
     case none, busy, success, fail
 }

protocol ViewToPresenterChannelProtocol:class {
    var view:PresenterToViewChannelProtocol? {get set}
    var interactor:PresenterToInteractorChannelProtocol? {get set}
    var router: PresenterToRouterChannelProtocol? {get set}
    func startVideoBroadcast(account:Account)
    func startMuteLocalAudioStream(isMuted:Bool)
    func startSwitchLocalVideoCamera()
    func startExitVideoBroadcast()
    
}

protocol PresenterToViewChannelProtocol:class {
    func onLocalVideo(_ remoteStatus:RemotStatus, aryVideoSession:[VideoSession])
    func onRemoteVideo(_ remoteStatus:RemotStatus, aryVideoSession:[VideoSession])
    func onMuteAudio(_ remoteStatus:RemotStatus, muted:Bool)
}

protocol PresenterToRouterChannelProtocol:class {
    static func createChannelModule(account:Account)->ChannelViewController
}

protocol PresenterToInteractorChannelProtocol:class {
    var presenter:InteractorToPresenterChannelProtocol? {get set}
    func videoBroadcast(account:Account)
    func muteLocalAudioStream(isMuted:Bool)
    func switchLocalVideoCamera()
    func exitVideoBroadcast()
}

protocol InteractorToPresenterChannelProtocol:class {
    
    func localVideo(_ remoteStatus:RemotStatus, aryVideoSession:[VideoSession])
    func remoteVideo(_ remoteStatus:RemotStatus, aryVideoSession:[VideoSession])
    func muteAudio(_ remoteStatus:RemotStatus, muted:Bool)
    
}
