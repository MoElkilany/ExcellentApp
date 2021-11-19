//
//  AddAwardPointsVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 07/05/2021.
//

import UIKit

class AddAwardPointsVC: LoadingView {
    
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var balanceCount: UILabel!
    
    @IBOutlet weak var awardPointLab: UILabel!
    @IBOutlet weak var reasonOfAwardPointLab: UILabel!
    @IBOutlet weak var reasonOfAwardPointTF: UITextField!
    @IBOutlet weak var reasonOfAwardPointValidationLab: UILabel!

    @IBOutlet weak var numberOfPointsLab: UILabel!
    @IBOutlet weak var  numberOfPointsTF: UITextField!
    @IBOutlet weak var numberOfPointsValidationLab: UILabel!

    @IBOutlet weak var selectChildLab: UILabel!
    @IBOutlet weak var selectChildTF: UITextField!
    @IBOutlet weak var selectChildValidationLab: UILabel!

    @IBOutlet weak var awardBtn: CornerButton!
    
    @IBOutlet weak var previousAwardLab: UILabel!
    @IBOutlet weak var filterNameLab: UILabel!
    @IBOutlet weak var previousTable: UITableView!
    
    var kidsPointsData = [KidsAwardHomeModel](){
        didSet{
            previousTable.reloadData()
        }
    }
    
    var parentKidsData = [ParentKidsModel]()
    var kidId = ""
    var isFilter = false
    var childId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getParentKidsNetwork()
        viewDidLoadActivity()
    }

      func viewDidLoadActivity(){
            setUpView()
            setUpLoclizeElements()
            tableConfigration()
        }
    
        func setUpView(){
            balanceView.layer.cornerRadius = 16
            
            reasonOfAwardPointValidationLab.isHidden = true
            numberOfPointsValidationLab.isHidden = true
            selectChildValidationLab.isHidden = true
        }

    func setUpLoclizeElements(){
            awardPointLab.setTitle(For: "Award points")
            reasonOfAwardPointLab.setTitle(For: "The reason for awarding points")
            reasonOfAwardPointTF.setTextfieldPlaceolder(Placeholder: "Please enter the awarding reason")
            numberOfPointsTF.setTextfieldPlaceolder(Placeholder: "Please enter the number of points")
            selectChildLab.setTitle(For: "Select kids")
            selectChildTF.setTextfieldPlaceolder(Placeholder: "Please select kids")
            awardBtn.setButtonTitle(to: "Award")
            previousAwardLab.setTitle(For: "Previous Award")
            numberOfPointsLab.setTitle(For:"Number of points")
            numberOfPointsTF.setTextfieldPlaceolder(Placeholder: "Enter the number of points")
        }

    
    func tableConfigration(){
        previousTable.register(UINib(nibName:DiscountPointsCell.cellID , bundle: nil), forCellReuseIdentifier: DiscountPointsCell.cellID)
        previousTable.delegate = self
        previousTable.dataSource = self
        previousTable.separatorStyle = .none
        previousTable.showsVerticalScrollIndicator = false
    }
        
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func awardAction(_ sender: Any) {
        let validation = validationTF()
        if validation {
            addAwardNetwork()
        }
    }
    
    @IBAction func selectChildAction(_ sender: Any) {
        isFilter = false
        let vc = GeneralTabelVC(mainSection: "")
            vc.delegate = self
        vc.childArr = parentKidsData
            vc.tableType = .Child
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func filterAction(_ sender: Any) {
        isFilter = true
        let vc = GeneralTabelVC(mainSection: "")
            vc.delegate = self
           vc.childArr = parentKidsData
            vc.tableType = .Child
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
    }
    
    func getKidsAwardHomeNetwork(pageIndex: String, kidId: String){
        self.showLoadingView()
        NetworkManager.getKidsAwardHomeNetwork(pageIndex: pageIndex, kidId: kidId) { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.kidsPointsData.removeAll()
                    guard let array =  dataValue.data else {return}
                    self.kidsPointsData = array
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    func getParentKidsNetwork(){
        NetworkManager.getKidsNetwork() { (response) in
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.parentKidsData.removeAll()
                    guard let array =  dataValue.data else {return}
                    self.parentKidsData = array
                    self.filterNameLab.text = "All".localized
                    self.getKidsAwardHomeNetwork(pageIndex: "1", kidId: "")
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    
    
    func addAwardNetwork(){
        self.showLoadingView()
        NetworkManager.addRewardAndDiscountHomeNetwork(PointTypeId:"1", KidsProfileId: self.childId, PointsObtained: self.numberOfPointsTF.text!, Reason: self.reasonOfAwardPointTF.text!){ (response) in
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
    
    
    //resendDiscountOrAwardNetwork
    
    func resendDiscountOrAwardNetwork(opId:String){
        NetworkManager.resendDiscountOrAwardNetwork(opId: opId) { (response) in
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    HelperTools.ShowIntervalMassge(massge: nil, key: dataValue.message ?? "")
                    self.getKidsAwardHomeNetwork(pageIndex: "1", kidId: self.kidId)

                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    

    func validationTF()->Bool{
        reasonOfAwardPointValidationLab.isHidden = false
        numberOfPointsValidationLab.isHidden = false
        selectChildValidationLab.isHidden = false
        
        reasonOfAwardPointValidationLab.text = "Please Enter the reason of award".localized
        numberOfPointsValidationLab.text = "Please Enter the number of points".localized
        selectChildValidationLab.text = "Please choose the child".localized
        
        guard !reasonOfAwardPointTF.text!.isEmpty else {
//            HelperTools.ShowErrorMassge(massge: "Please Enter the reason of award", title: .error)
            
            reasonOfAwardPointValidationLab.text = "Please Enter the reason of award".localized

            return false
        }
        
        reasonOfAwardPointValidationLab.isHidden = true

        
        guard !numberOfPointsTF.text!.isEmpty else {
//            HelperTools.ShowErrorMassge(massge: "Please Enter the number of points", title: .error)
            numberOfPointsValidationLab.text = "Please Enter the number of points".localized

            return false
        }
        numberOfPointsValidationLab.isHidden = true

        
        if self.childId == "" {
//            HelperTools.ShowErrorMassge(massge: "Please choose the child", title: .error)
            selectChildValidationLab.text = "Please choose the child".localized

            return false
        }
        selectChildValidationLab.isHidden = true

        return true    
    
    }
}
 

extension AddAwardPointsVC : GetGeneralData {
    func modelChildData(model: ParentKidsModel, type: GeneralTabel) {
        if type == .Child {
            if isFilter == true {
                self.kidId = "\(model.id ?? 0 )"
                self.filterNameLab.text = model.fullName ?? ""
                self.getKidsAwardHomeNetwork(pageIndex: "1", kidId: "\(kidId)")
            }else{
                self.childId = "\(model.id ?? 0 )"
                self.selectChildTF.text = model.fullName ?? ""
            }
        }
    }
    
    func modelData(model: GeneralPopUpModel, type: GeneralTabel) {
    }
    
    func data(name: String, type: GeneralTabel) {
        
    }
}

extension AddAwardPointsVC : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kidsPointsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DiscountPointsCell.cellID, for: indexPath) as! DiscountPointsCell
        cell.setUpCellData(model: kidsPointsData[indexPath.item])
        //resendDiscountOrAwardNetwork
        cell.isDiscount = false
        
        cell.resendDiscountAndRewardAction = {[weak self] in
            guard let self = self else {return}
            self.resendDiscountOrAwardNetwork(opId: "\(self.kidsPointsData[indexPath.item].id ?? 0 )")
        }
        
        cell.moreAction = {[weak self] in
            guard  let self = self  else {return}
            let vc = CardSettingsVC()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

