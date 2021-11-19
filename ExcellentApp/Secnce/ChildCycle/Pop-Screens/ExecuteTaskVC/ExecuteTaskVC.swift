//
//  ExecuteTaskVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 13/10/2021.
//

import UIKit

protocol  ReloadChildHomeData {
    func isExecuteTaskDone(isDone:Bool)
}

class ExecuteTaskVC: LoadingView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var trueBtn: UIButton!
    @IBOutlet weak var falseBtn: UIButton!

    var kidID = ""
    var delegate :ReloadChildHomeData?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView(){
        containerView.layer.cornerRadius = 18
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.blue.cgColor
    }

    @IBAction func dismissBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func trueBtn(_ sender: Any) {
        executeTaskNetwork()
    }
    
    
    func executeTaskNetwork(){
        self.showLoadingView()
        NetworkManager.executeTask(KidsTaskId: self.kidID) { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                
                if dataValue.status == 200 {
                    HelperTools.ShowIntervalMassge(massge: nil, key:dataValue.message ?? "" )
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.delegate?.isExecuteTaskDone(isDone: true)
                        self.dismiss(animated: true , completion: nil)
                    }
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
    
