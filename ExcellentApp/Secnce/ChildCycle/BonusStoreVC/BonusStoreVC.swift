//
//  BonusStoreVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 16/04/2021.
//

import UIKit

class BonusStoreVC: LoadingView {

    @IBOutlet weak var blureImage: UIImageView!
    @IBOutlet weak var bonusStoreTable: UITableView!
    
    var pageCount = 1
    var isGetMore = false
    
    var kidGiftArray :[GetKidGiftsModel] = [] {
        didSet{
            bonusStoreTable.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadActivity()
    }
    
    func viewDidLoadActivity(){
        navigationButtons()
        tableConfigration()
        setupView()
    }
    
    func setupView(){
       getKidGiftNetwork()
    }
    
    func navigationButtons(){
        HelperTools.setBackBarButton("Bonus Store", self)
        
        let navbarFont = UIFont(name: "Cairo-Bold", size: 12)  ?? UIFont.systemFont(ofSize: 12)

        let imageButton = UIBarButtonItem(image: UIImage(named:"no"), style:.plain, target: self, action: nil)
        let premeuimButton = UIBarButtonItem(title:"Premium".localized, style: .plain, target: self, action: nil)
        
        let premenuAttribute = [NSAttributedString.Key.font: navbarFont, NSAttributedString.Key.foregroundColor:UIColor(named: "E5C100")]
        premeuimButton.setTitleTextAttributes(premenuAttribute as [NSAttributedString.Key : Any], for: .normal)

        navigationItem.rightBarButtonItems = [premeuimButton,imageButton]
        }
    
    
    func tableConfigration(){
        bonusStoreTable.register(UINib(nibName:BonusStoreCell.cellID , bundle: nil), forCellReuseIdentifier: BonusStoreCell.cellID)
        bonusStoreTable.delegate = self
        bonusStoreTable.dataSource = self
        bonusStoreTable.separatorStyle = .none
        bonusStoreTable.showsVerticalScrollIndicator = false
        bonusStoreTable.prefetchDataSource = self
    }
    
    
    func getKidGiftNetwork(){
        self.isGetMore = true
        self.showLoadingView()
        NetworkManager.getKidGift(pageIndex: "\(pageCount)") { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    self.kidGiftArray.removeAll()
                    guard  let activiyData = dataValue.data else {
                        return
                    }
                    self.kidGiftArray = activiyData
                }else{
                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
                }
                
                self.pageCount+=1
                self.isGetMore = false
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
    
    
    func giftRequestNetwork(GiftId:String){
        self.showLoadingView()
        NetworkManager.giftRequest(GiftId: GiftId) { (response) in
            self.dismissLoadingView()
            switch response {
            case .success(let dataValue):
                if dataValue.status == 200 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        HelperTools.ShowIntervalMassge(massge: nil, key: dataValue.message ?? "" )
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
    
      func paginateData(indexPaths:[IndexPath]){
              for index in indexPaths {
                  if index.row >= kidGiftArray.count - 1 && !isGetMore {
                    getKidGiftNetwork()
                      break
                  }
              }
      }
}

extension BonusStoreVC : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kidGiftArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BonusStoreCell.cellID, for: indexPath) as! BonusStoreCell
        cell.setUpCellData(model: kidGiftArray[indexPath.item])
        cell.bonusRequestActionCloure = {[weak self] in
            guard let self = self else {return}
            self.giftRequestNetwork(GiftId: "\(self.kidGiftArray[indexPath.item].id ?? 0)")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let giftID = kidGiftArray[indexPath.item].id ?? 0
        self.giftRequestNetwork(GiftId: "\(giftID)")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}


extension BonusStoreVC:UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        paginateData(indexPaths: indexPaths)
    }
}
