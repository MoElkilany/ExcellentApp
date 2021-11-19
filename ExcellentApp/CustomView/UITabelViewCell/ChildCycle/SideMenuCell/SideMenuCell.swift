//
//  SideMenuCell.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 16/04/2021.
//

import UIKit

class SideMenuCell: UITableViewCell {
    static let cellID = "SideMenuCell"

    @IBOutlet weak var sideImage: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var knowAdvantagesLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    
    func setUpCellData(title:String,image:String ){
        knowAdvantagesLab.setTitle(For: "Know the features")
        self.titleLab.text = title
        sideImage.image = UIImage(named: image)
    }
    
    func setUpCellData(title:String,subTitle:String,image:String ){
        self.titleLab.text = title
        sideImage.image = UIImage(named: image)
        knowAdvantagesLab.text = subTitle
    }
}
