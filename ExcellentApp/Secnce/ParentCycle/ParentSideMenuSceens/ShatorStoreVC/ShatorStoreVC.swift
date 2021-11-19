//
//  ShatorStoreVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 06/05/2021.
//

import UIKit

class ShatorStoreVC: LoadingView {
    @IBOutlet weak var backBtn: UIButton!

    @IBOutlet weak var shatorStoreLab: UILabel!
    @IBOutlet weak var advantagesShatorStoreLab: UILabel!
    @IBOutlet weak var activeShatorLab: UILabel!
    
    @IBOutlet weak var stroeSwitchBtn: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        getActivateStoreNetwork()
        setUpView()
       
    }
    
    func setUpView(){
        shatorStoreLab.setTitle(For: "Segments store")
        advantagesShatorStoreLab.setTitle(For: "One of the advantages of the Shator premium application is the ability to activate the Shator store for the child")
        activeShatorLab.setTitle(For: "Activate the store bits")
    }

    @IBAction func dismissActionBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpStoreData(model:ActiveStoreData){
        if model.activateStore == true {
            stroeSwitchBtn.setOn(true, animated: true)
        }else{
            stroeSwitchBtn.setOn(true, animated: true)
        }
    
        if model.isSubscriber == true {
            stroeSwitchBtn.isEnabled = true
        }else{
            stroeSwitchBtn.isEnabled = false

        }
    }
    
    
    @IBAction func storeAction(_ sender: UISwitch) {
        if sender.isOn {
            
        }else{
            
        }
        
    }
    
    
    func getActivateStoreNetwork(){
        self.showLoadingView()
        NetworkManager.getActivateStoreNetwork { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    guard let storeData = dataValue.data else {return}
                    
                    self.setUpStoreData(model: storeData)
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    
    func changeActivateStoreNetwork(isActive:String){
        self.showLoadingView()
        NetworkManager.ChangeActivateStoreNetwork(isActive: isActive) { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.stroeSwitchBtn.setOn(true, animated: true)
//                    self.stroeSwitchBtn.setOn(false, animated: true)

                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    
//ChangeActivateStoreNetwork
    
    //getActivateStoreNetwork
}
