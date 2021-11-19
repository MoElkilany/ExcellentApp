//
//  GrantCell.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 16/04/2021.
//

import UIKit
import AVFoundation

class GrantCell: UITableViewCell {
    static let cellID = "GrantCell"

    @IBOutlet weak var starCount: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var playerBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        playerBtn.addTarget(self, action: #selector(convertTextToSpeech), for: .touchUpInside)

    }
    
    func setUpCellData(model:KidsDiscountsAndGrantsModel){
        self.titleLab.text = model.reason ?? ""
        self.starCount.text = "\(model.pointsObtained ?? 0)"
        self.dateLab.text = model.createdDate ?? ""
    }

    
   @objc func convertTextToSpeech(){
    let utterance = AVSpeechUtterance(string: self.titleLab.text ?? "" )
        utterance.voice = AVSpeechSynthesisVoice(language: "ar-GB")
    utterance.rate = 0.50

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    
}
