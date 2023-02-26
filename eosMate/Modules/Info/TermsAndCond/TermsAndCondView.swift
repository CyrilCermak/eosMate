//
//  TermsAndCondView.swift
//  eosMate
//
//  Created by Cyril on 29/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

class TermsAndCondView: UIView {
    private let textView = UITextView()
    let acceptBtn = BaseButton(title: InfoLocalization.tacAccept.text,
                               type: BaseButtonType.shinningBlue)
    
    @available(*, unavailable)  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        backgroundColor = UIColor(patternImage: UIImage(named: "vcBgGradient")!)
        setTextToTextView()
    }
    
    private func initView() {
        [textView, acceptBtn].forEach { self.addSubview($0) }
        setTextView()
        setButton()
    }
    
    private func setTextView() {
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = UIFont.exFontLatoRegular(size: 14)
        textView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(self.acceptBtn.snp.top).offset(-10)
        }
    }
    
    private func setButton() {
        acceptBtn.setFullSizeBtnConstraints()
    }
    
    private func setTextToTextView() {
        let terms =
            """
            <!DOCTYPE html>
            <html lang="en" dir="ltr">
              <head>
                <meta charset="utf-8">
                <title></title>
              </head>
              <body>
                <style>
                  html { color: white }
                  p { font-size: 16px }
                  li { font-size: 16px }
                  h2 { font-size: 20px }
                  h3 { font-size: 18px }
                </style>
                <h2>Terms and Conditions of <span>eosMate</span> and <span>www.eosMate.app</span></h2>
                <p>The following terms and conditions (collectively, these "Terms and Conditions") apply to your use of eosMate and www.eosMate.app, including any content, functionality and services offered on or via eosMate (the "App") and https://www.eosMate.app (the "Website").</p>
                <p>Please read the Terms and Conditions carefully before you start using eosMate, because by using the App you accept and agree to be bound and abide by these Terms and Conditions.</p>
                <p>These Terms and Conditions are effective as of October 25, 2018. We expressly reserve the right to change these Terms and Conditions from time to time without notice to you. You acknowledge and agree that it is your responsibility to review this Website and these Terms and Conditions from time to time and to familiarize yourself with any modifications. Your continued use of this Website or the App after such modifications will constitute acknowledgement of the modified Terms and Conditions and agreement to abide and be bound by the modified Terms and Conditions.</p>
                <p>THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
                    HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. ENTIRELY WITH YOU.</p>
                <h3>eosMate Usage</h3>
                <p>eosMate can be used in two cases. It can serve as an observer of users EOS accounts so as it can be a full wallet. In order to use eosMate as a wallet, the user have to put in eos accounts private key.</p>
                <h3>Private Key</h3>
                <p>Private key is saved in Apple's Keychain and only the App has access to it. Private key IS NOT sent to eosMate server or distributed to any other 3rd party services. Private key IS NOT recoverable, if users phone is lost or stolen and keychain is the only place where the user saved the private key there IS NOT any chance to recover the private key.</p>
                <ul>
                    <li>eosMate IS NOT RESPONSIBLE for any damage, token loses, or other issues that were caused by the App or the EOS blockchain itself.</li>
                    <li>eosMate IS NOT RESPONSIBLE for any kind of misleading usage of the App. It is users responsibility to take care of the device security where the App is installed.</li>
                </ul>
                <p></p>
                <h3>Intellectual Property</h3>
                <p>By accepting these Terms and Conditions, you acknowledge and agree that all content presented to you in the App or on this Website is protected by copyrights, trademarks, service marks, patents or other proprietary rights and laws, and is the sole property of eosMate.app.</p>
                <p>You are only permitted to use the content as expressly authorized by us or the specific content provider. Except for a single copy made for personal use only, you may not copy, reproduce, modify, republish, upload, post, transmit, or distribute any documents or information from this Website or App in any form or by any means without prior written permission from us or the specific content provider, and you are solely responsible for obtaining permission before reusing any copyrighted material that is available on this Website or within the App.</p>
                <h3>Third Party Apps</h3>
                <p>The App may link you to other places connected to the Internet (e.g Facebook) or otherwise include references to information, documents, software, materials and/or services provided by other parties. These websites may contain information or material that some people may find inappropriate or offensive.</p>
                <p>These other parties are not under our control, and you acknowledge that we are not responsible for the accuracy, copyright compliance, legality, decency, or any other aspect of the content of such sites, nor are we responsible for errors or omissions in any references to other parties or their products and services. The inclusion of such a link or reference is provided merely as a convenience and does not imply endorsement of, or association with, the Website or party by us, or any warranty of any kind, either express or implied.</p>
                <h3>Disclaimer of Warranties, Limitations of Liability and Indemnification</h3>
                <p>Your use of the App and eosMate.app is at your sole risk. The App is provided "as is" and "as available". We disclaim all warranties of any kind, express or implied, including, without limitation, the warranties of merchantability, fitness for a particular purpose and non-infringement.</p>
                <p>We are not liable for damages, direct or consequential, resulting from your use of the App or the Website, and you agree to defend, indemnify and hold us harmless from any claims, losses, liability costs and expenses (including but not limites to attorney's fees) arising from your violation of any third-party's rights. You acknowledge that you have only a limited, non-exclusive, nontransferable license to use the App and the Website. Because the App and the Website is not error or bug free, you agree that you will use it carefully and avoid using it ways which might result in any loss of your or any third party's property or information.</p>
                <p>eosMate and eosMate.app reserves the right to terminate this Terms and Conditions or suspend your account at any time in case of unauthorized, or suspected unauthorized use of the Website whether in contravention of this Terms and Conditions or otherwise. If eosMate.app terminates this Terms and Conditions, or suspends your account for any of the reasons set out in this section, eosMate.app shall have no liability or responsibility to you.</p>
                <h3>Governing Law</h3>
                <p>These Terms and Conditions and any dispute or claim arising out of, or related to them, shall be governed by and construed in accordance with the internal laws of the Czech Republic without giving effect to any choice or conflict of law provision or rule.</p>
                <p>Any legal suit, action or proceeding arising out of, or related to, these Terms of Service or the Website shall be instituted exclusively in the federal courts of Czech Republic.</p>
              </body>
            </html>
            """
        textView.attributedText = terms.convertHtml()
        textView.isEditable = false
    }
}
