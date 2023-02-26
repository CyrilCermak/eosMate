//
//  AccountDetailVC.swift
//  eosMate
//
//  Created by Cyril on 6/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AccountDetailVC: BasePopVC {
    private var account: EOSAccount?
    let accountView = AccountDetailView(frame: kBaseTopNavScreenSize)
    let didClickTransaction = PublishSubject<EOSAccount>()
    let didClickOtherTokens = PublishSubject<EOSAccount>()
    
    convenience init(services: Services, title: String, account: EOSAccount) {
        self.init(services: services)
        self.title = title
        accountView.account = account
        self.account = account
        
        if self.services.blockchain.isActive(account: account) == false {
            addNavigationPlusButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAccountTransactionsBtn()
    }
    
    override func loadView() {
        view = accountView
    }
    
    private func addNavigationPlusButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: AccountFlowLocalization.addPk.text,
                                                           style: .done, target: self, action: #selector(didClickAdd))
    }
    
    private func bindAccountTransactionsBtn() {
        accountView.didClickTransactions.bind(to: didClickTransaction).disposed(by: disposeBag)
        accountView.didClickShowOtherTokens.bind(to: didClickOtherTokens).disposed(by: disposeBag)
    }
    
    @objc func didClickAdd() {
        let options = AMPopUpOptions(firstButtonTitle: AccountFlowLocalization.btnAdd.text,
                                     secondButtonTitle: AccountFlowLocalization.cancel.text,
                                     title: "\(AccountFlowLocalization.addPk.text) \(account?.accountName ?? "")",
                                     text: AccountFlowLocalization.addPkDsc.text)
        AMPopUpController.shared
            .createInputPopUp(at: navigationController?.view ?? view,
                              options: options,
                              yesBtn: { [weak self] pk in
                                  guard let self = self, let account = self.account else { return }
                                  self.view.endEditing(true)
                                  self.update(account: account, withPK: pk)
                                
                              }, cancelBtn: { self.view.endEditing(true) })
    }
    
    private func update(account: EOSAccount, withPK pk: String) {
        if let pkError = services.blockchain.savePKfor(account: account, pk: pk) {
            return showErrorMessage(pkError)
        }
        navigationItem.leftBarButtonItem = nil
    }
}
