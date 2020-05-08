//
//  ChatPresenter.swift
//  Agora
//
//  Created by donny on 4/24/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import Foundation
import UIKit

class ChatPresenter: ViewToPresenterChatProtocol {

    var view: PresenterToViewChatProtocol?
    var interactor: PresenterToInteractorChatProtocol?
    var router: PresenterToRouterChatProtocol?
    
    func startJoinChatRoom(user:String, chatroom:String) {
        interactor?.joinChatRoom(user: user, chatroom: chatroom)
    }
    func startSendChatRoom(message:String) {
        interactor?.sendChatRoom(message: message)
    }
    func startLeaveChatRoom() {
        interactor?.leaveChatRoom()
    }
    
}

extension ChatPresenter : InteractorToPresenterChatProtocol {
    func chatRoom(_ remoteStatus:RemotStatus, chatroom:Bool) {
        view?.onChatRoom(remoteStatus, chatroom: chatroom)
    }
    func messageList(_ remoteStatus:RemotStatus, aryMessage:[MessageData]) {
        view?.onMessageList(remoteStatus, aryMessage: aryMessage)
    }
     
}
