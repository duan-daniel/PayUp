//
//  OweNote.swift
//  PayUp
//
//  Created by Daniel Duan on 7/23/18.
//  Copyright © 2018 Daniel Duan. All rights reserved.
//

import Foundation
import RealmSwift

class OweNote: Object {
    
    @objc dynamic var date = ""
    @objc dynamic var purpose = ""
    @objc dynamic var amount = ""
    @objc dynamic var originalSegIndex = 0
    
}
