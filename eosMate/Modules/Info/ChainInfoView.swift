//
//  ChainInfoView.swift
//  eosMate
//
//  Created by Cyril on 2/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ChainInfoView: BaseViewWithTableView {
    let actionsView = ChainActionsView()
    
    var market: EOSMarket? { didSet { tableView.reloadData() } }
    var chartData: EOSChart? { didSet { tableView.reloadData() } }
    var ramPrice: Double? { didSet { reloadData() } }
    let didTapGraph = PublishSubject<Void>()
    let didTapSendTokens = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    fileprivate var cells = [InfoCell(), GraphCell()]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addActionsView()
        observeScrollInMainContainer()
        
        if isSmallIPhone {
            // TODO: make table view scrollable
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func addActionsView() {
        addSubview(actionsView)
        actionsView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(10)
            make.height.equalTo(isIphoneX ? 275 : 260)
        }
    }
    
    private func observeScrollInMainContainer() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.baseNavScrollViewDidScroll, object: nil, queue: nil) { [weak self] notification in
            if let offset = notification.object as? CGFloat {
                self?.animateViewFor(offset: offset)
            }
        }
    }
    
    private func animateViewFor(offset: CGFloat) {
        let screenWidth = UIScreen.main.bounds.width
        let offset = offset > screenWidth ? 2 * screenWidth - offset : offset
        let scrollOffset = screenWidth - offset
        let menuOffset = scrollOffset + 10
        UIView.animate(withDuration: 0.1) {
            self.actionsView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(menuOffset)
            }
        }
    }
}

// MARK: - TableView
extension ChainInfoView {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = cells[indexPath.row] as? InfoCell {
                cell.set(eosMarket: market, ramPrice: "\(ramPrice ?? 0.0) EOS/kb")
                return cell
            }
        case 1:
            if let cell = cells[indexPath.row] as? GraphCell {
                cell.set(data: chartData)
                return cell
            }
        default: break
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == 1 else { return }
        didTapGraph.onNext(())
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return InfoCell.height
        case 1: return GraphCell.height
        case 2: return ButtonCell.height
        default: return 0
        }
    }
}
