//
//  RealmManager.swift
//  TapNumber
//
//  Created by kyosuke on 2024/12/24.
//

import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    private let realm: Realm
    private init(){
        let config = Realm.Configuration(schemaVersion: 5)
        Realm.Configuration.defaultConfiguration = config
        do{
            realm = try Realm()
        }catch{
            fatalError("Failed to open Realm. Error: \(error)")
        }
    }
    
    func getRealm() -> Realm{
        return realm
    }
}
