//
//  ObserverSerice.swift
//  eosMate
//
//  Created by Cyril on 4/9/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol ObserverProtocol {
    func subscribeFor(account: CachedEOSAccount)
    func unsubscribeFrom(account: CachedEOSAccount)
}

class ObserverProvider: ObserverProtocol {
    let provider = MoyaProvider<ObserverAPI>()
    let disposeBag = DisposeBag()
    
    func subscribeFor(account: CachedEOSAccount) {
        provider.rx.request(.subscribeFor(name: account.name, amount: account.latestVolume)).mapObject(CachedEOSAccount.self)
            .subscribe(onSuccess: { account in
                print(account)
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
    func unsubscribeFrom(account: CachedEOSAccount) {
        // TODO:
    }
}
