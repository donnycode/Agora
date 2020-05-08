//
//  UIViewController+Extension.swift
//  Agora
//
//  Created by donny on 4/25/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {
    func alertError(error: NSError,
                    action: ((UIAlertAction) -> Swift.Void)?) {
        let alert: UIAlertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "ok", style: .default, handler: action)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
