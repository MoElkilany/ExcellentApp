//
//  AboutAppVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 05/05/2021.
//

import UIKit

//About the application
class AboutAppVC: LoadingView {
    @IBOutlet weak var aboutTheAppLab: UILabel!
    @IBOutlet weak var aboutValueLab: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadActivity()
    }
    func viewDidLoadActivity(){
        actionButton()
        setUpView()
        setUpLoclizeElements()
        getAboutAppNetwork()
    }
    
    
    func setUpView(){
        
    }
    
    func setUpLoclizeElements(){
        aboutTheAppLab.setTitle(For: "About Shator application")
    }
    func actionButton(){
        
    }
    
    
    @IBAction func bacAaction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func getAboutAppNetwork(){
        self.showLoadingView()
        NetworkManager.getAboutAppNetwork() { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.aboutValueLab.text = dataValue.data ?? ""
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
}
