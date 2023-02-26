//
//  AchieverButton.swift
//  eosMate
//
//  Created by Cyril on 12/2/18.
//  Copyright © 2018 Cyril. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SnapKit

enum BaseButtonType: Int {
    case shadow, shinningBlue
}

class BaseButton: UIButton {
    var touchColor: UIColor!
    var normalColor: UIColor!
    var disabledColor: UIColor!
    
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = self.isHighlighted ? touchColor : normalColor
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? normalColor : disabledColor
        }
    }
    
    private var type: BaseButtonType!
    
    convenience init(title: String, normalColor: UIColor, touchColor: UIColor, titleColor: UIColor) {
        self.init(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width - 20, height: 52))
        self.normalColor = normalColor
        self.touchColor = touchColor
        setTitle(title.uppercased(), for: .normal)
        titleLabel?.font = UIFont.exFontLatoBold(size: 15)
        backgroundColor = normalColor
        setTitleColor(titleColor, for: .normal)
    }
    
    convenience init(title: String, type: BaseButtonType, withConstraints: Bool = false) {
        self.init(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width - 20, height: 52))
        self.type = type
        setBg()
        setTitle(title.uppercased(), for: .normal)
        layer.cornerRadius = 10
        titleLabel?.font = UIFont.exFontLatoBold(size: 15)
        if withConstraints { setConstraints() }
    }
    
    private func setConstraints() {
        snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 20)
            make.height.equalTo(52)
        }
    }
    
    private func setBg() {
        switch type ?? .shinningBlue {
        case .shadow:
            backgroundColor = UIColor.exLightGray()
            setTitleColor(UIColor.white, for: .normal)
            normalColor = UIColor.exLightGray()
            touchColor = UIColor.lightGray
            disabledColor = UIColor.black
        case .shinningBlue:
            backgroundColor = UIColor.exShiningBlue()
            setTitleColor(UIColor.white, for: .normal)
            normalColor = UIColor.exShiningBlue()
            touchColor = UIColor.exShiningBlue().withAlphaComponent(0.5)
            disabledColor = UIColor.exDarkGray()
        }
    }
}
