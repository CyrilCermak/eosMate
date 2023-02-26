//
//  ChainActionsView.swift
//  eosMate
//
//  Created by Cyril on 1/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum ChainMenuActions {
    case sendEos, ram, resource, transactionRequest, pendingTransactions
    
    static var enumerated: [ChainMenuActions] {
        return [.sendEos, .ram, .resource, transactionRequest, pendingTransactions]
    }
    
    var actionName: String {
        switch self {
        case .sendEos: return InfoLocalization.actionSendEos.text
        case .ram: return InfoLocalization.actionRam.text
        case .resource: return InfoLocalization.actionResources.text
        case .pendingTransactions: return InfoLocalization.actionPendingTr.text
        case .transactionRequest: return InfoLocalization.actionTrRequest.text
        }
    }
}

class ChainActionsView: BaseViewWithTableView {
    var actions = [BlockActionsCell(type: .ramAndCpu), BlockActionsCell(type: .requestAndPendingTransactions), ButtonCell()]
    let didSelectAction = PublishSubject<ChainMenuActions>()
    let disposeBag = DisposeBag()
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    deinit { NotificationCenter.default.removeObserver(self) }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    private func initView() {
        backgroundColor = UIColor.exBaseDarkBlue()
        layer.cornerRadius = 40
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        tableView.refreshControl = nil
        tableView.clipsToBounds = true
        tableView.isUserInteractionEnabled = true
        tableView.isScrollEnabled = false
        tableView.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(27)
        }
    }
}

extension ChainActionsView {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return actions.count }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = actions[indexPath.row] as? BlockActionsCell, indexPath.row == 0 {
            cell.didTapFirstItem = { [weak self] in
                self?.didSelectAction.onNext(ChainMenuActions.resource)
            }
            cell.didTapSecondItem = { [weak self] in
                self?.didSelectAction.onNext(ChainMenuActions.ram)
            }
            return cell
        }
        if let cell = actions[indexPath.row] as? BlockActionsCell, indexPath.row == 1 {
            cell.didTapFirstItem = { [weak self] in
                self?.didSelectAction.onNext(ChainMenuActions.transactionRequest)
            }
            cell.didTapSecondItem = { [weak self] in
                self?.didSelectAction.onNext(ChainMenuActions.pendingTransactions)
            }
            return cell
        }
        if let cell = actions[indexPath.row] as? ButtonCell {
            cell.btn.rx.tap.map { ChainMenuActions.sendEos }.bind(to: didSelectAction).disposed(by: disposeBag)
            cell.set(title: ChainMenuActions.sendEos.actionName)
        }
        return actions[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return SearchInputCell.height }
}
