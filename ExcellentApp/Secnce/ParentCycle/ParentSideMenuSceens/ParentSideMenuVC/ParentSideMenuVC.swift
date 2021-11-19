//
//  ParentSideMenuVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 03/05/2021.
//

import UIKit

class ParentSideMenuVC: UIViewController {

   
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var sideMenuTabel: UITableView!
    

    let tableSubTitleArray = ["","Know the features","","","","","","",""]
    
    let tableTitleArray = ["Edit profile","Shatour","Your balance","shatur store","change Password","The language","call us","About the application","sign out"]
    
    let tableImageArray = ["familyblack","premium","sideBalance","sideStore","SidechangePass","language", "callus","sideAboutApp","logout"]

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


extension ParentSideMenuVC : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableTitleArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.cellID, for: indexPath) as! SideMenuCell
//        if indexPath.row != 0 {
//            cell.knowAdvantagesLab.isHidden = true
//        }
        cell.setUpCellData(title: tableTitleArray[indexPath.item].localized,subTitle:tableSubTitleArray[indexPath.item].localized, image: tableImageArray[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("")
            
            self.presentViewController(present: EditProfileVC())
        case 1:
            self.presentViewController(present: PremuimPageVC())
//            AboutAppVC
        case 2:
            print("")
            
            self.presentViewController(present: BalanceVC())

        case 3:
            print("")
        let vc = ShatorStoreVC()
            self.presentViewController(present: vc)
 
        case 4:
            print("")
            self.presentViewController(present: ChangePasswordVC())
        case 5:
            HelperTools.dafault.set(true, forKey: "changeLanguageFromParentModel")
            HelperTools.dafault.set(false, forKey: "changeLanguageFromKIDSModel")
            HelperTools.dafault.set(false, forKey: "changeFromSplash")

            let vc = ChangeLanguageChildVC()
                self.presentViewController(present: vc)
        case 6:
            let vc = CallUsVC()
                self.presentViewController(present: vc)
        case 7:
            self.presentViewController(present: AboutAppVC())
        case 8:
            HelperTools.isLogout()
            HelperTools.dafault.set(false, forKey: "isLoginParent")
            self.setViewControllerAsRoot(present: LoginVC())
        default:
            print("")
        }
    }
    
 
}
