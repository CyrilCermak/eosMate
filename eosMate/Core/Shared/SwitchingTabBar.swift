//
//  SwitchingTabBar.swift
//  eosMate
//
//  Created by Cyril on 5/9/19.
//  Copyright © 2019 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SwitchingTabBar: UIView {
    static let height: CGFloat = 50
    
    var buttons: [UIButton] = []
    var currentlyActive: UIButton?
    let indicatorView = UIView()
    let stackView = UIStackView()
    let state: Variable<Int> = Variable(0)
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStackView()
    }
    
    func set(titles: [String]) {
        buttons = [UIButton]()
        for title in titles {
            let btn = UIButton()
            btn.setTitle(title, for: .normal)
            buttons.append(btn)
        }
        
        initView()
        updateView(activatedButton: buttons.first!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        for button in buttons {
            stackView.addArrangedSubview(button)
            button.titleLabel?.font = UIFont.exFontLatoSemiBold(size: 13)
            button.backgroundColor = UIColor.exBaseDarkBlue()
            button.setTitleColor(UIColor.exLightGray(), for: .normal)
            button.setTitleColor(UIColor.exWhite(), for: .selected)
            button.snp.makeConstraints { $0.height.equalTo(50); $0.width.equalTo(UIScreen.main.bounds.width / 3) }
            button.addTarget(self, action: #selector(didTap(button:)), for: .touchUpInside)
        }
        
        setIndicator()
    }
    
    private func setStackView() {
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-2)
            make.bottom.equalToSuperview().offset(2)
            make.left.equalToSuperview().offset(-1)
            make.right.equalToSuperview().offset(1)
        }
    }
    
    @objc func didTap(button: UIButton) {
        updateView(activatedButton: button)
    }
    
    private func setIndicator() {
        addSubview(indicatorView)
        indicatorView.backgroundColor = UIColor.exShiningBlue()
        let width = UIScreen.main.bounds.width / CGFloat(buttons.count) + 1
        indicatorView.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(2)
            make.left.equalToSuperview().offset(0)
            make.bottom.equalTo(self.stackView).offset(-2)
        }
    }
    
    private func updateView(activatedButton: UIButton) {
        guard activatedButton != currentlyActive else { return }
        currentlyActive = activatedButton
        updateButtons(activatedButton: activatedButton)
        let index = buttons.firstIndex(of: activatedButton) ?? 0
        state.value = index
        animateIndicator(for: index)
    }
    
    private func updateButtons(activatedButton: UIButton) {
        activatedButton.isSelected = true
        buttons.forEach { if $0 != activatedButton { $0.isSelected = false } }
    }
    
    private func animateIndicator(for index: Int) {
        let buttonWidth = UIScreen.main.bounds.width / CGFloat(buttons.count) - 1
        UIView.animate(withDuration: 0.5, animations: {
            self.indicatorView.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(buttonWidth * CGFloat(index))
            }
            self.layoutIfNeeded()
        })
    }
}
