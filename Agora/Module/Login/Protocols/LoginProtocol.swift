//
//  LoginProtocol.swift
//  Agora
//
//  Created by donny on 4/24/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol ViewToPresenterLoginProtocol:class {
    var view:PresenterToViewLoginProtocol? {get set}
    var interactor:PresenterToInteractorLoginProtocol? {get set}
    var router: PresenterToRouterLoginProtocol? {get set}
    
    func showChannelController(nc:UINavigationController, account:Account)
    
}

protocol PresenterToViewLoginProtocol:class {

}

protocol PresenterToRouterLoginProtocol:class {
    static func createLoginModule(loginVC:LoginViewController)
    func pushToChannel(navigationController:UINavigationController, account:Account)
}

protocol PresenterToInteractorLoginProtocol:class {
    var presenter:InteractorToPresenterLoginProtocol? {get set}
    func login(_ roomName:String, _ userName:String, _ pwd:String)
}

protocol InteractorToPresenterLoginProtocol:class {

    
}
