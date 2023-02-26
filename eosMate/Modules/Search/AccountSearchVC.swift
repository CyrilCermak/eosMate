//
//  ProfileSearchVC.swift
//  eosMate
//
//  Created by Cyril on 1/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

enum AccountSearchVCType {
    case search, addAccount
}

protocol AccountSearchDelegate: AnyObject {
    func presentTransactions(for account: EOSAccount)
    func presentOtherTokens(for account: EOSAccount)
}

class AccountSearchVC: BaseVC {
    weak var delegate: AccountSearchDelegate?
    
    let searchView = AccountSearchView(frame: kBaseTopNavScreenSize)
    
    convenience init(services: Services, title: String) {
        self.init(services: services)
        self.title = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeForTransactions()
    }
    
    override func loadView() {
        view = searchView
        searchView.delegate = self
        searchView.addTransactionBtn()
    }
    
    private func subscribeForTransactions() {
        searchView.didClickTransactions.subscribe(onNext: { [weak self] clicked in
            guard let account = self?.searchView.account else { return }
            self?.delegate?.presentTransactions(for: account)
        }).disposed(by: disposeBag)
    }
}

extension AccountSearchVC: AccountSearchViewDelegate {
    func didClickSearch(for name: String) {
        services.analytics.log(event: .search, info: ["accountName": name])
        searchView.startSpinning()
        services.blockchain.getAccount(name: name.lowercased()).asObservable()
            .subscribe(onNext: { [weak self] account in
                self?.searchView.set(account: account)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                
                self.searchView.stopSpinning()
                self.searchView.removeAccount()
                self.showErrorMessage(AMError(localizedTitle: SearchLocalization.notFoundTitle.text,
                                              localizedDescription: SearchLocalization.notFoundDsc.text,
                                              code: 500))
            }).disposed(by: disposeBag)
    }
    
    func didClickOtherTokens(for account: EOSAccount) {
        delegate?.presentOtherTokens(for: account)
    }
    
    func searchDidBecomeActive() {
        DispatchQueue.main.async {
            self.searchView.removeAccount()
        }
    }
}
