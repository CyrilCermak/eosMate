//
//  RamFlowSummaryView.swift
//  eosMate
//
//  Created by Cyril on 20/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class RamSummaryView: BaseFlowSummaryView {
    var action: RamAction? { didSet { reload() }}
    var activeAccount: EOSAccount? { didSet { self.reload() }}
    var ramAmount: Float? { didSet { self.reload() }}
    
    @available(*, unavailable)  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setCells()
    }
    
    private func setCells() {
        self.cells = [InfoInputCell(), InfoInputCell(), InfoInputCell()]
    }
    
    private func reload() {
        self.checkForButton()
        self.tableView.reloadData()
    }
    
    func checkForButton() {
        sendButton.isEnabled = action != nil && activeAccount != nil && ramAmount != nil
    }
}

extension RamSummaryView {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if hasSpinningProgress, indexPath.row == cells.count { return SpinningCell() }
        let cell = cells[indexPath.row]
        cell.inputField.isUserInteractionEnabled = false
        switch indexPath.row {
        case 0: cell.set(text: action?.name ?? "", withInfo: RamFlowLocalization.action.text)
        case 1: cell.set(text: activeAccount?.accountName ?? "", withInfo: RamFlowLocalization.account.text)
        case 2: cell.set(text: "\(ramAmount ?? 0)",
                         withInfo: (action ?? .buy) == .buy ? RamFlowLocalization.ramInEos.text : RamFlowLocalization.ramBytes.text)
        default: break
        }
        return cell
    }
}
