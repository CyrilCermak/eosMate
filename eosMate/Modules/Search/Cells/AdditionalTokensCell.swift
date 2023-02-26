//
//  AdditionalTokensCell.swift
//  eosMate
//
//  Created by Cyril on 5/9/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

class AdditionalTokensCell: UITableViewCell {
    static let height: CGFloat = 1800
    
    let wizz = TitleWithRightSubtitleBox(title: AdditionalTokenName.wizz.tokenAccount.name.uppercased(), value: "0", style: .dark)
    let poor = TitleWithRightSubtitleBox(title: AdditionalTokenName.poor.tokenAccount.name.uppercased(), value: "0", style: .light)
    let ipos = TitleWithRightSubtitleBox(title: AdditionalTokenName.ipos.tokenAccount.name.uppercased(), value: "0", style: .dark)
    let adderal = TitleWithRightSubtitleBox(title: AdditionalTokenName.adderal.tokenAccount.name.uppercased(), value: "0", style: .light)
    let atidium = TitleWithRightSubtitleBox(title: AdditionalTokenName.atidium.tokenAccount.name.uppercased(), value: "0", style: .dark)
    let bean = TitleWithRightSubtitleBox(title: AdditionalTokenName.bean.tokenAccount.name.uppercased(), value: "0", style: .light)
    let bet = TitleWithRightSubtitleBox(title: AdditionalTokenName.bet.tokenAccount.name.uppercased(), value: "0", style: .dark)
    let eosBlack = TitleWithRightSubtitleBox(title: AdditionalTokenName.eosBlack.tokenAccount.name.uppercased(), value: "0", style: .light)
    let boid = TitleWithRightSubtitleBox(title: AdditionalTokenName.boid.tokenAccount.name.uppercased(), value: "0", style: .dark)
    let chaince = TitleWithRightSubtitleBox(title: AdditionalTokenName.chaince.tokenAccount.name.uppercased(), value: "0", style: .light)
    let challengeDac = TitleWithRightSubtitleBox(title: AdditionalTokenName.challengeDac.tokenAccount.name.uppercased(), value: "0", style: .dark)
    let dabble = TitleWithRightSubtitleBox(title: AdditionalTokenName.dabble.tokenAccount.name.uppercased(), value: "0", style: .light)
    let deos = TitleWithRightSubtitleBox(title: AdditionalTokenName.deos.tokenAccount.name.uppercased(), value: "0", style: .dark)
    let edna = TitleWithRightSubtitleBox(title: AdditionalTokenName.edna.tokenAccount.name.uppercased(), value: "0", style: .light)
    let eosButton = TitleWithRightSubtitleBox(title: AdditionalTokenName.eosButton.tokenAccount.name.uppercased(), value: "0", style: .dark)
    let eeth = TitleWithRightSubtitleBox(title: AdditionalTokenName.eeth.tokenAccount.name.uppercased(), value: "0", style: .light)
    let eosCash = TitleWithRightSubtitleBox(title: AdditionalTokenName.eosCash.tokenAccount.name.uppercased(), value: "0", style: .dark)
    let eosDAC = TitleWithRightSubtitleBox(title: AdditionalTokenName.eosDAC.tokenAccount.name.uppercased(), value: "0", style: .light)
    let eoxCommerce = TitleWithRightSubtitleBox(title: AdditionalTokenName.eoxCommerce.tokenAccount.name.uppercased(), value: "0", style: .dark)
    let eosSportsBets = TitleWithRightSubtitleBox(title: AdditionalTokenName.eosSportsBets.tokenAccount.name.uppercased(), value: "0", style: .light)
    let evr = TitleWithRightSubtitleBox(title: AdditionalTokenName.evr.tokenAccount.name.uppercased(), value: "0", style: .dark)
    let horusPay = TitleWithRightSubtitleBox(title: AdditionalTokenName.horusPay.tokenAccount.name.uppercased(), value: "0", style: .light)
    let everipedia = TitleWithRightSubtitleBox(title: AdditionalTokenName.everipedia.tokenAccount.name.uppercased(), value: "0", style: .dark)
    let iRespo = TitleWithRightSubtitleBox(title: AdditionalTokenName.iRespo.tokenAccount.name.uppercased(), value: "0", style: .light)
    let karma = TitleWithRightSubtitleBox(title: AdditionalTokenName.karma.tokenAccount.name.uppercased(), value: "0", style: .dark)
    let meet = TitleWithRightSubtitleBox(title: AdditionalTokenName.meet.tokenAccount.name.uppercased(), value: "0", style: .light)
    let oracleChain = TitleWithRightSubtitleBox(title: AdditionalTokenName.oracleChain.tokenAccount.name.uppercased(), value: "", style: .dark)
    let pub = TitleWithRightSubtitleBox(title: AdditionalTokenName.pub.tokenAccount.name.uppercased(), value: "0", style: .light)
    let riddle = TitleWithRightSubtitleBox(title: AdditionalTokenName.riddle.tokenAccount.name.uppercased(), value: "0", style: .dark)
    let trybe = TitleWithRightSubtitleBox(title: AdditionalTokenName.trybe.tokenAccount.name.uppercased(), value: "0", style: .light)
    
    var tokenViews: [TitleWithRightSubtitleBox] {
        return [
            wizz,
            poor,
            ipos,
            adderal,
            atidium,
            bean,
            bet,
            eosBlack,
            boid,
            chaince,
            challengeDac,
            dabble,
            deos,
            edna,
            eosButton,
            eeth,
            eosCash,
            eosDAC,
            eoxCommerce,
            eosSportsBets,
            evr,
            horusPay,
            everipedia,
            iRespo,
            karma,
            meet,
            oracleChain,
            pub,
            riddle,
            trybe
        ]
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    private func initView() {
        [wizz, poor, ipos].forEach { self.contentView.addSubview($0) }
        setContentView()
        setStack()
    }
    
    private func setContentView() {
        contentView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }

        contentView.addCellShadow(for: CGSize(width: screenSize.width - 30, height: AdditionalTokensCell.height - 20))
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor.exDarkBlue()
    }
    
    private func setStack() {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 12
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        tokenViews.forEach {
            stack.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalTo(stack)
            }
        }
    }
    
    func set(tokens: AdditionalTokens?) {
        wizz.label.text = tokens?.wizz
        setSpinnner(for: wizz, shouldSpin: tokens?.wizz == nil)
        
        poor.label.text = tokens?.poor
        setSpinnner(for: poor, shouldSpin: tokens?.poor == nil)
        
        ipos.label.text = tokens?.ipos
        setSpinnner(for: ipos, shouldSpin: tokens?.ipos == nil)
        
        adderal.label.text = tokens?.adderal
        setSpinnner(for: adderal, shouldSpin: tokens?.adderal == nil)
        
        atidium.label.text = tokens?.atidium
        setSpinnner(for: atidium, shouldSpin: tokens?.atidium == nil)
        
        bean.label.text = tokens?.bean
        setSpinnner(for: bean, shouldSpin: tokens?.bean == nil)
        
        bet.label.text = tokens?.bet
        setSpinnner(for: bet, shouldSpin: tokens?.bet == nil)
        
        eosBlack.label.text = tokens?.eosBlack
        setSpinnner(for: eosBlack, shouldSpin: tokens?.eosBlack == nil)
        
        boid.label.text = tokens?.boid
        setSpinnner(for: boid, shouldSpin: tokens?.boid == nil)
        
        chaince.label.text = tokens?.chaince
        setSpinnner(for: chaince, shouldSpin: tokens?.chaince == nil)
        
        challengeDac.label.text = tokens?.challengeDac
        setSpinnner(for: challengeDac, shouldSpin: tokens?.challengeDac == nil)
        
        dabble.label.text = tokens?.dabble
        setSpinnner(for: dabble, shouldSpin: tokens?.dabble == nil)
        
        deos.label.text = tokens?.deos
        setSpinnner(for: deos, shouldSpin: tokens?.deos == nil)
        
        edna.label.text = tokens?.edna
        setSpinnner(for: edna, shouldSpin: tokens?.edna == nil)
        
        eosButton.label.text = tokens?.eosButton
        setSpinnner(for: eosButton, shouldSpin: tokens?.eosButton == nil)
        
        eeth.label.text = tokens?.eeth
        setSpinnner(for: eeth, shouldSpin: tokens?.eeth == nil)
        
        eosCash.label.text = tokens?.eosCash
        setSpinnner(for: eosCash, shouldSpin: tokens?.eosCash == nil)
        
        eosDAC.label.text = tokens?.eosDAC
        setSpinnner(for: eosDAC, shouldSpin: tokens?.eosDAC == nil)
        
        eoxCommerce.label.text = tokens?.eoxCommerce
        setSpinnner(for: eoxCommerce, shouldSpin: tokens?.eoxCommerce == nil)
        
        eosSportsBets.label.text = tokens?.eosSportsBets
        setSpinnner(for: eosSportsBets, shouldSpin: tokens?.eosSportsBets == nil)
        
        evr.label.text = tokens?.evr
        setSpinnner(for: evr, shouldSpin: tokens?.evr == nil)
        
        horusPay.label.text = tokens?.horusPay
        setSpinnner(for: horusPay, shouldSpin: tokens?.horusPay == nil)
        
        everipedia.label.text = tokens?.everipedia
        setSpinnner(for: everipedia, shouldSpin: tokens?.everipedia == nil)
        
        iRespo.label.text = tokens?.iRespo
        setSpinnner(for: iRespo, shouldSpin: tokens?.iRespo == nil)
        
        karma.label.text = tokens?.karma
        setSpinnner(for: karma, shouldSpin: tokens?.karma == nil)
        
        meet.label.text = tokens?.meet
        setSpinnner(for: meet, shouldSpin: tokens?.meet == nil)
        
        oracleChain.label.text = tokens?.oracleChain
        setSpinnner(for: oracleChain, shouldSpin: tokens?.oracleChain == nil)
        
        pub.label.text = tokens?.pub
        setSpinnner(for: pub, shouldSpin: tokens?.pub == nil)
        
        riddle.label.text = tokens?.riddle
        setSpinnner(for: riddle, shouldSpin: tokens?.riddle == nil)
        
        trybe.label.text = tokens?.trybe
        setSpinnner(for: trybe, shouldSpin: tokens?.trybe == nil)
    }
    
    private func setSpinnner(for box: TitleWithRightSubtitleBox, shouldSpin: Bool) {
        shouldSpin ? box.spinner.startAnimating() : box.spinner.stopAnimating()
    }
}
