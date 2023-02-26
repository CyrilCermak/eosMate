//
//  ResourceFlowView.swift
//  eosMate
//
//  Created by Cyril on 20/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum ResourceAction {
    case stake, unstake
    
    var name: String {
        switch self {
        case .stake: return "STAKE"
        case .unstake: return "UNSTAKE"
        }
    }
}

class ResourceFlowView: BaseFlowView, SpinsOnMainAction {
    let selectActionView = FlowSelectActionView(type: .stake)
    let selectAccountView = FlowSelectAccountView()
    let cpuInputView = FlowInputView()
    let netInputView = FlowInputView()
    let summaryView = ResourceSummaryView()
    
    lazy var views = {
        return [selectActionView, selectAccountView, cpuInputView, netInputView, summaryView]
    }()
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    private func setView() {
        titles.append(contentsOf: [
            ResourcesFlowLocalization.selectAction.text,
            ResourcesFlowLocalization.activeAccount.text,
            ResourcesFlowLocalization.cpu.text,
            ResourcesFlowLocalization.net.text,
            ResourcesFlowLocalization.summary.text
        ])
        mainActionView.contentSize = CGSize(width: CGFloat(views.count) * screenSize.width, height: screenSize.height)
        for (index, view) in views.enumerated() {
            view.frame = CGRect(x: CGFloat(index) * screenSize.width, y: 64, width: screenSize.width, height: screenSize.height - 64)
            mainActionView.addSubview(view)
        }
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
