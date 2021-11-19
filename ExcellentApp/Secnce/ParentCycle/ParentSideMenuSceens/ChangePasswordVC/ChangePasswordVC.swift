//
//  ChangePasswordVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 06/05/2021.
//

import UIKit

class ChangePasswordVC: LoadingView {

    @IBOutlet weak var changePassLab: UILabel!
    @IBOutlet weak var pleaseEnterTheOldPassLab: UILabel!
    @IBOutlet weak var currentPasswordTF: UITextField!
    @IBOutlet weak var currentPasswordImage: UIImageView!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var newPasswordImage: UIImageView!
    @IBOutlet weak var confirmNewPasswordTF: UITextField!
    @IBOutlet weak var confirmNewPasswordImage: UIImageView!
    @IBOutlet weak var changeBtn: CornerButton!
    
    
    var isDelegate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton()
        localizeElements()
        configureNavigationBar()
    }
    
    func actionButton(){
        if isDelegate {
            //            cartBtn.isHidden = true
        }
        changeBtn.addTarget(self, action: #selector(confirmationBtnTapped), for: .touchUpInside)
    }
    
    func configureNavigationBar(){
        
    }
    
    @objc func didbackButton(){
        
    }
    
    
    @objc func confirmationBtnTapped(){
        let validate = validationChangePassword()
        if  validate {
           changePasswordNetwork()
        }
    }
    
    
        func changePasswordNetwork(){
            self.showLoadingView()
            NetworkManager.changePasswordNetwork(currentPassword: self.currentPasswordTF.text!, newPassword: self.newPasswordTF.text!) { (response) in
                self.dismissLoadingView()
                switch response {
    
                case .success(let dataValue):
                    if dataValue.status == 200 {
                        HelperTools.saveUserData(respons: dataValue)
                        HelperTools.ShowIntervalMassge(massge: nil, key: dataValue.message ?? "")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.dismiss(animated: true , completion: nil)
                        }
                    }else{
                        HelperTools.ShowErrorMassge(massge: dataValue.message ?? "", title: .error)
                    }
                case .failure(let error):
                    print("error",error)
                }
            }
        }
    
    @IBAction func bakBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func hiddenOldPasswordAction(_ sender: Any) {
        if currentPasswordTF.isSecureTextEntry == true {
            currentPasswordTF.isSecureTextEntry = false
            currentPasswordImage.image = UIImage(named: "hidden")
        }else{
            currentPasswordTF.isSecureTextEntry = true
            currentPasswordImage.image = UIImage(named: "show")
        }
    }
    
    @IBAction func hiddenNewPasswordAction(_ sender: Any) {
        if newPasswordTF.isSecureTextEntry == true {
            newPasswordTF.isSecureTextEntry = false
            newPasswordImage.image = UIImage(named: "hidden")
        }else{
            newPasswordTF.isSecureTextEntry = true
            newPasswordImage.image = UIImage(named: "show")
        }
    }

    @IBAction func hiddenNewPasswordConfirmationAction(_ sender: Any) {
        if confirmNewPasswordTF.isSecureTextEntry == true {
            confirmNewPasswordTF.isSecureTextEntry = false
            confirmNewPasswordImage.image = UIImage(named: "hidden")
        }else{
            confirmNewPasswordTF.isSecureTextEntry = true
            confirmNewPasswordImage.image = UIImage(named: "show")
        }
    }
    

    
    func localizeElements(){
        self.changePassLab.setTitle(For: "Change Password")
        changeBtn.setButtonTitle(to: "Change")
        currentPasswordTF.setTextfieldPlaceolder(Placeholder: "Current Password")
        newPasswordTF.setTextfieldPlaceolder(Placeholder: "New Password")
        confirmNewPasswordTF.setTextfieldPlaceolder(Placeholder: "Confirm New Password")
        pleaseEnterTheOldPassLab.setTitle(For: "Enter the old password for your account And then the new word")
    }
    
    
    func validationChangePassword()->Bool{
        
        guard !currentPasswordTF.text!.isEmpty  else {
            HelperTools.ShowErrorMassge(massge:"old Password is Empty".localized, title: .error)
            return false
        }
        
        guard currentPasswordTF.text!.count >= 6   else {
            HelperTools.ShowErrorMassge(massge: ValidationMessages.invalidPasswordNumberCount.rawValue, title: .error)
            return false
        }
        
        guard !newPasswordTF.text!.isEmpty  else {
            HelperTools.ShowErrorMassge(massge: "Current Password is Empty ", title: .error)
            return false
        }
        
        guard newPasswordTF.text!.count >= 6   else {
            HelperTools.ShowErrorMassge(massge: ValidationMessages.invalidPasswordNumberCount.rawValue, title: .error)
            return false
        }
                
        guard !confirmNewPasswordTF.text!.isEmpty  else {
            HelperTools.ShowErrorMassge(massge:"confirm new password is empty ", title: .error)
            return false
        }
        
        if newPasswordTF.text != confirmNewPasswordTF.text {
            HelperTools.ShowErrorMassge(massge: ValidationMessages.passwordMatch.rawValue, title:.error)
            return false
        }
        
        return true
    }
    
}

