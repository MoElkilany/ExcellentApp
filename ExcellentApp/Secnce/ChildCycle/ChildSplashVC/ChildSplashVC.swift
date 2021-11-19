//
//  ChildSplashVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 4/10/21.
//

import UIKit

class ChildSplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        childFlow()
    }
    
    func childFlow(){
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.presentViewController(present: ChildLoginVC())
            
        }
    }
}
