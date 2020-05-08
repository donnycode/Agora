//
//  ChannelRouter.swift
//  Agora
//
//  Created by donny on 4/24/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import Foundation
import UIKit


class ChannelRouter:PresenterToRouterChannelProtocol{

    
    static func createChannelModule(account:Account)->ChannelViewController {
        let view = ChannelRouter.mainstoryboard.instantiateViewController(withIdentifier: "ChannelViewController") as! ChannelViewController
        view.account = account
        let presenter: ViewToPresenterChannelProtocol & InteractorToPresenterChannelProtocol = ChannelPresenter()
        let interactor: PresenterToInteractorChannelProtocol = ChannelInteractor()
        let router:PresenterToRouterChannelProtocol = ChannelRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
        
    }
    
    static func embedChatModule(chatVC:ChatViewController) {
        ChatRouter.createChatModule(chatVC: chatVC)
    }
    
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
}
