//
//  ChildHomeCell.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 16/04/2021.
//

import UIKit

class ChildHomeCell: UITableViewCell {

    static let cellID = "ChildHomeCell"
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var starCount: UILabel!
    @IBOutlet weak var rewardIImge: UIImageView!
    var rewardImgeCloure : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        rewardImageTapped()
    }
    
    func rewardImageTapped(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapRewardImage))
        rewardIImge.isUserInteractionEnabled = true
        rewardIImge.addGestureRecognizer(tap)
    }
    
    @objc func tapRewardImage(){
        if  rewardIImge.image == UIImage(named: "navigate"){
            print("printed in ")
            rewardImgeCloure?()
        }
    }
    
    
    func setUpCellData(model:KidsActivitiesAndGoalsModel){
        self.title.text = model.taskTitle ?? ""
        self.starCount.text = "\(model.points ?? 0 )"
        if model.status == 0 {
            rewardIImge.image = UIImage(named: "navigate")
        }else if model.status == 1 {
            rewardIImge.image = UIImage(named: "checkMaer")
        }else{
            rewardIImge.image = UIImage(named: "middel")
        }
    }
    


}
