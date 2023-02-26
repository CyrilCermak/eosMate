//
//  SendTokensFindAccountView.swift
//  eosMate
//
//  Created by Cyril on 29/9/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//
import UIKit
import Foundation
import RxSwift

class SendTokensFindAccountView: BaseViewWithTableView {
    weak var delegate: AccountSearchViewDelegate? { didSet { tableView.reloadData() }}
    
    let didTapContinue = PublishSubject<EOSAccount?>()
    var account: EOSAccount?
    var searchedAccount: String?
    private var cells: [UITableViewCell] = [SearchInputCell(), AccountDetailBaseCell()]
    private var disposeBag = DisposeBag()
    private let spinner = UIActivityIndicatorView()
    private let continueBtn = BaseButton(title: TokensFlowLocalization.btnContinue.text,
                                         type: BaseButtonType.shinningBlue)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTableView()
        self.addSpinner()
        self.addContinueBtn()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setTableView() {
        self.tableView.refreshControl = nil
    }
    
    func set(account: EOSAccount) {
        self.account = account
        self.continueBtn.isEnabled = true
        self.stopSpinning()
        self.tableView.reloadData()
    }
    
    func removeAccount() {
        if self.account != nil {
            self.continueBtn.isEnabled = false
            self.account = nil
            self.tableView.reloadData()
            if let cell = self.cells[0] as? SearchInputCell {
                cell.inputField.becomeFirstResponder()
            }
        }
    }
    
    func startSpinning() {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    func stopSpinning() {
        self.spinner.isHidden = true
        self.spinner.stopAnimating()
    }
    
    private func addSpinner() {
        self.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.equalToSuperview().offset(SearchInputCell.height + 40)
            make.centerX.equalToSuperview()
        }
        stopSpinning()
    }
    
    private func addContinueBtn() {
        self.addSubview(continueBtn)
        self.continueBtn.isEnabled = false
        continueBtn.rx.tap.map { self.account }.bind(to: self.didTapContinue).disposed(by: disposeBag)
        continueBtn.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(kBottomButtonInset)
        }
    }
    
    func becomeActive() {
        if let c = self.cells[0] as? SearchInputCell { c.inputField.becomeFirstResponder() }
    }
}

// MARK: - TableView
extension SendTokensFindAccountView {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return account == nil ? 1 : cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cells[indexPath.row]
        if let cell = cell as? SearchInputCell {
            cell.delegate = delegate
        }
        if let cell = cell as? AccountDetailBaseCell {
            if let account = account {
                cell.set(account: account)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return SearchInputCell.height
        case 1: return account == nil ? 0 : AccountDetailBaseCell.height
        default: return 0
        }
    }
}
