//
//  AddAccountCell.swift
//  eosMate
//
//  Created by Cyril on 3/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

private enum Constants {
    static let textViewText = AccountFlowLocalization.enterPk.text
}

class AddAccountCell: UITableViewCell {
    weak var delegate: AccountDetailCellDelegate?
    static let height: CGFloat = 190
    
    let textView = UITextView()
    let observedText = BehaviorSubject<String?>(value: nil)
    let didClickDone = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let balance = TitleWithLabelBox(title: "TOTAL BALANCE", value: "", style: .dark)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    private func initView() {
        [balance, textView].forEach { self.contentView.addSubview($0) }
        setContentView()
        setBalance()
        setTextView()
    }
    
    private func setContentView() {
        contentView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addCellShadow(for: CGSize(width: screenSize.width - 30, height: AddAccountCell.height - 20))
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor.exDarkBlue()
    }
    
    private func setBalance() {
        balance.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.right.equalTo(self.textView)
            make.height.equalTo(44)
        }
    }
    
    private func setTextView() {
        textView.applyBaseStyling()
        textView.addPasteFromClipboardBtn()
        textView.text = Constants.textViewText
        textView.rx.didBeginEditing.subscribe(onNext: { [weak self] editingStarted in
            if self?.textView.text == Constants.textViewText {
                self?.textView.text = ""
            }
        }).disposed(by: disposeBag)
        textView.returnKeyType = .done
        textView.rx.text.subscribe(onNext: { [weak self] text in
            guard text != Constants.textViewText else {
                self?.observedText.onNext(nil)
                return
            }
            self?.observedText.onNext(text ?? "")
            if let lastChar = text?.last, lastChar == "\n" {
                self?.textView.text = self?.textView.text.replacingOccurrences(of: "\n", with: "")
                self?.textView.resignFirstResponder()
            }
        }).disposed(by: disposeBag)
        textView.rx.didEndEditing.bind(to: didClickDone).disposed(by: disposeBag)
        textView.snp.makeConstraints { make in
            make.top.equalTo(self.balance.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func set(account: EOSAccount) {
        balance.label.text = account.totalBalanceFormatted
    }
}
