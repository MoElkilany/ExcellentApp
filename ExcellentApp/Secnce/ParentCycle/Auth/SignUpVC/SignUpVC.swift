//
//  SignUpVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 4/9/21.
//

import UIKit
import FlagPhoneNumber

class SignUpVC: LoadingView {
    
    @IBOutlet weak var createNewAccpuntLab: UILabel!
    
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailOrPhoneTF: UITextField!
    
    @IBOutlet weak var sexLab: UILabel!
    @IBOutlet weak var sexBtn: UIButton!
    
    @IBOutlet weak var mobileNumberTF: FPNTextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var hiddenPasswordButton: UIButton!
    @IBOutlet weak var eyeImage: UIImageView!
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var hiddenConfirmPasswordButton: UIButton!
    @IBOutlet weak var confirmEyeImage: UIImageView!
    
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var createAccountBtn: CornerButton!
    @IBOutlet weak var haveAccountLab: UILabel!
    @IBOutlet weak var loginNowBtn: UIButton!
    
    var sexID = ""
    var countryId = ""
    var tex = ""
    
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadActivity()
    }
    
    func viewDidLoadActivity(){
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
        mobileNumberTF.layer.cornerRadius = 10
        mobileNumberTF.backgroundColor = .white
        mobileNumberTF.layer.shadowOffset = CGSize(width: -1,height: 1)
        mobileNumberTF.layer.shadowRadius = 4
        mobileNumberTF.layer.shadowOpacity = 0.25
        mobileNumberTF.layer.shadowColor = UIColor.lightGray.cgColor
        mobileNumberTF.layer.masksToBounds = false
        mobileNumberTF.layer.shouldRasterize = true
        mobileNumberTF.delegate = self
    }
    
    
    func localizaElements(){
        createNewAccpuntLab.setTitle(For: "Create a new account")
        fullNameTF.setTextfieldPlaceolder(Placeholder: "Full Name")
        emailOrPhoneTF.setTextfieldPlaceolder(Placeholder: "Email or mobile number")
        sexLab.setTitle(For: "Sex")
        passwordTF.setTextfieldPlaceolder(Placeholder: "Password")
        confirmPasswordTF.setTextfieldPlaceolder(Placeholder: "Confirm Password")
        createAccountBtn.setButtonTitle(to: "Create Account")
        haveAccountLab.setTitle(For: "Have Account?")
        loginNowBtn.setButtonTitle(to: "Login Now")
    }
    
    func actionButton(){
        dismissBtn.addTarget(self, action: #selector(dismissBtnTapped), for: .touchUpInside)
        hiddenPasswordButton.addTarget(self, action: #selector(hiddenPasswordButtonTapped), for: .touchUpInside)
        
        hiddenConfirmPasswordButton.addTarget(self, action: #selector(hiddenConfirmPasswordButtonTapped), for: .touchUpInside)
        sexBtn.addTarget(self, action: #selector(sexBtnTapped), for: .touchUpInside)
        
        loginNowBtn.addTarget(self, action: #selector(loginNowBtnTapped), for: .touchUpInside)
        createAccountBtn.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
    }
    
    
    @IBAction func hiddenPasswordAction(_ sender: Any) {
    
        if passwordTF.isSecureTextEntry == true {
            passwordTF.isSecureTextEntry = false
            eyeImage.image = UIImage(named: "hidden")
        }else{
            passwordTF.isSecureTextEntry = true
            eyeImage.image = UIImage(named: "show")
        }
    }
    
    
    @IBAction func hiddenPasswordConfirmationAction(_ sender: Any) {
        if confirmPasswordTF.isSecureTextEntry == true {
            confirmPasswordTF.isSecureTextEntry = false
            confirmEyeImage.image = UIImage(named: "hidden")
        }else{
            confirmPasswordTF.isSecureTextEntry = true
            confirmEyeImage.image = UIImage(named: "show")
        }
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
        print("the tex iS:",self.tex)
        let valid = validateTextField()
        if valid {
            signUpParentNetwork()
        }
    }
    
    @objc func  dismissBtnTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func hiddenPasswordButtonTapped(){
        if passwordTF.isSecureTextEntry == true {
            passwordTF.isSecureTextEntry = false
        }else{
            passwordTF.isSecureTextEntry = true
        }
    }
    
    
    @objc func hiddenConfirmPasswordButtonTapped(){
        if confirmPasswordTF.isSecureTextEntry == true {
            confirmPasswordTF.isSecureTextEntry = false
        }else{
            confirmPasswordTF.isSecureTextEntry = true
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
        
        guard !self.passwordTF.text!.isEmpty else {
            HelperTools.ShowErrorMassge(massge: "Please Enter New Password".localized, title: .error)
            return false
        }
        
        guard !self.passwordTF.text!.isEmpty else {
            HelperTools.ShowErrorMassge(massge: "Please Enter New Password".localized, title: .error)
            return false
        }
        
        guard !self.confirmPasswordTF.text!.isEmpty else {
            HelperTools.ShowErrorMassge(massge:ValidationMessages.emptyConfirmPassword.rawValue, title: .error)
            return false
        }
        
        if self.passwordTF.text != self.confirmPasswordTF.text {
            HelperTools.ShowErrorMassge(massge:ValidationMessages.passwordMatch.rawValue, title: .error)
            return false
        }
        return true
    }
    
    func signUpParentNetwork(){
        self.showLoadingView()
        NetworkManager.registerParentNetwork(email: emailOrPhoneTF.text!, Password: self.passwordTF.text!, ConfirmPassword: self.confirmPasswordTF.text!, PhoneNumber: self.tex, FullName: fullNameTF.text!, GenderId: self.sexID, CountryId: self.countryId) { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200  {
                    HelperTools.ShowIntervalMassge(massge: nil, key:dataValue.message ?? "" )
                    self.presentViewController(present: LoginVC())
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

extension SignUpVC : GetGeneralData {
    func modelChildData(model: ParentKidsModel, type: GeneralTabel) {
        
    }
    
    func modelData(model: GeneralPopUpModel, type: GeneralTabel) {
        
    }
    
    func data(name: String, type: GeneralTabel) {
        if type == .sex {
            self.sexLab.text = name.localized
            if name == "Male" {
                self.sexID = "1"
            }else{
                self.sexID = "2"
            }
        }
    }
}


extension SignUpVC:FPNTextFieldDelegate {
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



