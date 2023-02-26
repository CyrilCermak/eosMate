//
//  MotivationNavigationController.swift
//  eosMate
//
//  Created by Cyril on 25/10/17.
//  Copyright © 2017 Cyril. All rights reserved.
//

import Foundation
import UIKit

class BasePopNavigationController: UINavigationController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initNavcontroller()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        initNavcontroller()
    }
    
    @available(*, unavailable)  required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initNavcontroller() {
        applyBaseStyling()
    }
}

class BaseNavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        initNavcontroller()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    func initNavcontroller() {
        applyBaseStyling()
    }
    
    func hideNavbar() {
        isNavigationBarHidden = true
    }
    
    func showNabar() {
        isNavigationBarHidden = false
    }
    
    func sendNavBarToBack() {
        navigationBar.barTintColor = .white
        navigationBar.layer.zPosition = -1
    }
    
    func sendNavBarToFront() {
        navigationBar.layer.zPosition = 1000
    }
    
    // MARK: - Overrides
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringPushAnimation = true
        
        super.pushViewController(viewController, animated: animated)
    }

    // MARK: - Private Properties
    
    fileprivate var duringPushAnimation = false
    
    // MARK: - Unsupported Initializers
    
    @available(*, unavailable)  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - UINavigationControllerDelegate

extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let ccNavigationController = navigationController as? BaseNavigationController else { return }
        
        ccNavigationController.duringPushAnimation = false
    }
}

// MARK: - UIGestureRecognizerDelegate

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true // default value
        }
        
        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return viewControllers.count > 1 && duringPushAnimation == false
    }
}

extension UINavigationController {
    func applyBaseStyling() {
        navigationBar.addBaseShadow()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .white
        navigationBar.backgroundColor = UIColor.exDarkBlue()
        navigationBar.tintColor = .white
        navigationBar.barTintColor = UIColor.exDarkBlue()
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.exFontLatoBold(size: 16)]
    }
}
