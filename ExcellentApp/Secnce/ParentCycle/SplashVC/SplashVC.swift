//
//  SplashVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 4/9/21.
//

import UIKit

class SplashVC: UIViewController {
    
    let isLoginParent = HelperTools.dafault.bool(forKey: "isLoginParent")
    let isLoginChild = HelperTools.dafault.bool(forKey: "isLoginChild")

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
            if self.isLoginParent {
                HelperTools.setTabBarAsRoot()
            }else if self.isLoginChild {
                
                let childHomeVC = UINavigationController(rootViewController: ChildHomeVC())
                           let appDelegate = UIApplication.shared.delegate as! AppDelegate
                       appDelegate.window?.rootViewController = childHomeVC
            }else{
                
                let vc = AppLanguageVC()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

}
