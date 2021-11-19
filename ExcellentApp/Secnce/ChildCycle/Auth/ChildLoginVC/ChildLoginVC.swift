//
//  ChildLoginVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 4/10/21.
//

import UIKit

class ChildLoginVC: LoadingView {
    
    @IBOutlet weak var ChildLoginLab: UILabel!
    @IBOutlet weak var getLoginLab: UILabel!
    @IBOutlet weak var IDNumberTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signInWithBarcodeBtn: UIButton!

    
    @IBOutlet weak var iDNumberValidationLab: UILabel!
    @IBOutlet weak var passwordValidationLab: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        IDNumberTF.text = "em4975259@gmail.com"
        passwordTF.text = "pass4975259"
        viewDidLoadActivity()
    }
    
    
    func viewDidLoadActivity(){
        setUpLocalization()
        actionButton()
    }
 
   
    func setUpLocalization(){
        ChildLoginLab.setTitle(For: "Child login")
        getLoginLab.setTitle(For: "Get login information through an app Bits for parents")
        IDNumberTF.setTextfieldPlaceolder(Placeholder: "ID number")
        passwordTF.setTextfieldPlaceolder(Placeholder: "Password")
        loginBtn.setButtonTitle(to: "Login")
        signInWithBarcodeBtn.setButtonTitle(to: "Sign in with barcode")
    }
    
    //ChildHomeVC
    
    func actionButton(){
        loginBtn.addTarget(self, action: #selector(loginBtnTapped), for: .touchUpInside)
        signInWithBarcodeBtn.addTarget(self, action: #selector(signInWithBarcodeBtnTapped), for: .touchUpInside)
    }
    
    @objc func loginBtnTapped(){
        let validate  = validation()
        if validate {
            loginNetwork()
        }
    }
    
    
    @objc func signInWithBarcodeBtnTapped(){
        let vc = QrCodeVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func validation()->Bool {
        
        iDNumberValidationLab.isHidden = false
        passwordValidationLab.isHidden = false
        
        passwordValidationLab.text = "Please Enter your Password".localized
        
        guard !IDNumberTF.text!.isEmpty else {
            iDNumberValidationLab.text = "Please Enter the ID number".localized
            return false
        }
        
        iDNumberValidationLab.isHidden = true
        guard !passwordTF.text!.isEmpty else {
            return false
        }
        passwordValidationLab.isHidden = true
        return true
    }
    
    func loginNetwork(){
        self.showLoadingView()
        NetworkManager.loginChildByUserName(userName: IDNumberTF.text!, password: passwordTF.text!) { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    HelperTools.dafault.set(true, forKey: "isLoginChild")
                    HelperTools.saveUserData(respons: dataValue)
                    let childHomeVC = UINavigationController(rootViewController: ChildHomeVC())
                               let appDelegate = UIApplication.shared.delegate as! AppDelegate
                           appDelegate.window?.rootViewController = childHomeVC
                           
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
