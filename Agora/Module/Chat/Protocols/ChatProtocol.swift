//
//  ChatProtocol.swift
//  Agora
//
//  Created by donny on 4/24/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import Foundation
import UIKit

protocol ViewToPresenterChatProtocol:class {
    var view:PresenterToViewChatProtocol? {get set}
    var interactor:PresenterToInteractorChatProtocol? {get set}
    var router: PresenterToRouterChatProtocol? {get set}
    //func showChannelController(nc:UINavigationController, ChatData:ChatData)
    func startJoinChatRoom(user:String, chatroom:String)
    func startSendChatRoom(message:String)
    func startLeaveChatRoom()
}

protocol PresenterToViewChatProtocol:class {
    func onChatRoom(_ remoteStatus:RemotStatus, chatroom:Bool)
    func onMessageList(_ remoteStatus:RemotStatus, aryMessage:[MessageData])
}

protocol PresenterToRouterChatProtocol:class {
    static func createChatModule(chatVC:ChatViewController)
    //func pushToChannel(navigationController:UINavigationController, ChatData:ChatData)
}

protocol PresenterToInteractorChatProtocol:class {
    var presenter:InteractorToPresenterChatProtocol? {get set}
    func joinChatRoom(user:String, chatroom:String)
    func sendChatRoom(message:String)
    func leaveChatRoom()
}

protocol InteractorToPresenterChatProtocol:class {

    func chatRoom(_ remoteStatus:RemotStatus, chatroom:Bool)
    func messageList(_ remoteStatus:RemotStatus, aryMessage:[MessageData])
    
}
