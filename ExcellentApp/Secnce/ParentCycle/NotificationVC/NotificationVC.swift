//
//  NotificationVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 16/10/2021.
//

import UIKit

class NotificationVC: UIViewController {
    
    @IBOutlet weak var navTilteLab: UILabel!
    @IBOutlet weak var filterResultLab: UILabel!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var notifiactionTable: UITableView!

    var parentKidsData = [ParentKidsModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getParentKidsNetwork()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterBtn.addTarget(self, action: #selector(filterBtnTapped), for: .touchUpInside)
        tableConfigration()
    }
    
    
    
    
    func tableConfigration(){
        notifiactionTable.register(UINib(nibName:NotificationCell.cellID , bundle: nil), forCellReuseIdentifier: NotificationCell.cellID)
        notifiactionTable.delegate = self
        notifiactionTable.dataSource = self
        notifiactionTable.separatorStyle = .none
        notifiactionTable.showsVerticalScrollIndicator = false
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
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil )
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


extension NotificationVC : GetGeneralData {
    func data(name: String, type: GeneralTabel) {
    }
    
    func modelData(model: GeneralPopUpModel, type: GeneralTabel) {
    }
    
    func modelChildData(model: ParentKidsModel, type: GeneralTabel) {
        if type == .Child {
            self.filterResultLab.text = model.fullName ?? ""
          
        }
    }
}


extension NotificationVC : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.cellID, for: indexPath) as! NotificationCell
//        cell.setUpCellData(model: tasksData[indexPath.item])
        cell.acceptAction = {[weak self] in
            guard  let self = self  else {return}
        }
        
        cell.refuseAction = {[weak self] in
            guard  let self = self  else {return}
      
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
