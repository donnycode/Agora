//
//  AgoraRtmManager.swift
//  Agora
//
//  Created by donny on 4/27/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import Foundation
import AgoraRtmKit

enum LoginStatus {
    case online, offline
}

enum OneToOneMessageType {
    case normal, offline
}

final class AgoraRtmManager: NSObject {

    typealias ChatRoomCallBack = ((RemotStatus, Bool) -> Void)
    typealias MessageCallBack = ((RemotStatus, [MessageData]) -> Void)
    
    typealias AgoraCallBack = (() -> Void)
    private let AppID: String = "4f963ceffccc48eb9da641572481258c"
    
    private static var agoraRtmManager:AgoraRtmManager!
    internal static let defaultInstance:AgoraRtmManager = {
        agoraRtmManager = AgoraRtmManager()
        return agoraRtmManager
    }()
    
    lazy var list = [MessageData]()
    private var agoraRtmKit: AgoraRtmKit!
    var rtmChannel: AgoraRtmChannel?
    private var current: String?
    private var status: LoginStatus = .offline
    private var oneToOneMessageType: OneToOneMessageType = .normal
    private var offlineMessages = [String: [AgoraRtmMessage]]()
    private var callBack:AgoraCallBack?
    private var chatRoomCallBack: ChatRoomCallBack?
    private var messageCallBack: MessageCallBack?
    private var user:String?
    private var channel:String?
    
    override init() {
        super.init()
        initializeAgoraRtm()
    }
    
    private func initializeAgoraRtm() {
        agoraRtmKit = AgoraRtmKit(appId: AppID, delegate: self)
    }
    
//    func add(offlineMessage: AgoraRtmMessage, from user: String) {
//        guard offlineMessage.isOfflineMessage else {
//            return
//        }
//        var messageList: [AgoraRtmMessage]
//        if let list = offlineMessages[user] {
//            messageList = list
//        } else {
//            messageList = [AgoraRtmMessage]()
//        }
//        messageList.append(offlineMessage)
//        offlineMessages[user] = messageList
//    }
//
//    func getOfflineMessages(from user: String) -> [AgoraRtmMessage]? {
//        return offlineMessages[user]
//    }
//
//    func removeOfflineMessages(from user: String) {
//        offlineMessages.removeValue(forKey: user)
//    }
    
    func groupMessageSend(_ message:String) {
        let rtmMessage = AgoraRtmMessage(text: message)
        rtmChannel?.send(rtmMessage) { (error) in
            guard error.rawValue == 0  else {
                print(error.rawValue)
                return
            }
            self.appendMessage(user: self.user!, content: message)
        }
    }
    
    
    func appendMessage(user: String, content: String) {
        let msg = MessageData(userId: user, text: content)
        self.list.append(msg)
        if self.list.count > 100 {
            self.list.removeFirst()
        }
        messageCallBack!(.success, list)
    }
    
    
    func login(user: String,
               channel:String,
               chatRoomCallBack:@escaping ChatRoomCallBack,
               messageCallBack:@escaping MessageCallBack
    ) {
        self.chatRoomCallBack = chatRoomCallBack
        self.messageCallBack = messageCallBack
        self.user = user
        self.channel = channel
        
        agoraRtmKit.login(byToken: nil, user: user) { [unowned self] (errorCode) in
            guard errorCode == .ok else {
                //self.showAlert("login error: \(errorCode.rawValue)")
                return
            }
            
            self.status = .online
            self.createChannel(channel)

        }
    }
    func logout() {
        guard status == .online else {
            return
        }
        
        agoraRtmKit.logout(completion: {  [unowned self] (error) in
            guard error == .ok else {
                return
            }
            self.status = .offline
        })
    }
    
    func createChannel(_ channel: String) {
        guard let rtmChannel = agoraRtmKit?.createChannel(withId: channel, delegate: self as! AgoraRtmChannelDelegate) else {
            //showAlert("join channel fail", handler: errorHandle)
            print("join channel fail")
            return
        }
        
        rtmChannel.join { [weak self] (error) in
            if error != .channelErrorOk, let strongSelf = self {
                //strongSelf.showAlert("join channel error: \(error.rawValue)", handler: errorHandle)
                print("join channel error: \(error.rawValue)")
            }
        }
        
        self.rtmChannel = rtmChannel
        chatRoomCallBack!(.success, true)
    }
    
    
    func leaveChannel() {
        rtmChannel?.leave { (error) in
            print("leave channel error: \(error.rawValue)")
        }
    }
    
}

extension AgoraRtmManager: AgoraRtmDelegate {
    func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason) {
        print("connection state changed: \(state.rawValue)")
//        showAlert("connection state changed: \(state.rawValue)") { [weak self] (_) in
//            if reason == .remoteLogin, let strongSelf = self {
//                strongSelf.navigationController?.popToRootViewController(animated: true)
//            }
//        }
    }
    
    
    
    // Receive one to one offline messages
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        //add(offlineMessage: message, from: peerId)
        //callBack
    }
}

extension AgoraRtmManager: AgoraRtmChannelDelegate {
    func channel(_ channel: AgoraRtmChannel, memberJoined member: AgoraRtmMember) {
        DispatchQueue.main.async { [unowned self] in
            //self.showAlert("\(member.userId) join")
            print("\(member.userId) join")
        }
    }
    
    func channel(_ channel: AgoraRtmChannel, memberLeft member: AgoraRtmMember) {
        DispatchQueue.main.async { [unowned self] in
            //self.showAlert("\(member.userId) left")
            print("\(member.userId) left")
        }
    }
    
    func channel(_ channel: AgoraRtmChannel, messageReceived message: AgoraRtmMessage, from member: AgoraRtmMember) {
        DispatchQueue.main.async { [unowned self] in
            self.appendMessage(user: member.userId, content: message.text)
        }
    }
}
