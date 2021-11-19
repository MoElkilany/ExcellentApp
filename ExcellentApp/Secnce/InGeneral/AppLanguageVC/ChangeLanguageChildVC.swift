//
//  ChangeLanguageChildVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 29/04/2021.
//

import UIKit

class ChangeLanguageChildVC: LoadingView {
    
    @IBOutlet weak var navLang: UILabel!
    @IBOutlet weak var changeLang: UILabel!
    
    @IBOutlet weak var theLang: UILabel!
    @IBOutlet weak var langValue: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let lang = LocalizationManager.shared.getLanguage() {
            if lang == .English {
                langValue.text = "English"
            }else{
                langValue.text = "العربية"
            }
        }
        
        changeLang.setTitle(For: "You can change the application language")
        theLang.setTitle(For:"the Language")
        navLang.setTitle(For:"the Language")
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func chooseLang(_ sender: Any) {
        let vc = GeneralTabelVC(mainSection: "Choose Language")
        vc.delegate = self
        vc.tableType = .language
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func changeLangNetwork(languageID: String){
        self.showLoadingView()
        NetworkManager.changeAccountChangeProfileLanguage(languageID: languageID) { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    HelperTools.ShowIntervalMassge(massge: nil, key: dataValue.message ?? "" )
                    if self.langValue.text == "English" {
                        LocalizationManager.shared.setLanguage(language: .English)
                    }else{
                        LocalizationManager.shared.setLanguage(language: .Arabic)
                    }
                    
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    
    
}

extension ChangeLanguageChildVC : GetGeneralData {
    func modelChildData(model: ParentKidsModel, type: GeneralTabel) {
        
    }
    
    func modelData(model: GeneralPopUpModel, type: GeneralTabel) {
        
    }
    
    func data(name: String, type: GeneralTabel) {
        if type == .language {
            HelperTools.langInChild = true
            self.langValue.text = name
            if name == "English" {
              
                self.changeLangNetwork(languageID: "2")
                
            }else{
              
                self.changeLangNetwork(languageID: "1")

            }
        }
    }
    
}
