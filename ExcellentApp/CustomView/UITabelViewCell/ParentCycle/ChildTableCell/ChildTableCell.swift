//
//  ChildTableCell.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 02/05/2021.
//

import UIKit

class ChildTableCell: UITableViewCell {
    static let cellID = "ChildTableCell"

    @IBOutlet weak var kidNameLab: UILabel!
    @IBOutlet weak var checkBox: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                checkBox.image = UIImage(named: "icons8-checked-checkbox-24")
            }else{
            checkBox.image = UIImage(named: "blackEmptyCheck")
            }
        }
    }

    func setUpCellData(model:ParentKidsModel){
        kidNameLab.text = model.fullName ?? ""
    }
//
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if HelperTools.isAllSelected == true {

            if selected {
                checkBox.image = UIImage(named: "icons8-checked-checkbox-24")
            }else{
                checkBox.image = UIImage(named: "blackEmptyCheck")
            }
        }else{
            return
        }
    }
}
