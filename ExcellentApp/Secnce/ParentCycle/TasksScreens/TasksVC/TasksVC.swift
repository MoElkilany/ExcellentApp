//
//  TasksVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 23/04/2021.
//

import UIKit

class TasksVC: LoadingView {
    
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var sideMenuBtn: UIButton!
    @IBOutlet weak var tasksBtn: UIButton!
    @IBOutlet weak var segmentBar: UISegmentedControl!
    @IBOutlet weak var noTasksLab: UILabel!
    @IBOutlet weak var filterBtn: UIButton!

    @IBOutlet weak var addTaskBtn: UIButton!
    @IBOutlet weak var addTaskNavBtn: UIButton!
    @IBOutlet weak var tasksTable: UITableView!
    @IBOutlet weak var filterResultLab: UILabel!
    @IBOutlet weak var thereIsNoTaskLab: UILabel!
    
    var tasksData = [KidsGoalsAndActivityModel](){
        didSet{
            tasksTable.reloadData()
        }
    }
    var parentKidsData = [ParentKidsModel]()
    var kidID = ""
    var isGoal     = true
    var isActivity = false
    var selectedTaskID = ""
    var selectedKidID = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadActivity()
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
    
    func viewDidLoadActivity(){
        actionButton()
        setUpView()
        tableConfigration()
        setUpLoclizeElements()
    }
    
    
    func setUpView(){
        self.thereIsNoTaskLab.setTitle(For: "There are no tasks")
        let attribute = [NSAttributedString.Key.font:UIFont(name: "Cairo-Bold", size: 12)]
        segmentBar.setTitle("Goals".localized, forSegmentAt: 0)
        segmentBar.setTitle("Activities".localized, forSegmentAt: 1)
        segmentBar.setTitleTextAttributes(attribute as [NSAttributedString.Key : Any], for: .normal)
    }
    
    func setUpLoclizeElements(){
        tasksBtn.setButtonTitle(to: "Tasks")
    }
    
    func actionButton(){
        addTaskBtn.addTarget(self, action: #selector(addTaskBtnTapped), for: .touchUpInside)
        sideMenuBtn.addTarget(self, action: #selector(sideMenuBtnTapped), for: .touchUpInside)
        notificationBtn.addTarget(self, action: #selector(notificationBtnTapped), for: .touchUpInside)
        filterBtn.addTarget(self, action: #selector(filterBtnTapped), for: .touchUpInside)
        addTaskNavBtn.addTarget(self, action: #selector(addTaskNavBtnTapped), for: .touchUpInside)
    }
    
    
    func tableConfigration(){
        tasksTable.register(UINib(nibName:myTaskCell.cellID , bundle: nil), forCellReuseIdentifier: myTaskCell.cellID)
        tasksTable.delegate = self
        tasksTable.dataSource = self
        tasksTable.separatorStyle = .none
        tasksTable.showsVerticalScrollIndicator = false
    }
    
    
    @objc func addTaskNavBtnTapped(){
        
        let vc = ChooseTaskVC()
        vc.chooseTaskDelegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    @objc func addTaskBtnTapped(){
        let vc = ChooseTaskVC()
        vc.chooseTaskDelegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func sideMenuBtnTapped(){
        self.presentViewController(present: ParentSideMenuVC())
    }
    
    @objc func notificationBtnTapped(){
        
    }
    
    @objc func filterBtnTapped(){
        let vc = GeneralTabelVC(mainSection: "")
        vc.delegate = self
        vc.tableType = .Child
        vc.childArr = self.parentKidsData
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("goals")
            getKidGoalsNetwork(pageIndex: "1", kidId: kidID)
            isGoal  = true
        }else{
            print("Activity")
            getKidActivitiesNetwork(pageIndex: "1", kidId: kidID)
            isGoal     = false
        }
    }
}


extension TasksVC : GetGeneralData {
    func data(name: String, type: GeneralTabel) {
    }
    
    func modelData(model: GeneralPopUpModel, type: GeneralTabel) {
    }
    
    func modelChildData(model: ParentKidsModel, type: GeneralTabel) {
        if type == .Child {
            self.filterResultLab.text = model.fullName ?? ""
            self.kidID = "\(model.id ?? 0 )"
            if isGoal {
                getKidGoalsNetwork(pageIndex: "1", kidId: kidID)
            }else{
                getKidActivitiesNetwork(pageIndex: "1", kidId: kidID)
            }
        }
    }
}

// Network
extension TasksVC {
    
    func getKidGoalsNetwork(pageIndex: String, kidId: String){
        //        self.showLoadingView()
        NetworkManager.getKidGoalsNetwork(pageIndex: pageIndex, kidId: kidId) { (response) in
            //            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.tasksData.removeAll()
                    guard let array =  dataValue.data else {return}
                    self.tasksData = array
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
    
    func getKidActivitiesNetwork(pageIndex: String, kidId: String){
        //        self.showLoadingView()
        NetworkManager.getKidActivitiesNetwork(pageIndex: pageIndex, kidId: kidId ) { (response) in
            //            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.tasksData.removeAll()
                    guard let array =  dataValue.data else {return}
                    self.tasksData = array
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
    
    func getParentKidsNetwork(){
        NetworkManager.getKidsNetwork() { (response) in
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.parentKidsData.removeAll()
                    guard let array =  dataValue.data else {return}
                    self.parentKidsData = array
                    self.filterResultLab.text = "All".localized
                    self.getKidGoalsNetwork(pageIndex: "1", kidId: "")
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


extension TasksVC : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myTaskCell.cellID, for: indexPath) as! myTaskCell
        cell.setUpCellData(model: tasksData[indexPath.item])
        cell.moreAction = {[weak self] in
            guard  let self = self  else {return}
            let vc = CardSettingsVC()
            vc.type = .task
            self.selectedTaskID = "\(self.tasksData[indexPath.item].taskID ?? 0 )"
            self.selectedKidID  = "\(self.tasksData[indexPath.item].kids ?? "" )"
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


extension TasksVC : ChooseTask {
    func isChooseTask(choosedTask: Bool) {
        if choosedTask {
            if isGoal == true {
                getKidGoalsNetwork(pageIndex: "1", kidId: kidID)
            }else{
                getKidActivitiesNetwork(pageIndex: "1", kidId: kidID)
            }
        }
    }
}


extension TasksVC :ChooseFromCard {
    func chooseFromCard(theType: CardType, theLogic: CardLogicType, index: IndexPath) {
        if theType == .task {
            if theLogic == .delete {
                print("delete task")
                deleteTaskNetwork(index: index)
            }else{
                print("update task")
            }
        }

        if theType == .gifts {
            if theLogic == .delete {
                print("delete gifts")
                deleteGiftNetwork(index: index)
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
                        self.tasksData.remove(at: index.row)
                        self.tasksTable.reloadData()
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
   

    func deleteGiftNetwork(index:IndexPath){
        self.showLoadingView()
        NetworkManager.deleteTaskNetwork(taskId: self.selectedTaskID, kidId: self.selectedKidID) { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    HelperTools.ShowIntervalMassge(massge: nil, key: dataValue.message ?? "" )
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                           self.dismiss(animated: true, completion: nil)
                        self.tasksData.remove(at: index.row)
                        self.tasksTable.reloadData()
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
