//
//  ChildProfileDetailsVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 20/08/2021.
//

import UIKit

class ChildProfileDetailsVC: LoadingView {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var childImage: UIImageView!
    @IBOutlet weak var childNameLab: UILabel!
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    @IBOutlet weak var idNameLab: UILabel!
    @IBOutlet weak var idNameTF: UITextField!
    
    @IBOutlet weak var passwordLab: UILabel!
    @IBOutlet weak var passwordTF: UITextField!

    @IBOutlet weak var changePasswordBtn: CornerButton!
    @IBOutlet weak var loginChildBtn: CornerButton!

    var childID = ""
    var childValueImageUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getKidLoginDataNetwork()
        setUpView()
        setUpLocalizable()
    }
    //premuimPage
    func setUpView(){
        let urlString = "https://www.shattoor.com/api" + (childValueImageUrl)
        childImage.kf.setImage(with: URL(string: urlString))

        
        childImage.layer.cornerRadius = childImage.layer.frame.height / 2
        qrCodeImage.layer.cornerRadius = 12
        containerView.layer.cornerRadius = 12
    }
    
    func setUpLocalizable(){
        idNameLab.setTitle(For: "ID number")
        passwordLab.setTitle(For: "Password")
        idNameTF.setTextfieldPlaceolder(Placeholder: "Please enter the ID")
        passwordTF.setTextfieldPlaceolder(Placeholder: "Please Enter your Password")
        changePasswordBtn.setButtonTitle(to: "ChangePassword")
        loginChildBtn.setButtonTitle(to: "Sign in for children")
    }
        
    @IBAction func dismissBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changePasswordAction(_ sender: Any) {
        let validTF = validationTF()
        if validTF{
            changeKidLoginDataNetwork()
        }
       
    }
    
    @IBAction func loginChildAction(_ sender: Any) {
        
    }
    
    func validationTF()->Bool{
        
        guard !idNameTF.text!.isEmpty else {
            HelperTools.ShowErrorMassge(massge: "Please enter the ID", title: .error)
            return false
        }
                
        guard !idNameTF.text!.isEmpty else {
            HelperTools.ShowErrorMassge(massge: "Please Enter your Password", title: .error)
            return false
        }
        
        return true
    }
    
    
    func setUpViewData(model: ChildLoadingDataModel){
    qrCodeImage.image = convertBase64StringToImage(imageBase64String: model.qrcode ?? "" )
        childNameLab.text = model.fullName ?? ""
        idNameTF.text = model.identityNumber ?? ""
        passwordTF.text = model.password ?? ""
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }
    
   
    
    
    func getKidLoginDataNetwork(){
        NetworkManager.getKidLoginDataNetwork(kidId:self.childID) { (response) in
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    guard let ChildData = dataValue.data else {return}
                    self.setUpViewData(model: ChildData)
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    
    
    func changeKidLoginDataNetwork(){
        self.showLoadingView()
        NetworkManager.changeKidLoginDataNetwork(kidId: self.childID, username: self.idNameTF.text!, password: self.passwordTF.text!) { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    HelperTools.ShowIntervalMassge(massge: nil, key: dataValue.message ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.dismiss(animated: true, completion: nil)
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
