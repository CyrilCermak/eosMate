//
//  TransactionsVC.swift
//  eosMate
//
//  Created by Cyril on 10/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class TransactionsVC: BaseVC {
    let transactionView = TransactionsView(frame: kBaseTopNavScreenSize)
    let didClickClose = PublishSubject<Void>()
    var selectedAccount = PublishSubject<EOSAccount>()
    private var currentAccount: EOSAccount?
    
    convenience init(services: Services, account: EOSAccount) {
        self.init(services: services)
        currentAccount = account
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        subscribeForSelectedTransaction()
        observePullDown()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let account = currentAccount else { return }
        getTransactionsFor(account: account)
    }
    
    override func loadView() {
        view = transactionView
    }
    
    private func setNavigation() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "btnCancelGrey"), style: .done, target: self, action: #selector(didClickCloseBtn))
        navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        navigationController?.navigationBar.layer.shadowRadius = 0
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), for: .default)
        
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    private func getTransactionsFor(account: EOSAccount) {
        guard let name = account.accountName else { return }
        title = name
        services.analytics.log(event: .transactionsSearch, info: ["accountName": name])
        transactionView.startRefreshing()
        services.blockchain.getAccountActions(name: name).subscribe(onNext: { [weak self] actions in
            guard let self = self else { return }
            self.transactionView.stopRefreshing()
            
            self.transactionView.accountName = name
            self.transactionView.transactions = actions
        }, onError: { e in
            self.transactionView.stopRefreshing()
            self.transactionView.showError()
            print(e)
        }).disposed(by: disposeBag)
    }
    
    private func subscribeForSelectedTransaction() {
        transactionView.selectedTransaction
            .subscribe(onNext: { [weak self] transaction in
                guard let self = self else { return }
                if let jsonData = try? JSONSerialization.data(withJSONObject: transaction.dictPayload ?? [:], options: .prettyPrinted) {
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        AMPopUpController.shared.createPopUp(at: self.navigationController?.view ?? self.view,
                                                             title: TransactionsLocalization.payload.text,
                                                             description: jsonString,
                                                             okCompletion: {})
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    private func observePullDown() {
        transactionView.refreshControl.rx.controlEvent(UIControlEvents.valueChanged)
            .filter { [weak self] pulledDown -> Bool in
                return (self?.transactionView.refreshControl.isRefreshing == true)
            }
            .subscribe(onNext: { [weak self] pulledDown in
                if let account = self?.currentAccount {
                    self?.getTransactionsFor(account: account)
                }
            }).disposed(by: disposeBag)
    }
    
    @objc func didClickCloseBtn() {
        didClickClose.onNext(())
    }
}
