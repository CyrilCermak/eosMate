//
//  MarketProvider.swift
//  eosMate
//
//  Created by Cyril on 3/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol MarketProtocol {
    func getMarketData() -> Observable<EOSMarket?>
    func getChartData(days: Int) -> Observable<EOSChart>
}

struct MarketProvider: MarketProtocol {
    let provider = MoyaProvider<Market>()
    
    func getMarketData() -> Observable<EOSMarket?> {
        return provider.rx.request(.baseData)
            .mapArray(EOSMarket.self)
            .map { return $0.first }
            .asObservable()
    }
    
    func getChartData(days: Int) -> Observable<EOSChart> {
        return provider.rx.request(.chart(int: days))
            .mapObject(EOSChart.self)
            .asObservable()
    }
}
