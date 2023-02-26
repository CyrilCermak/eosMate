//
//  RequestTransactionFlowVC.swift
//  eosMate
//
//  Created by Cyril Cermak on 07.06.20.
//  Copyright © 2020 CyrilCermak. All rights reserved.
//

import UIKit

class RequestTransactionFlowVC: BasePopVC, LoadsActiveAccounts {
    weak var delegate: FinishesFlow?

    lazy var selectAccountView: FlowSelectAccountView? = requestTransactionView.selectAccountView
    var selectedActiveAccount: EOSAccount? { didSet { summaryView.toAccount = selectedActiveAccount }}
    var transactionRequestType: TransactionRequestType = .tokens
    
    private var fromAccount: EOSAccount? { didSet { self.summaryView.fromAccount = fromAccount }}
    private var amount: String? { didSet { self.summaryView.eosAmount = amount?.formatAmount() }}
    
    private var netAmount: String? { didSet { self.summaryView.eosAmount = "CPU: \(amount ?? "0"); NET: \(netAmount ?? "0")" }} // Net amount for Stake
    
    let requestTransactionView = RequestTransactionFlowView(frame: UIScreen.main.bounds)
    
    lazy var summaryView: RequestTransactionSummaryView = requestTransactionView.summaryView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeCloseBtn()
        subscribeForEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadSaveAccounts()
    }
    
    override func loadView() {
        self.view = requestTransactionView
        requestTransactionView.accountSearchView.delegate = self
    }
    
    private func observeCloseBtn() {
        requestTransactionView.rightBtnClicked.subscribe(onNext: { [weak self] clicked in
            guard let self = self else { return }
            self.requestTransactionView.endEditing(true)
            self.delegate?.didFinishFlow(at: self)
        }).disposed(by: disposeBag)
    }
    
    func didSelectAccount(account: EOSAccount) {
        self.selectedActiveAccount = account
    }
    
    private func subscribeForEvents() {
        requestTransactionView.transactionTypeView.actionSelected.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            self.transactionRequestType = type
            self.requestTransactionView.transactionRequestType = type
            self.requestTransactionView.moveScrollView(toFront: true)
        }).disposed(by: disposeBag)
        
        requestTransactionView.accountSearchView.didTapContinue.subscribe(onNext: { [weak self] account in
            guard let self = self else { return }
            self.fromAccount = account
            self.requestTransactionView.moveScrollView(toFront: true)
            self.requestTransactionView.amountToSendView.becomeActive()
        }).disposed(by: disposeBag)
        
        requestTransactionView.selectAccountView.didSelectAccount.subscribe(onNext: { [weak self] account in
            guard let self = self else { return }
            self.selectedActiveAccount = account
            self.requestTransactionView.moveScrollView(toFront: true)
            self.requestTransactionView.accountSearchView.becomeActive()
        }).disposed(by: disposeBag)
        
        requestTransactionView.amountToSendView.didTapContinue.subscribe(onNext: { [weak self] amount in
            guard let self = self else { return }
            self.amount = amount
            self.requestTransactionView.moveScrollView(toFront: true)
            
            if case self.transactionRequestType = TransactionRequestType.stake {
                self.requestTransactionView.netAmountToSendView.becomeActive()
            }
        }).disposed(by: disposeBag)
        
        requestTransactionView.netAmountToSendView.didTapContinue.subscribe(onNext: { [weak self] amount in
            guard let self = self else { return }
            self.netAmount = amount
            self.requestTransactionView.moveScrollView(toFront: true)
        }).disposed(by: disposeBag)
        
        requestTransactionView.summaryView.didTapSend.subscribe(onNext: { [weak self] tapped in
            guard let self = self else { return }
            if let requestee = self.selectedActiveAccount, let reciever = self.fromAccount, let amount = self.amount?.formatAmount() {
                self.sendRequest(from: requestee, reciever: reciever, amount: amount, type: self.transactionRequestType)
            }
        }).disposed(by: disposeBag)
    }
    
    private func sendRequest(from requestee: EOSAccount, reciever: EOSAccount, amount: String, type: TransactionRequestType) {
        guard let requesteeName = requestee.accountName,
              let recieverName = reciever.accountName,
              let transactionModel = makeTransactionModel(from: requesteeName, recieverName: recieverName, amount: amount)
        else {
            let error = AMError(localizedTitle: CoreLocalization.upps.text,
                                localizedDescription: CoreLocalization.uppsDsc.text,
                                code: 0)
            
            return showErrorMessage(error)
        }

        services.transactions.sendTransaction(request: transactionModel)
            .subscribe(onNext: { [weak self] processedTransaction in
                guard let self = self else { return }
                self.showPopUpWith(title: CoreLocalization.success.text, message: processedTransaction.id, okeyCompletion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.requestTransactionView.endEditing(true)
                        self.services.analytics.log(event: .requestedTransaction, info: nil)
                        self.delegate?.didFinishFlow(at: self)
                    }
                })
            }, onError: { [weak self] error in
                self?.showErrorMessage(error)
            }).disposed(by: disposeBag)
    }
    
    private func makeTransactionModel(from requesteeName: String, recieverName: String, amount: String) -> MateTransactionRequest? {
        switch transactionRequestType {
        case .tokens:
            let transferModel = Transfer(from: recieverName,
                                         to: requesteeName,
                                         quantity: amount,
                                         memo: RequestTransactionLocalization.sentFromMate.text)
            
            guard let parameters = try? JSONEncoder().encode(transferModel).base64EncodedString() else {
                let error = AMError(localizedTitle: CoreLocalization.upps.text,
                                    localizedDescription: CoreLocalization.uppsDsc.text,
                                    code: 0)
                
                self.showErrorMessage(error)
                return nil
            }
            
            return MateTransactionRequest(id: 0,
                                          type: .tokens,
                                          transactionName: "\(RequestTransactionLocalization.requestEosFrom.text) \(requesteeName)",
                                          accountName: recieverName,
                                          tableName: EOSIOAction.transfer.tableAccountName,
                                          action: EOSIOAction.transfer.rawValue,
                                          parameters: parameters)
            
        case .ram:
            let ramModel = BuyRam(payer: recieverName, receiver: requesteeName, quant: amount)
            guard let parameters = try? JSONEncoder().encode(ramModel).base64EncodedString() else {
                let error = AMError(localizedTitle: CoreLocalization.upps.text,
                                    localizedDescription: CoreLocalization.uppsDsc.text,
                                    code: 0)
                self.showErrorMessage(error)
                return nil
            }
            
            return MateTransactionRequest(id: 0,
                                          type: .ram,
                                          transactionName: "\(RequestTransactionLocalization.requestRamFrom.text) \(requesteeName)",
                                          accountName: recieverName,
                                          tableName: EOSIOAction.buyram.tableAccountName,
                                          action: EOSIOAction.buyram.rawValue,
                                          parameters: parameters)
            
        case .stake:
            let stakeModel = StakeTransfer(from: recieverName, receiver: requesteeName, stakeNetQuantity: netAmount?.formatAmount() ?? "0 EOS", stakeCpuQuantity: amount)
            
            guard let parameters = try? JSONEncoder().encode(stakeModel).base64EncodedString() else {
                let error = AMError(localizedTitle: CoreLocalization.upps.text,
                                    localizedDescription: CoreLocalization.uppsDsc.text,
                                    code: 0)
                
                self.showErrorMessage(error)
                return nil
            }
            
            return MateTransactionRequest(id: 0,
                                          type: .stake,
                                          transactionName: "\(RequestTransactionLocalization.requestStakeFrom.text) \(requesteeName)",
                                          accountName: recieverName,
                                          tableName: EOSIOAction.delegatebw.tableAccountName,
                                          action: EOSIOAction.delegatebw.rawValue,
                                          parameters: parameters)
            
        default:
            fatalError("Not yet implemented!")
        }
    }
}

extension RequestTransactionFlowVC: AccountSearchViewDelegate {
    func didClickSearch(for name: String) {
        requestTransactionView.accountSearchView.startSpinning()
        services.blockchain.getAccount(name: name.lowercased()).asObservable()
            .subscribe(onNext: { [weak self] account in
                self?.requestTransactionView.accountSearchView.set(account: account)
            }, onError: { [weak self] error in
                self?.requestTransactionView.accountSearchView.stopSpinning()
                self?.requestTransactionView.accountSearchView.removeAccount()
                self?.showErrorMessage(AMError(localizedTitle: RequestTransactionLocalization.notFound.text,
                                               localizedDescription: RequestTransactionLocalization.notFoundDsc.text,
                                               code: 500))
            }).disposed(by: disposeBag)
    }
    
    func didClickOtherTokens(for account: EOSAccount) {}
    
    func searchDidBecomeActive() {
        DispatchQueue.main.async {
            self.requestTransactionView.accountSearchView.removeAccount()
        }
    }
}
