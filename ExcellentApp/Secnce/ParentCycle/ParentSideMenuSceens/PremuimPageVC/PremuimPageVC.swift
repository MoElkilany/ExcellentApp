//
//  PremuimPageVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 21/08/2021.
//

import UIKit

class PremuimPageVC: UIViewController {
    
    @IBOutlet weak var premuimLab: UILabel!
    @IBOutlet weak var pointCountLab: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var subscriptionCollection: UICollectionView!
    @IBOutlet weak var subscribeBtn: CornerButton!
    
    var subscription = [subscriptionResponse](){
        didSet{
            subscriptionCollection.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSubscriptionsNetwork()
        setUpLocalizeElement()
        collectionConfigration()
    }
    
    
    func setUpView(){
        
    }
    
    func setUpLocalizeElement(){
        premuimLab.setTitle(For: "Shatoor premium")
        pointCountLab.setTitle(For: "Unlimited points")
    }
    
    func collectionConfigration(){
        subscriptionCollection.delegate = self
        subscriptionCollection.dataSource = self
        subscriptionCollection.register(UINib(nibName: PremuimCollectionCell.cellID, bundle: nil), forCellWithReuseIdentifier: PremuimCollectionCell.cellID)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        subscriptionCollection.collectionViewLayout = layout
    
        layout.itemSize = CGSize(width: subscriptionCollection.frame.width / 3  , height:  150)
        layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        subscriptionCollection.collectionViewLayout = layout
    }
    
    @IBAction func backActionBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func subscribeActionBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getSubscriptionsNetwork(){
        NetworkManager.getSubscriptionsNetwork() { (response) in
            
            switch response {
            case .success(let dataValue):
                self.subscription = dataValue
//                if dataValue.status == 200 {
//
//                }else{
//                    HelperTools.ShowErrorMassge(massge: dataValue.message ?? "" , title: .error)
//                }
            case .failure(let error):
                print("the Error is ",error)
                HelperTools.ShowErrorMassge(massge: Constants.InternetConnection.noInternet.rawValue, title: .serverError)
            }
        }
    }
}
//
    
    
    
extension PremuimPageVC :UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subscription.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PremuimCollectionCell.cellID, for: indexPath) as! PremuimCollectionCell
        cell.setUpCellData(model: subscription[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
