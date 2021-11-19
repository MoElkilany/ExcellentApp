//
//  StatisticsDetailsVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 12/09/2021.
//

import UIKit

class StatisticsDetailsVC: LoadingView {
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var filterResultLab: UILabel!
    @IBOutlet weak var navTitle: UILabel!
    
    @IBOutlet weak var rightStack: UIStackView!
    @IBOutlet weak var rightLab: UILabel!
    @IBOutlet weak var rightValueLab: UILabel!
    
    @IBOutlet weak var leftStack: UIStackView!
    @IBOutlet weak var leftLab: UILabel!
    @IBOutlet weak var leftValueLab: UILabel!
    @IBOutlet weak var statisticsTable: UITableView!
    
    @IBOutlet weak var noContentLab: UILabel!
    @IBOutlet weak var noContentStack: UIStackView!
    
    var statisticsDetailsArray:[StatisticsDetailsModel] = [StatisticsDetailsModel]() {
        didSet{
            statisticsTable.reloadData()
        }
    }
    
    var parentKidsData = [ParentKidsModel]()
    var kidID = ""
    var navName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Constants.state",Constants.state)
        tableConfigration()
    }
    
    
    func tableConfigration(){
        statisticsTable.register(StatisticsDetailsCell.nib(), forCellReuseIdentifier: StatisticsDetailsCell.cellID)
        statisticsTable.delegate = self
        statisticsTable.dataSource = self
        statisticsTable.separatorStyle = .none
        statisticsTable.showsVerticalScrollIndicator = false
    }


    func setUpView(){
        noContentLab.setTitle(For: "noContent")
        navTitle.text = navName
        switch Constants.state {
        case .goal:
            getStatisticsGoalsKid(pageIndex: "1", kidId: self.kidID)
            rightLab.setTitle(For: "Balance")
            leftLab.setTitle(For: "goal")
        case .activity:
            getStatisticsActivitiesKid(pageIndex: "1", kidId: self.kidID)
            rightLab.setTitle(For: "Balance")
            leftLab.setTitle(For: "activity")
        case .discountPoint:
            GetStatisticsDeductionKid(pageIndex: "1", kidId: self.kidID)
            rightLab.setTitle(For:"Number of points")
            leftLab.setTitle(For: "discount")
            
        case .addPoint:
            GetStatisticsGrantKid(pageIndex: "1", kidId: self.kidID)
            rightLab.setTitle(For:"Number of points")
            leftLab.setTitle(For: "Grant")
            
        case .reward:
            GetStatisticsGiftsKid(pageIndex: "1", kidId: self.kidID)
            rightStack.isHidden = true
            leftStack.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getParentKidsNetwork()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    @IBAction func filterActionBtn(_ sender: Any) {
        let vc = GeneralTabelVC(mainSection: "")
        vc.delegate = self
        vc.tableType = .Child
        vc.childArr = self.parentKidsData
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpDataToViews(model:StatisticsDetailsResponse){
        self.statisticsDetailsArray.removeAll()
        guard let array =  model.data else {return}
        self.statisticsDetailsArray = array
        if array.isEmpty == true {
            self.statisticsTable.isHidden = true
        }else{
            self.statisticsTable.isHidden = false
        }
        
        switch Constants.state {
        case .goal:
            rightValueLab.text = "\(model.points ?? 0) :"
            leftValueLab.text =  "\(model.count ?? 0)  :"
        case .activity:
            rightValueLab.text = "\(model.points ?? 0) :"
            leftValueLab.text =  "\(model.count ?? 0)  :"
        case .discountPoint:
            rightValueLab.text = "\(model.points ?? 0) :"
            leftValueLab.text =  "\(model.count ?? 0)  :"
        case .addPoint:
            rightValueLab.text = "\(model.points ?? 0) :"
            leftValueLab.text =  "\(model.count ?? 0)  :"
        case .reward:
            rightValueLab.text = ""
            leftValueLab.text = ""
        }
    }
}

extension StatisticsDetailsVC {
    func getParentKidsNetwork(){
        NetworkManager.getKidsNetwork() { (response) in
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.parentKidsData.removeAll()
                    guard let array =  dataValue.data else {return}
                    self.parentKidsData = array
                    let firstKid = array.first
                    self.filterResultLab.text = firstKid?.fullName ?? ""
                    self.kidID = "\(firstKid?.id ?? 0 )"
                    self.setUpView()
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    
    
    func getStatisticsGoalsKid(pageIndex: String, kidId: String){
        self.showLoadingView()
        NetworkManager.GetStatisticsGoalsKid(kidId: kidId, pageIndex: pageIndex) { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.setUpDataToViews(model: dataValue)
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    func getStatisticsActivitiesKid(pageIndex: String, kidId: String){
        self.showLoadingView()
        NetworkManager.getStatisticsActivitiesKid(kidId: kidId, pageIndex: pageIndex) { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.setUpDataToViews(model: dataValue)
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    
    func GetStatisticsGiftsKid(pageIndex: String, kidId: String){
        self.showLoadingView()
        NetworkManager.GetStatisticsGiftsKid(kidId: kidId, pageIndex: pageIndex) { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.setUpDataToViews(model: dataValue)
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    func GetStatisticsGrantKid(pageIndex: String, kidId: String){
        self.showLoadingView()
        NetworkManager.GetStatisticsGrantKid(kidId: kidId, pageIndex: "1") { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.setUpDataToViews(model: dataValue)
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
        
    func GetStatisticsDeductionKid(pageIndex: String, kidId: String){
        self.showLoadingView()
        NetworkManager.GetStatisticsDeductionKid(kidId: kidId, pageIndex: "1") { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.setUpDataToViews(model: dataValue)
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


extension StatisticsDetailsVC : GetGeneralData {
    func data(name: String, type: GeneralTabel) {
    }
    
    func modelData(model: GeneralPopUpModel, type: GeneralTabel) {
    }
    
    func modelChildData(model: ParentKidsModel, type: GeneralTabel) {
        if type == .Child {
            self.filterResultLab.text = model.fullName ?? ""
            self.kidID = "\(model.id ?? 0 )"
            setUpView()
        }
    }
}


extension StatisticsDetailsVC : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statisticsDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsDetailsCell.cellID, for: indexPath) as! StatisticsDetailsCell
        
        cell.setUpCellView(model: statisticsDetailsArray[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

