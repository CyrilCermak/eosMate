//
//  SendTokensFlowView.swift
//  eosMate
//
//  Created by Cyril on 25/9/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SendTokensFlowView: BaseFlowView, SpinsOnMainAction {
    private var fromAccount: EOSAccount? { didSet { summaryView.fromAccount = fromAccount }}
    private var toAccount: EOSAccount? { didSet { summaryView.toAccount = toAccount }}
    private var amount: String? { didSet { summaryView.eosAmount = amount?.formatAmount() }}
    
    let selectAccountView = FlowSelectAccountView()
    let accountSearchView = SendTokensFindAccountView()
    let amountToSendView = FlowInputView()
    let summaryView = SendTokensSummaryView()
    lazy var views = {
        return [selectAccountView, accountSearchView, amountToSendView, summaryView]
    }()
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    private func setView() {
        self.titles.append(contentsOf: [
            TokensFlowLocalization.activeAccounts.text,
            TokensFlowLocalization.receiver.text,
            TokensFlowLocalization.amount.text,
            TokensFlowLocalization.summary.text
        ])
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
}
