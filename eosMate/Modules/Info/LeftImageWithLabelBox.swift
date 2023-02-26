//
//  LeftImageWithLabelBox.swift
//  eosMate
//
//  Created by Cyril on 20/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

class LeftImageWithLabelBox: UIView {
    let preferredHeight: CGFloat = 55
    let imageView = UIImageView()
    let label = UILabel()
    var style: ImageWithBoxStyle = .dark
    
    convenience init(imageName: String?, value: String?, style: ImageWithBoxStyle = .dark) {
        self.init(frame: CGRect.zero)
        if let imageName = imageName { imageView.image = UIImage(named: imageName) }
        label.text = value
        self.style = style
        setViewColor()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    private func initView() {
        [imageView, label].forEach { self.addSubview($0) }
        layer.cornerRadius = 10
        setViewColor()
        setImageView()
        setLabel()
    }
    
    func setViewColor() {
        switch style {
        case .light:
            backgroundColor = UIColor.exLightGray()
        case .dark:
            backgroundColor = UIColor.exDarkGray()
        default: break
        }
    }
    
    private func setImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setLabel() {
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.exFontLatoBold(size: 13)
        label.numberOfLines = 0
        label.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func set(imageName: String, text: String) {
        imageView.image = UIImage(named: imageName)
        label.text = text
    }
}
