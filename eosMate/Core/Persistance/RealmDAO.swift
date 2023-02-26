//
//  RealmHandler.swift
//  eosMate
//
//  Created by Cyril on 5/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDAO {
    var realm: Realm!
    
    init() {
        initRealm()
    }
    
    private func initRealm() {
        let config = Realm.Configuration(
            schemaVersion: 2, // Set current schema version
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
//                switch oldSchemaVersion {
//                case 1:
//                    break
//                default:
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
                // }
            }
        )
        realm = try! Realm(configuration: config)
    }
    
    func save(account: RealmEOSAccount) {
        write { realm.add(account, update: .all) }
    }
    
    func updateActiveOnAccount(account: EOSAccount, isActive: Bool) {
        if let realmAccount = realm.object(ofType: RealmEOSAccount.self, forPrimaryKey: account.accountName ?? "") {
            write {
                realmAccount.isActive = isActive
            }
        }
    }
    
    func updateActiveOnAccounts(for pub: String) {
        getAccounts { cachedAccounts in
            let accountsForUpdate = cachedAccounts.filter { $0.isActive == false && $0.pub == pub }
            guard accountsForUpdate.count > 0 else { return }
            
            self.write {
                for account in accountsForUpdate {
                    if let realmAccount = self.realm.object(ofType: RealmEOSAccount.self, forPrimaryKey: account.name) {
                        realmAccount.isActive = true
                    }
                }
            }
        }
    }
    
    func getAccounts(completion: @escaping (_ accounts: [CachedEOSAccount]) -> Void) {
        let accounts = realm.objects(RealmEOSAccount.self)
        let cachedAccounts = Array(accounts).map { CachedEOSAccount(from: $0) }.sorted(by: { $0.name > $1.name })
        completion(cachedAccounts)
    }
    
    func getAccount(account: EOSAccount) -> CachedEOSAccount? {
        if let realmAccount = realm.object(ofType: RealmEOSAccount.self, forPrimaryKey: account.accountName ?? "") {
            return CachedEOSAccount(from: realmAccount)
        }
        return nil
    }
    
    func hasActiveAccounts() -> Bool {
        let account = realm.objects(RealmEOSAccount.self).first(where: { $0.isActive == true })
        return account != nil
    }
    
    func deleteAccount(account: EOSAccount) {
        if let objectToDelete = realm.object(ofType: RealmEOSAccount.self, forPrimaryKey: account.accountName ?? "") {
            write {
                realm.delete(objectToDelete)
            }
        }
    }
    
    private func write(transaction: () -> Void) {
        do {
            try realm.write {
                transaction()
                try realm.commitWrite()
            }
        } catch let e {
            print(e)
        }
    }
}
