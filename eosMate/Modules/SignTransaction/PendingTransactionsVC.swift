//
//  PendingTransactionsVC.swift
//  eosMate
//
//  Created by Cyril on 22/9/19.
//  Copyright © 2019 CyrilCermak. All rights reserved.
//

import UIKit
import RxSwift

protocol PendingTransactionTappable: AnyObject {
    var didSelect: ((_ pendingTransaction: MateTransactionRequest, _ vc: PendingTransactionsVC) -> Void)? { get set }
}

class PendingTransactionsVC: BasePopVC, PendingTransactionTappable {
    let pendingView = PendingTransactionsView(frame: kBaseTopNavScreenSize)
    var didSelect: ((_ pendingTransaction: MateTransactionRequest, _ vc: PendingTransactionsVC) -> Void)?
    
    convenience init(services: Services, title: String?) {
        self.init(services: services)
        self.title = title
        getPendingTransactions()
        observePullDown()
        subscribeForSelectedTransaction()
    }
    
    override func loadView() {
        view = pendingView
    }
    
    private func getPendingTransactions() {
        services.blockchain.getCachedAccounts(onlyActive: true)
            .subscribe(onNext: { [weak self] accounts in
                self?.getPendingTransaction(for: accounts.map { $0.name })
            }).disposed(by: disposeBag)
    }
    
    private func getPendingTransaction(for accountNames: [String]) {
        var accountNames = accountNames
        guard accountNames.count > 0, let name = accountNames.popLast() else {
            return pendingView.stopRefreshing()
        }
        
        let includedIds = pendingView.pendingTransactions.map { $0.id }
        pendingView.startRefreshing()
        services.transactions
            .getPendingTranscations(accountName: name)
            .subscribe(onNext: { [weak self] pendingTransactions in
                pendingTransactions.forEach { tr in
                    if !includedIds.contains(tr.id) {
                        self?.pendingView.pendingTransactions.append(tr)
                    }
                }
                self?.getPendingTransaction(for: accountNames)
            }, onError: { [weak self] error in
                self?.pendingView.showError()
            }).disposed(by: disposeBag)
    }
    
    private func observePullDown() {
        pendingView.refreshControl.rx.controlEvent(UIControlEvents.valueChanged)
            .filter { [weak self] pulledDown -> Bool in
                return (self?.pendingView.refreshControl.isRefreshing == true)
            }
            .subscribe(onNext: { [weak self] pulledDown in
                self?.getPendingTransactions()
            }).disposed(by: disposeBag)
    }
    
    private func subscribeForSelectedTransaction() {
        pendingView.selectedTransaction
            .subscribe(onNext: { [weak self] transaction in
                guard let self = self else { return }
                self.didSelect?(transaction, self)
            }).disposed(by: disposeBag)
        
        pendingView.transactionToDelete
            .subscribe(onNext: { [weak self] transaction in
                guard let self = self else { return }
                self.confirmDeletion(for: transaction)
            }).disposed(by: disposeBag)
    }
    
    private func confirmDeletion(for transaction: MateTransactionRequest) {
        let options = AMPopUpOptions(firstButtonTitle: SignTransactionLocalization.pendingOk.text,
                                     secondButtonTitle: SignTransactionLocalization.pendingCancel.text,
                                     title: SignTransactionLocalization.pendingTitleDeleteIt.text,
                                     text: SignTransactionLocalization.pendingTitleText.text)
        AMPopUpController.shared.createPopUp(at: navigationController?.view ?? view, options: options,
                                             firstBtn: { [weak self] in self?.delete(transaction: transaction) },
                                             secondBtn: {})
    }
    
    private func delete(transaction: MateTransactionRequest) {
        services.transactions.deleteTransaction(request: transaction)
            .subscribe(onNext: { [weak self] response in
                if response.statusCode == 200 {
                    self?.pendingView.pendingTransactions.removeAll(where: { $0.id == transaction.id })
                    self?.showPopUpWith(title: SignTransactionLocalization.transactionDeleted.text,
                                        message: "")
                }
            }, onError: { [weak self] error in
                self?.showErrorMessage(error)
            }).disposed(by: disposeBag)
    }
    
    func signed(transaction: MateTransactionRequest) {
        pendingView.pendingTransactions.removeAll(where: { $0.id == transaction.id })
    }
}
