//
//  ChildProfileOnParentCell.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 20/08/2021.
//

import UIKit

class ChildProfileOnParentCell: UITableViewCell {
static let cellID = "ChildProfileOnParentCell"

    @IBOutlet weak var taskNameLab: UILabel!
    @IBOutlet weak var taskImg: UIImageView!
    @IBOutlet weak var pointLab: UILabel!

    var moreAction : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        taskImg.layer.cornerRadius = taskImg.layer.frame.height / 2
        taskImg.layer.borderWidth = 0.5
        taskImg.layer.borderColor = UIColor.blue.cgColor
    }
    
    func setUpCellData(model:GetKidActivitiesOnProfileModel){
        let urlString = "https://www.shattoor.com/api" + (model.taskImage ?? "")
        taskImg.kf.setImage(with: URL(string: urlString))
        pointLab.text = "\(model.points ?? 0)" + " " + "Points".localized
        taskNameLab.text = model.taskTitle ?? "" 
    }
    
    @IBAction func moreActionButton(_ sender: Any) {
        moreAction?()
    }
    
    
}
