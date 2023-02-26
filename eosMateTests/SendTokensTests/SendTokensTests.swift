//
//  SendTokensTests.swift
//  eosMateTests
//
//  Created by Cyril on 17/11/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import XCTest
import RxSwift

@testable import eosX

class SendTokensTests: XCTestCase {
    let sender = EOSAccount(accountName: "eoschampion2")
    let reciever = EOSAccount(accountName: "aristocratic")
    let amount = "0.0001"
    
    var tokensVC: SendTokensFlowVC!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        tokensVC = SendTokensFlowVC()
        disposeBag = DisposeBag()
        tokensVC.selectedActiveAccount = sender
        tokensVC.toAccount = reciever
        tokensVC.eosAmount = amount
    }
    
    func testDidTapSend() {
        let expectation = XCTestExpectation(description: "Checks view controllers data")
        tokensVC.summaryView.didTapSend
            .subscribe(onNext: { [weak self] tapped in
                guard let self = self else { return }
                if let sender = self.tokensVC.selectedActiveAccount,
                   let reciever = self.tokensVC.toAccount,
                   let amount = self.tokensVC.eosAmount?.formatAmount() {
                    XCTAssertEqual(sender.accountName, sender.accountName)
                    XCTAssertEqual(reciever.accountName, self.reciever.accountName)
                    XCTAssertEqual(amount, self.amount.formatAmount())
                    expectation.fulfill()
                }
            }).disposed(by: disposeBag)
        
        tokensVC.summaryView.didTapSend.onNext(())
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testItFormatsAmount() {
        XCTAssertEqual("0.0001".formatAmount(), "0.0001 EOS")
        XCTAssertEqual("0.001".formatAmount(), "0.0010 EOS")
        XCTAssertEqual("0.01".formatAmount(), "0.0100 EOS")
        XCTAssertEqual("0.1".formatAmount(), "0.1000 EOS")
        XCTAssertEqual("1".formatAmount(), "1.0000 EOS")
        XCTAssertEqual("10".formatAmount(), "10.0000 EOS")
        XCTAssertEqual("100".formatAmount(), "100.0000 EOS")
        XCTAssertEqual("1000".formatAmount(), "1000.0000 EOS")
        XCTAssertEqual("10000".formatAmount(), "10000.0000 EOS")
    }
    
    func testItFormatsRandomPositiveAmount() {
        stride(from: 0, to: 100_000, by: 1).forEach { int in
            print("\(int).0000 EOS")
            XCTAssertEqual("\(int)".formatAmount(), "\(int).0000 EOS")
        }
    }
    
    func testItFormatsRandomDoubleAmount() {
        stride(from: 0.0001, to: 1.0, by: 0.001).forEach { double in
            let value = String(format: "%.4f", arguments: [double]) // Formats double if there is 0.01230000000001
            XCTAssertEqual("\(double)".formatAmount(), "\(value) EOS")
        }
    }
    
    func testItFormatsTooSmallNumbers() {
        var num = 0.0000001
        let addition = 0.0000001
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumIntegerDigits = 1
        numberFormatter.maximumFractionDigits = 7
        while num < 0.00009 {
            let stringNum = numberFormatter.string(from: num as NSNumber)
            XCTAssertEqual("\(stringNum!)".formatAmount(), "0.0000 EOS")
            num += addition
        }
    }
}
