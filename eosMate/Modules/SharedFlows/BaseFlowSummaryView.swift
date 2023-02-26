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

protocol HasSpinningCell {
    var hasSpinningProgress: Bool { get set }
}

class BaseFlowSummaryView: BaseViewWithTableView {
    var hasSpinningProgress = false { didSet { setProgress() } }
    var cells = [InfoInputCell]()
    let sendButton = BaseButton(title: SharedFlowLocalization.send.text,
                                type: BaseButtonType.shinningBlue)
    let didTapSend = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.refreshControl = nil
        setView()
        registerCell(for: MyAccountCell.self, id: "MyAccountCell")
        setButton()
    }
    
    private func setView() {
        let bg = UIView()
        bg.backgroundColor = UIColor(patternImage: UIImage(named: "vcBgGradient")!)
        addSubview(bg)
        bg.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(isIphoneX ? 85 : 90)
        }
    }
    
    private func setButton() {
        addSubview(sendButton)
        sendButton.rx.tap.bind(to: didTapSend).disposed(by: disposeBag)
        sendButton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(kBottomButtonInset)
        }
    }
    
    func setProgress() {
        tableView.isUserInteractionEnabled = !hasSpinningProgress
        tableView.reloadData()
    }
}

// MARK: - TableView
extension BaseFlowSummaryView {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hasSpinningProgress ? cells.count + 1 : cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return SearchInputCell.height }
}
