//
//  ChatViewController.swift
//  Agora
//
//  Created by donny on 4/24/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet private var inputTextField: UITextField!
    @IBOutlet private var inputViewBottom: NSLayoutConstraint!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var inputContainView: UIView!
    
    var presenter:ViewToPresenterChatProtocol?
    lazy private var aryMessage = [MessageData]()
    
    var posY:CGFloat = 0
    var account:Account?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
        updateViews()
        ChatRouter.createChatModule(chatVC: self)
        presenter?.startJoinChatRoom(user: account!.userName!, chatroom: account!.channelName!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.startLeaveChatRoom()
     }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardFrameWillChange(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func keyboardFrameWillChange(notification: NSNotification) {

        guard let userInfo = notification.userInfo,
            let endKeyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
                return
        }
        
        let endKeyboardFrame = endKeyboardFrameValue.cgRectValue
        let duration = durationValue.doubleValue
        let isShowing: Bool = endKeyboardFrame.maxY > UIScreen.main.bounds.height ? false : true
        
        UIView.animate(withDuration: duration) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if isShowing {
                let offsetY = self!.posY + self!.tableView.frame.size.height + self!.inputContainView.frame.size.height - endKeyboardFrame.minY
                guard offsetY > 0 else {
                    return
                }
                strongSelf.inputViewBottom.constant = offsetY
            } else {
                strongSelf.inputViewBottom.constant = 0
            }
            strongSelf.view.layoutIfNeeded()
        }
    }

    private func updateViews() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 55
    }
    
    private func pressedReturnToSendText(_ text: String?) -> Bool {
        guard let text = text, text.count > 0 else {
            return false
        }
        send(message: text)
        return true
    }
    
    private func send(message: String) {
        presenter?.startSendChatRoom(message: message)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatViewController: PresenterToViewChatProtocol {

    func onChatRoom(_ remoteStatus:RemotStatus, chatroom:Bool) {
        print("join chatroom \(chatroom)")
    }
    func onMessageList(_ remoteStatus:RemotStatus, aryMessage:[MessageData]) {
        self.aryMessage = aryMessage
        let end = IndexPath(row: self.aryMessage.count - 1, section: 0)
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: end, at: .bottom, animated: true)
    } 
}

// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = aryMessage[indexPath.row]
        let type: CellType = .left
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        cell.update(type: type, message: msg)
        return cell
    }
}

// MARK: - UITextFieldDelegate

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if pressedReturnToSendText(textField.text) {
            textField.text = nil
        } else {
            view.endEditing(true)
        }
        
        return true
    }
}
