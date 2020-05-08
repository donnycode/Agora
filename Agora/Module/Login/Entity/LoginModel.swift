//
//  LoginModel.swift
//  Agora
//
//  Created by donny on 4/24/20.
//  Copyright © 2020 Tung Hsieh. All rights reserved.
//

import Foundation
import ObjectMapper

//private let ID = "id"
//private let TITLE = "title"
//private let BRIEF = "brief"
//private let FILESOURCE = "filesource"
//
//class LoginModel: Mappable {
//
//    internal var id:String?
//    internal var title:String?
//    internal var brief:String?
//    internal var filesource:String?
//
//    required init?(map:Map) {
//        mapping(map: map)
//    }
//
//    func mapping(map:Map){
//        id <- map[ID]
//        title <- map[TITLE]
//        brief <- map[BRIEF]
//        filesource <- map[FILESOURCE]
//    }
//}

class Account: NSObject {
    
    private(set) var channelName:String?
    private(set) var userName:String?
    private(set) var password:String?
    
    init(channelName:String, userName:String, pwd:String?) {
        super.init()
        self.channelName = channelName
        self.userName = userName
        self.password = pwd
    }
    
}
