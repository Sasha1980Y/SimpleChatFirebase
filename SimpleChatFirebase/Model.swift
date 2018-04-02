//
//  Model.swift
//  SimpleChatFirebase
//
//  Created by Alexander Yakovenko on 3/31/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import Foundation

class Model: Encodable {
    var name: String
    var content: String
    
    init(name: String, content: String) {
        self.name = name
        self.content = content
    }
    
    func initWithDict(aDict: [String: AnyObject]) {
        self.name = aDict["Sasha"] as! String
        self.content = aDict["content"] as! String
    }
}
