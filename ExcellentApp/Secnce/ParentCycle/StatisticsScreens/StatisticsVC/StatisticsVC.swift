//
//  StatisticsVC.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 23/04/2021.
//

import UIKit

class StatisticsVC: UIViewController {
    
    @IBOutlet weak var titleBar: UIButton!
    @IBOutlet weak var statisticsCollection: UICollectionView!
    var state : StatisticsType = .goal
    
    var  statisticsArr :[StatisticsModel] = [
        StatisticsModel(imageString: "activity-tracker", title: "mission"),
        StatisticsModel(imageString: "activity-tracker", title: "the Activities"),
        StatisticsModel(imageString: "angy", title: "Discounts"),
        StatisticsModel(imageString:  "happy", title: "Award"),
        StatisticsModel(imageString: "bigPackge", title: "reward")
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("statisticsArr" ,statisticsArr)
        titleBar.setButtonTitle(to: "statistics")
        collectionViewConfigure()
    }
    
    
    func collectionViewConfigure(){
        let minimumItemSpacing:CGFloat = 20
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = minimumItemSpacing
        flowLayout.scrollDirection = .vertical
        statisticsCollection.collectionViewLayout = flowLayout
        statisticsCollection.delegate = self
        statisticsCollection.dataSource = self
        statisticsCollection.showsHorizontalScrollIndicator = false
        statisticsCollection.register(statisticsCell.nib(), forCellWithReuseIdentifier: statisticsCell.cellID)
    }
}

extension StatisticsVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return statisticsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: statisticsCell.cellID, for: indexPath ) as! statisticsCell
        
        cell.setUpView(model: statisticsArr[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  64
        
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize / 2, height: collectionViewSize/2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = StatisticsDetailsVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.navName = statisticsArr[indexPath.row].title.localized
        switch  indexPath.row {
        case 0 :
            Constants.state =  .goal
        case 1 :
            Constants.state = .activity
        case 2 :
            Constants.state = .discountPoint
        case 3 :
            Constants.state = .addPoint
        case 4 :
            Constants.state = .reward
        default:
            return
        }
        self.present(vc, animated: true, completion: nil)
    }
    
}
