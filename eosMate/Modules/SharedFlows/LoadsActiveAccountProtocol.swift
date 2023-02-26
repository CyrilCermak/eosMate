//
//  LoadsActiveAccountProtocol.swift
//  eosMate
//
//  Created by Cyril on 20/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import RxSwift

protocol LoadsActiveAccounts {
    var selectAccountView: FlowSelectAccountView? { get set }
    var selectedActiveAccount: EOSAccount? { get set }
    func loadSaveAccounts()
    func didSelectAccount(account: EOSAccount)
}

extension LoadsActiveAccounts where Self: BaseVC {
    func loadSaveAccounts() {
        selectAccountView?.startRefreshing()
        services.blockchain.getRefreshedAccounts(onlyActive: true)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] account, leftToLoad in
                if leftToLoad == 0 {
                    self?.selectAccountView?.stopRefreshing()
                }
                if let account = account {
                    self?.selectAccountView?.add(account: account)
                }
            }, onError: { [weak self] error in
                self?.selectAccountView?.stopRefreshing()
                print(error)
            }).disposed(by: disposeBag)
    }
}
