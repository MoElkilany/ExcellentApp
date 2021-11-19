//
//  BonusStoreCell.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 16/04/2021.
//

import UIKit
import AVFoundation

class BonusStoreCell: UITableViewCell {

    static let cellID = "BonusStoreCell"
    
    
    @IBOutlet weak var bonusRequestLab: UILabel!
    @IBOutlet weak var bonusRequestBtn: UIButton!
    @IBOutlet weak var starCount: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var playerBtn: UIButton!
    
    var bonusRequestActionCloure :(()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        bonusRequestLab.setTitle(For: "Bonus request")
        playerBtn.addTarget(self, action: #selector(convertTextToSpeech), for: .touchUpInside)

    }
    
    func setUpCellData(model:GetKidGiftsModel ){
        self.titleLab.text = model.giftName ?? ""
        self.starCount.text = "\(model.giftPricePoints ?? 0 )"
    }
    
    @objc func convertTextToSpeech(){
     let utterance = AVSpeechUtterance(string: self.titleLab.text ?? "" )
         utterance.voice = AVSpeechSynthesisVoice(language: "ar-GB")
     utterance.rate = 0.50
         let synthesizer = AVSpeechSynthesizer()
         synthesizer.speak(utterance)
     }
    
    
    @IBAction func requestAction(_ sender: Any) {
        bonusRequestActionCloure?()
    }
    
}


