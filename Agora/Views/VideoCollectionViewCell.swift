//
//  VideoCollectionViewCell.swift
//  Agora
//
//  Created by donny on 4/29/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    var videoSession:VideoSession? {
            didSet {
                let tmpView = videoSession!.hostingView
                contentView.addSubview(tmpView!)
                tmpView!.translatesAutoresizingMaskIntoConstraints = false
                    let horizontalConstraint = NSLayoutConstraint(item: tmpView!, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0)
                    let verticalConstraint = NSLayoutConstraint(item: tmpView!, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
                    let widthConstraint = NSLayoutConstraint(item: tmpView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
                let heightConstraint = NSLayoutConstraint(item: tmpView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)

                    contentView.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
                    contentView.layoutIfNeeded()
            }
       }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard videoSession != nil else {
            return
        }
        //videoView = videoSession!.hostingView
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard videoSession != nil else {
            return
        }
        

    }
}
