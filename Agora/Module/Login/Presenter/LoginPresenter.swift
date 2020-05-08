//
//  LoginPresenter.swift
//  Agora
//
//  Created by donny on 4/24/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class LoginPresenter: ViewToPresenterLoginProtocol {

    var view: PresenterToViewLoginProtocol?
    var interactor: PresenterToInteractorLoginProtocol?
    var router: PresenterToRouterLoginProtocol?

    func showChannelController(nc: UINavigationController, account:Account) {
        router?.pushToChannel(navigationController: nc, account:account)
    }
}

extension LoginPresenter : InteractorToPresenterLoginProtocol {
    
}
