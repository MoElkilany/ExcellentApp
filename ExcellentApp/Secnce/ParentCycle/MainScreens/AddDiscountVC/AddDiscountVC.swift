//
//  AddDiscountVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 07/05/2021.
//

import UIKit

class AddDiscountVC: LoadingView {
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var discountPointLab: UILabel!
    @IBOutlet weak var reasonOfDiscountPointLab: UILabel!
    @IBOutlet weak var reasonOfDiscountPointTF: UITextField!
    @IBOutlet weak var reasonOfDiscountPointValidationLab: UILabel!

    @IBOutlet weak var numberOfPointsLab: UILabel!
    @IBOutlet weak var  numberOfPointsTF: UITextField!
    @IBOutlet weak var numberOfPointsValidationLab: UILabel!

    @IBOutlet weak var selectChildLab: UILabel!
    @IBOutlet weak var selectChildTF: UITextField!
    @IBOutlet weak var selectValidationLab: UILabel!

    
    @IBOutlet weak var discountBtn: CornerButton!
    
    @IBOutlet weak var previousDiscountLab: UILabel!
    @IBOutlet weak var filterNameLab: UILabel!
    @IBOutlet weak var previousTable: UITableView!
    var selectedTaskID = ""
    var selectedKidID = ""
    
    var kidsPointsData = [KidsAwardHomeModel](){
        didSet{
            previousTable.reloadData()
        }
    }
    
    var parentKidsData = [ParentKidsModel]()
    var kidId = ""
    var childId = ""
    var isFilter = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getParentKidsNetwork()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadActivity()
    }
    
    func viewDidLoadActivity(){
        setUpView()
        setUpLoclizeElements()
        tableConfigration()
    }
    
    
    func setUpView(){
        reasonOfDiscountPointValidationLab.isHidden = true
        numberOfPointsValidationLab.isHidden = true
        selectValidationLab.isHidden = true
        balanceView.layer.cornerRadius = 16
    }
    
    func setUpLoclizeElements(){
        discountPointLab.setTitle(For: "Points discount")
        reasonOfDiscountPointLab.setTitle(For: "The reason for deducting points")
        reasonOfDiscountPointTF.setTextfieldPlaceolder(Placeholder: "Please enter the reason for the discount")
        numberOfPointsTF.setTextfieldPlaceolder(Placeholder: "Please enter the number of points")
        selectChildLab.setTitle(For: "Select kids")
        selectChildTF.setTextfieldPlaceolder(Placeholder: "Please select kids")
        previousDiscountLab.setTitle(For: "Previous discount")
        discountBtn.setButtonTitle(to: "Discount")
        /*
         "Re-discount" = "Re-discount";
         */
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
    
    @IBAction func discountAction(_ sender: Any) {
        let validation = validationTF()
        if validation{
            addDiscountNetwork()
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
    
    
    func getKidsDiscountHomeNetwork(pageIndex: String, kidId: String){
        self.showLoadingView()
        NetworkManager.getKidsDiscountHomeNetwork(pageIndex: pageIndex, kidId: kidId) { (response) in
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
                    self.getKidsDiscountHomeNetwork(pageIndex: "1", kidId: "")
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    func resendDiscountOrAwardNetwork(opId:String){
        NetworkManager.resendDiscountOrAwardNetwork(opId: opId) { (response) in
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    HelperTools.ShowIntervalMassge(massge: nil, key: dataValue.message ?? "")
                    self.getKidsDiscountHomeNetwork(pageIndex: "1", kidId: self.kidId)

                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    
    func addDiscountNetwork(){
        self.showLoadingView()
        NetworkManager.addRewardAndDiscountHomeNetwork(PointTypeId:"2", KidsProfileId: self.childId, PointsObtained: self.numberOfPointsTF.text!, Reason: self.reasonOfDiscountPointTF.text!){ (response) in
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
    
//    reasonOfDiscountPointValidationLab
//    numberOfPointsValidationLab
//    selectValidationLab

    func validationTF()->Bool{
       
        reasonOfDiscountPointValidationLab.isHidden = false
        numberOfPointsValidationLab.isHidden = false
        selectValidationLab.isHidden = false
        
        reasonOfDiscountPointValidationLab.text = "Please Enter the reason of discount".localized
        numberOfPointsValidationLab.text = "Please Enter the number of points".localized
        selectValidationLab.text = "Please choose the child".localized

        guard !reasonOfDiscountPointTF.text!.isEmpty else {
//            HelperTools.ShowErrorMassge(massge: "Please Enter the reason of discount", title: .error)
            reasonOfDiscountPointValidationLab.isHidden = false
            reasonOfDiscountPointValidationLab.text = "Please Enter the reason of discount".localized
            return false
        }
        reasonOfDiscountPointValidationLab.isHidden = true

     
        
        guard !numberOfPointsTF.text!.isEmpty else {
            numberOfPointsValidationLab.isHidden = false
//            HelperTools.ShowErrorMassge(massge: "Please Enter the number of points", title: .error)
            numberOfPointsValidationLab.text = "Please Enter the number of points".localized
            return false
        }
        numberOfPointsValidationLab.isHidden = true

        
        if self.childId == "" {
            selectValidationLab.isHidden = false
//            HelperTools.ShowErrorMassge(massge: "Please choose the child", title: .error)
            selectValidationLab.text = "Please choose the child".localized
            return false
        }
        
        selectValidationLab.isHidden = true
        
        return true
    }
    
    
}


extension AddDiscountVC : GetGeneralData {
    
    func modelChildData(model: ParentKidsModel, type: GeneralTabel) {
        if type == .Child {
            self.kidId = "\(model.id ?? 0 )"
            if isFilter == true {
                self.filterNameLab.text = model.fullName ?? ""
                self.getKidsDiscountHomeNetwork(pageIndex: "1", kidId: "\(kidId)")
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

extension AddDiscountVC : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kidsPointsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DiscountPointsCell.cellID, for: indexPath) as! DiscountPointsCell
        cell.setUpCellData(model: kidsPointsData[indexPath.item])
        
        cell.resendDiscountAndRewardAction = {[weak self] in
            guard let self = self else {return}
            self.resendDiscountOrAwardNetwork(opId: "\(self.kidsPointsData[indexPath.item].id ?? 0 )")
        }
        
        cell.moreAction = {[weak self] in
            guard  let self = self  else {return}
            let vc = CardSettingsVC()
            vc.type = .discount
            self.selectedTaskID = "\(self.kidsPointsData[indexPath.item].id ?? 0 )"
            self.selectedKidID  = "\(self.kidsPointsData[indexPath.item].kidsProfileID ?? 0 )"
            vc.indexPath = indexPath
            vc.delegate = self
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





extension AddDiscountVC :ChooseFromCard {
    func chooseFromCard(theType: CardType, theLogic: CardLogicType, index: IndexPath) {
        if theType == .discount {
            if theLogic == .delete {
                print("delete task")
                deleteTaskNetwork(index: index)
            }else{
                print("update task")
            }
        }

        if theType == .reward {
            if theLogic == .delete {
                print("delete gifts")
                deleteTaskNetwork(index: index)
            }else{
                print("update gifts8")
            }
        }
    }
    
      
    func deleteTaskNetwork(index:IndexPath){
        self.showLoadingView()
        NetworkManager.deleteTaskNetwork(taskId: self.selectedTaskID, kidId: self.selectedKidID) { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                
                if dataValue.status == 200 {
                    HelperTools.ShowIntervalMassge(massge: nil, key: dataValue.message ?? "" )
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.dismiss(animated: true, completion: nil)
                        self.kidsPointsData.remove(at: index.row)
                        self.previousTable.reloadData()
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
