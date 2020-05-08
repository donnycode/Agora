//
//  LoginViewController.swift
//  Agora
//
//  Created by donny on 4/24/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    var presenter:ViewToPresenterLoginProtocol?
    
    @IBOutlet private var userNameTextField: UITextField!
    @IBOutlet private var channelTextField: UITextField!
    @IBOutlet private var joinChannelButton: UIButton!
    
    private let throttleIntervalInMilliseconds = 100
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginRouter.createLoginModule(loginVC: self)
        channelTextField.text = "room1"
        joinChannelButton.isEnabled = false
        
        let userNameValid = userNameTextField
            .rx
            .text //1
            .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(throttleIntervalInMilliseconds), scheduler: MainScheduler.instance)
            .map {
                ($0!.count) > 0
        }
        
        userNameValid
            .map {
                $0 ? UIColor.white : UIColor.red
        }
        .subscribe(onNext: { [unowned self] in
            self.userNameTextField.backgroundColor = $0
        })
            .disposed(by: disposeBag) //5
        
        userNameValid
            .bind(to: joinChannelButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        joinChannelButton.rx.tap.bind {
            self.joinChannel()
        }
        .disposed(by: disposeBag)
        
    }
    
    private func joinChannel() {
        let account = Account(channelName:channelTextField.text!, userName:userNameTextField.text!, pwd:nil)
        presenter?.showChannelController(nc: self.navigationController!, account: account)
    }
    
//    @IBAction private func loginButtonClicked(_ sender:UIButton) {
//        guard channelTextField.text!.count > 0 && userNameTextField.text!.count > 0 else {
//            let alert = UIAlertController(title: "User or Channel name is empty", message: nil, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//            self.present(alert, animated: true)
//            return
//        }
//        self.joinChannel()
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension LoginViewController: PresenterToViewLoginProtocol {
    
    
    
}

extension LoginViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
