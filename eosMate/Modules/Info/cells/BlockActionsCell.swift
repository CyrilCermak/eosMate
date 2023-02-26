//
//  ResourceRamCell.swift
//  eosMate
//
//  Created by Cyril on 20/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

protocol BlockActionsTappable {
    var didTapFirstItem: (() -> Void)? { get set }
    var didTapSecondItem: (() -> Void)? { get set }
}

enum BlockActionsCellType {
    case ramAndCpu, requestAndPendingTransactions
}

class BlockActionsCell: UITableViewCell, BlockActionsTappable {
    private let stackView = UIStackView()
    private var firstActionItem = LeftImageWithLabelBox(imageName: "iconCPU",
                                                        value: InfoLocalization.resourceStakeUnstake.text)
    
    private var secondActionItem = LeftImageWithLabelBox(imageName: "iconRAM",
                                                         value: InfoLocalization.ramBuySell.text)
    
    private var cellType: BlockActionsCellType = .ramAndCpu
    
    var didTapFirstItem: (() -> Void)?
    var didTapSecondItem: (() -> Void)?
    
    convenience init(type: BlockActionsCellType) {
        self.init(style: .default, reuseIdentifier: "BlockActionsCell")
        
        switch type {
        case .requestAndPendingTransactions:
            firstActionItem.set(imageName: "iconRequestTransaction",
                                text: InfoLocalization.homeRequestTransaction.text)
            
            secondActionItem.set(imageName: "iconPendingTransactions",
                                 text: InfoLocalization.homePendingTransaction.text)
            
            secondActionItem.imageView.snp.updateConstraints { make in make.width.height.equalTo(40) }
        default: break
        }
    }
    
    @available(*, unavailable)  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stackView)
        backgroundColor = .clear
        selectionStyle = .none
        
        initView()
    }
    
    private func initView() {
        setContentView()
        setStackView()
        setFirstActionItem()
        setSecondActionItem()
    }
    
    private func setContentView() {
        contentView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func setStackView() {
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        [firstActionItem, secondActionItem].forEach { self.stackView.addArrangedSubview($0); $0.snp.makeConstraints { $0.height.equalTo(self.firstActionItem.preferredHeight) } }
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(self.firstActionItem.preferredHeight)
        }
    }
    
    private func setFirstActionItem() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapResource(gestureRecognizer:)))
        tap.delaysTouchesEnded = false
        firstActionItem.addGestureRecognizer(tap)
    }
    
    private func setSecondActionItem() {
        if cellType == .ramAndCpu {
            secondActionItem.imageView.snp.updateConstraints { make in
                make.height.equalTo(25)
                make.width.equalTo(50)
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapRam(gestureRecognizer:)))
        secondActionItem.addGestureRecognizer(tap)
    }
    
    @objc func didTapRam(gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            animateTapAt(tappedView: secondActionItem)
            didTapSecondItem?()
        }
    }
    
    @objc func didTapResource(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            animateTapAt(tappedView: firstActionItem)
            didTapFirstItem?()
        }
    }
    
    private func animateTapAt(tappedView: LeftImageWithLabelBox) {
        UIView.animate(withDuration: 0.7, animations: {
            tappedView.backgroundColor = UIColor.exLightGray()
            tappedView.setViewColor()
        })
    }
}
