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
    
    static func addToYouOweSomeone(owe: YourOweToSomeone){
        let realm = try! Realm()
        try! realm.write() {
            realm.add(owe)
        }
    }
    
    static func addAnOweToYou(owe: AnOweToYou) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(owe)
        }
    }
    
    static func addClearedOwe(owe: ClearedOwe) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(owe)
        }
    }
    
    static func deleteOwe(owe: OweNote){
        let realm = try! Realm()
        try! realm.write() {
            realm.delete(owe)
        }
    }
    
    static func updateOwe(oweToBeUpdated: OweNote, newOwe: OweNote) {
        let realm = try! Realm()
        try! realm.write() {
            oweToBeUpdated.date = newOwe.date
            oweToBeUpdated.purpose = newOwe.purpose
            oweToBeUpdated.amount = newOwe.amount
            oweToBeUpdated.originalSegIndex = newOwe.originalSegIndex
        }
    }
    
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
