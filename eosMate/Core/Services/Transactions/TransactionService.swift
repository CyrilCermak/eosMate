//
//  TransactionService.swift
//  eosMate
//
//  Created by Cyril on 22/9/19.
//  Copyright © 2019 CyrilCermak. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol TransactionsProtocol {
    func getPendingTranscations(accountName: String) -> Observable<[MateTransactionRequest]>
    func sendTransaction(request: MateTransactionRequest) -> Observable<ProcessedTransactionRequest>
    func deleteTransaction(request: MateTransactionRequest) -> Observable<Response>
}

class TransactionsProvider: TransactionsProtocol {
    let provider = MoyaProvider<TransactionsEndpoint>()
    
    func getPendingTranscations(accountName: String) -> Observable<[MateTransactionRequest]> {
        return provider.rx.request(.pendingTransactions(accountName: accountName))
            .mapArray(MateTransactionRequest.self)
            .asObservable()
    }
    
    func sendTransaction(request: MateTransactionRequest) -> Observable<ProcessedTransactionRequest> {
        return provider.rx.request(.transaction(request: request))
            .map(ProcessedTransactionRequest.self)
            .asObservable()
    }
    
    func deleteTransaction(request: MateTransactionRequest) -> Observable<Response> {
        return provider.rx.request(.deletePendingTransaction(request: request))
            .asObservable()
    }
}

struct ProcessedTransactionRequest: Codable {
    let id: String
}
