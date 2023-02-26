//
//  MenuLocalization.swift
//  eosMate
//
//  Created by Cyril Cermak on 13.03.21.
//  Copyright © 2021 CyrilCermak. All rights reserved.
//

import Foundation

enum MenuLocalization: String, LocalizedStringRepresentable {
    case about, support, removePKs, analytics, tac, privacyPolicy, imprint, title
    
    var text: String {
        return "module.menu.\(self)".localized()
    }
}

enum RemovePKsLocalization: String, LocalizedStringRepresentable {
    case title, subtitle, remove, screenTitle, disable, deletedTitle, deletedDsc
    
    var text: String {
        return "module.menu.removePK.\(self)".localized()
    }
}

enum AnalyticsLocalization: String, LocalizedStringRepresentable {
    case screenTitle, headerTitle, headerSubtitle, promo, enable, disable
    
    var text: String {
        return "module.menu.analytics.\(self)".localized()
    }
}

enum CoreLocalization: String, LocalizedStringRepresentable {
    case upps, uppsDsc, success, pasteFromClipboard
    case navSearch, navBlockchain, navMyAccounts
    case failure, error
    case tokens, trToSign
    
    var text: String {
        return "module.core.\(self)".localized()
    }
}

enum RequestTransactionLocalization: String, LocalizedStringRepresentable {
    case sentFromMate, requestEosFrom, requestRamFrom, requestStakeFrom, notFound, notFoundDsc, request, summeryTransaction, summeryRequestFrom, summerySendTo, summeryAmount
    
    case selectRequest, requesteeAccount, requestingFrom, requestingAmount, requestingDetail, ramInEos, requestinigCPUAmount, requestinigNETAmount
    
    var text: String {
        return "module.requestTransaction.\(self)".localized()
    }
}

enum SignTransactionLocalization: String, LocalizedStringRepresentable {
    case screenTitle, transaction, payload, pendingOk, pendingCancel, pendingTitleDeleteIt, pendingTitleText, transactionDeleted, sign, signName, signAccount, signTable, signAction, signParams
    
    case transactionsUnavailable
    var text: String {
        return "module.signTransaction.\(self)".localized()
    }
}

enum SharedFlowLocalization: String, LocalizedStringRepresentable {
    case btnContinue, enterAmount, send
    
    var text: String {
        return "module.sharedFlows.\(self)".localized()
    }
}

enum RamFlowLocalization: String, LocalizedStringRepresentable {
    case selectAction, activeAccount, ramBytes, summary, ramInEos, ramInBytes, success, trId, action, account

    var text: String {
        return "module.ramFlow.\(self)".localized()
    }
}

enum ResourcesFlowLocalization: String, LocalizedStringRepresentable {
    case success, trId, selectAction, activeAccount, summary, cpu, net, actionInfo, accountInfo, cpuInfo, netInfo
    
    var text: String {
        return "module.resourcesFlow.\(self)".localized()
    }
}

enum TokensFlowLocalization: String, LocalizedStringRepresentable {
    case fromInfo, toInfo, amountInfo, success, trId, notFoundTitle, notFoundDsc
    case activeAccounts, receiver, amount, summary, btnContinue
    
    var text: String {
        return "module.tokensFlow.\(self)".localized()
    }
}

enum AccountFlowLocalization: String, LocalizedStringRepresentable {
    case deleteIt, cancel, deleteAccountConfirmTitle, deleteAccountConfirmDsc, totalBalance, pkNotCorrect, pkNotCorrectDsc, yes, noJust, addRelatedAccounts, relatedAccounts, noSubAccounts, noSubAccountsDsc, notFound, notFoundDsc, addAccount, btnAdd, addPk, addPkDsc, addPkTitle, enterPk
    var text: String {
        return "module.account.\(self)".localized()
    }
}

enum InfoLocalization: String, LocalizedStringRepresentable {
    case noActiveAccountsTitle, noActiveAccountsDsc, tac, tacAccept
    case actionSendEos, actionRam, actionResources, actionPendingTr, actionTrRequest
    case past24h, eosPrice, ramPrice, high24h, low24h, change, span24h
    case resourceStakeUnstake, ramBuySell, homeRequestTransaction, homePendingTransaction
    
    var text: String {
        return "module.info.\(self)".localized()
    }
}

enum SearchLocalization: String, LocalizedStringRepresentable {
    case searchBy, totalBalance
    case staked, unstaked, privileged, otherTokens
    case notFoundTitle, notFoundDsc
    case transactions
    
    var text: String {
        return "module.search.\(self)".localized()
    }
}

enum TransactionsLocalization: String, LocalizedStringRepresentable {
    case payload
    case all, apps, transfers, stake, ram
    case upps
    var text: String {
        return "module.transactions.\(self)".localized()
    }
}

enum BlockchainLocalization: String, LocalizedStringRepresentable {
    case error, invalidPK, keyAlreadyExist, missingName, nameNotFound
    case trErrorTitle, trErrorDsc
    var text: String {
        return "module.blockchain.\(self)".localized()
    }
}

enum RatingsLocalization: String, LocalizedStringRepresentable {
    case enjoying, pleaseRateUs, rateUs, nextTime, rating
    
    var text: String {
        return "module.rateus.\(self)".localized()
    }
}
