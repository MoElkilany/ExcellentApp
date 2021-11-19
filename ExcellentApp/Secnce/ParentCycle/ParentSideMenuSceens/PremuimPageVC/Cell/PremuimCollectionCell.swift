//
//  PremuimCollectionCell.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 21/08/2021.
//

import UIKit

class PremuimCollectionCell: UICollectionViewCell {
    static let cellID = "PremuimCollectionCell"

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var typeNameLab: UILabel!
    @IBOutlet weak var subscriptionFeeLab: UILabel!
    @IBOutlet weak var typeTitleLab: UILabel!
    @IBOutlet weak var sarLab: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    override var isSelected: Bool{
        didSet{
            containerView.backgroundColor = isSelected ? #colorLiteral(red: 0.4745098039, green: 0.4, blue: 0.9921568627, alpha: 1): #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            typeNameLab.textColor = isSelected ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.4745098039, green: 0.4, blue: 0.9921568627, alpha: 1)
            subscriptionFeeLab.textColor = isSelected ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            typeTitleLab.textColor = isSelected ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            sarLab.textColor = isSelected ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func setUpView(){
        containerView.layer.cornerRadius = 20
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .white
        containerView.layer.shadowOffset = CGSize(width: 0,height: 1)
        containerView.layer.shadowRadius = 7
        containerView.layer.shadowOpacity = 0.10
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.masksToBounds = false
    }
    
    func setUpCellData(model:subscriptionResponse){
        typeNameLab.text = model.typeName ?? ""
        subscriptionFeeLab.text = "\(model.subscriptionFee ?? 0)"
        typeTitleLab.text = model.typeText ?? ""
    }

}
