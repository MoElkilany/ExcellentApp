//
//  AddRewardVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 11/08/2021.
//

import UIKit

class AddRewardVC: LoadingView {
    
    @IBOutlet weak var addNewRewardLab: UILabel!
    @IBOutlet weak var imageContainerVIew: UIView!
    @IBOutlet weak var childIMage: UIImageView!
    
    @IBOutlet weak var rewardNameLab: UILabel!
    @IBOutlet weak var rewardNameTF: UITextField!
    @IBOutlet weak var rewardNameValidationLab: UILabel!

    @IBOutlet weak var numberOfPointsLab: UILabel!
    @IBOutlet weak var numberOfPointsTF: UITextField!
    @IBOutlet weak var numberOfPointsValidationLab: UILabel!

    @IBOutlet weak var selectImg: UIImageView!
    @IBOutlet weak var selectLab: UILabel!
    @IBOutlet weak var selectChildValidationLab: UILabel!

    @IBOutlet weak var childTable: UITableView!
    @IBOutlet weak var addBtn: CornerButton!
    
    var selectAll = false
    var imagePicker = UIImagePickerController()
    var selectedIDs    = [String]()
    
    var arrSelectedIndex = [IndexPath]()
    var arrSelectedData = [String]()
    var taskImage : UIImage? = UIImage()
    
    var childsIDs = ""
    var parentKidsData = [ParentKidsModel](){
        didSet{
            childTable.reloadData()
        }
    }
    
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getParentKidsNetwork()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rewardNameValidationLab.isHidden = true
        numberOfPointsValidationLab.isHidden = true
        selectChildValidationLab.isHidden = true
        HelperTools.isAllSelected = false
        
        childIMage.image = UIImage(named: "childImage")
        childIMage.layer.cornerRadius = childIMage.layer.frame.height / 2
        imageContainerVIew.layer.cornerRadius = childIMage.layer.frame.height / 2
        addNewRewardLab.setTitle(For: "Add New gift")
        rewardNameLab.setTitle(For: "Gift name")
        rewardNameTF.setTextfieldPlaceolder(Placeholder: "Enter the gift name")
        numberOfPointsLab.setTitle(For:"Number of points")
        numberOfPointsTF.setTextfieldPlaceolder(Placeholder: "Enter the number of points")
        selectLab.setTitle(For: "select all")
        addBtn.setButtonTitle(to: "adding")
        tableConfigration()
    }
    
    func tableConfigration(){
        childTable.register(UINib(nibName:ChildTableCell.cellID , bundle: nil), forCellReuseIdentifier: ChildTableCell.cellID)
        childTable.delegate = self
        childTable.dataSource = self
        childTable.separatorStyle = .none
        childTable.showsVerticalScrollIndicator = false
        childTable.allowsMultipleSelection = true
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectAllAction(_ sender: Any) {
        if selectAll == false {
            selectAllRows()
            selectImg.image = #imageLiteral(resourceName: "icons8-checked-checkbox-24")
            selectAll = true
        }else{
            deSelectAllRows()
            selectImg.image = #imageLiteral(resourceName: "blueEmptyCheck")
            selectAll = false
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        let kidsIDS = getChildsIDs()
        print("getChildsIDs:",kidsIDS)
        let validate = validationTF()
        if validate {
            createTaskNetwork()
        }
    }
    
    @IBAction func chooseImageAction(_ sender: Any) {
        HelperTools.chosseOptionAlert(imagePicker: imagePicker, vc: self)
    }
    
    func validationTF()->Bool{
        //        if childIMage.image == UIImage(named: "childImage") {
        //            HelperTools.ShowErrorMassge(massge:"Please choose the gift Image", title: .error)
        //            return false
        //        }
        
        rewardNameValidationLab.isHidden = false
        numberOfPointsValidationLab.isHidden = false
        selectChildValidationLab.isHidden = false
        
        rewardNameValidationLab.text = "Please Enter the gift name".localized
        numberOfPointsValidationLab.text = "Please Enter the number of points".localized
        selectChildValidationLab.text = "Please select the kids".localized

        
        guard !rewardNameTF.text!.isEmpty else {
//            HelperTools.ShowErrorMassge(massge: "Please Enter the gift name", title: .error)
            return false
        }
        rewardNameValidationLab.isHidden = true
       
        
        guard !numberOfPointsTF.text!.isEmpty else {
//            HelperTools.ShowErrorMassge(massge: "Please Enter the number of points", title: .error)
            return false
        }
        numberOfPointsValidationLab.isHidden = true
        
        let kidsIDS = getChildsIDs()
        print("kidsIDS:",kidsIDS)
        if kidsIDS == "" {
//            HelperTools.ShowErrorMassge(massge: "Please select the kids", title: .error)
            return false
        }
        
        selectChildValidationLab.isHidden = true

        return true
    }
    
    
    func createTaskNetwork(){
        self.showLoadingView()
        let  parameter :[ String : String] = [
            "GiftName":rewardNameTF.text!,
            "GiftPricePoints":numberOfPointsTF.text!,
            "GiftKids": getChildsIDs()
        ]
        
        print("the parameter is", parameter)
        NetworkManager.APIWithImage(model: UserModelResponse.self, urlPath: "Parent/AddGift", imageParameterName: "file", image: self.taskImage, params: parameter) { (response, error) in
            self.dismissLoadingView()
            guard let response = response as? UserModelResponse  else {return}
            if response.status == 200 {
                HelperTools.ShowIntervalMassge(massge: nil, key: response.message ?? "")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.dismiss(animated: true, completion: nil)
                }
            }else{
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    func getParentKidsNetwork(){
        self.showLoadingView()
        NetworkManager.getKidsNetwork() { (response) in
            self.dismissLoadingView()
            switch response {
            
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.parentKidsData.removeAll()
                    guard let array =  dataValue.data else {return}
                    self.parentKidsData = array
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    func selectAllRows() {
        selectedIDs.removeAll()
        HelperTools.isAllSelected = true
        for section in 0..<childTable.numberOfSections {
            for row in 0..<childTable.numberOfRows(inSection: section) {
                childTable.selectRow(at: IndexPath(row: row, section: section), animated: false, scrollPosition: .none)
            }
        }
        
        for items in parentKidsData {
            self.selectedIDs.append("\(items.id ?? 0)" )
        }
    }
    
    func deSelectAllRows() {
        self.selectedIDs.removeAll()
        HelperTools.isAllSelected = true
        for section in 0..<childTable.numberOfSections {
            for row in 0..<childTable.numberOfRows(inSection: section) {
                childTable.deselectRow(at: IndexPath(row: row, section: section), animated: false)
            }
        }
    }
    
    func getChildsIDs()->String {
        childsIDs = ""
        for  i in selectedIDs {
            self.childsIDs += "\(i),"
        }
        if childsIDs != "" {
            childsIDs.remove(at: childsIDs.index(before: childsIDs.endIndex))
        }
        return childsIDs
    }
}

extension AddRewardVC :UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        self.childIMage.image = image
        self.taskImage = image
        dismiss(animated: true , completion: nil)
    }
}

extension AddRewardVC : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parentKidsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChildTableCell.cellID, for: indexPath) as! ChildTableCell
        
        cell.setUpCellData(model: parentKidsData[indexPath.item])
        if self.selectedIDs.contains("\(parentKidsData[indexPath.row].id ?? 0)")  {
            cell.isSelected = true
        }
        else{

            cell.isSelected = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        selectImg.image = #imageLiteral(resourceName: "blueEmptyCheck")
        selectAll = false
        
        
        HelperTools.isAllSelected = false
        if(selectedIDs.contains("\(parentKidsData[indexPath.row].id ?? 0)")) {
            selectedIDs = selectedIDs.filter
            {$0 != "\(parentKidsData[indexPath.row].id ?? 0)"}
        }else{
            selectedIDs.append("\(parentKidsData[indexPath.row].id ?? 0)")
        }
        print("didDeselect  iDs" , selectedIDs)
        childTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
