//
//  LoginRouter.swift
//  Agora
//
//  Created by donny on 4/24/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import Foundation
import UIKit

class LoginRouter:PresenterToRouterLoginProtocol {

    
    static private var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
    static func createLoginModule(loginVC: LoginViewController) {
        
        let presenter: ViewToPresenterLoginProtocol &
                InteractorToPresenterLoginProtocol = LoginPresenter()
        let interactor: PresenterToInteractorLoginProtocol = LoginInteractor()
        let router:PresenterToRouterLoginProtocol = LoginRouter()
        
        loginVC.presenter = presenter
        presenter.view = loginVC
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
    }
    
    func pushToChannel(navigationController:UINavigationController, account:Account){
        let videoChatModule = ChannelRouter.createChannelModule(account: account)
        navigationController.pushViewController(videoChatModule,animated: true)
    }
    
}
