//
//  MyChildCell.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 30/04/2021.
//

import UIKit
import Kingfisher

class MyChildCell: UITableViewCell {
    
    static let cellID = "MyChildCell"
    
    @IBOutlet weak var childImge: UIImageView!
    @IBOutlet weak var childNameLab: UILabel!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var childActivityLab: UILabel!
    @IBOutlet weak var childActivityValueLab: UILabel!
    
    @IBOutlet weak var childGoalsLab: UILabel!
    @IBOutlet weak var childGoalsValueLab: UILabel!
    
    @IBOutlet weak var childrewordLab: UILabel!
    @IBOutlet weak var childrewordValueLab: UILabel!
    
    var qrCodeButton : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
        actionButton()
    }
    
    func setUpCellData(model:KidsModel){
        let urlString = "https://www.shattoor.com/api" + (model.profileImageURL ?? "")
        childImge.kf.setImage(with: URL(string: urlString),placeholder: UIImage(named: "4"))
        childNameLab.text = model.fullName
        childActivityValueLab.text = "\(model.activitiesCount ?? 0 )"
        childGoalsValueLab.text = "\(model.goalsCount ?? 0 )"
        childrewordValueLab.text = "\(model.giftsCount ?? 0 )"
    }
    
    func setUpView(){
        childImge.layer.cornerRadius =  childImge.layer.frame.height / 2
        childImge.layer.borderColor = UIColor.blue.cgColor
        childImge.layer.borderWidth = 1
        childActivityLab.setTitle(For: "the Activities")
        childGoalsLab.setTitle(For: "the Goals")
        childrewordLab.setTitle(For: "the reword")
        
    }
    
    func actionButton(){
        let tapQrCode = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        qrCodeImage.isUserInteractionEnabled = true
        qrCodeImage.addGestureRecognizer(tapQrCode)
    }
    
    @objc func imageTapped(){
        qrCodeButton?()
    }
}
