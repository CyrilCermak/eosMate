//
//  RealmEOSAccount.swift
//  eosMate
//
//  Created by Cyril on 5/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import RealmSwift

class RealmEOSAccount: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var pub: String = ""
    @objc dynamic var latestVolume: Double = 0.0
    @objc dynamic var isActive: Bool = false
    
    override static func primaryKey() -> String? {
        return "name"
    }
}

struct CachedEOSAccount: Codable {
    var name: String
    var pub: String
    var latestVolume: Double
    var isActive: Bool
    
    init(name: String, latestVolume: Double, isActive: Bool, pub: String) {
        self.name = name; self.latestVolume = latestVolume; self.isActive = isActive
        self.pub = pub
    }
    
    init(from realm: RealmEOSAccount) {
        name = realm.name
        latestVolume = realm.latestVolume
        isActive = realm.isActive
        pub = realm.pub
    }
}
