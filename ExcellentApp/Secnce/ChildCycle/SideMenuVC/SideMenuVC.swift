//
//  SideMenuVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 16/04/2021.
//

import UIKit

class SideMenuVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var sideMenuTabel: UITableView!
    
    let tableTitleArray = ["Shatour","Log in to the parent application","Change image","The language","sign out"]
    let tableImageArray = ["premium","parent","ico - 24 - media & editing - image","language","logout"]

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadActivity()
    }
    
    func viewDidLoadActivity(){
        tableConfigration()
        actionButton()
    }
    
        func tableConfigration(){
        sideMenuTabel.register(UINib(nibName:SideMenuCell.cellID , bundle: nil), forCellReuseIdentifier: SideMenuCell.cellID)
        sideMenuTabel.delegate = self
        sideMenuTabel.dataSource = self
        sideMenuTabel.separatorStyle = .none
        sideMenuTabel.showsVerticalScrollIndicator = false
    }
    
    func actionButton(){
        backBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
    }
    
    @objc func backBtnTapped(){
        self.dismiss(animated: true, completion: nil)
    }
}


extension SideMenuVC : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableTitleArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.cellID, for: indexPath) as! SideMenuCell
        if indexPath.row != 0 {
            cell.knowAdvantagesLab.isHidden = true 
        }
        cell.setUpCellData(title: tableTitleArray[indexPath.item].localized, image: tableImageArray[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("")
        case 1:
            HelperTools.dafault.set(false, forKey: "isLoginChild")
            HelperTools.isLogout()
            self.setViewControllerAsRoot(present: LoginVC())
        case 2:
            print("")
        case 3:
            print("")
            HelperTools.dafault.set(false, forKey: "changeLanguageFromParentModel")
            HelperTools.dafault.set(true, forKey: "changeLanguageFromKIDSModel")
            HelperTools.dafault.set(false, forKey: "changeFromSplash")
        let vc = ChangeLanguageChildVC()
            self.presentViewController(present: vc)
        case 4:
            HelperTools.dafault.set(false, forKey: "isLoginChild")
            HelperTools.isLogout()
            self.setViewControllerAsRoot(present: ChildLoginVC())
            
        default:
            print("")
        }
    }
}
