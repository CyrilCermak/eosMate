//
//  EOSAccount.swift
//  eosMate
//
//  Created by Cyril on 3/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation

struct EOSAccount: Codable {
    let accountName: String?
    let headBlockNum: Int?
    let headBlockTime: String?
    let privileged: Bool?
    let lastCodeUpdate, created, coreLiquidBalance: String?
    let ramQuota, netWeight, cpuWeight: Int?
    let netLimit, cpuLimit: Limit?
    let ramUsage: Int?
    let permissions: [EOSXPermission]?
    let totalResources: TotalResources?
    let selfDelegatedBandwidth: SelfDelegatedBandwidth?
    let voterInfo: VoterInfo?
    
    var convertedCPUWeight: Double? {
        if let cpuWeight = cpuWeight {
            return Double(cpuWeight) / 10000.0
        }
        return nil
    }

    var convertedNetWeight: Double? {
        if let netWeight = netWeight {
            return Double(netWeight) / 10000.0
        }
        return nil
    }
    
    var totalBalanceFormatted: String {
        return "\(totalBalance?.formatNumberToMatesDigits() ?? "_") EOS"
    }
    
    var totalBalance: Double? {
        if let total = coreLiquidBalance?.replacingOccurrences(of: " EOS", with: "") {
            if let totalDouble = Double(total), let staked = staked {
                return totalDouble + staked
            }
        }
        return nil
    }

    var staked: Double? {
        if let net = netWeight, let cpu = cpuWeight {
            return (Double(net) + Double(cpu)) / 10000.0
        }
        return nil
    }

    var unstaked: Double? {
        if let totalNum = totalBalance, let staked = staked {
            return totalNum - staked
        }
        return nil
    }
    
    var pub: String? {
        return permissions?.first(where: { $0.permName == "active" })?.requiredAuth?.keys?.first?.key
    }
    
    init(accountName: String) {
        self.accountName = accountName
        headBlockNum = nil
        headBlockTime = nil
        privileged = nil
        lastCodeUpdate = nil; created = nil; coreLiquidBalance = nil
        ramQuota = nil; netWeight = nil; cpuWeight = nil
        netLimit = nil; cpuLimit = nil
        ramUsage = nil
        permissions = nil
        totalResources = nil
        selfDelegatedBandwidth = nil
        voterInfo = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case accountName = "account_name"
        case headBlockNum = "head_block_num"
        case headBlockTime = "head_block_time"
        case privileged
        case lastCodeUpdate = "last_code_update"
        case created
        case coreLiquidBalance = "core_liquid_balance"
        case ramQuota = "ram_quota"
        case netWeight = "net_weight"
        case cpuWeight = "cpu_weight"
        case netLimit = "net_limit"
        case cpuLimit = "cpu_limit"
        case ramUsage = "ram_usage"
        case permissions
        case totalResources = "total_resources"
        case selfDelegatedBandwidth = "self_delegated_bandwidth"
        case voterInfo = "voter_info"
    }
}

struct Limit: Codable {
    let used, available, max: Int?
}

struct EOSXPermission: Codable {
    let permName, parent: String?
    let requiredAuth: EosXRequiredAuth?
    
    enum CodingKeys: String, CodingKey {
        case permName = "perm_name"
        case parent
        case requiredAuth = "required_auth"
    }
}

struct EosXRequiredAuth: Codable {
    let threshold: Int?
    let keys: [Key]?
}

struct Key: Codable {
    let key: String?
    let weight: Int?
}

struct SelfDelegatedBandwidth: Codable {
    let from, to, netWeight, cpuWeight: String?
    
    enum CodingKeys: String, CodingKey {
        case from, to
        case netWeight = "net_weight"
        case cpuWeight = "cpu_weight"
    }
}

struct TotalResources: Codable {
    let owner, netWeight, cpuWeight: String?
    let ramBytes: Int?
    
    enum CodingKeys: String, CodingKey {
        case owner
        case netWeight = "net_weight"
        case cpuWeight = "cpu_weight"
        case ramBytes = "ram_bytes"
    }
}

struct VoterInfo: Codable {
    let owner, proxy: String?
    let staked: Int?
    let lastVoteWeight, proxiedVoteWeight: String?
    
    enum CodingKeys: String, CodingKey {
        case owner, proxy, staked
        case lastVoteWeight = "last_vote_weight"
        case proxiedVoteWeight = "proxied_vote_weight"
    }
}

struct KeyAccounts: Codable {
    let accountNames: [String]
    enum CodingKeys: String, CodingKey {
        case accountNames = "account_names"
    }
}
