//
//  GeneralTableCell.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 4/9/21.
//

import UIKit

class GeneralTableCell: UITableViewCell {

    static let cellID = "GeneralTableCell"
    
    @IBOutlet weak var titleLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    
    func setCellData(title:String){
        titleLab.text = title.localized
    }

    
}
