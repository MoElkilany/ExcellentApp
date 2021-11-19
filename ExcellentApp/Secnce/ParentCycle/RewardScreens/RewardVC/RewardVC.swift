//
//  RewardVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 23/04/2021.
//

import UIKit

class RewardVC: LoadingView {
    
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var sideMenuBtn: UIButton!
    @IBOutlet weak var rewardBtn: UIButton!
    @IBOutlet weak var noRewardLab: UILabel!
    @IBOutlet weak var addRewardBtn: UIButton!
    @IBOutlet weak var addRewardNavBtn: UIButton!
    @IBOutlet weak var rewardTable: UITableView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var filterResultLab: UILabel!
    
    var rewardData = [GetGiftModel](){
        didSet{
            rewardTable.reloadData()
        }
    }
    
    var kidID = ""
    var parentKidsData = [ParentKidsModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadActivity()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
     
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    func viewDidLoadActivity(){
        tableConfigration()
        setUpLoclizeElements()
        getParentKidsNetwork()
        getGiftsNetwork(pageIndex: "1", kidId: kidID)
    }
    
    
    
    func setUpLoclizeElements(){
        rewardBtn.setButtonTitle(to: "reward")
        self.noRewardLab.setTitle(For: "No rewards")
    }
    
    
    func tableConfigration(){
        
        rewardTable.register(UINib(nibName:RewardTableCell.cellID , bundle: nil), forCellReuseIdentifier: RewardTableCell.cellID)
        rewardTable.delegate = self
        rewardTable.dataSource = self
        rewardTable.separatorStyle = .none
        rewardTable.showsVerticalScrollIndicator = false
        
    }
    
    
    @IBAction func sideMenuAction(_ sender: Any) {
        self.presentViewController(present: ParentSideMenuVC())
    }
    
    @IBAction func notificationAction(_ sender: Any) {
        
        
    }
    
    @IBAction func addRewordAction(_ sender: Any) {
        self.presentViewController(present: AddRewardVC())

    }
    
    @IBAction func addRewordNavAction(_ sender: Any) {
        self.presentViewController(present: AddRewardVC())

    }
    
    
    @IBAction func filterAction(_ sender: Any) {
        let vc = GeneralTabelVC(mainSection: "")
        vc.delegate = self
        vc.tableType = .Child
        vc.childArr = self.parentKidsData
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func getParentKidsNetwork(){
        NetworkManager.getKidsNetwork() { (response) in
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.parentKidsData.removeAll()
                    guard let array =  dataValue.data else {return}
                    self.parentKidsData = array
                    self.filterResultLab.text =  "All".localized
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    

    func getGiftsNetwork(pageIndex: String,kidId:String){
        self.showLoadingView()
        NetworkManager.getGiftsNetwork(pageIndex: pageIndex, kidId: kidId) { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.rewardData.removeAll()
                    guard let array =  dataValue.data else {return}
                    self.rewardData = array
                    if array.isEmpty == true  {
                        self.rewardTable.isHidden = true
                    }else{
                        self.rewardTable.isHidden = false
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

extension RewardVC : GetGeneralData {
    
    func data(name: String, type: GeneralTabel) {
    }
    
    func modelData(model: GeneralPopUpModel, type: GeneralTabel) {
    }
    
    func modelChildData(model: ParentKidsModel, type: GeneralTabel) {
        if type == .Child {
            self.filterResultLab.text = model.fullName ?? ""
            self.kidID = "\(model.id ?? 0 )"
            getGiftsNetwork(pageIndex: "1", kidId: kidID)
        }
    }
}



extension RewardVC : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RewardTableCell.cellID, for: indexPath) as! RewardTableCell
        cell.setUpCellDate(model: rewardData[indexPath.item])
        
        cell.moreAction = {[weak self] in
            guard  let self = self  else {return}
            let vc = CardSettingsVC()
            vc.type = .gifts
            vc.taskId = "\(self.rewardData[indexPath.item].id ?? 0 )"
            vc.kidId = "\(self.rewardData[indexPath.item].kids ?? "" )"
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
