//
//  ForgertPasswordVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 4/9/21.
//

import UIKit

class ForgertPasswordVC: LoadingView {
    
    @IBOutlet weak var forgetPassLab: UILabel!
    @IBOutlet weak var enterYourEmailLab: UILabel!
    @IBOutlet weak var emailOrPhoneTF: UITextField!
    @IBOutlet weak var nextBtn: CornerButton!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var emailOrPasswordValidationLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadActivity()
    }
    
    
    func viewDidLoadActivity(){
        setUpView()
        actionButton()
        localizeElements()
    }
    
    func setUpView(){
        emailOrPasswordValidationLab.isHidden = true
        HelperTools.setBackButton(for: dismissBtn)
    }
    
    
    func actionButton(){
        dismissBtn.addTarget(self, action: #selector(dismissBtnTapped), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
    }
    
    
    @objc func dismissBtnTapped(){
        self.dismiss(animated: true , completion: nil)
    }
    
    @objc func nextBtnTapped(){
        let valid = validateTextField()
        if valid {
            forgetPasswordNetwork()
        }
    }
    
    
    func localizeElements(){
        forgetPassLab.setTitle(For: "Forget PasswordLab" )
        emailOrPhoneTF.setTextfieldPlaceolder(Placeholder: "Email or mobile number")
        enterYourEmailLab.setTitle(For: "Enter your email or mobile number To recover your password")
        nextBtn.setButtonTitle(to: "Next")
    }
    
    
    func validateTextField()->Bool{
        
        guard !emailOrPhoneTF.text!.isEmpty  else {
            emailOrPasswordValidationLab.isHidden = false

            emailOrPasswordValidationLab.text = ValidationMessages.emptyEmailOrPhone.rawValue.localized
            return false
        }
        return true
    }
    
    
    
    func forgetPasswordNetwork(){
        self.showLoadingView()
        NetworkManager.forgetPasswordNetwork(email: emailOrPhoneTF.text! ){ (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    let vc = ActivationCodeVC(phoneOrEmail: self.emailOrPhoneTF.text!)
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                }else{
                    self.emailOrPasswordValidationLab.isHidden = true
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
}
