//
//  BaseTopNavVC.swift
//  eosMate
//
//  Created by Cyril on 1/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import UIKit
import RxSwift

let kBaseTopNavScreenSize = CGRect(x: 0, y: 64, width: screenSize.width, height: screenSize.height - 64)

protocol BaseNavDelegate: AnyObject {
    func wantsToShowMenu()
    func wantsToshowOnboarding()
}

typealias BaseTopNavDelegate = AccountSearchDelegate & MyAccountsDelegate & ChainInfoDelegate & BaseNavDelegate

class BaseTopNavVC: BaseVC {
    let topNavView = BaseTopNavView(frame: UIScreen.main.bounds)
    weak var delegate: BaseTopNavDelegate?
    
    var accountVC: MyAccountsVC!
    var chainInfoVC: ChainInfoVC!
    var accountSearchVC: AccountSearchVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true

        setVCs()
        
        topNavView.didTapMenu.subscribe(onNext: { [weak self] tapped in
            self?.delegate?.wantsToShowMenu()
        }).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.checkForOnboarding()
        }
    }
    
    override func loadView() {
        view = topNavView
    }
    
    private func checkForOnboarding() {
        if UserDefaultsService.shared.finishedOnboarding() == false {
            delegate?.wantsToshowOnboarding()
        }
    }
    
    private func setVCs() {
        accountSearchVC = AccountSearchVC(services: services,
                                          title: CoreLocalization.navSearch.text)
        accountSearchVC.delegate = delegate
        chainInfoVC = ChainInfoVC(services: services,
                                  title: CoreLocalization.navBlockchain.text)
        chainInfoVC.delegate = delegate
        accountVC = MyAccountsVC(services: services,
                                 title: CoreLocalization.navMyAccounts.text)
        accountVC.delegate = delegate
//
        
        let vcs: [BaseVC] = [accountSearchVC, chainInfoVC, accountVC]
        
        topNavView.mainActionView.contentSize = CGSize(width: CGFloat(vcs.count) * screenSize.width, height: screenSize.height - 64)
        topNavView.titles.append(contentsOf: [
            accountSearchVC.title ?? "",
            chainInfoVC.title ?? "",
            accountVC.title ?? ""
        ].map { $0.uppercased() })
        
        for (index, vc) in vcs.enumerated() {
            vc.parentingVC = self
            vc.view.frame.origin = CGPoint(x: screenSize.width * CGFloat(index), y: 64)
            topNavView.mainActionView.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
        }
    }
}
