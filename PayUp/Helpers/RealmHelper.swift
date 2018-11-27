//
//  RealmHelper.swift
//  PayUp
//
//  Created by Daniel Duan on 11/22/18.
//  Copyright © 2018 Daniel Duan. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    
//    static func saveProfile(profile: Profile) {
//        let realm = try! Realm()
//        try! realm.write() {
//            realm.add(profile)
//        }
//    }
    
//    static func addOwe(owe: YourOweToSomeone, profile: Profile) {
//        let realm = try! Realm()
//        try! realm.write() {
//            profile.youOwe += Double(owe.amount)!
//            profile.youStillOweArray.append(owe)
//            realm.add(profile)
//        }
//    }
    
    static func addToYouOweSomeone(owe: YourOweToSomeone, profile: Profile){
        let realm = try! Realm()
        try! realm.write() {
            profile.youOwe += Double(owe.amount)!
            profile.youStillOweArray.append(owe)
            realm.add(profile)
        }
    }
    
    static func addAnOweToYou(owe: AnOweToYou, profile: Profile) {
        let realm = try! Realm()
        try! realm.write() {
            profile.owesYou += Double(owe.amount)!
            profile.stillOwesYouArray.append(owe)
            realm.add(profile)
        }
    }
    
    static func uppdateSmth(owe: AnOweToYou, profile: Profile) {
        let realm = try! Realm()
        try! realm.write() {
            profile.youStillOweArray.filter { $0 !== owe}
        }
    }
    
//    static func addClearedOwe(owe: ClearedOwe) {
//        let realm = try! Realm()
//        try! realm.write() {
//            realm.add(owe)
//        }
//    }
    
    
//    static func updateOwe(oweToBeUpdated: OweNote, newOwe: OweNote) {
//        let realm = try! Realm()
//        try! realm.write() {
//            oweToBeUpdated.date = newOwe.date
//            oweToBeUpdated.purpose = newOwe.purpose
//            oweToBeUpdated.amount = newOwe.amount
//            oweToBeUpdated.originalSegIndex = newOwe.originalSegIndex
//        }
//    }
    
    // unfinished
//    static func updateAnOweToYou(oweToBeUpdated: AnOweToYou, newOwe: AnOweToYou, profile: Profile) {
//        let realm = try! Realm()
//        guard let debtStr = oweToBeUpdated.amount as? String else { return }
//        let debt = Double(debtStr)
//        try! realm.write() {
//            profile.owesYou -= debt!
//
//        }
//    }
    
    
    static func retrieveYourOweToSomeone() -> Results<YourOweToSomeone> {
        let realm = try! Realm()
        return realm.objects(YourOweToSomeone.self)
    }
    
    static func retrieveAnOweToYou() -> Results<AnOweToYou> {
        let realm = try! Realm()
        return realm.objects(AnOweToYou.self)
    }
    
    static func retrieveClearedOwes() -> Results<ClearedOwe> {
        let realm = try! Realm()
        return realm.objects(ClearedOwe.self)
    }
    
}
