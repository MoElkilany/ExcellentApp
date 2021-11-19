//
//  StatisticsDetailsCell.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 12/09/2021.
//

import UIKit

class StatisticsDetailsCell: UITableViewCell {
    
    static let cellID = "StatisticsDetailsCell"

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var totalImplementationStack: UIStackView!
    @IBOutlet weak var totalImplementationLab: UILabel!
    @IBOutlet weak var totalImplementationValueLab: UILabel!
    
    @IBOutlet weak var reasonStack: UIStackView!
    @IBOutlet weak var reasonTitleLab: UILabel!
    @IBOutlet weak var reasonTitleValueLab: UILabel!


    static func nib()->UINib{
        return UINib(nibName: cellID, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOpacity = 0.25
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        containerView.layer.masksToBounds = false
        reasonTitleLab.setTitle(For: "Total implementation")
        switch Constants.state {
        case .goal:
            totalImplementationLab.setTitle(For: "Goal Name")
        case .activity:
            totalImplementationLab.setTitle(For: "Activity Name")
        case .discountPoint:
            totalImplementationLab.setTitle(For: "Reason for deduction of points")
        case .addPoint:
            totalImplementationLab.setTitle(For: "Reason for awarding points")
        case .reward:
            totalImplementationLab.setTitle(For: "Bonus name")
        }
    }

    func setUpCellView(model:StatisticsDetailsModel){
        switch Constants.state {
        case .goal:
            totalImplementationValueLab.text = model.taskTitle
            reasonTitleValueLab.text = "\(model.executedCount ?? 0 )"
        case .activity:
            totalImplementationValueLab.text = model.taskTitle
            reasonTitleValueLab.text = "\(model.executedCount ?? 0 )"
        case .discountPoint:
            totalImplementationValueLab.text = model.Reason
            reasonTitleValueLab.text = "\(model.PointsObtained ?? 0 )"
        case .addPoint:
            totalImplementationValueLab.text = model.Reason
            reasonTitleValueLab.text = "\(model.PointsObtained ?? 0 )"
        case .reward:
            totalImplementationValueLab.text = model.giftName ?? ""
            reasonTitleValueLab.text = "\(model.giftPricePoints ?? 0 )"
        }
        
        
    }
}

