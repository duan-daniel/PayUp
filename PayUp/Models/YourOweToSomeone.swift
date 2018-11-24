//
//  YourOweToSomeone.swift
//  PayUp
//
//  Created by Daniel Duan on 11/23/18.
//  Copyright © 2018 Daniel Duan. All rights reserved.
//

import Foundation
import RealmSwift

class YourOweToSomeone: Object {
    
    @objc dynamic var date = ""
    @objc dynamic var purpose = ""
    @objc dynamic var amount = ""
    @objc dynamic var originalSegIndex = 0
    
}

