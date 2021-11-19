//
//  NewPasswordVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 4/9/21.
//

import UIKit

class NewPasswordVC: LoadingView {
    
    @IBOutlet weak var resetPassworLab: UILabel!
    @IBOutlet weak var enterNewPasswordForYourAccountLab: UILabel!
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var hiddenPasswordButton: UIButton!
    @IBOutlet weak var eyeImage: UIImageView!
    @IBOutlet weak var passwordValidationLab: UILabel!

    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var hiddenConfirmPasswordButton: UIButton!
    @IBOutlet weak var confirmEyeImage: UIImageView!
    @IBOutlet weak var confirmPasswordValidationLab: UILabel!

    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var dismissBtn: UIButton!
    
    
    var email = ""
    
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
        confirmPasswordValidationLab.isHidden = true
        passwordValidationLab.isHidden = true
        HelperTools.setBackButton(for: self.dismissBtn)
    }
    
    func localizaElements(){
        
        nextBtn.setButtonTitle(to: "Next")
        resetPassworLab.setTitle(For: "Reset the password")
        enterNewPasswordForYourAccountLab.setTitle(For: "Enter a new password for your account Through it you can log in")
        passwordTF.setTextfieldPlaceolder(Placeholder: "Password")
        confirmPasswordTF.setTextfieldPlaceolder(Placeholder: "Confirm Password") 
        
    }
    
    
    func actionButton(){
        nextBtn.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
        dismissBtn.addTarget(self, action: #selector(dismissBtnTapped), for: .touchUpInside)
        hiddenPasswordButton.addTarget(self, action: #selector(hiddenPasswordButtonTapped), for: .touchUpInside)
        hiddenConfirmPasswordButton.addTarget(self, action: #selector(hiddenConfirmPasswordButtonTapped), for: .touchUpInside)
    }
    
    @objc func nextBtnTapped(){
        let valid = validateTextField()
        if valid {
            createNewPasswordNetwork()
        }
    }
    
    @objc func  dismissBtnTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func hiddenPasswordButtonTapped(){
        if passwordTF.isSecureTextEntry == true {
            passwordTF.isSecureTextEntry = false
            eyeImage.image = UIImage(named: "hidden")
        }else{
            passwordTF.isSecureTextEntry = true
            eyeImage.image = UIImage(named: "show")
        }
    }
    
    
    @objc func hiddenConfirmPasswordButtonTapped(){
        if confirmPasswordTF.isSecureTextEntry == true {
            confirmPasswordTF.isSecureTextEntry = false
            confirmEyeImage.image = UIImage(named: "hidden")
        }else{
            confirmPasswordTF.isSecureTextEntry = true
            confirmEyeImage.image = UIImage(named: "show")
        }
    }
    
    
    
    func createNewPasswordNetwork(){
        self.showLoadingView()
        NetworkManager.createNewPasswordNetwork(email: self.email, NewPassword: self.passwordTF.text!, RePassword: self.confirmPasswordTF.text!){ (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.presentViewController(present: LoginVC())
                }else{
                    self.confirmPasswordValidationLab.isHidden = true
                    self.passwordValidationLab.isHidden = true
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }

    
    func validateTextField()->Bool{
                
        guard !self.passwordTF.text!.isEmpty else {
            passwordValidationLab.isHidden = false
            passwordValidationLab.text = "Please Enter New Password".localized
//            HelperTools.ShowErrorMassge(massge: "Please Enter New Password".localized, title: .error)
            return false
        }
        
        guard !self.confirmPasswordTF.text!.isEmpty else {
            confirmPasswordValidationLab.isHidden = false
            confirmPasswordValidationLab.text = ValidationMessages.emptyConfirmPassword.rawValue.localized
//            HelperTools.ShowErrorMassge(massge:ValidationMessages.emptyConfirmPassword.rawValue, title: .error)
            return false
        }
        
        if self.passwordTF.text != self.confirmPasswordTF.text {
            
            confirmPasswordValidationLab.isHidden = false
            confirmPasswordValidationLab.text = ValidationMessages.passwordMatch.rawValue.localized
//           r HelperTools.ShowErrorMassge(massge:ValidationMessages.passwordMatch.rawValue, title: .error)
            return false
        }
        
        return true
    }
}

