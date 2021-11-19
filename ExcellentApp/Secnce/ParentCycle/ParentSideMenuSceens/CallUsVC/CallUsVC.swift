//
//  CallUsVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 06/05/2021.
//

import UIKit
import MessageUI

class CallUsVC: LoadingView ,MFMailComposeViewControllerDelegate{
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var callUsLab: UILabel!
    @IBOutlet weak var callUsIfYouNeedHeldLab: UILabel!

    @IBOutlet weak var emailLab: UILabel!
    @IBOutlet weak var emailValueLab: UILabel!

    @IBOutlet weak var webSiteLab: UILabel!
    @IBOutlet weak var webSiteValueLab: UILabel!
   var email = ""
    var phone = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAppContactNetwork()
        setUpView()
    }
    

    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpView(){
        callUsLab.setTitle(For: "call us")
        callUsIfYouNeedHeldLab.setTitle(For: "You can contact us if you need help")
        emailLab.setTitle(For: "E-mail")
        webSiteLab.setTitle(For: "Phone Number")
    }
    
    func setUpViewData(model:AppContactModel){
        emailValueLab.text = model.email ?? ""
        webSiteValueLab.text = model.phone ?? ""
        email  =  model.email ?? ""
        phone =  model.phone ?? ""
    }
        
    func getAppContactNetwork(){
        self.showLoadingView()
        NetworkManager.getAppContactNetwork() { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    guard let viewData = dataValue.data else{return}
                    self.setUpViewData(model: viewData)
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    @IBAction func emailActionBtn(_ sender: Any) {
        let recipientEmail = self.email
                   let subject = ""
                   let body = ""
                   
                   // Show default mail composer
                   if MFMailComposeViewController.canSendMail() {
                       let mail = MFMailComposeViewController()
                       mail.mailComposeDelegate = self
                       mail.setToRecipients([recipientEmail])
                       mail.setSubject(subject)
                       mail.setMessageBody(body, isHTML: false)
                       
                       present(mail, animated: true)
                    } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
                       UIApplication.shared.open(emailUrl)
                   }
    }
    
    
    @IBAction func phoneActionBtn(_ sender: Any) {
        HelperTools.callNumber(number: self.phone)
    }
    
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
                let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                
                let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
                let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
                let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
                let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
                let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
                
                if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
                    return gmailUrl
                } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
                    return outlookUrl
                } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
                    return yahooMail
                } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
                    return sparkUrl
                }
                
                return defaultUrl
            }
            
            func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
                controller.dismiss(animated: true)
            }
    
}
