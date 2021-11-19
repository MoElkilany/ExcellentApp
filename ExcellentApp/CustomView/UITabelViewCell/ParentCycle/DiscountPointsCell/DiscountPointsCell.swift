//
//  DiscountPointsCell.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 07/05/2021.
//

import UIKit

class DiscountPointsCell: UITableViewCell {
    static let cellID = "DiscountPointsCell"

    
    @IBOutlet weak var kidNameLab: UILabel!
    @IBOutlet weak var kidDescLab: UILabel!
    @IBOutlet weak var kidPointLab: UILabel!
    @IBOutlet weak var reDiscountView: UIView!
    @IBOutlet weak var reDiscountBtn: UIButton!
    @IBOutlet weak var kidImg: UIImageView!
    
    var isDiscount = false
   
    var moreAction : (()->())?
    var resendDiscountAndRewardAction : (()->())?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        kidImg.layer.cornerRadius = kidImg.layer.frame.height / 2
        reDiscountView.layer.cornerRadius = 12
        if isDiscount {
            reDiscountBtn.setButtonTitle(to: "Re-discount")
        }else{
            reDiscountBtn.setButtonTitle(to: "Resend")
        }
    }
    
    func setUpCellData(model:KidsAwardHomeModel){
        let urlString = "https://www.shattoor.com/api" + (model.profileImageURL ?? "")
        kidImg.kf.setImage(with: URL(string: urlString),placeholder: UIImage(named: "4"))
        kidNameLab.text = model.kidName ?? ""
        kidDescLab.text = model.reason ?? ""
        kidPointLab.text = "\(model.pointsObtained ?? 0)" + " " + "Points".localized
    }
    
    @IBAction func moreActionButton(_ sender: Any) {
        moreAction?()
    }
    
    @IBAction func resendAwardAndDiscountBtn(_ sender: Any) {
        resendDiscountAndRewardAction?()
    }
    //
}
