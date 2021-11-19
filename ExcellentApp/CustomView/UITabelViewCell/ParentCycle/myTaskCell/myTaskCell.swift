//
//  myTaskCell.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 02/05/2021.
//

import UIKit

class myTaskCell: UITableViewCell {
    static let cellID = "myTaskCell"

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var parentNameLab: UILabel!
    @IBOutlet weak var pointLab: UILabel!
    @IBOutlet weak var pointValueLab: UILabel!
    @IBOutlet weak var taskImage: UIImageView!
    
    var moreAction : (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
//        pointLab.setTitle(For: "Points")
        configureAuhView()
    }
    
    func configureAuhView(){
        taskImage.layer.cornerRadius = taskImage.layer.frame.height / 2
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor =  UIColor.darkGray.cgColor
        containerView.layer.shadowOpacity = 0.25
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        containerView.layer.masksToBounds = false
        taskImage.layer.borderColor = UIColor.blue.cgColor
        taskImage.layer.borderWidth = 1.2
    }

    @IBAction func moreActionButton(_ sender: Any) {
        moreAction?()
    }
    
    
    func setUpCellData(model:KidsGoalsAndActivityModel){
        let urlString = "https://www.shattoor.com/api" + (model.taskImage ?? "")
        taskImage.kf.setImage(with: URL(string: urlString),placeholder: UIImage(named: "middel"))
        pointValueLab.text = "\(model.points ?? 0 )"
        titleLab.text = "\(model.taskTitle ?? "" )"
        parentNameLab.text = "\(model.kids ?? "")"
        
    }
}
