//
//  AdsSettingsVC.swift
//  Egarr
//
//  Created by Mohamed Elkilany on 4/12/21.
//

import UIKit

protocol GetCardStatus {
    func propertyStatus(status:Constants.MoreStatus, id:String ,indexPath:Int)
}

protocol RealoadDataAfterDelete {
    func isDeleteSucess(isDeleted:Bool)
}

protocol ChooseFromCard {
    func chooseFromCard(theType:CardType,theLogic:CardLogicType , index : IndexPath)
}

class CardSettingsVC: LoadingView {
    
    @IBOutlet weak var contianerView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var delegate : ChooseFromCard?
    var taskId = ""
    var kidId = ""
    var indexPath = IndexPath()
    var type : CardType = .task
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton()
        setUpView()
    }
    
    func actionButton(){
        deleteBtn.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
        editBtn.addTarget(self, action: #selector(editBtnTapped), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    func setUpView(){
        
        editBtn.setButtonTitle(to: "edit")
        deleteBtn.setButtonTitle(to: "delete")
        
        contianerView.layer.cornerRadius = 12
        contianerView.layer.borderWidth = 1
        contianerView.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
    }
    
    
    @objc func deleteBtnTapped(){
        switch type {
        case .task:
            delegate?.chooseFromCard(theType: .task, theLogic: .delete, index: indexPath)
//            deleteTaskNetwork()
                    self.dismiss(animated: true, completion: nil)

        case .gifts:
//            deleteGiftNetwork()
            delegate?.chooseFromCard(theType: .gifts, theLogic: .delete, index: indexPath)
                    self.dismiss(animated: true, completion: nil)


        case .discount:
            delegate?.chooseFromCard(theType: .discount, theLogic: .delete, index: indexPath)
                    self.dismiss(animated: true, completion: nil)
        case .reward:
            delegate?.chooseFromCard(theType: .reward, theLogic: .delete, index: indexPath)
                    self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func editBtnTapped(){
        
        switch type {
        case .task:
//            delegate?.chooseFromCard(theType: .task, theLogic: .update)
            self.dismiss(animated: true, completion: nil)
        case .gifts:
//            delegate?.chooseFromCard(theType: .gifts, theLogic: .delete)
                self.dismiss(animated: true, completion: nil)

        case .discount:
            self.dismiss(animated: true, completion: nil)

        case .reward:
            self.dismiss(animated: true, completion: nil)

        }
    }
    
    @objc func dismissButtonTapped(){
        self.dismiss(animated: true , completion: nil)
    }
    
    
}

enum CardType {
    case task
    case gifts
    case discount
    case reward
}

enum CardLogicType {
    case delete
    case update
}
