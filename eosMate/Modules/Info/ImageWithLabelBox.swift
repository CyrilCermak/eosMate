//
//  ImageWithLabelBox.swift
//  eosMate
//
//  Created by Cyril on 3/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

enum ImageWithBoxStyle {
    case light, dark, darkWith(title: String), lightWith(title: String)
}

class ImageWithLabelBox: UIView {
    let preferredHeight: CGFloat = 75
    let imageView = UIImageView()
    let label = UILabel()
    let titleLabel = UILabel()
    var style: ImageWithBoxStyle = .dark
    
    convenience init(imageName: String?, value: String?, style: ImageWithBoxStyle = .dark) {
        self.init(frame: CGRect.zero)
        if let imageName = imageName { imageView.image = UIImage(named: imageName) }
        label.text = value
        self.style = style
        setView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    private func initView() {
        [imageView, label, titleLabel].forEach { self.addSubview($0) }
        setView()
        setImageView()
        setLabel()
        setTitleLabel()
    }
    
    private func setView() {
        layer.cornerRadius = 10
        switch style {
        case .light:
            backgroundColor = UIColor.exLightGray()
        case .dark:
            backgroundColor = UIColor.exDarkGray()
        case let .darkWith(title):
            backgroundColor = UIColor.exDarkGray()
            titleLabel.text = title.uppercased()
        case let .lightWith(title):
            backgroundColor = UIColor.exLightGray()
            titleLabel.text = title.uppercased()
        }
    }
    
    private func setImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setLabel() {
        label.textAlignment = .center
        label.textColor = UIColor.exTextGrayColor()
        label.font = UIFont.exFontLatoRegular(size: 14)
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(18)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    private func setTitleLabel() {
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.exFontLatoBold(size: 14)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.center.equalTo(self.imageView)
        }
    }
}
