//
//  SendTokensAmountView.swift
//  eosMate
//
//  Created by Cyril on 30/9/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class FlowInputView: BaseViewWithTableView {
    private let searchCell = SearchInputCell()
    private lazy var cells = { return [self.searchCell] }()
    private var disposeBag = DisposeBag()
    private let spinner = UIActivityIndicatorView()
    private let continueBtn = BaseButton(title: SharedFlowLocalization.btnContinue.text,
                                         type: BaseButtonType.shinningBlue)
    let didTapContinue = PublishSubject<String>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        addContinueBtn()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setView() {
        tableView.refreshControl = nil
        searchCell.inputField.keyboardType = .decimalPad
    }
    
    private func addContinueBtn() {
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 65))
        inputView.addSubview(continueBtn)
        continueBtn.isEnabled = false
        continueBtn.rx.tap
            .do(onNext: { self.searchCell.inputField.resignFirstResponder() })
            .map { self.searchCell.inputField.text ?? "" }
            .bind(to: didTapContinue)
            .disposed(by: disposeBag)
        continueBtn.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-12)
        }
        searchCell.inputField.inputAccessoryView = inputView
        searchCell.set(placeholder: SharedFlowLocalization.enterAmount.text)
        searchCell.inputField.rx.text.map { !($0?.isEmpty ?? false) }
            .bind(to: continueBtn.rx.isEnabled).disposed(by: disposeBag)
    }
    
    func becomeActive() {
        searchCell.inputField.becomeFirstResponder()
    }
}

// MARK: - TableView
extension FlowInputView {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return SearchInputCell.height
        default: return 0
        }
    }
}
