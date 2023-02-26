//
//  SearchInputCell.swift
//  eosMate
//
//  Created by Cyril on 3/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

class SearchInputCell: UITableViewCell, CellHeightRepresentable {
    weak var delegate: AccountSearchViewDelegate?
    static let height: CGFloat = 72
    let inputField = UITextField()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    private func initView() {
        setContentView()
        setTextField()
        setHelperIcon()
    }
    
    private func setContentView() {
        contentView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addCellShadow(for: CGSize(width: screenSize.width - 30, height: SearchInputCell.height - 20))
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor.exDarkBlue()
    }
    
    private func setTextField() {
        contentView.addSubview(inputField)
        inputField.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(55)
        }
        inputField.autocorrectionType = .yes
        inputField.textColor = UIColor.white
        inputField.font = UIFont.exFontLatoBold(size: 16)
        inputField.keyboardAppearance = .dark
        inputField.returnKeyType = .search
        inputField.tintColor = .white
        inputField.addTarget(self, action: #selector(didClickSearch), for: .editingDidEndOnExit)
        inputField.addTarget(self, action: #selector(didBecomeActive), for: .editingDidBegin)
        
        set(placeholder: SearchLocalization.searchBy.text)
    }
    
    private func setHelperIcon() {
        let imageView = UIImageView(image: UIImage(named: "symbolSearch"))
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc func didClickSearch() {
        let searchedText = inputField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        inputField.text = searchedText
        delegate?.didClickSearch(for: searchedText)
    }
    
    @objc func didBecomeActive() {
        delegate?.searchDidBecomeActive()
    }
    
    func set(placeholder: String) {
        inputField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            NSAttributedStringKey.foregroundColor: UIColor.exTextGrayColor(),
            NSAttributedStringKey.font: UIFont.exFontLatoBold(size: 16)
        ])
    }
}
