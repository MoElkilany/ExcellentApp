//
//  segmentCollectionCell.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 19/08/2021.
//

import UIKit

class segmentCollectionCell: UICollectionViewCell {
    static let cellID = "segmentCollectionCell"
    
    @IBOutlet weak var reportTitleLab: UILabel!
    @IBOutlet weak var reportView: UIView!

    override var isSelected: Bool {
        didSet{
            reportView.backgroundColor = isSelected ? #colorLiteral(red: 0.1568627451, green: 0.7882352941, blue: 0.9098039216, alpha: 1) : .clear
            reportTitleLab.textColor = isSelected ? #colorLiteral(red: 0.1568627451, green: 0.7882352941, blue: 0.9098039216, alpha: 1) : .black
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setUpCellData(data: collectionArrayModel) {
        reportTitleLab.text = data.name.localized
    }
}
