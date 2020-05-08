//
//  ChannelViewController.swift
//  Agora
//
//  Created by donny on 4/24/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import UIKit
import AgoraRtcKit
import RxSwift
import RxCocoa

class ChannelViewController: UIViewController {

    var presenter: ViewToPresenterChannelProtocol?
    var chatVC:ChatViewController!
    
    @IBOutlet var chatView:UIView!
    @IBOutlet var hangupButton: UIButton!
    @IBOutlet var micButton: UIButton!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    private var aryVideoSession:[VideoSession] = [VideoSession]()
    private var isLocalVideoRender: Bool = false
    private let disposeBag = DisposeBag()

    var account:Account?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter!.startVideoBroadcast(account: account!)
        
        hangupButton.rx.tap.bind {
            self.joinChannel()
        }
        .disposed(by: disposeBag)
        
        micButton.rx.tap.bind {
            self.joinChannel()
        }
        .disposed(by: disposeBag)
        
        cameraButton.rx.tap.bind {
            self.joinChannel()
        }
        .disposed(by: disposeBag)
        
//        let checkBoxValid = Variable(true)
//        checkBoxValid.asObservable().bindTo(checkBoxButton.rx.isSelected).disposed(by: disposeBag)
//
//        checkBoxButton.rx.tap.subscribe(onNext: {
//            checkBoxValid.value = !checkBoxValid.value
//        }).disposed(by: disposeBag)
        
    }
    private func joinChannel() {
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter!.startExitVideoBroadcast()
    }
    
    // MARK: - IBAction Method
    
    @IBAction private func hangUpButtonClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            presenter!.startExitVideoBroadcast()
            self.navigationController?.popViewController(animated: true)
        } else {
            presenter!.startVideoBroadcast(account: account!)
        }
    }
    @IBAction private func muteButtonClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        // mute local audio
        presenter!.startMuteLocalAudioStream(isMuted: sender.isSelected)
    }
    
    @IBAction private func switchCameraButtonClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        presenter!.startSwitchLocalVideoCamera()
    }


    private func reloadCollectionView(aryVideoSession:[VideoSession]) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.aryVideoSession = aryVideoSession
            strongSelf.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination as? ChatViewController,
            segue.identifier == "ChatViewSegue" {
            
            vc.posY = self.chatView.frame.origin.y + self.navigationController!.navigationBar.frame.origin.y
            vc.account = account
            ChannelRouter.embedChatModule(chatVC: vc)
            
            
            
            
        }
    }
    /*
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - PresenterToViewChannelProtocol

extension ChannelViewController : PresenterToViewChannelProtocol {
    
    func onLocalVideo(_ remoteStatus:RemotStatus, aryVideoSession:[VideoSession]) {
        switch(remoteStatus) {
        case .success:
            reloadCollectionView(aryVideoSession:aryVideoSession)
            break
        case .none, .busy, .fail: break
        }
    }
    func onRemoteVideo(_ remoteStatus:RemotStatus, aryVideoSession:[VideoSession]) {
        switch(remoteStatus) {
        case .success:
            reloadCollectionView(aryVideoSession:aryVideoSession)
            break
        case .none, .busy, .fail: break
        }
    }
    
    func onMuteAudio(_ remoteStatus:RemotStatus, muted:Bool) {
        //
    }
}


// MARK: - UICollectionViewDataSource

extension ChannelViewController : UICollectionViewDataSource {

    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aryVideoSession.count
    }
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReuseIdentifier", for: indexPath) as! VideoCollectionViewCell
        cell.videoSession = aryVideoSession[indexPath.row]
        return cell
   }
    

    // custom function to generate a random UIColor
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

}

