//
//  AddAccountVC.swift
//  eosMate
//
//  Created by Cyril on 5/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AddAccountVC: BaseVC {
    let addAccountView = AddAccountView(frame: kBaseTopNavScreenSize)
    let didClickClose = PublishSubject<Void>()
    let didAddedAccount = PublishSubject<EOSAccount>()
    let didClickOtherTokens = PublishSubject<EOSAccount>()
    var searchedAccount: String?
    var pk: String? {
        return self.addAccountView.pk.value?.replacingOccurrences(of: "\n", with: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeForViewEvents()
        addAccountView.delegate = self
    }
    
    override func loadView() {
        view = addAccountView
    }
    
    private func subscribeForViewEvents() {
        addAccountView.closeButton.rx.tap.bind(to: didClickClose).disposed(by: disposeBag)
        
        addAccountView.didClickAdd.subscribe(onNext: { [weak self] tap in
            guard let self = self else { return }
            
            if let account = self.addAccountView.account {
                self.cacheAndObserve(account: account, withPK: self.pk)
            }
        }).disposed(by: disposeBag)
        
        addAccountView.didClickDone.subscribe(onNext: { [weak self] tapped in
            guard let self = self else { return }
            
            if let error = self.services.blockchain.validatedPKwithError(string: self.pk) {
                self.showErrorMessage(error)
            }
        }).disposed(by: disposeBag)
    }
    
    private func cacheAndObserve(account: EOSAccount, withPK pk: String?) {
        services.observer.subscribeFor(account: CachedEOSAccount(name: account.accountName ?? "", latestVolume: 0.0, isActive: false, pub: account.pub ?? ""))
        services.analytics.log(event: .subscribeAccount, info: ["accountName": account.accountName ?? ""])
        if let _ = services.blockchain.validatedPKwithError(string: pk) {
            let error = AMError(localizedTitle: AccountFlowLocalization.pkNotCorrect.text,
                                localizedDescription: AccountFlowLocalization.pkNotCorrectDsc.text,
                                code: 300)
            return showErrorMessage(error, completion: { [weak self] in
                self?.fetchKeyAccounts(for: account)
            })
        }
        fetchKeyAccounts(for: account)
    }
    
    private func fetchKeyAccounts(for account: EOSAccount) {
        services.blockchain.getKeyAccounts(pub: account.pub ?? "").subscribe(onNext: { keyAccounts in
            guard keyAccounts.accountNames.count > 1 else {
                self.save(pk: self.pk ?? "", for: account)
                self.didAddedAccount.onNext(account)
                return self.didClickClose.onNext(())
            }
            
            var options = AMPopUpOptions()
            options.firstButtonTitle = AccountFlowLocalization.yes.text
            options.secondButtonTitle = "\(AccountFlowLocalization.noJust.text) \(account.accountName ?? "")"
            options.text = "\(AccountFlowLocalization.addRelatedAccounts.text) (\(keyAccounts.accountNames.joined(separator: ", ")))"
            options.title = AccountFlowLocalization.relatedAccounts.text
            AMPopUpController.shared.createPopUp(at: self.view,
                                                 options: options,
                                                 firstBtn: { [weak self] in
                                                     self?.addAccountView.hasSpinningProgress = true
                                                     self?.addRelatedAccounts(accountNames: keyAccounts.accountNames.reversed())
                                                     self?.didAddedAccount.onNext(account)
                                                 },
                                                 secondBtn: { [weak self] in
                                                     guard let self = self else { return }
                                                    
                                                     self.save(pk: self.pk ?? "", for: account)
                                                     self.didClickClose.onNext(())
                                                     self.didAddedAccount.onNext(account)
                                                 })
        }, onError: { [weak self] error in
            guard let self = self else { return }
            AMPopUpController.shared.createPopUp(at: self.view,
                                                 title: AccountFlowLocalization.noSubAccounts.text,
                                                 description: "\(AccountFlowLocalization.noSubAccountsDsc.text) (\(account.accountName ?? "")).") {
                self.save(pk: self.pk ?? "", for: account)
                self.didClickClose.onNext(())
                self.didAddedAccount.onNext(account)
            }
        }).disposed(by: disposeBag)
    }
    
    private func save(pk: String, for account: EOSAccount) {
        services.analytics.log(event: .addedPK, info: nil)
        let pkError = services.blockchain.savePKfor(account: account, pk: pk)
        services.blockchain.cache(account: account, isActive: pkError == nil)
    }
    
    private func addRelatedAccounts(accountNames: [String]) {
        var accountNames = accountNames
        
        guard accountNames.count > 0 else {
            addAccountView.hasSpinningProgress = false
            return didClickClose.onNext(())
        }
        
        if let accountName = accountNames.popLast() {
            services.blockchain.getAccount(name: accountName).subscribe(onNext: { [weak self] account in
                guard let self = self else { return }
                
                let pkError = self.services.blockchain.savePKfor(account: account, pk: self.pk ?? "")
                self.services.blockchain.cache(account: account, isActive: pkError == nil)
                self.didAddedAccount.onNext(account)
                self.addRelatedAccounts(accountNames: accountNames)
                self.services.observer.subscribeFor(account: CachedEOSAccount(name: account.accountName ?? "", latestVolume: 0.0, isActive: false, pub: account.pub ?? ""))
            }).disposed(by: disposeBag)
        }
    }
}

extension AddAccountVC: AccountSearchViewDelegate {
    func didClickOtherTokens(for account: EOSAccount) {
        didClickOtherTokens.onNext(account)
    }
    
    func didClickSearch(for name: String) {
        addAccountView.hasSpinningProgress = true
        services.blockchain.getAccount(name: name.lowercased()).asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] account in
                self?.addAccountView.hasSpinningProgress = false
                self?.addAccountView.set(account: account)
            }, onError: { [weak self] error in
                self?.addAccountView.hasSpinningProgress = false
                self?.showErrorMessage(AMError(localizedTitle: AccountFlowLocalization.notFound.text,
                                               localizedDescription: AccountFlowLocalization.notFoundDsc.text,
                                               code: 500))
            }).disposed(by: disposeBag)
    }
    
    func searchDidBecomeActive() {
        addAccountView.removeAccount()
    }
}
