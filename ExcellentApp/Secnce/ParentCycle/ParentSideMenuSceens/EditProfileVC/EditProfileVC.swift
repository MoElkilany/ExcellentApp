//
//  EditProfileVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 04/05/2021.
//

import UIKit
import FlagPhoneNumber

class EditProfileVC: LoadingView {
    
    @IBOutlet weak var editProfileLab: UILabel!
    
    @IBOutlet weak var fullNameLab: UILabel!
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailOrPhoneLab: UILabel!
    @IBOutlet weak var emailOrPhoneTF: UITextField!
    
    @IBOutlet weak var sexLab: UILabel!
    @IBOutlet weak var sexValueLab: UILabel!
    
    @IBOutlet weak var sexBtn: UIButton!
    @IBOutlet weak var mobileNumberValueLab: UILabel!
    
    @IBOutlet weak var mobileNumberTF: FPNTextField!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var editiBtn: CornerButton!
    var countryId = ""
    var tex = ""
    var sexID = ""
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadActivity()
    }
    
    func viewDidLoadActivity(){
        getParentProfileDataNetwork()
        setUpView()
        localizaElements()
        actionButton()
    }
    
    func setUpView(){
        mobileNumberTF.displayMode = .list
        mobileNumberTF.flagButton.isUserInteractionEnabled = true

        listController.setup(repository: mobileNumberTF.countryRepository)
        listController.didSelect = { [weak self] country in
        self?.mobileNumberTF.setFlag(countryCode: country.code)
        }
        
        
        //        mobileNumberTF.setFlag(key: .SA)
        mobileNumberTF.layer.cornerRadius = 10
        mobileNumberTF.backgroundColor = .white
        mobileNumberTF.layer.shadowOffset = CGSize(width: -1,height: 1)
        mobileNumberTF.layer.shadowRadius = 4
        mobileNumberTF.layer.shadowOpacity = 0.25
        mobileNumberTF.layer.shadowColor = UIColor.lightGray.cgColor
        mobileNumberTF.layer.masksToBounds = false
        mobileNumberTF.delegate = self
    }
    
    func localizaElements(){
        self.fullNameLab.setTitle(For: "Full Name")
        emailOrPhoneLab.setTitle(For: "Email or mobile number")
        mobileNumberValueLab.setTitle(For: "Phone Number")
        editProfileLab.setTitle(For: "Edit profile")
        fullNameTF.setTextfieldPlaceolder(Placeholder: "Full Name")
        emailOrPhoneTF.setTextfieldPlaceolder(Placeholder: "Email or mobile number")
        sexLab.setTitle(For: "Sex")
        editiBtn.setButtonTitle(to: "Edit profile")
    }
    
    
    func actionButton(){
        dismissBtn.addTarget(self, action: #selector(dismissBtnTapped), for: .touchUpInside)
        sexBtn.addTarget(self, action: #selector(sexBtnTapped), for: .touchUpInside)
    }
    
    
    
    @objc func loginNowBtnTapped(){
        self.dismiss(animated: true , completion: nil)
    }
    
    @objc func sexBtnTapped (){
        let vc = GeneralTabelVC(mainSection: "Sex")
        vc.delegate = self
        vc.tableType = .sex
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
        
    @objc func nextBtnTapped(){
     
    }
    
    @objc func  dismissBtnTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editAction(_ sender: Any) {
        editParentProfileNetwork()
    }
    
    func setUpViewData(model:ParentProfileDataResponse){
        fullNameTF.text = model.fullName ?? ""
        emailOrPhoneTF.text = model.email ?? ""
        mobileNumberTF.text = model.mobileNumber ?? ""
        tex = model.mobileNumber ?? ""
        sexID = "\(model.genderID ?? 0 )"
        if model.genderID == 1 {
            self.sexValueLab.text = "Male".localized
        }else{
            self.sexValueLab.text = "Female".localized
        }
    }
    
    
    func getParentProfileDataNetwork(){
        self.showLoadingView()
        NetworkManager.getParentProfileDataNetwork { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                self.setUpViewData(model: dataValue)
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    func validateTextField()->Bool{
        
        guard !self.fullNameTF.text!.isEmpty else {
            HelperTools.ShowErrorMassge(massge:"please enter your full Name", title: .error)
            return false
        }
        
        guard !self.emailOrPhoneTF.text!.isEmpty else {
            HelperTools.ShowErrorMassge(massge:"please Enter your Email", title: .error)
            return false
        }
        
        let validEmail = Validation.isValidEmail(emailOrPhoneTF.text!)
        if !validEmail {
            HelperTools.ShowErrorMassge(massge:"please enter valid email", title: .error)
            return false
        }
        
        
        if  self.sexID == "" {
            HelperTools.ShowErrorMassge(massge:"please choose the type", title: .error)
            return false
        }
        
        guard !self.mobileNumberTF.text!.isEmpty else {
            HelperTools.ShowErrorMassge(massge: "please enter phone number".localized, title: .error)
            return false
        }
        
        guard  mobileNumberTF.text!.count >= 9 else {
            HelperTools.ShowErrorMassge(massge: ValidationMessages.enterValidPhone.rawValue, title: .error)
            return false
        }
        
        if tex == "" {
            HelperTools.ShowErrorMassge(massge: "Enter valid Phone Number".localized, title: .error)
            return false
        }
        
        return true
    }
    
    
    func editParentProfileNetwork(){
        self.showLoadingView()
        NetworkManager.editParentProfileNetwork(name: self.fullNameTF.text!, email: self.emailOrPhoneTF.text!, gender:self.sexID, phone: self.mobileNumberTF.text!) { response in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    HelperTools.ShowIntervalMassge(massge: nil, key: dataValue.message ?? "")
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

extension EditProfileVC : GetGeneralData {
    func modelChildData(model: ParentKidsModel, type: GeneralTabel) {
        
    }
    
    func modelData(model: GeneralPopUpModel, type: GeneralTabel) {
        
    }
    
    func data(name: String, type: GeneralTabel) {
        if type == .sex {
            self.sexValueLab.text = name.localized
            if name == "Male" {
                self.sexID = "1"
            }else{
                self.sexID = "2"
            }
        }
    }
}


extension EditProfileVC:FPNTextFieldDelegate{
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print("name ",name , "dialCode",dialCode,"code",code)
        self.countryId = code
    }
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        
        if isValid {
            tex  = textField.text ?? ""
        }
        
    }
    
    func fpnDisplayCountryList() {
          let navigationViewController = UINavigationController(rootViewController: listController)
          present(navigationViewController, animated: true, completion: nil)
       }
}

