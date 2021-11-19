//
//  InformationPopUpVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 21/08/2021.
//

import UIKit

class InformationPopUpVC: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainTitle:UITextView!
    
    var titleType = ""
    init(title:String) {
        super.init(nibName:nil, bundle:nil)
        self.titleType = title

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    
    func setUpView(){
        mainTitle.text = self.titleType
        mainTitle.textAlignment = .center
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOpacity = 3
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        containerView.layer.masksToBounds = false
    }
    
    
    
    @IBAction func dismissBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
