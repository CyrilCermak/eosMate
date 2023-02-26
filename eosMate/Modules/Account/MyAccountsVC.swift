//
//  AccountVC.swift
//  eosMate
//
//  Created by Cyril on 1/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol MyAccountsDelegate: AnyObject {
    func wantsToAddAccount(at vc: MyAccountsVC)
    func showAccountDetail(for account: EOSAccount, at: BaseVC)
}

class MyAccountsVC: BaseVC {
    weak var delegate: MyAccountsDelegate?
    
    let accountView = MyAccountsView(frame: kBaseTopNavScreenSize)
    
    convenience init(services: Services, title: String) {
        self.init(services: services)
        self.title = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSaveAccounts()
        subscribeForAddAccountViewEvents()
        subscribeForDeleteEvents()
        accountView.startRefreshing()
        observePullDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func loadView() {
        view = accountView
    }
    
    private func getSaveAccounts() {
        services.blockchain.getRefreshedAccounts(onlyActive: false)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] account, leftToLoad in
                if leftToLoad == 0 {
                    self?.accountView.stopRefreshing()
                }
                if let account = account {
                    self?.accountView.add(account: account)
                }
            }, onError: { [weak self] error in
                self?.accountView.stopRefreshing()
                print(error)
            }).disposed(by: disposeBag)
    }
    
    private func subscribeForAddAccountViewEvents() {
        accountView.didClickAdd.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] clicked in
            guard let self = self else { return }
            self.delegate?.wantsToAddAccount(at: self)
        }).disposed(by: disposeBag)
        
        accountView.didSelectAccount.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] account in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.delegate?.showAccountDetail(for: account, at: self)
            }
        }).disposed(by: disposeBag)
    }
    
    func didAdded(account: EOSAccount) {
        accountView.add(account: account)
    }
    
    private func observePullDown() {
        accountView.refreshControl.rx.controlEvent(UIControlEvents.valueChanged)
            .filter { [weak self] pulledDown -> Bool in
                return (self?.accountView.refreshControl.isRefreshing == true)
            }
            .subscribe(onNext: { [weak self] pulledDown in
                self?.getSaveAccounts()
            }).disposed(by: disposeBag)
    }
    
    private func subscribeForDeleteEvents() {
        accountView.didTapDeleteAccount.subscribe(onNext: { [weak self] account in
            self?.assureToDelete(account: account)
        }).disposed(by: disposeBag)
    }
    
    func assureToDelete(account: EOSAccount) {
        let options = AMPopUpOptions(firstButtonTitle: AccountFlowLocalization.deleteIt.text,
                                     secondButtonTitle: AccountFlowLocalization.cancel.text,
                                     title: AccountFlowLocalization.deleteAccountConfirmTitle.text,
                                     text: "\(AccountFlowLocalization.deleteAccountConfirmDsc.text)(\(account.accountName ?? ""))")
        AMPopUpController.shared
            .createPopUp(at: parentingVC?.view ?? view,
                         options: options,
                         firstBtn: { [weak self] in
                             self?.services.blockchain.deleteCachedAccount(account: account)
                             self?.accountView.remove(account: account)
                         }, secondBtn: {})
    }
}
