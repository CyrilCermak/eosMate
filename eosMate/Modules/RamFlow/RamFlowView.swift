//
//  RamFlowView.swift
//  eosMate
//
//  Created by Cyril on 20/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum RamAction {
    case buy, sell
    
    var name: String {
        switch self {
        case .buy: return "BUY"
        case .sell: return "SELL"
        }
    }
}

class RamFlowView: BaseFlowView, SpinsOnMainAction {
    let selectActionView = FlowSelectActionView(type: .ram)
    let selectAccountView = FlowSelectAccountView()
    let ramBytesView = FlowInputView()
    let summaryView = RamSummaryView()
    
    lazy var views = {
        return [selectActionView, selectAccountView, ramBytesView, summaryView]
    }()
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    private func setView() {
        titles.append(contentsOf: [
            RamFlowLocalization.selectAction.text,
            RamFlowLocalization.activeAccount.text,
            RamFlowLocalization.ramBytes.text,
            RamFlowLocalization.summary.text
        ])
        
        mainActionView.contentSize = CGSize(width: CGFloat(views.count) * screenSize.width, height: screenSize.height)
        for (index, view) in views.enumerated() {
            view.frame = CGRect(x: CGFloat(index) * screenSize.width, y: 64, width: screenSize.width, height: screenSize.height - 64)
            mainActionView.addSubview(view)
        }
    }
    
    func updateTitleFor(action: RamAction) {
        titles[2] = action == .buy ? RamFlowLocalization.ramInEos.text : RamFlowLocalization.ramBytes.text
    }
    
    override func didScroll() {
        endEditing(true)
    }
    
    func setSpinnerTo(action: SpinnerAction) {
        let isSpinning = action == .active
        isUserInteractionEnabled = !isSpinning
        summaryView.hasSpinningProgress = isSpinning
    }
}
