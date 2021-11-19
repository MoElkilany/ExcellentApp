//
//  ChildHomeVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 16/04/2021.
//

import UIKit

class ChildHomeVC: LoadingView {

    
    @IBOutlet weak var blureImage: UIImageView!
    @IBOutlet weak var viewImge: UIView!
    @IBOutlet weak var kidImage: UIImageView!
    
    @IBOutlet weak var chooseImageBtn: UIButton!
    @IBOutlet weak var yourBallanceView: UIView!
    
    @IBOutlet weak var yourbalanceLab: UILabel!
    @IBOutlet weak var yourbalanceValueLab: UILabel!
    @IBOutlet weak var buyFromStoreLab: UILabel!
    
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityLab: UILabel!
    @IBOutlet weak var activityBtn: UIButton!
    @IBOutlet weak var activityUnderView: UIView!

    @IBOutlet weak var goalsView: UIView!
    @IBOutlet weak var goalsLab: UILabel!
    @IBOutlet weak var goalsBtn: UIButton!
    @IBOutlet weak var goalsUnderView: UIView!

    @IBOutlet weak var activeTabel: UITableView!
    
    @IBOutlet weak var grantLab: UILabel!
    @IBOutlet weak var discountsLab: UILabel!
    
    @IBOutlet weak var grantBtn: UIButton!
    @IBOutlet weak var discountsBtn: UIButton!
    @IBOutlet weak var rewardBtn: UIButton!
    
    var childName = ""
    var activitiesAndGoalsArray = [KidsActivitiesAndGoalsModel](){
        didSet{
            activeTabel.reloadData()
        }
    }
    
    var imagePicker = UIImagePickerController()
    private var pageCount = 1
    private var isGetMore = false
    var isActivity = Bool()
    var childImage : UIImage? = UIImage()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getKidProfileData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadActivity()
    }
    
    func viewDidLoadActivity(){
        actionButton()
        setUpView()
        setUpLocalizeElements()
        tableConfigration()
       
    }
    
    func setUpView(){
        getKidsActivities()
        isActivity = true
        goalsLab.isEnabled = false
        goalsUnderView.isHidden = true
        viewImge.layer.cornerRadius = viewImge.frame.height / 2
        kidImage.layer.cornerRadius = 12
        yourBallanceView.layer.cornerRadius = 15
        yourBallanceView.layer.borderColor = UIColor.lightGray.cgColor
        yourBallanceView.layer.borderWidth = 1
    }
    
    
    
    func setUpLocalizeElements(){
        yourbalanceLab.setTitle(For: "Your balance")
        buyFromStoreLab.setTitle(For: "You can purchase your reward from the Shator store")
        activityLab.setTitle(For: "Activities")
        goalsLab.setTitle(For: "Goals")
        grantLab.setTitle(For: "Grant")
        discountsLab.setTitle(For: "Discounts")
    }
   
    func navigationButtons(){
        let navbarFont = UIFont(name: "Cairo-Bold", size: 12)  ?? UIFont.systemFont(ofSize: 12)
               let sideMenuButton = UIBarButtonItem(image: UIImage(named:"sideMenu"), style:.plain, target: self, action: #selector(sideMenuButtonTapped))
        let name = "Hi".localized + " " + self.childName + " " + "excellent".localized
        let nameButton = UIBarButtonItem(title:name, style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItems = [sideMenuButton,nameButton]
        let nameAttribute = [NSAttributedString.Key.font: navbarFont, NSAttributedString.Key.foregroundColor:UIColor(named: "030414")]
        nameButton.setTitleTextAttributes(nameAttribute as [NSAttributedString.Key : Any], for: .normal)
        let imageButton = UIBarButtonItem(image: UIImage(named:"no"), style:.plain, target: self, action: nil)
        let premeuimButton = UIBarButtonItem(title:"Premium".localized, style: .plain, target: self, action: nil)
        let premenuAttribute = [NSAttributedString.Key.font: navbarFont, NSAttributedString.Key.foregroundColor:UIColor(named: "E5C100")]
        premeuimButton.setTitleTextAttributes(premenuAttribute as [NSAttributedString.Key : Any], for: .normal)
        navigationItem.rightBarButtonItems = [premeuimButton,imageButton]
        
        }
    
    @objc func sideMenuButtonTapped(){
        self.presentViewController(present: SideMenuVC())
    }
    
    func tableConfigration(){
        activeTabel.register(UINib(nibName:ChildHomeCell.cellID , bundle: nil), forCellReuseIdentifier: ChildHomeCell.cellID)
        activeTabel.delegate = self
        activeTabel.dataSource = self
        activeTabel.separatorStyle = .none
        activeTabel.showsVerticalScrollIndicator = false
        activeTabel.prefetchDataSource = self
    }
    
    func actionButton(){
        chooseImageBtn.addTarget(self, action: #selector(chooseImageBtnTapped), for: .touchUpInside)
        activityBtn.addTarget(self, action: #selector(activityBtnTapped), for: .touchUpInside)
        goalsBtn.addTarget(self, action: #selector(goalsBtnTapped), for: .touchUpInside)
        rewardBtn.addTarget(self, action: #selector(rewardBtnTapped), for: .touchUpInside)
        grantBtn.addTarget(self, action: #selector(grantBtnTapped), for: .touchUpInside)
        discountsBtn.addTarget(self, action: #selector(discountsBtnTapped), for: .touchUpInside)

    }
        
    @objc func grantBtnTapped(){
        let grantVC = UINavigationController(rootViewController: GrantVC())
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = grantVC
    }
    
    @objc func discountsBtnTapped(){
        let discountvc = UINavigationController(rootViewController: DiscountsVC())
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = discountvc
        
    }
    
    @objc func rewardBtnTapped(){
        let vc = BonusStoreVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func chooseImageBtnTapped(){
        HelperTools.chosseOptionAlert(imagePicker: imagePicker, vc: self)
    }
    
    @objc func activityBtnTapped(){
        isActivity = true
        pageCount = 1
        isGetMore = false

        goalsLab.isEnabled = false
        activityUnderView.isHidden = false
        goalsUnderView.isHidden = true
        activityLab.isEnabled = true
        getKidsActivities()
    }
    
    @objc func goalsBtnTapped(){
        isActivity = false
        pageCount = 1
        isGetMore = false
        activityUnderView.isHidden = true
        goalsUnderView.isHidden = false
        activityLab.isEnabled = false
                goalsLab.isEnabled = true
        getKidsGoals()
    }
    
    func getKidsActivities(){
        isGetMore = true
        self.showLoadingView()
        NetworkManager.getKidsActivities(pageIndex: "\(pageCount)") { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.activitiesAndGoalsArray.removeAll()
                    guard  let activiyData = dataValue.data else {
                        return
                    }
                    self.activitiesAndGoalsArray = activiyData
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
                self.pageCount = +1
                self.isGetMore = false
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }

    func getKidsGoals(){
        self.isGetMore = true
        self.showLoadingView()
        NetworkManager.getKidsGoals(pageIndex: "\(pageCount)") { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                
                if dataValue.status == 200 {
                    self.activitiesAndGoalsArray.removeAll()
                    guard  let goalData = dataValue.data else {
                        return
                    }
                    self.activitiesAndGoalsArray = goalData
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
                self.pageCount = +1
                self.isGetMore = false
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
        
    func getKidProfileData(){
//        self.showLoadingView()
        NetworkManager.getKidProfileData() { (response) in
//            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
            self.setUpHomeView(data: dataValue)
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    func setUpHomeView(data:GetKidProfileDataResponse){
        let urlString = "https://www.shattoor.com/api" + (data.imageURL ?? "")
        kidImage.kf.setImage(with: URL(string: urlString) ,placeholder: UIImage(named: "4"))
        yourbalanceValueLab.text = "\(data.points ?? 0)"
        self.childName = data.fullName ?? ""
        print("[childName]" , childName)
        navigationButtons()
    }
}


extension ChildHomeVC : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activitiesAndGoalsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChildHomeCell.cellID, for: indexPath) as! ChildHomeCell
        cell.setUpCellData(model: activitiesAndGoalsArray[indexPath.item])
        cell.rewardImgeCloure = { [weak self] in
            guard let self = self else {return}
            let vc = ExecuteTaskVC()
            vc.kidID = "\(self.activitiesAndGoalsArray[indexPath.item].kidsTaskID ?? 0 )"
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
  
    func paginateData(indexPaths:[IndexPath]){
        
//        for index in indexPaths {
//            if index.row >= activitiesAndGoalsArray.count - 1 && !isGetMore {
//                if isActivity {
//                    self.getKidsActivities()
//                    break
//                }else{
//                    getKidsGoals()
//                    break
//                }
//            }
//        }
        
//        if isActivity {
//        for index in indexPaths {
//            if index.row >= activitiesAndGoalsArray.count - 1 && !isGetMore {
//                self.getKidsActivities()
//                break
//              }
//           }
//        }else{
//            for index in indexPaths {
//                if index.row >= activitiesAndGoalsArray.count - 1 && !isGetMore {
//                    self.getKidsGoals()
//                    break
//                  }
//               }
//        }
    }
    
    
    func changeKidProfileImage(){
        self.showLoadingView()
        let  parameter :[ String : String] = ["":""]
        print("the parameter is", parameter)
        NetworkManager.APIWithImage(model: UserModelResponse.self, urlPath: "kids/ChangeKidProfileImage", imageParameterName: "file", image: self.childImage, params: parameter) { (response, error) in
            self.dismissLoadingView()
            guard let response = response as? UserModelResponse  else {return}
            if response.status == 200 {
                HelperTools.ShowIntervalMassge(massge: nil, key: response.message ?? "")
            }else{
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
}

extension ChildHomeVC :UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        self.kidImage.image = image
        childImage = image
        changeKidProfileImage()
        dismiss(animated: true , completion: nil)
    }
}

extension ChildHomeVC:ReloadChildHomeData {
    func isExecuteTaskDone(isDone: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.activeTabel.reloadData()
        }
    }
}

extension ChildHomeVC:UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        paginateData(indexPaths: indexPaths)
    }    
}
