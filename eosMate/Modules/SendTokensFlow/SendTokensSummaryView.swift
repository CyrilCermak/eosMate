//
//  SendTokensSummaryView.swift
//  eosMate
//
//  Created by Cyril on 29/9/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class SendTokensSummaryView: BaseFlowSummaryView, HasSpinningCell {
    var fromAccount: EOSAccount? { didSet { tableView.reloadData() }}
    var toAccount: EOSAccount? { didSet { self.tableView.reloadData() }}
    var eosAmount: String? { didSet { self.tableView.reloadData() }}
    
    @available(*, unavailable)  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setCells()
    }
    
    private func setCells() {
        self.cells = [InfoInputCell(), InfoInputCell(), InfoInputCell()]
    }
    
    func checkForButton() {
        sendButton.isEnabled = fromAccount != nil && toAccount != nil && eosAmount != nil
    }
}

extension SendTokensSummaryView {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if hasSpinningProgress, indexPath.row == cells.count { return SpinningCell() }
        let cell = cells[indexPath.row]
        cell.inputField.isUserInteractionEnabled = false
        switch indexPath.row {
        case 0: cell.set(text: fromAccount?.accountName ?? "",
                         withInfo: TokensFlowLocalization.fromInfo.text)
        case 1: cell.set(text: toAccount?.accountName ?? "",
                         withInfo: TokensFlowLocalization.toInfo.text)
        case 2: cell.set(text: eosAmount ?? "",
                         withInfo: TokensFlowLocalization.amountInfo.text)
        default: break
        }
        return cell
    }
}
