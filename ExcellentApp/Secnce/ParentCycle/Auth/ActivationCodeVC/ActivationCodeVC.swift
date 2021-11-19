//
//  ActivationCodeVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 4/9/21.
//

import UIKit

class ActivationCodeVC: LoadingView {
    
    @IBOutlet weak var activationLab : UILabel!
    @IBOutlet weak var enterCodeLab: UILabel!
    @IBOutlet weak var numberLab: UILabel!
    
    @IBOutlet weak var view1 : UIView!
    @IBOutlet weak var view2 : UIView!
    @IBOutlet weak var view3 : UIView!
    @IBOutlet weak var view4 : UIView!
    
    @IBOutlet weak var code1TF : UITextField!
    @IBOutlet weak var code2TF : UITextField!
    @IBOutlet weak var code3TF : UITextField!
    @IBOutlet weak var code4TF : UITextField!
    
    @IBOutlet weak var nextBtn : UIButton!
    @IBOutlet weak var resendCodeBtn : UIButton!
    @IBOutlet weak var counterLabelLab: UILabel!
    @IBOutlet weak var dismissBtn : UIButton!
    @IBOutlet weak var codeValidationLab: UILabel!
    
    var phoneOrEmail = ""
    var codeText = ""
    init(phoneOrEmail:String) {
        super.init(nibName: nil, bundle: nil)
        self.phoneOrEmail = phoneOrEmail
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadActivity()
    }
    
    func viewDidLoadActivity(){
        setUpView()
        actionButton()
        setUpLocalizeElements()
    }
    
    func setUpView(){
        codeValidationLab.isHidden = true
        HelperTools.setBackButton(for: dismissBtn)
        numberLab.text = phoneOrEmail
        code1TF.delegate = self
        code2TF.delegate = self
        code3TF.delegate = self
        code4TF.delegate = self
        
        code1TF.textAlignment = .center
        code2TF.textAlignment = .center
        code3TF.textAlignment = .center
        code4TF.textAlignment = .center
    }
    
    func setUpLocalizeElements(){
        nextBtn.setButtonTitle(to: "Next")
        resendCodeBtn.setButtonTitle(to: "Resend the code after")
        activationLab.setTitle(For: "Verification")
        enterCodeLab.setTitle(For: "Enter the code that was sent to the number")
    }
    
    
    
    func actionButton(){
        nextBtn.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
        dismissBtn.addTarget(self, action: #selector(dismissBtnTapped), for: .touchUpInside)
    }
    
    
    @objc func  dismissBtnTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func nextBtnTapped(){
        let valid = validateTextField()
        if valid {
//            self.presentViewController(present: NewPasswordVC())
            confirmCodeNetwork()
        }
    }
    
    
    func confirmCodeNetwork(){
        self.showLoadingView()
        NetworkManager.confirmCodeNetwork(email: self.phoneOrEmail,code: codeText ){ (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    let vc = NewPasswordVC()
                    vc.email = self.phoneOrEmail
                    self.presentViewController(present: vc)
                   
                }else{
                    self.codeValidationLab.isHidden = true
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
        
    func validateTextField()->Bool{
         codeText = code1TF.text! +  code2TF.text! + code3TF.text! + code4TF.text!
        print("codeText",codeText)
        guard  codeText.count != 0   else {
            codeValidationLab.isHidden = false
            codeValidationLab.text = ValidationMessages.emptyVerificationCode.rawValue.localized
            return false
        }
        
        guard  codeText.count == 4 else {
            codeValidationLab.isHidden = false
            codeValidationLab.text = ValidationMessages.completeVerificationCode.rawValue.localized
            return false
        }
        return true
    }
    
    func setViewBoarderForVerificationCode(to view:UIView) {
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.4745098039, green: 0.4, blue: 0.9921568627, alpha: 1)
    }
}

extension ActivationCodeVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let updateText = currentText.replacingCharacters(in: stringRange, with: string)
        return updateText.count <= 1
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text
        if let lang = LocalizationManager.shared.getLanguage() {
            if lang == .English {
                
                setViewBoarderForVerificationCode(to: view4)
                if  text?.count == 1 {
                    switch textField{
                    
                    case code4TF:
                        code3TF.becomeFirstResponder()
                        setViewBoarderForVerificationCode(to: view3)
                    case code3TF:
                        code2TF.becomeFirstResponder()
                        setViewBoarderForVerificationCode(to: view2)
                    case code2TF:
                        code1TF.becomeFirstResponder()
                        setViewBoarderForVerificationCode(to: view1)
                    case code1TF:
                        code1TF.resignFirstResponder()
                        setViewBoarderForVerificationCode(to: view1)
                    default:
                        break
                    }
                }
            }else{
                if  text?.count == 1 {
                    
                    setViewBoarderForVerificationCode(to: view1)
                    switch textField{
                    case code1TF:
                        code2TF.becomeFirstResponder()
                        setViewBoarderForVerificationCode(to: view2)
                    case code2TF:
                        code3TF.becomeFirstResponder()
                        setViewBoarderForVerificationCode(to: view3)
                    case code3TF:
                        code4TF.becomeFirstResponder()
                        setViewBoarderForVerificationCode(to: view4)
                    case code4TF:
                        code4TF.resignFirstResponder()
                        setViewBoarderForVerificationCode(to: view4)
                    default:
                        break
                    }
                }
            }
        }
    }
}

