//
//  DiscountsVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 16/04/2021.
//

import UIKit

class DiscountsVC: LoadingView {

    @IBOutlet weak var discountsTable: UITableView!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var grantLab: UILabel!
    @IBOutlet weak var discountsLab: UILabel!
    @IBOutlet weak var grantBtn: UIButton!
    
    var pageCount = 1
    var isGetMore = false
    var discountArray = [KidsDiscountsAndGrantsModel](){
        didSet{
            discountsTable.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getKidsDiscounts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadActivity()
    }
    
    func viewDidLoadActivity(){
        tableConfigration()
        navigationButtons()
        loclizeElements()
        actionButton()
    }
    
    func loclizeElements(){
        grantLab.setTitle(For: "Grant")
        discountsLab.setTitle(For: "Discounts")
    }
    
        func tableConfigration(){
        discountsTable.register(UINib(nibName:DiscountsCell.cellID , bundle: nil), forCellReuseIdentifier: DiscountsCell.cellID)
        discountsTable.delegate = self
        discountsTable.dataSource = self
        discountsTable.separatorStyle = .none
        discountsTable.showsVerticalScrollIndicator = false
            discountsTable.prefetchDataSource = self
    }
    
    func navigationButtons(){
        let navbarFont = UIFont(name: "Cairo-Bold", size: 12)  ?? UIFont.systemFont(ofSize: 12)

               let sideMenuButton = UIBarButtonItem(image: UIImage(named:"sideMenu"), style:.plain, target: self, action: #selector(sideMenuButtonTapped))
        let nameButton = UIBarButtonItem(title:  "Discounts".localized, style: .plain, target: self, action: nil)
        
        let nameAttribute = [NSAttributedString.Key.font: navbarFont, NSAttributedString.Key.foregroundColor:UIColor(named: "030414")]
        nameButton.setTitleTextAttributes(nameAttribute as [NSAttributedString.Key : Any], for: .normal)
        
        navigationItem.leftBarButtonItems = [sideMenuButton,nameButton]
        
        let imageButton = UIBarButtonItem(image: UIImage(named:"no"), style:.plain, target: self, action: nil)
        let premeuimButton = UIBarButtonItem(title:"Premium".localized, style: .plain, target: self, action: nil)
        let premenuAttribute = [NSAttributedString.Key.font: navbarFont, NSAttributedString.Key.foregroundColor:UIColor(named: "E5C100")]
        premeuimButton.setTitleTextAttributes(premenuAttribute as [NSAttributedString.Key : Any], for: .normal)
        navigationItem.rightBarButtonItems = [premeuimButton,imageButton]
        
        }
    func actionButton(){
        homeBtn.addTarget(self, action: #selector(homeBtnTapped), for: .touchUpInside)
        grantBtn.addTarget(self, action: #selector(grantBtnTapped), for: .touchUpInside)
    }
    
    
    
    
    @objc func grantBtnTapped(){
        let grantvc = UINavigationController(rootViewController: GrantVC())
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = grantvc
    }
    
    @objc func homeBtnTapped(){
        let homevc = UINavigationController(rootViewController: ChildHomeVC())
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = homevc
    }

    @objc func sideMenuButtonTapped(){
        self.presentViewController(present: SideMenuVC())
    }
    
    func getKidsDiscounts(){
        
        isGetMore = true
        self.showLoadingView()
        NetworkManager.getKidsDiscounts(pageIndex: "\(pageCount)") { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    guard  let discountData = dataValue.data else {
                        return
                    }
                    self.discountArray = discountData
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
    
    
    func paginateData(indexPaths:[IndexPath]){
        for index in indexPaths {
            if index.row >= discountArray.count - 1 && !isGetMore {
                getKidsDiscounts()
                break
            }
        }
    }
}


extension DiscountsVC : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discountArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DiscountsCell.cellID, for: indexPath) as! DiscountsCell
        cell.setUpCellData(model: discountArray[indexPath.item])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
}

extension DiscountsVC:UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        paginateData(indexPaths: indexPaths)
    }
}
