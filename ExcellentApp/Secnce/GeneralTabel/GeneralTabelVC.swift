//
//  GeneralTabelVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 4/9/21.
//

import UIKit

protocol GetGeneralData {
    func data(name:String ,type:GeneralTabel)
    func modelData(model:GeneralPopUpModel ,type:GeneralTabel)
    func modelChildData(model:ParentKidsModel ,type:GeneralTabel)

}

class GeneralTabelVC: LoadingView {
    
    @IBOutlet weak var generalTabel: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var mainSectionLab: UILabel!
    
    let sexArr = ["Male", "Female"]
    let LangArr = ["العربية", "English"]

    
   
    
    var relativesArr :[GeneralPopUpModel] = [GeneralPopUpModel](){
        didSet{
            generalTabel.reloadData()
        }
    }
    
    var childArr  = [ParentKidsModel]()
    

//getRelationsNetwork
    var sectionName = ""
    var  tableType : GeneralTabel = .relativeRelation
    var delegate : GetGeneralData?
   
    init(mainSection:String) {
        super.init(nibName: nil, bundle: nil)
        self.sectionName = mainSection
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if tableType == .relativeRelation {
            getRelationsNetwork()
        }
        tableConfigration()
        setUpView()
    }
    
    func setUpView(){
        mainSectionLab.textAlignment = .center
        doneBtn.setButtonTitle(to: "Done")
        self.mainSectionLab.text = sectionName.localized
        doneBtn.addTarget(self, action: #selector(doneBtnTapped), for: .touchUpInside)
    }
    
    @objc func doneBtnTapped(){
        self.dismiss(animated: true , completion: nil)
    }
    
    func tableConfigration(){
        generalTabel.delegate = self
        generalTabel.dataSource = self
        generalTabel.register(UINib(nibName: GeneralTableCell.cellID, bundle: nil), forCellReuseIdentifier: GeneralTableCell.cellID)
        generalTabel.showsVerticalScrollIndicator = false
        generalTabel.showsHorizontalScrollIndicator = false
        generalTabel.separatorStyle = .none
    }
    
    //
    
    func getRelationsNetwork(){
        self.showLoadingView()
        NetworkManager.getRelationsNetwork { (response) in
            self.dismissLoadingView()
            switch response {
            
            case .success(let dataValue):
                if dataValue.Status == 200 {
                    guard let array =  dataValue.data else {return}
                    self.relativesArr = array
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.Message ?? "" , title: .error)
                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    
}

extension GeneralTabelVC : UITableViewDelegate ,  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableType == .relativeRelation {
            return relativesArr.count
        }else if tableType == .sex {
            return sexArr.count
        }else if tableType == .language {
            return LangArr.count
        }else if tableType == .Child {
            return childArr.count
        }else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GeneralTableCell.cellID ) as! GeneralTableCell
        
        if tableType == .relativeRelation {
            cell.setCellData(title: relativesArr[indexPath.item].Name ?? "" )
            return cell
        }else if tableType == .sex {
            cell.setCellData(title: sexArr[indexPath.item])
            return cell
            
        }else if tableType == .language {
            cell.setCellData(title: LangArr[indexPath.item])
            return cell
            
        }else if tableType == .Child {
            cell.setCellData(title: childArr[indexPath.item].fullName ?? "" )
            return cell
        }else{
            return UITableViewCell()
        }        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableType == .relativeRelation {
            delegate?.data(name: relativesArr[indexPath.item].Name ?? "" , type: tableType)
            delegate?.modelData(model: relativesArr[indexPath.item], type: tableType)

        }else if tableType == .sex {
            delegate?.data(name: sexArr[indexPath.item], type: tableType)
        } else if tableType == .language{
        delegate?.data(name: LangArr[indexPath.item], type: tableType)
        }else if  tableType == .Child {
            delegate?.modelChildData(model: childArr[indexPath.item], type: tableType)
        }
        
        self.dismiss(animated: true, completion: nil)
   }
}
