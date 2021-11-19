//
//  MainVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 23/04/2021.
//

import UIKit


class MainVC: LoadingView {
    
    @IBOutlet weak var balanceValue: UILabel!
    @IBOutlet weak var balanceView: UIView!
    
    @IBOutlet weak var yorGiftLab: UILabel!
    @IBOutlet weak var premuimBtn: UIButton!
    
    @IBOutlet weak var grantBtn: CornerButton!
    @IBOutlet weak var discountBtn: CornerButton!
    
    @IBOutlet weak var myChildLab: UILabel!
    
    @IBOutlet weak var addMyChildBtn: UIButton!
    @IBOutlet weak var myParentTable: UITableView!
    
    var HomeData = [HomeParentModel](){
        didSet{
            myParentTable.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        tableConfigration()
    }
    
    func setUpView(){
        myChildLab.setTitle(For: "My Child")
        grantBtn.setButtonTitle(to: "Grant")
        discountBtn.setButtonTitle(to: "Discounts")
        premuimBtn.setButtonTitle(to: "Premium")
        yorGiftLab.setTitle(For: "Buy your gift for your child at the gift shop")
        balanceValue.text = "100"
        balanceView.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getHomeDataNetwork(pageIndex: "1")
        navigationController?.setNavigationBarHidden(true, animated: false)
        getHeaderNetwork()
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func tableConfigration(){
        myParentTable.register(UINib(nibName:MainCell.cellID , bundle: nil), forCellReuseIdentifier: MainCell.cellID)
        myParentTable.delegate = self
        myParentTable.dataSource = self
        myParentTable.separatorStyle = .none
        myParentTable.showsVerticalScrollIndicator = false
        
    }
    
    
    @IBAction func sideMenuAction(_ sender: Any) {
        self.presentViewController(present: ParentSideMenuVC())        
    }
    @IBAction func premuniAction(_ sender: Any) {
    }
    
    @IBAction func notificationAction(_ sender: Any) {
        self.presentViewController(present: NotificationVC())

    }
    
    @IBAction func addChildAction(_ sender: Any) {
        let vc = AddChildVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.reloadDelegate =  self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func disCountAction(_ sender: Any) {
        self.presentViewController(present: AddDiscountVC())
    }
    
    @IBAction func plusDiscountBtn(_ sender: Any) {
        self.presentViewController(present: AddDiscountVC())
    }
    
    @IBAction func awardAction(_ sender: Any) {
        self.presentViewController(present: AddAwardPointsVC())
    }
    
    @IBAction func plusAwardBtn(_ sender: Any) {
        self.presentViewController(present: AddAwardPointsVC())
    }
    
    
    @IBAction func awardInformationBtn(_ sender: Any) {
        self.presentViewController(present: InformationPopUpVC(title: "Award information".localized))
    }
    //"Award information"
    //"Discount information"
    @IBAction func discountInformationBtn(_ sender: Any) {
        
        self.presentViewController(present: InformationPopUpVC(title: "Discount information".localized))
    }
    
    
    func setUpHeaderData(model:GetHeaderModel){
        yorGiftLab.text = model.ad ?? ""
        balanceValue.text = "\(model.points ?? 0)"
    }
    
    func getHomeDataNetwork(pageIndex: String){
        self.showLoadingView()
        NetworkManager.getParentKidsWithCompletionRateNetwork(pageIndex: pageIndex) { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.Status == 200 {
                    self.HomeData.removeAll()
                    guard let array =  dataValue.data else {return}
                    self.HomeData = array
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.Message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    func getHeaderNetwork(){
        NetworkManager.getHeaderNetwork() { (response) in
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    guard let header = dataValue.data else {return}
                    self.setUpHeaderData(model: header)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
}
//

extension MainVC : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   HomeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainCell.cellID, for: indexPath) as! MainCell
        
        cell.qrCodeButton = {[weak self] in
            guard let self = self else {return}
            let vc = ChildProfileDetailsVC()
            vc.childID = "\(self.HomeData[indexPath.item].Id ?? 0 )"
            vc.childValueImageUrl = self.HomeData[indexPath.item].profileImageUrl ?? ""
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
        
        cell.plusButton = { [weak self ] in
            guard let self = self else {return}
            let vc = ChooseTaskVC()
            vc.kidID = "\(self.HomeData[indexPath.item].Id ?? 0 )"
            self.presentViewController(present: vc)
        }
        
        cell.setUpCellData(model: HomeData[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProfileChildOnParentVC()
        vc.kidID = "\(HomeData[indexPath.item].Id ?? 0 )"
        vc.kidName = "\(HomeData[indexPath.item].FullName ?? "" )"
        self.presentViewController(present: vc)
    }
}


extension MainVC : ReloadTheFullData {
    func isDataReloaded(isReload: Bool) {
        if isReload {
            getHomeDataNetwork(pageIndex: "1")
        }
    }
}
