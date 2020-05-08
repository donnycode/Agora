//
//  ChatInterator.swift
//  Agora
//
//  Created by donny on 4/24/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import Foundation


class ChatInteractor: NSObject, PresenterToInteractorChatProtocol{
  
    private let agoraRtmManager = AgoraRtmManager.defaultInstance
    var presenter: InteractorToPresenterChatProtocol?
    
    func joinChatRoom(user:String, chatroom:String) {
        agoraRtmManager.login(
            user: user,
            channel: chatroom,
            chatRoomCallBack: {
            (remoteStatus, joinRoom) in
                self.presenter?.chatRoom(remoteStatus, chatroom: joinRoom)
                                
        }, messageCallBack: {
            (remoteStatus, aryMessage) in
            self.presenter?.messageList(remoteStatus, aryMessage: aryMessage)
        })
    }

    func sendChatRoom(message:String) {
        agoraRtmManager.groupMessageSend(message)
    }
    
    func leaveChatRoom() {
        agoraRtmManager.leaveChannel()
    }
    
}


