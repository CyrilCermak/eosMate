//
//  RequestTransactionFlowView.swift
//  eosMate
//
//  Created by Cyril Cermak on 07.06.20.
//  Copyright © 2020 CyrilCermak. All rights reserved.
//

import UIKit

class RequestTransactionFlowView: BaseFlowView, SpinsOnMainAction {
    var transactionRequestType: TransactionRequestType = .tokens {
        didSet {
            summaryView.requestType = transactionRequestType
            setTitles()
        }
    }
    
    private var toAccount: EOSAccount? { didSet { summaryView.toAccount = toAccount }}
    private var amount: String? { didSet { summaryView.eosAmount = amount?.formatAmount() }}
    
    let transactionTypeView = FlowSelectTransactionView()
    let selectAccountView = FlowSelectAccountView()
    let accountSearchView = SendTokensFindAccountView()
    let amountToSendView = FlowInputView()
    let netAmountToSendView = FlowInputView()
    let summaryView = RequestTransactionSummaryView()
    
    lazy var views = {
        return [transactionTypeView, selectAccountView, accountSearchView, amountToSendView, summaryView]
    }()
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init(frame: CGRect) {
        super.init(frame: frame)
        titles.append(contentsOf: [
            RequestTransactionLocalization.selectRequest.text,
            RequestTransactionLocalization.requesteeAccount.text,
            RequestTransactionLocalization.requestingFrom.text,
            RequestTransactionLocalization.requestingAmount.text,
            RequestTransactionLocalization.requestingDetail.text
        ])
        setView()
    }
    
    private func setView() {
        self.mainActionView.contentSize = CGSize(width: CGFloat(views.count) * screenSize.width, height: screenSize.height)
        for (index, view) in views.enumerated() {
            view.frame = CGRect(x: CGFloat(index) * screenSize.width, y: 64, width: screenSize.width, height: screenSize.height - 64)
            self.mainActionView.addSubview(view)
        }
    }
    
    override func didScroll() {
        self.endEditing(true)
    }
    
    func setSpinnerTo(action: SpinnerAction) {
        let isSpinning = action == .active
        self.isUserInteractionEnabled = !isSpinning
        self.summaryView.hasSpinningProgress = isSpinning
    }
    
    private func setTitles() {
        views = [transactionTypeView, selectAccountView, accountSearchView, amountToSendView, summaryView]
        setView()
        switch transactionRequestType {
        case .tokens:
            titles = [
                RequestTransactionLocalization.selectRequest.text,
                RequestTransactionLocalization.requesteeAccount.text,
                RequestTransactionLocalization.requestingFrom.text,
                RequestTransactionLocalization.requestingAmount.text,
                RequestTransactionLocalization.requestingDetail.text
            ]
        case .ram:
            titles = [
                RequestTransactionLocalization.selectRequest.text,
                RequestTransactionLocalization.requesteeAccount.text,
                RequestTransactionLocalization.requestingFrom.text,
                RequestTransactionLocalization.ramInEos.text,
                RequestTransactionLocalization.requestingDetail.text
            ]
        case .stake:
            titles = [
                RequestTransactionLocalization.selectRequest.text,
                RequestTransactionLocalization.requesteeAccount.text,
                RequestTransactionLocalization.requestingFrom.text,
                RequestTransactionLocalization.requestinigCPUAmount.text,
                RequestTransactionLocalization.requestinigNETAmount.text,
                RequestTransactionLocalization.requestingDetail.text
            ]
            
            views = [
                transactionTypeView,
                selectAccountView,
                accountSearchView,
                amountToSendView,
                netAmountToSendView,
                summaryView
            ]
            
            setView()
        case .custom:
            // Not implemented yet for the flow
            titles = []
        }
    }
}
