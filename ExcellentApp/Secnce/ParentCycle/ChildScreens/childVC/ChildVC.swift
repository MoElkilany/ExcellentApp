//
//  ChildVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 23/04/2021.
//
protocol childAdded {
    func childAdded(added:Bool)
}

import UIKit

class ChildVC: LoadingView {
    
    @IBOutlet weak var noChildLab: UILabel!
    @IBOutlet weak var childBtn: UIButton!
    @IBOutlet weak var childsTable: UITableView!
    
    
    var childData:[KidsModel] = [KidsModel](){
        didSet{
            childsTable.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getKidsNetwork(pageIndex: "1")
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        tableConfigration()
    }
    
    func tableConfigration(){
        childsTable.register(UINib(nibName:MyChildCell.cellID , bundle: nil), forCellReuseIdentifier: MyChildCell.cellID)
        childsTable.delegate = self
        childsTable.dataSource = self
        childsTable.separatorStyle = .none
        childsTable.showsVerticalScrollIndicator = false
    }
    
    //    func setUpCellData(model:KidsModel){
    func setUpView(){
        noChildLab.setTitle(For: "There are no registered children")
        childBtn.setButtonTitle(to: "Sons")
    }
    
    
    @IBAction func addAction(_ sender: Any) {
        let vc = AddChildVC()
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil )
    }
    
    @IBAction func addChildNavgation(_ sender: Any) {
        let vc = AddChildVC()
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil )
    }
    
    @IBAction func sideMenuAction(_ sender: Any) {
        self.presentViewController(present: ParentSideMenuVC())
    }
    
    @IBAction func notificationAction(_ sender: Any) {
        
    }
    
    func getKidsNetwork(pageIndex: String){
        self.showLoadingView()
        NetworkManager.getParentKidsWithMoreDetailsNetwork(pageIndex: pageIndex) { (response) in
            self.dismissLoadingView()
            switch response {

            case .success(let dataValue):
                if dataValue.status == 200 {
                    guard let array =  dataValue.data else {return}
                    self.childData = array
                    if array.isEmpty == true {
                        self.childsTable.isHidden = true
                    }else{
                        self.childsTable.isHidden = false
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

extension ChildVC : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyChildCell.cellID, for: indexPath) as! MyChildCell
        cell.setUpCellData(model: childData[indexPath.item])
        cell.qrCodeButton = {[weak self] in
            guard let self = self else {return}
            let vc = ChildProfileDetailsVC()
            vc.childID = "\(self.childData[indexPath.item].id ?? 0 )"
            vc.childValueImageUrl = self.childData[indexPath.item].profileImageURL ?? ""
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProfileChildOnParentVC()
        vc.kidID = "\(childData[indexPath.item].id ?? 0 )"
        vc.kidName = "\(childData[indexPath.item].fullName ?? "" )"
        self.presentViewController(present: vc)
    }
}


extension ChildVC :childAdded {
    func childAdded(added: Bool) {
        if added == true {
            getKidsNetwork(pageIndex: "1")
        }
    }
    
    
}
