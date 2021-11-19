//
//  RewardTableCell.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 03/05/2021.
//

import UIKit

class RewardTableCell: UITableViewCell {
    
    static let cellID = "RewardTableCell"
    
    @IBOutlet weak var pointView: UIView!
    @IBOutlet weak var stackPoint: UIStackView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var pointLab: UILabel!
    @IBOutlet weak var pointValueLab: UILabel!
    @IBOutlet weak var rewardImge: UIImageView!
    @IBOutlet weak var childNameLab: UILabel!
    
    
    var moreAction : (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        pointLab.setTitle(For: "Points")
        configureAuhView()
    }
    
    func configureAuhView(){
        rewardImge.layer.cornerRadius = rewardImge.layer.frame.height / 2
        pointView.layer.cornerRadius = 8
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor =  UIColor.darkGray.cgColor
        containerView.layer.shadowOpacity = 0.25
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        containerView.layer.masksToBounds = false
    }
    
    func setUpCellDate(model:GetGiftModel){
        let urlString = "https://www.shattoor.com/api" + (model.imageURL ?? "")
        rewardImge.kf.setImage(with: URL(string: urlString) , placeholder: UIImage(named: "childPrayer"))
        titleLab.text = model.giftName ?? ""
        childNameLab.text = model.kids ?? ""
        pointValueLab.text = "\(model.giftPricePoints ?? 0)"
    }
    

    @IBAction func moreActionButton(_ sender: Any) {
        moreAction?()
    }
}
