//
//  AddChildVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 30/04/2021.
//

import UIKit
protocol ReloadTheFullData {
    func isDataReloaded(isReload:Bool)
}

class AddChildVC: LoadingView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var myChildLab: UILabel!
    @IBOutlet weak var imageContainerVIew: UIView!
    @IBOutlet weak var childIMage: UIImageView!
    
    @IBOutlet weak var childNameLab: UILabel!
    @IBOutlet weak var childNameTF: UITextField!
    @IBOutlet weak var childNameValidationLab: UILabel!

    @IBOutlet weak var sexLab: UILabel!
    @IBOutlet weak var sexTF: UITextField!
    @IBOutlet weak var sexValidationLab: UILabel!

    @IBOutlet weak var dateOfBirthLab: UILabel!
    @IBOutlet weak var dateOfBirthTF: UITextField!
    @IBOutlet weak var dateOfBirthValidationLab: UILabel!

    @IBOutlet weak var relativeRelationLab: UILabel!
    @IBOutlet weak var relativeRelationValueLab: UILabel!
    @IBOutlet weak var relativeRelationValidationLab: UILabel!

    @IBOutlet weak var relativeRelationBtn: UIButton!
    @IBOutlet weak var addBtn: CornerButton!
    
    
    var imagePicker = UIImagePickerController()
    let datePicker = UIDatePicker()
    var reloadDelegate :ReloadTheFullData?

    var relativeRelationID = ""
    var sexID = ""
    var childImage : UIImage? = UIImage()
    var delegate : childAdded?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    
    func setUpView(){
        childNameValidationLab.isHidden = true
        sexValidationLab.isHidden = true
        dateOfBirthValidationLab.isHidden = true
        relativeRelationValidationLab.isHidden = true
        
        childIMage.image = UIImage(named: "childImage")
        createDatePicker()
        myChildLab.setTitle(For: "Add Child")
        childNameLab.setTitle(For:"child's name")
        childNameTF.setTextfieldPlaceolder(Placeholder: "Enter the child's name")
        sexLab.setTitle(For: "Sex")
        sexTF.setTextfieldPlaceolder(Placeholder: "choose Sex")
        addBtn.setButtonTitle(to: "add")
        dateOfBirthLab.setTitle(For: "Date of Birth")
        dateOfBirthTF.setTextfieldPlaceolder(Placeholder: "Age must be from 3 to 15 years")
        relativeRelationLab.setTitle(For:"Relative relation")
        relativeRelationValueLab.setTitle(For:"Relative relation")
        imageContainerVIew.layer.cornerRadius = imageContainerVIew.frame.height / 2
        childIMage.layer.cornerRadius = childIMage.frame.height / 2
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = #colorLiteral(red: 0.4745098039, green: 0.4, blue: 0.9960784314, alpha: 1)
        relativeRelationBtn.addTarget(self, action: #selector(relativeRelationBtnTapped), for: .touchUpInside)
    }
    
    
    func createDatePicker(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDateBtnTapped))
        toolBar.setItems([doneBtn], animated: true)
        dateOfBirthTF.inputAccessoryView = toolBar
        
        datePicker.datePickerMode  = .date
        dateOfBirthTF.inputView = datePicker
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    
    @objc func doneDateBtnTapped(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: datePicker.date)
        
        dateOfBirthTF.text = date
        self.view.endEditing(true)
        //        childImage
    }
    
    func validateTextField()->Bool{
        
        childNameValidationLab.isHidden = false
        sexValidationLab.isHidden = false
        dateOfBirthValidationLab.isHidden = false
        relativeRelationValidationLab.isHidden = false
//
//        if childIMage.image == UIImage(named: "childImage") {
//            HelperTools.ShowErrorMassge(massge:"Please choose the child Image", title: .error)
//            return false
//        }
        
        childNameValidationLab.text = "please enter child's name".localized
        sexValidationLab.text = "please choose the type".localized
        dateOfBirthValidationLab.text = "Please Enter the Date of Birth".localized
        relativeRelationValidationLab.text = "Please choose the relative realation".localized
        
        
        guard !self.childNameTF.text!.isEmpty else {
//            HelperTools.ShowErrorMassge(massge:"please enter child's name", title: .error)
            return false
        }
        childNameValidationLab.isHidden = true
       
        
        if  self.sexID == "" {
//            HelperTools.ShowErrorMassge(massge:"please choose the type", title: .error)
            return false
        }
        
        sexValidationLab.isHidden = true
      
        guard !self.dateOfBirthTF.text!.isEmpty else {
//            HelperTools.ShowErrorMassge(massge:"Please Enter the Date of Birth", title: .error)
            return false
        }
        dateOfBirthValidationLab.isHidden = true
        
        if  self.relativeRelationID == "" {
//            HelperTools.ShowErrorMassge(massge:"Please choose the relative realation", title: .error)
            return false
        }
        relativeRelationValidationLab.isHidden = true
        
        //childImage
        return true
    }
    
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sexAction(_ sender: Any) {
        let vc = GeneralTabelVC(mainSection: "Sex")
        vc.delegate = self
        vc.tableType = .sex
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        HelperTools.chosseOptionAlert(imagePicker: imagePicker, vc: self)
    }
    
    @IBAction func addAction(_ sender: Any) {
        let validation = validateTextField()
        if validation {
            addChildNetwork()
        }
        
    }
    
    @objc func relativeRelationBtnTapped (){
        let vc = GeneralTabelVC(mainSection: "Relative relation")
        vc.delegate = self
        vc.tableType = .relativeRelation
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func addChildNetwork(){
        var langID = ""
        let currentLang =  HelperTools.currentLanguage()
        if currentLang?.rawValue == "ar"{
            langID = "1"
        }else{
            langID = "2"
        }
        self.showLoadingView()
        let  parameter :[ String : String] = [
            
            "FullName":self.childNameTF.text!,
            "GenderId":self.sexID,
            "DateOfBirth":self.dateOfBirthTF.text!,
            "LanguageId":langID,
            "TotalNumberOfPoints":"0",
            "RelationshipId":self.relativeRelationID
            
        ]
        
        print("the parameter is", parameter)
        NetworkManager.APIWithImage(model: UserModelResponse.self, urlPath: "Account/RegisterKids", imageParameterName: "imageFile", image: self.childImage, params: parameter) { (response, error) in
            self.dismissLoadingView()
            guard let response = response as? UserModelResponse  else {return}
            if response.status == 200 {
                
                HelperTools.ShowIntervalMassge(massge: nil, key: response.message ?? "")
                self.delegate?.childAdded(added: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.reloadDelegate?.isDataReloaded(isReload: true)
                    self.dismiss(animated: true, completion: nil)
                }
            }else{
                self.delegate?.childAdded(added: false)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    
}

extension AddChildVC :UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        self.childIMage.image = image
        childImage = image
        dismiss(animated: true , completion: nil)
    }
}

extension AddChildVC : GetGeneralData {
    func modelChildData(model: ParentKidsModel, type: GeneralTabel) {
    }
    func modelData(model: GeneralPopUpModel, type: GeneralTabel) {
        if type == .relativeRelation {
            relativeRelationID = "\(model.Id ?? 0)"
            relativeRelationValueLab.text = model.Name ?? ""
        }
    }
    
    func data(name: String, type: GeneralTabel) {
        if type == .sex {
            self.sexTF.text = name.localized
            if name == "Male" {
                self.sexID = "1"
            }else{
                self.sexID = "2"
            }
        }
    }
}
