//
//  AdditionalTokenRow.swift
//  eosMate
//
//  Created by Cyril on 6/9/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation

enum AdditionalTokenName {
    case wizz, poor, ipos, adderal, atidium, bean, bet, eosBlack, boid, chaince, challengeDac, dabble,
         edna, deos, eosButton, eeth, eosCash, eosDAC, eoxCommerce, eosSportsBets, evr, horusPay, everipedia,
         iRespo, karma, meet, oracleChain, pub, riddle, trybe
    
    var tokenAccount: (name: String, account: String) {
        switch self {
        case .wizz: return ("WiZZ", "wizznetwork1") // main
        case .poor: return ("Poorman Token", "poormantoken") // main
        case .ipos: return ("IPOS", "oo1122334455") // main
            
        case .adderal: return ("AdderalCoin", "eosadddddddd")
        case .atidium: return ("Atidium", "eosatidiumio")
        case .bean: return ("BEAN", "thebeantoken")
        case .bet: return ("EOS BET", "betdividends")
        case .eosBlack: return ("eosBlack", "eosblackteam")
        case .boid: return ("BOID", "boidcomtoken")
        case .chaince: return ("Chaince", "eosiochaince")
        case .challengeDac: return ("Challenge DAC", "challengedac")
        case .dabble: return ("DABBLE", "eoscafekorea")
        case .deos: return ("DEOS Games", "thedeosgames")
        case .edna: return ("EDNA", "ednazztokens")
        case .eosButton: return ("The EOS Button", "theeosbutton")
        case .eeth: return ("EETH", "ethsidechain")
        case .eosCash: return ("eosCASH", "horustokenio")
        case .eosDAC: return ("EOSDAC", "eosdactokens")
        case .eoxCommerce: return ("EOX Commerce", "eoxeoxeoxeox")
        case .eosSportsBets: return ("EOS Sports Bets", "esbcointoken")
        case .evr: return ("EVR Token", "eosvrtokenss")
        case .horusPay: return ("Horus Pay", "horustokenio")
        case .everipedia: return ("Everipedia", "everipediaiq")
        case .iRespo: return ("iRespo", "irespotokens")
        case .karma: return ("KARMA", "therealkarma")
        case .meet: return ("MEET.ONE", "eosiomeetone")
        case .oracleChain: return ("Oracle Chain", "octtothemoon")
        case .pub: return ("PUB", "publytoken11")
        case .riddle: return ("RIDL", "ridlridlcoin")
        case .trybe: return ("TRYBE", "trybenetwork")
        }
    }
    
    static var supportedTokens: [AdditionalTokenName] {
        return [
            .wizz,
            .poor,
            .ipos,
            .adderal,
            .atidium,
            .bean,
            .bet,
            .eosBlack,
            .boid,
            .chaince,
            .challengeDac,
            .dabble,
            .edna,
            .deos,
            .eosButton,
            .eeth,
            .eosCash,
            .eosDAC,
            .eoxCommerce,
            .eosSportsBets,
            .evr,
            .horusPay,
            .everipedia,
            .iRespo,
            .karma,
            .meet,
            .oracleChain,
            .pub,
            .riddle,
            .trybe
        ]
    }
}

struct AdditionalTokens {
    var wizz: String?
    var poor: String?
    var ipos: String?
    var adderal: String?
    var atidium: String?
    var bet: String?
    var eosBlack: String?
    var boid: String?
    var bean: String?
    var chaince: String?
    var challengeDac: String?
    var dabble: String?
    var edna: String?
    var deos: String?
    var eosButton: String?
    var eeth: String?
    var eosCash: String?
    var eosDAC: String?
    var eoxCommerce: String?
    var eosSportsBets: String?
    var evr: String?
    var horusPay: String?
    var everipedia: String?
    var iRespo: String?
    var karma: String?
    var meet: String?
    var oracleChain: String?
    var pub: String?
    var riddle: String?
    var trybe: String?
    
    init() {}
    
    mutating func set(value: String?, for token: AdditionalTokenName) {
        switch token {
        case .ipos: ipos = value
        case .poor: poor = value
        case .wizz: wizz = value
        case .adderal: adderal = value
        case .atidium: atidium = value
        case .bean: bean = value
        case .bet: bet = value
        case .eosBlack: eosBlack = value
        case .boid: boid = value
        case .chaince: chaince = value
        case .challengeDac: challengeDac = value
        case .dabble: dabble = value
        case .deos: deos = value
        case .edna: edna = value
        case .eosButton: eosButton = value
        case .eeth: eeth = value
        case .eosCash: eosCash = value
        case .eosDAC: eosDAC = value
        case .eoxCommerce: eoxCommerce = value
        case .eosSportsBets: eosSportsBets = value
        case .evr: evr = value
        case .horusPay: horusPay = value
        case .everipedia: everipedia = value
        case .iRespo: iRespo = value
        case .karma: karma = value
        case .meet: meet = value
        case .oracleChain: oracleChain = value
        case .pub: pub = value
        case .riddle: riddle = value
        case .trybe: trybe = value
        }
    }
}

struct AdditionalToken: Codable {
    let rows: [AdditionalTokenRow]?
    var getBalance: String? {
        return rows?.first?.balance
    }
}

struct AdditionalTokenRow: Codable {
    let balance: String?
}
