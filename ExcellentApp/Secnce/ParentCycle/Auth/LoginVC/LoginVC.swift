//
//  LoginVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 4/6/21.
//

import UIKit

class LoginVC: LoadingView {
    @IBOutlet weak var ParentsLoginLabel: UILabel!
    
    @IBOutlet weak var phoneOrEmailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phoneOrEmailValidationLab: UILabel!
    @IBOutlet weak var passwordValidationLab: UILabel!

    @IBOutlet weak var hiddenPasswordButton: UIButton!
    @IBOutlet weak var eyeImage: UIImageView!
    
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var createAccountBtn: UIButton!
    
    @IBOutlet weak var dontHaveAccountLab: UILabel!
    
    @IBOutlet weak var childAppBtn: CornerButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadActivity()
    }
    
    
    func viewDidLoadActivity(){
        setUpView()
        actionButton()
    }
    
    
    func setUpView(){
//        self.phoneOrEmailTF.text = "mo@gmail.com"
//        self.passwordTF.text = "1234567890"
        phoneOrEmailValidationLab.isHidden = true
        passwordValidationLab.isHidden = true
        forgetPasswordButton.setButtonTitle(to: "Forget Password")
        loginButton.setButtonTitle(to: "Login")
        ParentsLoginLabel.setTitle(For: "Parents login")
        phoneOrEmailTF.setTextfieldPlaceolder(Placeholder: "Email or mobile number")
        passwordTF.setTextfieldPlaceolder(Placeholder: "Password")
        createAccountBtn.setButtonTitle(to: "Create an account now")
        dontHaveAccountLab.setTitle(For:"Don't have Account?" )
        childAppBtn.setButtonTitle(to: "Child application")
    }
    
    func actionButton(){
        hiddenPasswordButton.addTarget(self, action: #selector(hiddenPasswordButtontapped), for: .touchUpInside)
        forgetPasswordButton.addTarget(self, action: #selector(forgetPasswordButtontapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtontapped), for: .touchUpInside)
        createAccountBtn.addTarget(self, action: #selector(createAccountBtntapped), for: .touchUpInside)
        childAppBtn.addTarget(self, action: #selector(childAppButtontapped), for: .touchUpInside)
    }
    
    
    @objc func hiddenPasswordButtontapped(){
        
        if passwordTF.isSecureTextEntry == true {
            passwordTF.isSecureTextEntry = false
            eyeImage.image = UIImage(named: "hidden")
        }else{
            passwordTF.isSecureTextEntry = true
            
            eyeImage.image = UIImage(named: "show")
        }
    }
    
    @objc func forgetPasswordButtontapped(){
        self.presentViewController(present: ForgertPasswordVC())
    }
    
    @objc func loginButtontapped(){
        HelperTools.dafault.set(false, forKey:UserActivity.isUserChild.rawValue)
        let valid = validation()
        if valid {
            loginNetwork()
        }
    }
    
    @objc func  createAccountBtntapped(){
        self.presentViewController(present: SignUpVC())
    }
    
    @objc func childAppButtontapped(){
        HelperTools.dafault.set(true, forKey:UserActivity.isUserChild.rawValue)
        self.presentViewController(present: ChildSplashVC())
    }
    
    func validation()->Bool {
        
        phoneOrEmailValidationLab.isHidden = false
        passwordValidationLab.isHidden = false
        
        passwordValidationLab.text = "Please Enter your Password".localized
        
        guard !phoneOrEmailTF.text!.isEmpty else {
            phoneOrEmailValidationLab.text = "Please Enter your phone".localized
            return false
        }
        
        phoneOrEmailValidationLab.isHidden = true

        
        guard !passwordTF.text!.isEmpty else {
//            HelperTools.ShowErrorMassge(massge: "Please Enter your Password", title: .error)
            return false
        }
        passwordValidationLab.isHidden = true

        
        return true
    }
    

    func loginNetwork(){
        self.showLoadingView()
        NetworkManager.loginNetwork(username: phoneOrEmailTF.text!, password: passwordTF.text!) { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    HelperTools.dafault.set(true, forKey: "isLoginParent")
                    HelperTools.saveUserData(respons: dataValue)
                    HelperTools.setTabBarAsRoot()
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
