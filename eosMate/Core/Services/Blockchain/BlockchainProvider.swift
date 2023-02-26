//
//  BlockchainProvider.swift
//  eosMate
//
//  Created by Cyril on 3/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON
import EosioSwift
import EosioSwiftVault
import EosioSwiftVaultSignatureProvider
import EosioSwiftAbieosSerializationProvider

protocol BlockchainProtocol {
    func getAccount(name: String) -> Observable<EOSAccount>
    func getAccountActions(name: String) -> Observable<[EOSXTransaction]>
    func getRam() -> Observable<RAMRow>
    func getRefreshedAccounts(onlyActive: Bool) -> PublishSubject<(EOSAccount?, Int)>
    func getCachedAccounts(onlyActive: Bool) -> PublishSubject<[CachedEOSAccount]>
    func hasActiveAccounts() -> Bool
    func isActive(account: EOSAccount) -> Bool
    func deleteCachedAccount(account: EOSAccount)
    func cache(account: EOSAccount, isActive: Bool)
    func getToken(name: String, for accountName: String) -> Observable<String?>
    func validatedPKwithError(string: String?) -> Error?
    func savePKfor(account: EOSAccount, pk: String) -> Error?
    func sendTokens(sender: EOSAccount, reciever: EOSAccount, amount: String, completion: @escaping (_ result: EosTransactionResult?, _ error: Error?) -> Void)
    func sendResourceRequestWith(action: ResourceAction, account: EOSAccount, cpu: Float, net: Float, completion: @escaping (_ result: EosTransactionResult?, _ error: Error?) -> Void)
    func sendRamRequestWith(action: RamAction, account: EOSAccount, ramBytes: Float, completion: @escaping (_ result: EosTransactionResult?, _ error: Error?) -> Void)
    func sign(transaction: TransactionRequest, completion: @escaping (_ result: EosTransactionResult?, _ error: Error?) -> Void)
    func getKeyAccounts(pub: String) -> Observable<KeyAccounts>
    func deleteAllPKs()
}

enum EOSIOAction: String {
    case transfer, delegatebw, undelegatebw, buyram, sellram
    
    var tableAccountName: String {
        switch self {
        case .transfer: return "eosio.token"
        default: return "eosio"
        }
    }
}

class BlockchainProvider: BlockchainProtocol {
    let transactionFactory: EosioTransactionFactory
    let vault: EosioVault
    let provider = MoyaProvider<Blockchain>()
    let realm = RealmDAO()
    let disposeBag = DisposeBag()
    let pushNotifications = PushNotificationService()
    var currentTransaction: EosioTransaction?
    
    private let accessGroup = "group.com.eosMate"
    
    init() {
        let rpcProvider = EosioRpcProvider(endpoint: URL(string: Configuration.blockchainBaseAPI)!)
        let signatureProvider = EosioVaultSignatureProvider(accessGroup: accessGroup)
        let serializationProvider = EosioAbieosSerializationProvider()
        transactionFactory = EosioTransactionFactory(rpcProvider: rpcProvider,
                                                     signatureProvider: signatureProvider,
                                                     serializationProvider: serializationProvider)
        
        vault = EosioVault(accessGroup: accessGroup)
    }
    
    func getAccount(name: String) -> Observable<EOSAccount> {
        return provider.rx.request(.account(name: name)).mapObject(EOSAccount.self).asObservable()
    }
    
    func getKeyAccounts(pub: String) -> Observable<KeyAccounts> {
        return provider.rx.request(.getKeyAccounts(pub: pub)).mapObject(KeyAccounts.self).asObservable()
    }
    
    func getRam() -> Observable<RAMRow> {
        return provider.rx.request(.ram).mapObject(RAMRow.self).asObservable()
    }
    
    func getToken(name: String, for accountName: String) -> Observable<String?> {
        return provider.rx.request(.token(name: name.lowercased(), accountName: accountName.lowercased())).mapObject(AdditionalToken.self)
            .map { return $0.getBalance }.asObservable()
    }
    
    func getRefreshedAccounts(onlyActive: Bool = false) -> PublishSubject<(EOSAccount?, Int)> {
        let accountObservable = PublishSubject<(EOSAccount?, Int)>()
        realm.getAccounts { accounts in
            DispatchQueue.main.async {
                if onlyActive {
                    return self.getCachedAcountFrom(accounts: accounts.filter { $0.isActive == true }, accountObservable: accountObservable)
                }
                self.getCachedAcountFrom(accounts: accounts, accountObservable: accountObservable)
            }
        }
        return accountObservable
    }
    
    func getCachedAccounts(onlyActive: Bool) -> PublishSubject<[CachedEOSAccount]> {
        let accountObservable = PublishSubject<[CachedEOSAccount]>()
        realm.getAccounts { accounts in
            DispatchQueue.main.async {
                if onlyActive {
                    return accountObservable.onNext(accounts.filter { $0.isActive == true })
                }
                return accountObservable.onNext(accounts)
            }
        }
        return accountObservable
    }
    
    func isActive(account: EOSAccount) -> Bool {
        return realm.getAccount(account: account)?.isActive ?? false
    }
    
    func hasActiveAccounts() -> Bool {
        return realm.hasActiveAccounts()
    }
    
    private func getCachedAcountFrom(accounts: [CachedEOSAccount], accountObservable: PublishSubject<(EOSAccount?, Int)>) {
        guard accounts.count > 0 else {
            accountObservable.onNext((nil, 0))
            return
        }
        var accounts = accounts
        if let account = accounts.popLast() {
            provider.rx.request(.account(name: account.name.lowercased()))
                .mapObject(EOSAccount.self).subscribe(onSuccess: { eosAccount in
                    accountObservable.onNext((eosAccount, accounts.count))
                    self.getCachedAcountFrom(accounts: accounts, accountObservable: accountObservable)
                }, onError: { error in
                    accountObservable.onError(error)
                })
                .disposed(by: disposeBag)
        }
    }
    
    func deleteCachedAccount(account: EOSAccount) {
        realm.deleteAccount(account: account)
        guard let accountName = account.accountName else { return }
        if let pub = account.pub {
            try? vault.deleteKey(eosioPublicKey: pub)
        }
        pushNotifications.unsubscribeFrom(topic: accountName)
    }
    
    func cache(account: EOSAccount, isActive: Bool) {
        let realmAccount = RealmEOSAccount()
        realmAccount.name = account.accountName ?? ""
        realmAccount.latestVolume = account.totalBalance ?? 0
        realmAccount.isActive = isActive
        realmAccount.pub = account.pub ?? ""
        realm.save(account: realmAccount)
        pushNotifications.subscribeTo(topic: account.accountName ?? "")
    }
    
    func validatedPKwithError(string eosioPrivateKey: String?) -> Error? {
        let invalidPK = AMError(localizedTitle: BlockchainLocalization.error.text,
                                localizedDescription: BlockchainLocalization.invalidPK.text,
                                code: 500)
        guard let eosioPrivateKey = eosioPrivateKey, eosioPrivateKey.count > 0 else { return invalidPK }
        do {
            try _ = Data(eosioPrivateKey: eosioPrivateKey)
        } catch let e {
            return e
        }
        return nil
    }
    
    func savePKfor(account: EOSAccount, pk: String) -> Error? {
        do {
            try _ = vault.addExternal(eosioPrivateKey: pk)
            realm.updateActiveOnAccount(account: account, isActive: true)
            updatePKforSamePubs(account: account)
            return nil
        } catch { // EosioError
            if error.eosioError.reason == BlockchainLocalization.keyAlreadyExist.text {
                realm.updateActiveOnAccount(account: account, isActive: true)
                updatePKforSamePubs(account: account)
                return nil
            }
            return error
        }
    }
    
    func deleteAllPKs() {
        getCachedAccounts(onlyActive: true).subscribe(onNext: { accounts in
            accounts.forEach { account in
                do {
                    try? self.vault.deleteKey(eosioPublicKey: account.pub)
                }
                self.realm.updateActiveOnAccount(account: EOSAccount(accountName: account.name), isActive: false)
            }
        }).disposed(by: disposeBag)
    }
    
    private func updatePKforSamePubs(account: EOSAccount) {
        guard let pub = account.pub else { return }
        
        realm.updateActiveOnAccounts(for: pub)
    }
    
    // TODO: Improve action handling
    func getAccountActions(name: String) -> Observable<[EOSXTransaction]> {
        let observable = PublishSubject<[EOSXTransaction]>()
        
        provider.rx.request(.accountActions(name: name)).mapJSON(failsOnEmptyData: true).subscribe(onSuccess: { data in
            observable.onNext(EOSXTransactionsSerializer.transactions(from: JSON(data)))
        }, onError: { e in
            observable.onError(e)
        }).disposed(by: disposeBag)
        return observable
    }
    
    func sendTokens(sender: EOSAccount, reciever: EOSAccount, amount: String, completion: @escaping (_ result: EosTransactionResult?, _ error: Error?) -> Void) {
        guard let senderName = sender.accountName, let recieverName = reciever.accountName else { return completion(nil, nil) }
        let transafer = Transfer(
            from: senderName,
            to: recieverName,
            quantity: amount,
            memo: "Sent from EosMate"
        )
        
        startTransactionWith(data: transafer,
                             senderName: senderName,
                             tableAccountName: EOSIOAction.transfer.tableAccountName,
                             actionName: EOSIOAction.transfer.rawValue,
                             completion: completion)
    }
    
    func sendResourceRequestWith(action: ResourceAction, account: EOSAccount, cpu: Float, net: Float, completion: @escaping (_ result: EosTransactionResult?, _ error: Error?) -> Void) {
        guard let accountName = account.accountName?.lowercased() else { return completion(nil, nil) }
        switch action {
        case .stake:
            let stakeTransfer = StakeTransfer(from: accountName,
                                              receiver: accountName,
                                              stakeNetQuantity: format(amount: net),
                                              stakeCpuQuantity: format(amount: cpu),
                                              transfer: 0)
            
            startTransactionWith(data: stakeTransfer, senderName: accountName,
                                 tableAccountName: EOSIOAction.delegatebw.tableAccountName,
                                 actionName: EOSIOAction.delegatebw.rawValue,
                                 completion: completion)
        case .unstake:
            let unstakeTransfer = UnstakeTransfer(from: accountName,
                                                  receiver: accountName,
                                                  unstakeNetQuantity: format(amount: net),
                                                  unstakeCpuQuantity: format(amount: cpu),
                                                  transfer: 0)
            
            startTransactionWith(data: unstakeTransfer,
                                 senderName: accountName,
                                 tableAccountName: EOSIOAction.undelegatebw.tableAccountName,
                                 actionName: EOSIOAction.undelegatebw.rawValue,
                                 completion: completion)
        }
    }
    
    func sendRamRequestWith(action: RamAction, account: EOSAccount, ramBytes: Float, completion: @escaping (_ result: EosTransactionResult?, _ error: Error?) -> Void) {
        guard let name = account.accountName else { return completion(nil, AMError(localizedTitle: BlockchainLocalization.missingName.text, localizedDescription: BlockchainLocalization.nameNotFound.text, code: 500)) }
        switch action {
        case .buy:
            let buyRam = BuyRam(payer: name, receiver: name, quant: format(amount: ramBytes))
            startTransactionWith(data: buyRam,
                                 senderName: name,
                                 tableAccountName: EOSIOAction.buyram.tableAccountName,
                                 actionName: EOSIOAction.buyram.rawValue,
                                 completion: completion)
        case .sell:
            let sellRam = SellRam(account: name, bytes: ramBytes)
            startTransactionWith(data: sellRam,
                                 senderName: name,
                                 tableAccountName: EOSIOAction.sellram.tableAccountName,
                                 actionName: EOSIOAction.sellram.rawValue,
                                 completion: completion)
        }
    }
    
    func sign(transaction: TransactionRequest, completion: @escaping (_ result: EosTransactionResult?, _ error: Error?) -> Void) {
        do {
            guard
                let data = try? Data(base64: transaction.parameters),
                let jsonDict = jsonDict(from: data)
            else {
                return completion(nil, AMError(localizedTitle: CoreLocalization.upps.text, localizedDescription: CoreLocalization.uppsDsc.text, code: 0))
            }
            
            if let tr = try createSerializedTransaction(data: jsonDict, senderName: transaction.accountName, tableAccountName: transaction.tableName, actionName: transaction.action) {
                sign(transaction: tr) { result, e in
                    completion(result, e)
                }
            }
        } catch let e { completion(nil, e) }
    }
    
    private func startTransactionWith(data: Codable,
                                      senderName: String,
                                      tableAccountName: String,
                                      actionName: String,
                                      completion: @escaping (_ result: EosTransactionResult?, _ error: Error?) -> Void) {
        do {
            if let transaction = try createTransaction(data: data, senderName: senderName, tableAccountName: tableAccountName, actionName: actionName) {
                sign(transaction: transaction, completion: completion)
            } else {
                completion(nil, AMError(localizedTitle: BlockchainLocalization.trErrorTitle.text,
                                        localizedDescription: BlockchainLocalization.trErrorDsc.text,
                                        code: 500))
            }
        } catch let e { completion(nil, e) }
    }
    
    private func createTransaction(data: Codable, senderName: String, tableAccountName: String, actionName: String) throws -> EosioTransaction? {
        let action = try EosioTransaction.Action(
            account: EosioName(tableAccountName),
            name: EosioName(actionName),
            authorization: [
                EosioTransaction.Action.Authorization(
                    actor: EosioName(senderName),
                    permission: EosioName("active")
                )
            ], data: data
        )

        let transaction = transactionFactory.newTransaction()
        transaction.add(action: action)
        return transaction
    }
    
    private func createSerializedTransaction(data: [String: Any], senderName: String, tableAccountName: String, actionName: String) throws -> EosioTransaction? {
        let action = try EosioTransaction.Action(
            account: EosioName(tableAccountName),
            name: EosioName(actionName),
            authorization: [
                EosioTransaction.Action.Authorization(
                    actor: EosioName(senderName),
                    permission: EosioName("active")
                )
            ], data: data
        )
        
        let transaction = transactionFactory.newTransaction()
        transaction.add(action: action)
        return transaction
    }
    
    // EosioRpcTransactionResponse
    private func sign(transaction: EosioTransaction, completion: @escaping (_ result: EosTransactionResult?, _ error: Error?) -> Void) {
        currentTransaction = transaction
        transaction.signAndBroadcast { result in
            switch result {
            case .success:
                completion(EosTransactionResult(transactionId: transaction.transactionId), nil)
                
            case let .failure(failure):
                completion(nil, failure)
            }
        }
    }
    
    private func format(amount: Float) -> String {
        return String(format: "%.4f EOS", amount)
    }
}
