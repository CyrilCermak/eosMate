//
//  BaseVC.swift
//  eosMate
//
//  Created by Cyril on 08/05/17.
//  Copyright © 2017 Cyril. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import EosioSwift

class BaseVC: UIViewController {
    weak var parentingVC: BaseVC?
    var services: Services!
    let disposeBag = DisposeBag()
    
    convenience init(services: Services) {
        self.init()
        self.services = services
    }
    
    override func viewDidLoad() {
        print("BaseVC: \(classForCoder) did load")
        super.viewDidLoad()
    }
    
    deinit {
        print("BaseVC: \(self.classForCoder) deinited")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        services.analytics.log(viewName: "\(classForCoder)")
    }
    
    func showErrorMessage(_ error: Error?, completion: @escaping (() -> Void) = {}) {
        guard let error = error else { return }
        DispatchQueue.main.async {
            if let eosioError = error as? EosioError {
                if let eosResponseError = eosioError.originalError?.eosResponseError?.responseError {
                    if let reason = eosResponseError.details?.first?.message {
                        return self.showPopUpWith(title: CoreLocalization.failure.text,
                                                  message: "\(reason)", okeyCompletion: completion)
                    }
                }
                
                return self.showPopUpWith(title: eosioError.reason, message: eosioError.description, okeyCompletion: completion)
            }
            if let error = error as? AMError {
                AMPopUpController.shared
                    .createPopUp(at: self.parentingVC?.view ?? self.view,
                                 title: error.localizedTitle,
                                 description: error.localizedDescription, okCompletion: completion)
            } else {
                return self.showPopUpWith(title: CoreLocalization.error.text,
                                          message: error.localizedDescription)
            }
        }
    }
    
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func showPopUpWith(title: String, message: String) {
        let topView = parentingVC?.navigationController?.view ?? navigationController?.view
        AMPopUpController.shared
            .createPopUp(at: topView ?? view, title: title, description: message, okCompletion: {})
    }
    
    func showPopUpWith(title: String, message: String, okeyCompletion: @escaping ((()) -> Void) = { _ in }) {
        let overlayView = navigationController?.view ?? view ?? UIView()
        AMPopUpController.shared
            .createPopUp(at: overlayView, title: title, description: message, okCompletion: okeyCompletion)
    }
}
