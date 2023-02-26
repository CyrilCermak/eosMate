//
//  Extensions.swift
//  Animations
//
//  Created by Cyril on 14/04/17.
//  Copyright © 2017 Cyril. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

extension UIView {
    func rotate360() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0.0
        animation.toValue = -CGFloat(.pi * 2.0)
        animation.duration = 1
        
        layer.add(animation, forKey: nil)
    }
    
    func fadeInAndOut() {
        fadeOut { completed in
            if completed {
                // self.imageView.fadeIn()
            }
        }
    }
    
    func fullFadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
    }
    
    func fadeOut(duration: Double = 1, completion: @escaping (_ completed: Bool) -> Void) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 0
        }, completion: completion)
    }
    
    func fadeIn(completion: @escaping (_ completed: Bool) -> Void = { _ in }) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    func zoomInAndOut() {
        transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { completed in
            if completed {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: nil)
            }
        }
    }
    
    func moveToTheRight(point: CGFloat) {
        let x = frame.origin.x
        let y = frame.origin.y
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            self.frame.origin.x = point
            self.frame.origin.y = 0
        }, completion: { completed in
            if completed {
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
                    self.frame.origin.x = x
                    self.frame.origin.y = y
                })
            }
        })
    }
    
    func addBaseShadow() {
        layer.applyShadow(color: UIColor.exLightGray(), alpha: 0.2, x: 0, y: 15, blur: 15, spread: 0)
    }
    
    func addCellShadow(for size: CGSize) {
        let shadowSize: CGFloat = 3.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: size.width + shadowSize,
                                                   height: size.height + shadowSize))
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
        layer.shadowRadius = 10
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
    }

    var safeArea: ConstraintBasicAttributesDSL {
        #if swift(>=3.2)
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide.snp
            }
            return snp
        #else
            return snp
        #endif
    }
    
    func addCellShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.2
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func setFullSizeBtnConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(52)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(kBottomButtonInset)
        }
    }
}

extension CALayer {
    func applyShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4, spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
