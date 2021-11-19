//
//  ProfileChildOnParentVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 19/08/2021.
//

import UIKit

class ProfileChildOnParentVC: LoadingView {
    
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var filterResultLab: UILabel!
    @IBOutlet weak var imageContainerVIew: UIView!
    @IBOutlet weak var childIMage: UIImageView!
    
    @IBOutlet weak var enterChildView: UIView!
    @IBOutlet weak var enterChildLab: UILabel!
    
    @IBOutlet weak var activityValueLab: UILabel!
    @IBOutlet weak var activityLab: UILabel!
    @IBOutlet weak var pointsValueLab: UILabel!
    @IBOutlet weak var pointsLab: UILabel!
    @IBOutlet weak var segmentCollection: UICollectionView!

    @IBOutlet weak var addingLab: UILabel!
    @IBOutlet weak var addNewBtn: UIButton!
    
    @IBOutlet weak var tasksTable: UITableView!
    
    var imagePicker = UIImagePickerController()
    var childImage : UIImage? = UIImage()
    var parentKidsData = [ParentKidsModel]()
    var kidID = ""
    var kidName = ""
    var addingText = ""
    var index = ""
    var imageUrl = ""
    
    var tableData = [GetKidActivitiesOnProfileModel](){
        didSet{
            tasksTable.reloadData()
        }
    }
    
    var collectionArray : [collectionArrayModel] = [
        collectionArrayModel.init(name: "Activities", index: "1"),
        collectionArrayModel.init(name: "Goals", index: "2"),
        collectionArrayModel.init(name: "statistics", index: "3"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        getParentKidsNetwork()
        setUpView()
        setUpLocalize()
        collectionConfigration()
        tableConfigration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        childProfileFromParentNetwork(kidId: kidID)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func tableConfigration(){
        tasksTable.register(UINib(nibName:ChildProfileOnParentCell.cellID , bundle: nil), forCellReuseIdentifier: ChildProfileOnParentCell.cellID)
        tasksTable.delegate = self
        tasksTable.dataSource = self
        tasksTable.separatorStyle = .none
        tasksTable.showsVerticalScrollIndicator = false
    }
    
    func setUpView(){
        self.filterResultLab.text = kidName

        mainContainer.layer.maskedCorners = [.layerMinXMaxYCorner , .layerMaxXMaxYCorner]
        mainContainer.layer.cornerRadius = 180
        enterChildView.layer.cornerRadius = 10
        imageContainerVIew.layer.cornerRadius = imageContainerVIew.layer.frame.height / 2
        childIMage.layer.cornerRadius =  childIMage.layer.frame.height / 2
        
        mainContainer.layer.shadowColor = UIColor.darkGray.cgColor
        mainContainer.layer.shadowOpacity = 0.55
        mainContainer.layer.shadowRadius = 5
        mainContainer.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        mainContainer.layer.masksToBounds = false
    }
    
    func setUpLocalize(){
        enterChildLab.setTitle(For: "Child entry")
        activityLab.setTitle(For:"the Activities")
        pointsLab.setTitle(For: "the Point")
    }
    
    
    func collectionConfigration(){
        segmentCollection.delegate = self
        segmentCollection.dataSource = self
        segmentCollection.register(UINib(nibName: segmentCollectionCell.cellID, bundle: nil), forCellWithReuseIdentifier: segmentCollectionCell.cellID)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        segmentCollection.collectionViewLayout = layout
    
        layout.itemSize = CGSize(width: segmentCollection.frame.width / 3  , height:  50)
        layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        segmentCollection.collectionViewLayout = layout
        
    }
    
    
    @IBAction func filterBtn(_ sender: Any) {
        
        let vc = GeneralTabelVC(mainSection: "")
        vc.delegate = self
        vc.tableType = .Child
        vc.childArr = self.parentKidsData
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        HelperTools.chosseOptionAlert(imagePicker: imagePicker, vc: self)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func notificationBtn(_ sender: Any) {
    }
    
    @IBAction func editBtn(_ sender: Any) {
    }
    
    @IBAction func addNewAction(_ sender: Any) {
        if self.index == "0" {
            let vc = ActivityTaskVC()
            vc.kidID = self.kidID
            vc.isFormMain = true
            self.presentViewController(present: vc)
        }else if self.index == "1"{            
            let vc = GoalTaskVC()
            vc.kidID = self.kidID
            vc.isFormMain = true
            self.presentViewController(present: vc)
            
        }else{
            
        }
    }
    
    @IBAction func enterChildBtn(_ sender: Any) {
        let vc = ChildProfileDetailsVC()
        vc.childID = self.kidID
        vc.childValueImageUrl = self.imageUrl
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func setUpChildData(model:ChildProfileFromParentModel){
        let urlString = "https://www.shattoor.com/api" + (model.profileImageURL ?? "")
        imageUrl = model.profileImageURL ?? ""
        childIMage.kf.setImage(with: URL(string: urlString))
        self.activityValueLab.text = "\(model.activitiesCount ?? 0 )"
        self.pointsValueLab.text = "\(model.points ?? 0 )"
    }
}

// Network
extension ProfileChildOnParentVC {
    func getParentKidsNetwork(){
        NetworkManager.getKidsNetwork() { (response) in
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.parentKidsData.removeAll()
                    guard let array =  dataValue.data else {return}
                    self.parentKidsData = array
//                    let firstIndex = self.parentKidsData[0]
//                    self.kidID = "\(firstIndex.id ?? 0)"
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    func childProfileFromParentNetwork(kidId:String){
        NetworkManager.childProfileFromParentNetwork(kidId: kidId) { (response) in
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    guard let childData = dataValue.data else {
                        return
                    }
                    self.setUpChildData(model: childData)
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    
    
    func getKidActivitiesOnProfileNetwork(pageIndex: String, kidId: String){
//                self.showLoadingView()
        NetworkManager.getKidActivitiesOnProfileNetwork(pageIndex: pageIndex, kidId: kidId ) { (response) in
//                        self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.tableData.removeAll()
                    guard let array =  dataValue.data else {return}
                    self.tableData = array
                    if array.isEmpty == true {
                        self.tasksTable.isHidden = true
                    }else{
                        self.tasksTable.isHidden = false
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
    
    func getKidGoalsOnProfileNetwork(pageIndex: String, kidId: String){
//                self.showLoadingView()
        NetworkManager.getKidGoalsOnProfileNetwork(pageIndex: pageIndex, kidId: kidId ) { (response) in
//                        self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.tableData.removeAll()
                    guard let array =  dataValue.data else {return}
                    self.tableData = array
                    if array.isEmpty == true {
                        self.tasksTable.isHidden = true
                    }else{
                        self.tasksTable.isHidden = false
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

    
    func changeKidProfileImage(){
        self.showLoadingView()
        let  parameter :[ String : String] = ["":""]
        print("the parameter is", parameter)
        NetworkManager.APIWithImage(model: UserModelResponse.self, urlPath: "Parent/ChangeKidProfileImage?kidId=\(self.kidID)", imageParameterName: "file", image: self.childImage, params: parameter) { (response, error) in
            self.dismissLoadingView()
            guard let response = response as? UserModelResponse  else {return}
            if response.status == 200 {
                HelperTools.ShowIntervalMassge(massge: nil, key: response.message ?? "")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.childProfileFromParentNetwork(kidId: self.kidID)
                }
            }else{
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
}

extension ProfileChildOnParentVC : GetGeneralData {
    func data(name: String, type: GeneralTabel) {
    }
    
    func modelData(model: GeneralPopUpModel, type: GeneralTabel) {
    }
    
    func modelChildData(model: ParentKidsModel, type: GeneralTabel) {
        if type == .Child {
            self.filterResultLab.text = model.fullName ?? ""
            self.kidID = "\(model.id ?? 0)"
            childProfileFromParentNetwork(kidId: "\(model.id ?? 0)")

        }
    }
}


extension ProfileChildOnParentVC :UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: segmentCollectionCell.cellID, for: indexPath) as! segmentCollectionCell
        cell.setUpCellData(data: collectionArray[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch  indexPath.row  {
        case 0:
            self.index = "0"
            getKidActivitiesOnProfileNetwork(pageIndex: "1", kidId: self.kidID)
            self.addingLab.text = "Add New Activity".localized
        case 1:
            self.index = "1"
            getKidGoalsOnProfileNetwork(pageIndex: "1", kidId: self.kidID)
            self.addingLab.text = "Add New Goal".localized
        case 2:
            self.index = "2"
            self.tasksTable.isHidden = true
            self.addingLab.text = "Add New statistics".localized
        default:
            return
        }
    }
}

struct collectionArrayModel {
    var name  :String
    var index : String
}


extension ProfileChildOnParentVC : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChildProfileOnParentCell.cellID, for: indexPath) as! ChildProfileOnParentCell
        cell.setUpCellData(model: tableData[indexPath.item])
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
        return 100
    }
}

//changeKidProfileImage()
extension ProfileChildOnParentVC :UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        self.childIMage.image = image
        childImage = image
        dismiss(animated: true , completion: nil)
        changeKidProfileImage()
    }
}
