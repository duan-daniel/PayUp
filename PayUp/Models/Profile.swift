//
//  Profile.swift
//  PayUp
//
//  Created by Daniel Duan on 7/21/18.
//  Copyright © 2018 Daniel Duan. All rights reserved.
//

import Foundation
import RealmSwift

class Profile: Object {

    @objc dynamic var name = ""
    @objc dynamic var owesYou = 0.00
    @objc dynamic var youOwe = 0.00

    let stillOwesYouArray = List<AnOweToYou>()
    let youStillOweArray = List<YourOweToSomeone>()
    let clearedOweArray = List<ClearedOwe>()




//    @objc dynamic var clearedOweArray: [ClearedOwe] = []
//    var stillOwesYouArray: Results<AnOweToYou>!
//    var youStillOweArray: Results<YourOweToSomeone>!
//    var clearedOwesArray: Results<ClearedOwe>!
}
//
//class Profile {
//
//    var name = ""
//    var owesYou = 0.00
//    var youOwe = 0.00
//
////    let stillOwesYouArray = List<AnOweToYou>()
////    let youStillOweArray = List<YourOweToSomeone>()
////    let clearedOweArray = List<ClearedOwe>()
//
//    var stillOwesYouArray: [AnOweToYou] = []
//    var youStillOweArray: [YourOweToSomeone] = []
//    var clearedOweArray: [ClearedOwe] = []
//
//
//
//    //    @objc dynamic var clearedOweArray: [ClearedOwe] = []
//    //    var stillOwesYouArray: Results<AnOweToYou>!
//    //    var youStillOweArray: Results<YourOweToSomeone>!
//    //    var clearedOwesArray: Results<ClearedOwe>!
//}
