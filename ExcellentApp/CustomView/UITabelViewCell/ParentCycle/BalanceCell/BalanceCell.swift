//
//  BalanceCell.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 06/05/2021.
//

import UIKit

class BalanceCell: UITableViewCell {
    static let cellID = "BalanceCell"
    @IBOutlet weak var balanceNameLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setUpCellData(name:String){
        balanceNameLab.text = name
    }
   
    
}
