//
//  TappableCell.swift
//  eosMate
//
//  Created by Cyril on 20/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol TappableCell {
    var disposeBag: DisposeBag { get set }
    var tappedContetnViewColor: UIColor { get set }
    var baseContentViewColor: UIColor { get set }
    
    func addTapRecognizer()
    func didTapContentView(completion: @escaping (_ completed: Bool) -> Void)
}

extension TappableCell where Self: UITableViewCell {
    func addTapRecognizer() {
        let tap = UITapGestureRecognizer(target: nil, action: nil)
        contentView.addGestureRecognizer(tap)
        tap.rx.event.subscribe(onNext: { tapped in
            self.didTapContentView(completion: { _ in })
        }).disposed(by: disposeBag)
    }
    
    func didTapContentView(completion: @escaping (_ completed: Bool) -> Void) {
        UIView.animate(withDuration: 0.7, animations: {
            self.contentView.backgroundColor = self.tappedContetnViewColor
            self.contentView.backgroundColor = self.baseContentViewColor
            DispatchQueue.main.async { completion(true) }
        })
    }
}
