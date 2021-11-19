//
//  MainCell.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 30/04/2021.
//

import UIKit
import MSCircularSlider

class MainCell: UITableViewCell {
    static let cellID = "MainCell"

    @IBOutlet weak var childIMag: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var slider: MSCircularSlider!
    @IBOutlet weak var addTaskLAb: UILabel!
    @IBOutlet weak var containerView: shadowViewWithoutCorner!
    @IBOutlet weak var addBtnView: UIView!
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    var plusButton : (()->())?
    var qrCodeButton : (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
        actionButton()
    }
    
    func setUpView(){
        selectionStyle = .none
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOpacity = 0.25
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        containerView.layer.masksToBounds = false
        addTaskLAb.setTitle(For: "Add Task")
        childIMag.layer.cornerRadius = childIMag.layer.frame.height / 2
        addBtnView.layer.cornerRadius = addBtnView.layer.frame.height / 2
        childIMag.layer.borderColor = UIColor.blue.cgColor
        childIMag.layer.borderWidth = 1
        
    }
    
    func actionButton(){
        let tapQrCode = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        qrCodeImage.isUserInteractionEnabled = true
        qrCodeImage.addGestureRecognizer(tapQrCode)
    }

    func setUpCellData(model:HomeParentModel){
        let urlString = "https://www.shattoor.com/api" + (model.profileImageUrl ?? "")
        childIMag.kf.setImage(with: URL(string: urlString) ,placeholder: UIImage(named: "4"))
        titleLab.text = model.FullName ?? ""
        slider._currentValue = Double(model.CompletionRate ?? 0)
    }

    @IBAction func plusAction(_ sender: Any) {
        plusButton?()
    }

    @objc func imageTapped(){
        qrCodeButton?()
    }
    
}


/*
 let vc = ChildProfileDetailsVC()
 vc.childID = self.kidID
 vc.childValueImageUrl = self.imageUrl
 vc.modalPresentationStyle = .overFullScreen
 vc.modalTransitionStyle = .crossDissolve
 self.present(vc, animated: true, completion: nil)
 */
