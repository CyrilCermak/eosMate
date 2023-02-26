//
//  SignTransaction.swift
//  eosMate
//
//  Created by Cyril on 21/6/19.
//  Copyright © 2019 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SignTransactionVC: BasePopVC {
    let signTransactionView = SignTransactionView(frame: screenSize)
    var transaction: MateTransactionRequest? { didSet { signTransactionView.transaction = transaction } }
    let transactionSigend = PublishSubject<MateTransactionRequest>()
    let transactionNotDeleted = PublishSubject<Error>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = SignTransactionLocalization.screenTitle.text
        
        bindView()
        subscribeForParametrsSelection()
    }
    
    override func loadView() {
        view = signTransactionView
    }
    
    private func bindView() {
        signTransactionView
            .didTapSign
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { tap in self.signTransaction() })
            .disposed(by: disposeBag)
    }
    
    private func signTransaction() {
        guard let transaction = transaction else { return }
        signTransactionView.startRefreshing()
        
        services.blockchain.sign(transaction: TransactionRequest(tr: transaction)) { [weak self] tr, e in
            guard let self = self else { return }
            self.signTransactionView.stopRefreshing()

            if let error = e { return self.showErrorMessage(error) }
            self.deleteSigned(transactionRequest: transaction)
            self.transactionSigend.onNext(transaction)
            self.services.analytics.log(event: .signedTransactionFromMate, info: nil)
            self.showPopUpWith(title: SignTransactionLocalization.transaction.text,
                               message: tr?.transactionId ?? "", okeyCompletion: { [weak self] tapped in
                                   self?.didClickClose.onNext(())
                               })
        }
    }
    
    private func deleteSigned(transactionRequest: MateTransactionRequest) {
        services.transactions.deleteTransaction(request: transactionRequest).subscribe(onError: { error in
            self.transactionNotDeleted.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    private func subscribeForParametrsSelection() {
        signTransactionView.didSelectParametrs.subscribe(onNext: { [weak self] tr in
            guard let self = self else { return }
            
            let navView = self.navigationController?.view
            AMPopUpController.shared.createPopUp(at: navView ?? self.view,
                                                 title: SignTransactionLocalization.payload.text,
                                                 description: tr.parameters,
                                                 okCompletion: {})
        }).disposed(by: disposeBag)
    }
}
