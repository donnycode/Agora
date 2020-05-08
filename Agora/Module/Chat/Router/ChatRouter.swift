//
//  ChatRouter.swift
//  Agora
//
//  Created by donny on 4/24/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import Foundation
import UIKit

class ChatRouter:PresenterToRouterChatProtocol {

    static private var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
    static func createChatModule(chatVC: ChatViewController) {
        
        let presenter: ViewToPresenterChatProtocol &
                InteractorToPresenterChatProtocol = ChatPresenter()
        let interactor: PresenterToInteractorChatProtocol = ChatInteractor()
        let router:PresenterToRouterChatProtocol = ChatRouter()
        
        chatVC.presenter = presenter
        presenter.view = chatVC
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
    }
    
    
    
    
//    func pushToChannel(navigationController:UINavigationController, ChatData:ChatData){
//        let videoChatModule = ChannelRouter.createChannelModule(ChatData: ChatData)
//
//        navigationController.pushViewController(videoChatModule,animated: true)
//
//    }
    
}
