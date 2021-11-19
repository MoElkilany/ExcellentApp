//
//  ChooseTaskVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 02/05/2021.
//

import UIKit
protocol ChooseTask {
    func isChooseTask(choosedTask:Bool)
}


class ChooseTaskVC: UIViewController {
    @IBOutlet weak var containerVIew: shadowView!
    @IBOutlet weak var chooseTaskLab: UILabel!
    
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var goalBtn: UIButton!

    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityBtn: UIButton!
    @IBOutlet weak var continueBtn: CornerButton!
    
    var chooseDelegate :ChooseTask?
    var type = 0
    
    var chooseTaskDelegate : ChooseTask?

var kidID = "" 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setSelectView(view: self.goalView, button: self.goalBtn)
        self.setUNSelectView(view: self.activityView, button: self.activityBtn)
                containerVIew.layer.cornerRadius = 30
        containerVIew.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        chooseTaskLab.setTitle(For: "Choose Task Type")
        goalBtn.setButtonTitle(to: "Goals")
        activityBtn.setButtonTitle(to: "Activities")
        continueBtn.setButtonTitle(to: "continuation")
    }


    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continueBtn(_ sender: Any) {
        if type == 1{
//            self.presentViewController(present: ActivityTaskVC())
            let vc = ActivityTaskVC()
            vc.activeTaskDelegate = self
            vc.kidID = kidID
            vc.isFormMain = true
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
            
            //chooseTaskDelegate
        }else{
            
//            self.presentViewController(present: GoalTaskVC())
            
            let vc = GoalTaskVC()
            vc.goalTaskDelegate = self
            vc.kidID = kidID
            vc.isFormMain = true
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func goalAction(_ sender: Any) {
        type = 0
        self.setSelectView(view: self.goalView, button: self.goalBtn)
        self.setUNSelectView(view: self.activityView, button: self.activityBtn)
    }
    
    @IBAction func activityAction(_ sender: Any) {
        type = 1
        self.setUNSelectView(view: self.goalView, button: self.goalBtn)
        self.setSelectView(view: self.activityView, button: self.activityBtn)
        
    }
    
    func setSelectView(view:UIView , button:UIButton){
        
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view.layer.masksToBounds = false
        view.backgroundColor = #colorLiteral(red: 0.4745098039, green: 0.4, blue: 0.9921568627, alpha: 1)
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    func setUNSelectView(view:UIView , button:UIButton){
        
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.4745098039, green: 0.4, blue: 0.9921568627, alpha: 1)
        view.backgroundColor = UIColor.white
        button.setTitleColor(#colorLiteral(red: 0.4745098039, green: 0.4, blue: 0.9921568627, alpha: 1), for: .normal)
    }
}

extension ChooseTaskVC : ActivityTaskCompleted {
    func isActiveTaskCompleted(activeTask: Bool) {
        if activeTask {
            chooseDelegate?.isChooseTask(choosedTask: true)
            self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension ChooseTaskVC : GoalTaskCompleted {
    func isGoalTaskCompleted(goalTask: Bool) {
        chooseDelegate?.isChooseTask(choosedTask: true)
        self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
}

