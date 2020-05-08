//
//  ChannelPresenter.swift
//  Agora
//
//  Created by donny on 4/24/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ChannelPresenter: ViewToPresenterChannelProtocol {
    var view: PresenterToViewChannelProtocol?
    
    var interactor: PresenterToInteractorChannelProtocol?
    
    var router: PresenterToRouterChannelProtocol?
    
    
    // Outputs
    let aryVideoSessionBehaviorRelay = BehaviorRelay<[VideoSession]>(value: [])
    
    func startVideoBroadcast(account:Account) {
        interactor?.videoBroadcast(account:account)
    }
    func startMuteLocalAudioStream(isMuted:Bool) {
        interactor?.muteLocalAudioStream(isMuted: isMuted)
    }
    func startSwitchLocalVideoCamera() {
        interactor?.switchLocalVideoCamera()
    }
    
    func startExitVideoBroadcast() {
        interactor?.exitVideoBroadcast()
    }

}

extension ChannelPresenter : InteractorToPresenterChannelProtocol {
    func muteAudio(_ remoteStatus: RemotStatus, muted: Bool) {
        view?.onMuteAudio(remoteStatus, muted:muted)
    }
    
    func localVideo(_ remoteStatus:RemotStatus, aryVideoSession:[VideoSession]) {
        view?.onLocalVideo(remoteStatus, aryVideoSession:aryVideoSession)
    }
    
    func remoteVideo(_ remoteStatus:RemotStatus, aryVideoSession:[VideoSession]) {
        view?.onRemoteVideo(remoteStatus, aryVideoSession:aryVideoSession)
    }
    

}
