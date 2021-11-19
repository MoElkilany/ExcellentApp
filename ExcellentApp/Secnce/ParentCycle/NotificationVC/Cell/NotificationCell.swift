//
//  NotificationCell.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 16/10/2021.
//

import UIKit

class NotificationCell: UITableViewCell {
    static let cellID = "NotificationCell"

    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var childNameLab: UILabel!
    @IBOutlet weak var taskNameLab: UILabel!
    @IBOutlet weak var pointsLab: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderCont: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var acceptAction : (()->Void)?
    var refuseAction : (()->Void)?


    @IBAction func aceeptBtn(_ sender: Any) {
        acceptAction?()
    }
    
    @IBAction func refuseBtn(_ sender: Any) {
        refuseAction?()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        sliderCont.text = "\(currentValue)"
    }
    
}
