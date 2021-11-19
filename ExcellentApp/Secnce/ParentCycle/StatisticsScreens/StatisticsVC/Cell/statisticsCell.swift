//
//  statisticsCell.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 12/09/2021.
//

import UIKit

class statisticsCell: UICollectionViewCell {
    static let cellID = "statisticsCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageImg: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    
    static func nib()->UINib{
        return UINib(nibName: cellID, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 32
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOpacity = 0.45
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }
    
    func setUpView(model:StatisticsModel){
        imageImg.image = UIImage(named: model.imageString)
        titleLab.text = model.title.localized
    }
    
}


struct StatisticsModel {
    var imageString :String
    var title:String
}
