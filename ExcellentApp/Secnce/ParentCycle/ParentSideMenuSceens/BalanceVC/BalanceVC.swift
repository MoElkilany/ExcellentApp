//
//  BalanceVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 06/05/2021.
//

import UIKit

class BalanceVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var yourBalanceLab: UILabel!
    
    @IBOutlet weak var balanceToMorePointesLab: UILabel!
    
    @IBOutlet weak var subscribeView: UIView!

    @IBOutlet weak var subscribeNowBtn: CornerButton!
    @IBOutlet weak var showVideoView: UIView!

    @IBOutlet weak var showVideoBtn: CornerButton!

    @IBOutlet weak var useBalanceLab: UILabel!
    
    @IBOutlet weak var useBalanceTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadActivity()
        
    }
    
    
   

//BalanceCell
func viewDidLoadActivity(){
    tableConfigration()
        setUpView()
        setUpLoclizeElements()
    }
    
    
    func setUpView(){
        subscribeView.layer.cornerRadius = 15
        showVideoView.layer.cornerRadius = 15
        subscribeNowBtn.layer.cornerRadius = 10
        showVideoBtn.layer.cornerRadius = 10
    }
    func tableConfigration(){
        useBalanceTable.register(UINib(nibName:BalanceCell.cellID , bundle: nil), forCellReuseIdentifier: BalanceCell.cellID)
        useBalanceTable.delegate = self
        useBalanceTable.dataSource = self
        useBalanceTable.separatorStyle = .none
        useBalanceTable.showsVerticalScrollIndicator = false
    }
    
    func setUpLoclizeElements(){
        yourBalanceLab.setTitle(For: "Your balance")
        subscribeNowBtn.setButtonTitle(to: "subscribe now")
        showVideoBtn.setButtonTitle(to:"Watch a video")
        balanceToMorePointesLab.setTitle(For: "To increase your points balance")
        useBalanceLab.setTitle(For: "Uses of the balance" )

        
    }
    
    @IBAction func backAtionButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension BalanceVC : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
            //tableTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BalanceCell.cellID, for: indexPath) as! BalanceCell
//        cell.setUpCellData(title: tableTitleArray[indexPath.item], count: tableCountArray[indexPath.item] ,date:tableDateArray[indexPath.item])
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 130
//    }
}
